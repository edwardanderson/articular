import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import ConjunctiveGraph
from rich import print_json

from articular import Template


logging.basicConfig(level=logging.DEBUG)
app = typer.Typer()


def transform(path: Path) -> str:
    with open(path, 'r') as in_file:
        settings, document = frontmatter.parse(in_file.read())

    # Default graph name.
    if 'graph-name' not in settings:
        settings['graph-name'] = path.name

    template = Template(**settings)
    result = template.transform(document)
    return result


@app.command()
def transform_and_serialise(path: Path, syntax: str = 'json-ld') -> None:
    result = transform(path)
    match syntax:
        case 'json-ld':
            print_json(result)
        case _:
            graph = ConjunctiveGraph()
            graph.parse(data=result, format='json-ld')
            data = graph.serialize(format=syntax)
            print(data)
