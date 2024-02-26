import frontmatter
import xml.etree.ElementTree as etree

from markdown_it import MarkdownIt
from pathlib import Path
from rdflib import ConjunctiveGraph
from rdflib.compare import to_isomorphic

from articular import Template


tests_path = Path(__file__).parent / 'tests.md'
md = MarkdownIt('commonmark')
with open(tests_path, 'r') as in_file:
    html_str = md.render(in_file.read())

html_doc = '<html>' + html_str + '</html>'
tree = etree.ElementTree(etree.fromstring(html_doc))
for position, test in enumerate(tree.findall('h2')):
    name = test.text
    markdown = tree.findall('pre/code[@class="language-markdown"]')[position].text
    turtle = tree.findall('pre/code[@class="language-turtle"]')[position].text
    settings, document = frontmatter.parse(markdown)
    template = Template(**settings)
    html = template._transform_md_to_html(document)
    (status, result) = template._transform_html_to_json_ld(html)
    generated = ConjunctiveGraph()
    generated.parse(data=result, format='json-ld')
    expected = ConjunctiveGraph()
    expected.parse(data=turtle, format='turtle')
    print(to_isomorphic(generated) == to_isomorphic(expected), '\t', name)
