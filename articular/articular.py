import logging
from markdown_it import MarkdownIt

from lxml import etree
from pathlib import Path
from saxonche import PySaxonProcessor


logger = logging.getLogger(__name__)


class Template:

    _path = Path(__file__).parent / 'xsl/ul.xsl'

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
        arguments = {'breaks': True, 'html': True}
        md = (
            MarkdownIt(
                'commonmark',
                arguments
            )
            .enable('table')
        )
        html_str = md.render(md_str)
        html_obj = etree.fromstring(html_str, parser=Template._parser)
        logger.debug(etree.tostring(html_obj, pretty_print=True).decode('utf-8'))
        node = self.processor.parse_xml(xml_text=str(html_str))
        result = self.executable.transform_to_string(xdm_node=node)
        return result
