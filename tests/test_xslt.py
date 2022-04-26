'''
Test HTML to XML transformations.
'''


import unittest
from lxml import etree
from pathlib import Path


class XSLTest(object):

    def __init__(self, xsl_filename, data_filename):
        xslt_path = Path(__file__).parent.parent.joinpath(f'mdul_json/templates/{xsl_filename}')
        xslt = etree.parse(str(xslt_path))
        self.template = etree.XSLT(xslt)

        data_path = Path(__file__).parent.joinpath('data/')
        source_html_path = data_path.joinpath(f'source/html/{data_filename}.html')
        with open(source_html_path, 'r') as in_file:
            text = in_file.read().strip()
            if text:
                self.source_html = etree.fromstring(text)
            else:
                self.source_html = etree.Element('empty')

        target_xml_path = data_path.joinpath(f'target/xml/{data_filename}.xml')
        with open(target_xml_path, 'r') as in_file:
            self.target_xml = in_file.read()

    def transform(self):
        result = self.template(self.source_html)
        etree.indent(result, space='    ')
        result_str = etree.tostring(result, pretty_print=True).decode('utf-8')
        return result_str


class TestFile(unittest.TestCase):

    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'file')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestH1PlainText(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'h1_plain_text')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestH1Hyperlink(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'h1_hyperlink')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestH1H2(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'h1_h2')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestH1H2Hyperlink(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'h1_h2_hyperlink')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestBlockquoteAttributed(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'blockquote_attributed')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestBlockquoteRich(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'blockquote_rich')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestBlockquote(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'blockquote')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestParagraph(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'paragraph')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestImage(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'image')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestTable(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'table')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestList(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'list')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


class TestListHyperlinkImage(unittest.TestCase):
    
    maxDiff = None

    def setUp(self):
        self.xsl = XSLTest('mdul_to_json.xsl', 'list_hyperlink_image')
 
    def test_xsl(self):
        result = self.xsl.transform()
        self.assertEqual(result, self.xsl.target_xml)


if __name__ == '__main__':
    unittest.main()
