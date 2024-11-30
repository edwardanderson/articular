import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import ConjunctiveGraph
from rdflib.plugin import PluginException
from rich import print_json
from rich.console import Console
from rich.syntax import Syntax
from typing_extensions import Annotated

from krml import Template


app = typer.Typer()

ValidPath = Annotated[
    Path,
    typer.Argument(
        exists=True,
        file_okay=True,
        dir_okay=False,
        writable=False,
        readable=True,
        resolve_path=True,
    )
]

EmbedContext = Annotated[
    bool,
    typer.Option(
        '--embed-context/--no-embed-context'
    )
]

PrettyPrint = Annotated[
    bool,
    typer.Option(
        '--pretty-print/--no-pretty-print'
    )
]

def parse(path: Path) -> tuple[dict, str]:
    with open(path, 'r') as in_file:
        settings, document = frontmatter.parse(in_file.read())

    if 'id' not in settings and 'title' not in settings:
        settings['title'] = path.stem

    try:
        settings['id'] = str(settings['id'])
    except KeyError:
        settings['id'] = str(path.name)

    return (settings, document)


def configure_logging(debug: bool) -> None:
    if debug:
        level = logging.DEBUG
    else:
        level = logging.INFO

    logging.basicConfig(level=level)


@app.command()
def transform_and_serialise(path: ValidPath, syntax: str = 'json-ld', debug: bool = False, context: EmbedContext = None, pretty_print: PrettyPrint = True, metadata: bool = False) -> None:
    configure_logging(debug)
    (settings, document) = parse(path)
    settings['embed-context'] = context
    settings['metadata'] = metadata
    template = Template(**settings)
    html = template._transform_md_to_html(document)
    doc = html.xpath('/document')[0]

    glossaries = settings.get('import')
    if glossaries:
        if isinstance(glossaries, str):
            glossaries = [glossaries]
        else:
            glossaries = list(set(glossaries))

        for glossary in glossaries:
            glossary_path = path.parent / glossary
            (_, glossary_document) = parse(glossary_path)
            glossary_html = template._transform_md_to_html(glossary_document)
            glossary_definition_lists = glossary_html.xpath('/document/dl')
            for definition_list in glossary_definition_lists:
                doc.append(definition_list)

    (status, result) = template._transform_html_to_json_ld(html)
    if not status:
        console = Console()
        error_line_number = template.debug(document)

        console.print('\nUnable to transform document.', style='red')
        print(f'Could not continue parsing document after line {error_line_number}: \n')
        lines = document.splitlines()
        for line_number, line in enumerate(lines):
            if line_number >= error_line_number:
                console.print(line, style='red')
            else:
                print(line)
        return

    match syntax:
        case 'json-ld':
            print_json(result, ensure_ascii=False)
        case _:
            graph = ConjunctiveGraph()
            graph.parse(data=result, format='json-ld')
            graph.bind('ex', 'http://example.org/')
            graph.bind('exterms', 'http://example.org/terms/')

            try:
                data = graph.serialize(format=syntax)
            except PluginException:
                print(f'Unrecognised RDF syntax: "{syntax}".')
                print('Try: "nt", "turtle" or "nquads".\n')
                print('See: <https://rdflib.readthedocs.io/en/7.1.1/plugin_serializers.html>')
                raise typer.Exit(code=1)

            console = Console()
            if pretty_print and console.is_terminal:
                syntax_lexer = {
                    'longturtle': 'turtle',
                    'n3': 'turtle',
                    'nquads': 'turtle',
                    'nt': 'turtle',
                    'pretty-xml': 'xml',
                    'trig': 'turtle'
                }
                lexer = syntax_lexer.get(syntax, syntax)
                renderer = Syntax(
                    data,
                    lexer,
                    background_color='default',
                    word_wrap=True
                )
                console.print(renderer)
            else:
                print(data)
