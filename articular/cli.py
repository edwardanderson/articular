import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import ConjunctiveGraph
from rich import print_json
from rich.console import Console
from typing_extensions import Annotated

from articular import Template


logging.basicConfig(level=logging.INFO)
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


@app.command()
def transform_and_serialise(path: ValidPath, syntax: str = 'json-ld') -> None:
    (settings, document) = parse(path)
    template = Template(**settings)
    (status, result) = template.transform(document)
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
            print_json(result)
        case _:
            graph = ConjunctiveGraph()
            graph.parse(data=result, format='json-ld')
            data = graph.serialize(format=syntax)
            print(data)
