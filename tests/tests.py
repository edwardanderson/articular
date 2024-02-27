import frontmatter

from lxml import etree
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
tree = etree.fromstring(html_doc)
markdown_fixtures = tree.findall('pre/code[@class="language-markdown"]')
expected_fixtures = tree.xpath('//pre/code[@class="language-turtle" or @class="language-trig"]')

ns = {'re': 'http://exslt.org/regular-expressions'}
headings = tree.xpath(
    '//*[re:test(local-name(), "^h\d+$")]',
    namespaces=ns
)
tests = [heading for heading in headings if heading.getnext().tag == 'pre']

template = Template()
for position, test in enumerate(tests):
    name = test.text
    markdown = markdown_fixtures[position].text
    fixture = expected_fixtures[position]
    syntax = fixture.get('class').split('-')[-1]
    expected_data = fixture.text

    settings, document = frontmatter.parse(markdown)
    if settings:
        template = Template(**settings)

    html = template._transform_md_to_html(document)
    (status, result) = template._transform_html_to_json_ld(html)
    generated = ConjunctiveGraph()
    generated.parse(data=result, format='json-ld')
    expected = ConjunctiveGraph()
    expected.parse(data=expected_data, format=syntax)

    status = to_isomorphic(generated) == to_isomorphic(expected)
    if status:
        print(status, '\t', name)
    else:
        print(f'\n=== {name} ===\n')
        print('Generated:\n')
        print(generated.serialize(format='turtle'))
        print('----------')
        print('\nExpected:\n')
        print(expected.serialize(format='turtle'))
        print('=========')
