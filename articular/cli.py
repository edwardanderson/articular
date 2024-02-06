import frontmatter
import logging
import typer

from pathlib import Path
from rdflib import Graph
from rich import print_json

from articular import Template


logging.basicConfig(level=logging.INFO)
app = typer.Typer()


@app.command()
def transform(path: Path, syntax: str = 'json-ld'):
    with open(path, 'r') as in_file:
        settings, document = frontmatter.parse(in_file.read())

    template = Template(**settings)
    result = template.transform(document)
    match syntax:
        case 'json-ld':
            print_json(result)
        case _:
            graph = Graph()
            graph.parse(data=result, format='json-ld')
            syntax = graph.serialize(format=syntax)
            print(syntax)
