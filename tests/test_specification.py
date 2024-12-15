import json
import pytest
import testmark

from pathlib import Path
from rdflib import ConjunctiveGraph, Graph
from rdflib.compare import to_isomorphic
from krml.document import KrmlSourceDocument


# Path to the specification file
SPECIFICATION_PATH = Path(__file__).parent.parent / 'docs/specification.md'

# Parse testmark fixtures
fixtures = testmark.parse(SPECIFICATION_PATH)


def parse_fixtures(fixtures):
    '''
    Organize fixtures into a dictionary with categories.
    '''
    tests = {}
    for identifier, content in fixtures.items():
        key, category = identifier.split(' ')
        if key not in tests:
            tests[key] = {}
        tests[key][category] = content
    return tests


def prepare_expected_graph(expected_graph_str, graph_name):
    '''
    Prepare the expected graph based on the provided string.
    '''
    if not expected_graph_str:
        return None

    graph = ConjunctiveGraph() if graph_name else Graph()
    syntax = 'trig' if graph_name else 'turtle'
    graph.parse(data=expected_graph_str, format=syntax)
    return graph


@pytest.mark.parametrize('identifier, fixture', parse_fixtures(fixtures).items())
def test_fixtures(identifier, fixture):
    # Arrange
    source = fixture.get('arrange')
    params = {'embed-context': True}
    document = KrmlSourceDocument(source, **params)

    expected_graph_str = fixture.get('assert-graph')
    graph_name = document.settings.get('id', None)
    expected_graph = prepare_expected_graph(expected_graph_str, graph_name)

    expected_str = fixture.get('assert-json')
    expected_json = json.loads(expected_str) if expected_str else {}

    # Act
    try:
        result = document.transform()
    except Exception as e:
        pytest.fail(f"Transformation failed for {identifier}: {e}")

    # Assert
    if expected_graph:
        isomorphic = to_isomorphic(result.graph) == to_isomorphic(expected_graph)
        turtle = result.graph.serialize(format='turtle')
        assert isomorphic is True, f'Graph mismatch for {identifier}; got: {turtle}'

    if expected_json:
        assert result.json == expected_json, f'JSON mismatch for {identifier}'
