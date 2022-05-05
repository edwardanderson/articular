'''
Classes for performing Markdown content transformations.
'''


import frontmatter
import json
import pypandoc
import re
import urllib.parse
import xmltodict

from lxml import etree
from pathlib import Path
from typing import Dict


class Template:
    '''
    Translate a Markdown string.

    >>> md = """
    ... ---
    ... context:
    ...   Album: https://schema.org/MusicAlbum
    ... ---
    ... # [Kind of Blue](http://www.wikidata.org/entity/Q283221 "Album")
    ...
    ... Kind of Blue is a studio album by American jazz musician Miles Davis.
    ...
    ... > Don't play what's there, play what's not there.
    ...
    ... """

    >>> d = Template.transform(md)
    >>> print(Template._dump(d))
    {
        "@context": [
            "https://articular.netlify.app/articular.json",
            {
                "Album": "https://schema.org/MusicAlbum"
            }
        ],
        "_label": "Kind of Blue",
        "type": "Album",
        "_same_as": {
            "id": "http://www.wikidata.org/entity/Q283221",
            "type": "Album",
            "_label": "Kind of Blue"
        },
        "_comment": [
            {
                "type": "_Comment",
                "_content": "Kind of Blue is a studio album by American jazz musician Miles Davis."
            },
            {
                "type": "_Quotation",
                "_content": "Don’t play what’s there, play what’s not there."
            }
        ]
    }

    '''
    _path = Path(__file__).parent.joinpath('templates/html_to_xml.xsl')
    _xslt = etree.parse(str(_path))
    _template = etree.XSLT(_xslt)

    @classmethod
    def _dump(cls, d: dict) -> str:
        '''
        Serialise a dictionary as JSON.
        '''
        return json.dumps(d, indent=4, ensure_ascii=False)

    @classmethod
    def _md_to_html(cls, md: str) -> etree.ElementTree:
        '''
        Convert a Markdown string to heading-nested HTML.

        >>> md = '# Example'
        >>> html = Template._md_to_html(md)
        >>> print(etree.tostring(html, pretty_print=True).decode('utf-8')) # doctest: +NORMALIZE_WHITESPACE
        <section id="example" class="level1">
            <h1>Example</h1>
        </section>

        '''
        html = pypandoc.convert_text(
            md,
            'html5',
            format='md',
            extra_args=[
                '--section-divs'
            ]
        )
        # Patch @title quote marks.
        html_str = re.sub(r'a href="%22(.*)%22', r'a href="" title="\1', html)
        html_obj = etree.fromstring(html_str)
        return html_obj

    @classmethod
    def _html_to_xml(cls, xml: etree.ElementTree) -> str:
        '''
        Apply XSLT to reshape document.

        >>> md = '# Example'
        >>> html = Template._md_to_html(md)
        >>> result = Template._html_to_xml(html)
        >>> print(result) # doctest: +NORMALIZE_WHITESPACE
        <document>
            <context/>
            <_label>Example</_label>
        </document>

        '''
        result = cls._template(xml)
        return str(result)

    @classmethod
    def _xml_to_dict(cls, xml: str) -> Dict:
        '''
        Convert an XML document to dictionary.

        >>> md = '# Example'
        >>> html = Template._md_to_html(md)
        >>> xml = Template._html_to_xml(html)
        >>> d = Template._xml_to_dict(xml)
        >>> print(d)
        OrderedDict([('document', OrderedDict([('context', None), ('_label', 'Example')]))])

        '''
        d = xmltodict.parse(xml)
        return d

    @classmethod
    def transform(cls, text: str) -> Dict:
        '''
        Convert a Markdown string.
        '''
        contexts = ['https://articular.netlify.app/articular.json']
        front_matter, content = frontmatter.parse(text)

        # User-declared context
        front_matter_context = front_matter.get('context', dict())

        # Convert document.
        html = cls._md_to_html(content)
        xml = cls._html_to_xml(html)
        d = cls._xml_to_dict(xml)

        # User-generated context.
        context = d['document'].pop('context', dict())
        if not context:
            context = dict()

        if isinstance(front_matter_context, str):
            contexts.append(front_matter_context)
        else:
            # Combine user-generated with user-declared context.
            context.update(front_matter_context)

        clean_context = cls.sanitise_context(context)
        if clean_context:
            contexts.append(clean_context)

        document = {'@context': contexts}
        document.update(d['document'])
        return document

    @classmethod
    def sanitise_context(cls, context: dict) -> Dict:
        '''
        Clean up a @context by removing URL-encoding references
        and removing duplicates.
        '''
        def make_safe_reference(reference: str) -> str:
            # Do not encode colons to preserve namespaces.
            return urllib.parse.quote(reference).replace('%3A', ':')

        for key, value in dict(context).items():
            if isinstance(value, list):
                items = list(set(value))
                if len(items) == 1:
                    safe_reference = make_safe_reference(items[0])
                else:
                    raise ValueError(f'Unexpected number of references in context: {items}.')
                context[key] = safe_reference
            elif isinstance(value, dict):
                # Patch @reverse property.
                if value['type'] in ['inverse', 'reverse']:
                    context[key] = {'@reverse': value['id']}
                # Fix missing @ prefixes.
                for k, v in dict(value).items():
                    if k in ['id', 'type']:
                        value[f'@{k}'] = v
                        value.pop(k)
            elif isinstance(value, str):
                context[key] = make_safe_reference(value)

        return context


if __name__ == '__main__':
    import doctest
    doctest.testmod()
