import frontmatter
import json

from pathlib import Path
from rdflib import ConjunctiveGraph, Dataset
from krml import Template



class KrmlResultDocument:
    
    def __init__(self, json_ld: str) -> None:
        self.json = json.loads(json_ld)
        self._graph = None

    @property
    def graph(self) -> ConjunctiveGraph:
        if not self._graph:
            self._graph = ConjunctiveGraph()
            # self._graph = Dataset()
            self._graph.parse(data=self.json, format='json-ld')

        return self._graph

    @property
    def turtle(self) -> str:
        return self.graph.serialize(format='turtle')

    @property
    def json_ld(self) -> str:
        return json.dumps(self.json, indent=2, ensure_ascii=False)


class KrmlSourceDocument:

    def __init__(self, md: str, name: str | None = None) -> None:
        self._md = md
        settings, document = frontmatter.parse(md)
        self.template = Template(**settings)
        self.html = self.template._transform_md_to_html(document)

        content = self.html.xpath('/document')[0]
        glossary_path_str = settings.get('import')
        if glossary_path_str:
            template = Template()
            glossary_path = Path(glossary_path_str)
            with open(glossary_path, 'r') as in_file:
                glossary = template._transform_md_to_html(in_file.read())

            glossary_dls = glossary.xpath('/document/dl')
            for dl in glossary_dls:
                content.append(dl)


    def __str__(self) -> str:
        return self.html

    def transform(self) -> KrmlResultDocument:
        (status, result) = self.template._transform_html_to_json_ld(self.html)
        document = KrmlResultDocument(result)
        return document

    @property
    def md(self) -> str:
        return self._md
