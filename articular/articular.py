import logging

from lxml import etree
from markdown_it import MarkdownIt
from mdit_py_plugins import deflist
from pathlib import Path
from saxonche import PySaxonProcessor


logger = logging.getLogger(__name__)


class Template:

    _path = Path(__file__).parent / 'xsl/document.xsl'

    _parser = etree.XMLParser(
        ns_clean=True,
        recover=True,
        encoding='utf-8',
        remove_blank_text=True
    )

    def __init__(self, template_path: Path = _path, **parameters):
        self.processor = PySaxonProcessor()
        self.xslt = self.processor.new_xslt30_processor()
        for (parameter, value) in parameters.items():
            match value:
                case str():
                    prepared_value = self.processor.make_string_value(value)
                case bool():
                    prepared_value = self.processor.make_boolean_value(value)
                case int():
                    prepared_value = self.processor.make_integer_value(value)
                case _:
                    continue

            self.xslt.set_parameter(parameter, prepared_value)

        self.executable = self.xslt.compile_stylesheet(
            stylesheet_file=str(template_path)
        )

    def transform(self, md_str: str):
        arguments = {
            'breaks': True,
            'html': True,
            'typographer': True
        }
        md = (
            MarkdownIt(
                'commonmark',
                arguments
            )
            .enable(
                [
                    'replacements',
                    'smartquotes',
                    'table'
                ]
            )
            .use(deflist.deflist_plugin)
        )
        html_str = md.render(md_str)
        html_doc = '<document>' + html_str + '</document>'
        logger.debug(html_doc)
        html_obj = etree.fromstring(html_doc, parser=Template._parser)

        # Trim trailing new line characters from list items.
        items = html_obj.xpath('//li')
        for item in items:
            try:
                item.text = item.text.rstrip()
            except AttributeError:
                pass

        html_doc_str = etree.tostring(html_obj).decode('utf-8')

        logger.debug(etree.tostring(html_obj, pretty_print=True).decode('utf-8'))
        node = self.processor.parse_xml(xml_text=str(html_doc_str))
        result = self.executable.transform_to_string(xdm_node=node)
        return result
