'''
Transformation tests.
'''


import json
import unittest
from mdul_json import Document, create_context
from pathlib import Path
from rdflib import ConjunctiveGraph
from rdflib.compare import isomorphic, graph_diff


class MarkdownFile(object):

    def __init__(self, filename):
        data_path = Path(__file__).parent.joinpath('data')
        self.file = data_path.joinpath(f'source/md/{filename}')

        # Generate document.
        document = Document(
            context=create_context(
                'ns/v1/mdul.json',
                base='/home/'
            ),
            file=self.file
        )
        self.source_json = json.loads(document.to_json())
        self.source_graph = ConjunctiveGraph()
        self.source_graph.parse(data=self.source_json, format='json-ld')

        target_json_path = data_path.joinpath(f'target/json/{self.file.stem}.json')
        with open(target_json_path, 'r') as in_file:
            self.target_json = json.load(in_file)

        self.target_graph = ConjunctiveGraph()
        target_trig_path = data_path.joinpath(f'target/trig/{self.file.stem}.trig')
        self.target_graph.parse(target_trig_path, format='trig')

    def is_isomorphic(self):
        in_both, in_first, in_second = graph_diff(self.source_graph, self.target_graph)
        return isomorphic(self.target_graph, in_both)


# class TestFile(unittest.TestCase):

#     maxDiff = None

#     def setUp(self):
#         self.file = MarkdownFile('file.md')

#     def test_json(self):
#         self.assertDictEqual(self.file.source_json, self.file.target_json)

#     def test_trig(self):
#         status = self.file.is_isomorphic()
#         self.assertTrue(status)


class TestH1PlainText(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.file = MarkdownFile('h1_plain_text.md')

    def test_json(self):
        self.assertDictEqual(self.file.source_json, self.file.target_json)

    def test_trig(self):
        status = self.file.is_isomorphic()
        self.assertTrue(status)


class TestBlockquote(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.file = MarkdownFile('blockquote.md')

    def test_json(self):
        self.assertDictEqual(self.file.source_json, self.file.target_json)

    def test_trig(self):
        status = self.file.is_isomorphic()
        self.assertTrue(status)


if __name__ == '__main__':
    unittest.main()
