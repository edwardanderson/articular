import frontmatter
import xml.etree.ElementTree as ET

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
tree = ET.ElementTree(ET.fromstring(html_doc))
markdown_fixtures = tree.findall('pre/code[@class="language-markdown"]')
turtle_fixtures = tree.findall('pre/code[@class="language-turtle"]')

for position, test in enumerate(tree.findall('h2')):
    name = test.text
    markdown = markdown_fixtures[position].text
    turtle = turtle_fixtures[position].text

    settings, document = frontmatter.parse(markdown)
    template = Template(**settings)
    html = template._transform_md_to_html(document)
    (status, result) = template._transform_html_to_json_ld(html)
    generated = ConjunctiveGraph()
    generated.parse(data=result, format='json-ld')
    expected = ConjunctiveGraph()
    expected.parse(data=turtle, format='turtle')
    status = to_isomorphic(generated) == to_isomorphic(expected)
    if status:
        print(status, '\t', name)
    else:
        print(f'\n{name}\n')
        print(generated.serialize(format='turtle'))
