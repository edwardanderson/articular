'''
Execute the Specification test fixtures.
'''

import json
import testmark

from rdflib import Graph
from rdflib.compare import to_isomorphic
from pathlib import Path

from krml.document import KrmlSourceDocument


specification = Path(__file__).parent.parent / 'docs/specification.md'
fixtures = testmark.parse(specification)
tests = {}
for identifier, content in fixtures.items():
    key, category = identifier.split(' ')
    try:
        tests[key][category] = content
    except KeyError:
        tests[key] = {category: content}

for identifier, fixture in tests.items():
    # Arrange.
    source = fixture.get('arrange')
    document = KrmlSourceDocument(source)
    expected_ttl = fixture.get('assert-graph')
    if expected_ttl:
        expected_graph = Graph()
        expected_graph.parse(data=expected_ttl, format='turtle')

    expected_str = fixture.get('assert-json')
    if expected_str:
        try:
            expected_json = json.loads(expected_str)
        except:
            expected_json = {}

    # Act.
    try:
        result = document.transform()
    except Exception as e:
        print(f'cannot transform: {identifier}')
        continue

    # Assert.
    status_shape = to_isomorphic(result.graph) == to_isomorphic(expected_graph)
    status_syntax = result == expected_json

    # Report.
    print(f'{identifier}\t{status_shape}\t{status_syntax}')
