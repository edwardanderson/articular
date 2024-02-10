import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import Graph, ConjunctiveGraph
from rich import print_json

from articular import Template


logging.basicConfig(level=logging.DEBUG)
app = typer.Typer()


@app.command()
def transform(path: Path, syntax: str = 'json-ld'):
    with open(path, 'r') as in_file:
        settings, document = frontmatter.parse(in_file.read())

    # Default graph name.
    if 'graph-name' not in settings:
        settings['graph-name'] = path.name

    template = Template(**settings)
    result = template.transform(document)
    match syntax:
        case 'json-ld':
            print_json(result)
        case _:
            graph = ConjunctiveGraph()
            graph.parse(data=result, format='json-ld')
            syntax = graph.serialize(format=syntax)
            print(syntax)
