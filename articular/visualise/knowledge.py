'''
Draw all the triples.
'''


from rdflib import ConjunctiveGraph
from pathlib import Path


graph = ConjunctiveGraph()

for path in Path('../out/').glob('*.json'):
    graph.parse(str(path), format='json-ld')

print(graph.serialize(format='trig'))
