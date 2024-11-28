import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import ConjunctiveGraph
from rdflib.plugin import PluginException
from rich import print_json
from rich.console import Console
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


def parse(path: Path) -> tuple[dict, str]:
    with open(path, 'r') as in_file:
        settings, document = frontmatter.parse(in_file.read())

    # Default graph name.
    if 'graph-name' not in settings:
        settings['graph-name'] = path.name

    return (settings, document)


def configure_logging(debug: bool) -> None:
    if debug:
        level = logging.DEBUG
    else:
        level = logging.INFO

    logging.basicConfig(level=level)


@app.command()
def transform_and_serialise(path: ValidPath, syntax: str = 'json-ld', debug: bool = False) -> None:
    configure_logging(debug)
    (settings, document) = parse(path)
    template = Template(**settings)
    html = template._transform_md_to_html(document)
    doc = html.xpath('/document')[0]

    glossary_path_str = settings.get('glossary')
    if glossary_path_str:
        glossary_path = path.parent / glossary_path_str
        (_, glossary_document) = parse(glossary_path)
        glossary_html = template._transform_md_to_html(glossary_document)
        glossary_dls = glossary_html.xpath('/document/dl')
        for dl in glossary_dls:
            doc.append(dl)

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
            try:
                data = graph.serialize(format=syntax)
                print(data)
            except PluginException:
                print(f'Unrecognised RDF syntax: "{syntax}".')
                print('Try: "nt", "turtle" or "nquads".')
                typer.Exit(code=1)
