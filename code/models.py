'''
Classes for parsing and serialising Linked Art JSON-LD from Markdown documents (via HTML).
'''


import re
import json
import mimetypes
import markdown as md
from bs4 import BeautifulSoup
# from dateutil import parser
import datetime
import dateparser
from dateparser.search import search_dates


import requests
from pyld import jsonld
from rdflib import ConjunctiveGraph


repository = 'https://github.com/example-museum'

class LinkedArtPrimitive(dict):

    def __init__(self, *html_objects):
        self._property = None
        for html_obj in html_objects:
            if html_obj.name == 'code':
                # Type
                text = html_obj.text
                if ' ' in text:
                    text = text.title().replace(' ', '')
                self['type'] = text
            elif html_obj.name == 'a':
                # URI
                id_ = html_obj.get('href')
                # Relative URIs are local
                if not id_.startswith('http'):
                    if not id_.startswith('#'):
                        id_ = f'{repository}/{id_}'.replace(' ', '-').lower()
                    else:
                        id_ = id_.replace(' ', '-').lower()
                self['id'] = id_
                self['_label'] = html_obj.text
            elif html_obj.name == 'em':
                # Property
                self._property = html_obj.text.replace(' ', '_').lower()
            elif html_obj.name == 'p':
                # Text
                self['content'] = str(html_obj)
                self['format'] = 'text/html'
            elif html_obj.name == 'strong':
                # Special key for: { "property": "value" }
                self['str'] = html_obj.text
            elif html_obj.name == 'img':
                self.update(Image(html_obj))
            elif html_obj.name == 'blockquote':
                self.update(BlockQuote(html_obj))
            elif html_obj.name is None:
                # An emoji in any position sets the type.
                parts = html_obj.split(' ')
                for i in parts:
                    if i in emoji_types:
                        self['type'] = emoji_types[i]
                        # TODO: Fix missing _label when emoji used.
                        return

                # Label
                try:
                    self['_label'] = html_obj.text
                except:
                    self['_label'] = html_obj.strip()

            # Remove empty.
            if '_label' in self:
                if not self['_label']:
                    del self['_label']


class LinkedArtObject(dict):

    def __init__(self, *args, **kwargs):
        self._property = None
        for html_obj in args:
            primitive = LinkedArtPrimitive(html_obj)
            if primitive._property is not None:
                self._property = primitive._property
            else:
                self.update(primitive)
        self.update(kwargs)

        # Replace emojis with textual types.
        try:
            self['type'] = emoji_types[self['type']]
        except Exception:
            pass

        # Set defaults.
        # Type
        if not 'type' in self:
            if self._property:
                # Apply framework default property
                try:
                    self['type'] = defaults[self._property]
                except:
                    pass
            else:
                # Infer type from vocabulary
                if 'id' in self:
                    if self['id'].startswith('http://vocab.getty.edu/aat/'):
                        self['type'] = 'Type'
                    elif self['id'].startswith(('http://vocab.getty.edu/tgn/', 'https://sws.geonames.org/')):
                        self['type'] = 'Place'

        # Property
        if self._property is None:
            try:
                self._property = defaults[self['type']]
            except:
                pass

    def add(self, obj):
        if obj._property:
            if 'str' in obj:
                # Normalise ISO date string to dateTime if incomplete
                if obj._property in ['begin_of_the_begin', 'begin_of_the_end']:
                    date_time = normalise_iso_date_fragment(obj['str'])
                    self[obj._property] = date_time
                elif obj._property in ['end_of_the_begin', 'end_of_the_end']:
                    date_time = normalise_iso_date_fragment(obj['str'], start=False)
                    self[obj._property] = date_time
                else:
                    self[obj._property] = obj['str']
            else:
                try:
                    self[obj._property].append(obj)
                except:
                    self[obj._property] = [obj]
        else:
            for key in obj:
                value = obj[key]
                try:
                    self[key].append(value)
                except:
                    self[key] = value

    def json(self):
        return json.dumps(self, indent=2, sort_keys=False, ensure_ascii=False)


class UnorderedList(LinkedArtObject):

    def __init__(self, ul):
        super().__init__()
        self.unordered_list(self, ul)

    def unordered_list(self, parent, ul):
        for li in ul.find_all('li', recursive=False):
            obj = LinkedArtObject(*li.children)
            nest = li.find('ul')
            if nest:
                children = self.unordered_list(obj, nest)
                parent.add(children)
            else:
                parent.add(obj)
        return parent


class BlockQuote(LinkedArtObject):

    def __init__(self, blockquote):
        super().__init__()
        rich_text = blockquote.find_all(['strong', 'em', 'a'])
        if rich_text:
            self['content'] = ''.join([str(i) for i in blockquote.contents if i != '\n'])
            self['format'] = 'text/html'
        else:
            # Plain text
            self['content'] = list(blockquote.stripped_strings)[0]


class ArticularTimeSpan(LinkedArtObject):

    def __init__(self, obj):
        super().__init__()
        dates_str = obj['content']
        self['identified_by'] = [{'type': 'Name', 'content': dates_str}]

        dates = search_dates(dates_str)

        start_date_str = dates[0][0]
        end_date_str = dates[-1][0]

        start_date = search_dates(start_date_str, settings={'PREFER_DAY_OF_MONTH': 'first', 'RELATIVE_BASE': datetime.datetime(1900, 1, 1)})
        end_date = search_dates(end_date_str, settings={'PREFER_DAY_OF_MONTH': 'last', 'RELATIVE_BASE': datetime.datetime(1900, 12, 31)})
        end_date = end_date[0][1] + datetime.timedelta(days=1)
        end_date = end_date - datetime.timedelta(seconds=1)


        self['begin_of_the_begin'] = str(start_date[0][1]).replace(' ', 'T') + 'Z'
        self['end_of_the_end'] = str(end_date).replace(' ', 'T') + 'Z'



class Image(LinkedArtObject):

    def __init__(self, img):
        super().__init__()
        path = img.get('src')
        mime = mimetypes.guess_type(path)[0]
        self['type'] = 'DigitalObject'
        self['_label'] = img.get('alt')
        self['access_point'] = [{'id': path, 'type': 'DigitalObject'}]
        self['classified_as'] = {'id': 'http://vocab.getty.edu/aat/300215302', '_label': 'Digital Image', 'type': 'Type'}
        self['format'] = mime


class LinkedArtDocument(LinkedArtObject):

    def __init__(self, markdown_doc_str):
        html_doc = md.markdown(markdown_doc_str)
        self.soup = BeautifulSoup(html_doc, 'html.parser')

        # Heading
        h1 = self.soup.find('h1')
        super().__init__(*h1.contents)
        self['@context'] = 'https://linked.art/ns/v1/linked-art.json'

        # Sub-headings
        sections = self.split_by_headings(self.soup)
        stack = self.headings_to_object(sections)
        try:
            self.add(stack[0])
        except:
            pass

    def _next_element(self, elem):
        while elem is not None:
            # Find next element, skip NavigableString objects
            elem = elem.next_sibling
            if hasattr(elem, 'name'):
                return elem

    def split_by_headings(self, html_doc):
        sections = []
        headings = html_doc.find_all(re.compile('^h[1-6]$'))
        for h in headings:
            depth = int(h.name[1])
            obj = LinkedArtObject(*h.contents)

            # Parse heading block's child elements.
            element = self._next_element(h)
            while element and not str(element.name).startswith('h'):
                if element != '\n':
                    child = None
                    if element.name == 'ul':
                        child = UnorderedList(element)
                    elif element.name == 'blockquote':
                        child = BlockQuote(element)
                        if obj['type'] == 'TimeSpan':
                            child = ArticularTimeSpan(child)

                    elif element.name == 'p':
                        # Images
                        for img in element.contents:
                            try:
                                child = Image(img)
                                child._property = 'digitally_shown_by'
                            except:
                                pass

                    if child:
                        if depth > 1:
                            obj.add(child)
                        elif depth == 1:
                            self.add(child)

                element = self._next_element(element)

            if depth > 1:
                d = {'object': obj, 'depth': depth}
                sections.append(d)

        return sections

    def headings_to_object(self, sections):
        stack = []
        depth = 0
        current = LinkedArtObject()
        for d in sections:
            # Determine how to nest headings.
            if d['depth'] > depth:
                # Deeper
                next = d['object']
                current.add(next)
                stack.append(current)
                current = next
                depth = d['depth']
            elif d['depth'] < depth:
                # Shallower closes current, gets previous level.
                while depth > d['depth']:
                    prev = stack.pop()
                    depth = depth - 1
                current = d['object']
                stack[-1].add(current)
                depth = d['depth']
            else:
                # Same depth 
                current = d['object']
                stack[-1].add(current)
        return stack

    def graph(self):
        js = json.loads(self.json())
        nq = jsonld.to_rdf(js, {'format': 'application/nquads'})
        rdf_graph = ConjunctiveGraph()
        contexts = {
            'crm': 'http://www.cidoc-crm.org/cidoc-crm/', 
            'sci': 'http://www.ics.forth.gr/isl/CRMsci/', 
            'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 
            'rdfs': 'http://www.w3.org/2000/01/rdf-schema#', 
            'dc': 'http://purl.org/dc/elements/1.1/', 
            'dcterms': 'http://purl.org/dc/terms/', 
            'schema': 'http://schema.org/', 
            'skos': 'http://www.w3.org/2004/02/skos/core#', 
            'foaf': 'http://xmlns.com/foaf/0.1/', 
            'xsd': 'http://www.w3.org/2001/XMLSchema#', 
            'dig': 'http://www.ics.forth.gr/isl/CRMdig/', 
            'la': 'https://linked.art/ns/terms/', 
        }
        for namespace in contexts:
            rdf_graph.bind(namespace, contexts[namespace])
        rdf_graph.parse(data=nq, format='nt')
        return rdf_graph

    def jsonld(self):
        js = json.loads(self.json())
        # Frame
        frame = {'@id': self['id'], "@embed": "@always"}
        framed = jsonld.frame(js, frame)
        # Compact
        compacted = jsonld.compact(framed, linked_art_application_profile.json())
        compacted['@context'] = linked_art_context
        return json.dumps(compacted, indent=2, ensure_ascii=False)

    def turtle(self):
        graph = self.graph()
        return graph.serialize(format='turtle').decode('utf-8')

    def html(self):
        return self.soup.prettify()


def normalise_iso_date_fragment(iso_date, start=True):
    start_time = '00:00:00Z'
    end_time = '23:59:59Z'
    if len(iso_date) == 4:
        if start:
            date_time = f'{iso_date}-01-01T{start_time}'
        else:
            date_time = f'{iso_date}-12-31T{end_time}'
    elif len(iso_date) == 7:
        if start:
            date_time = f'{iso_date}-01T{start_time}'
        else:
            date_time = f'{iso_date}-31T{end_time}'
    elif len(iso_date) == 10:
        if start:
            date_time = f'{iso_date}T{start_time}'
        else:
            date_time = f'{iso_date}T{end_time}'
    elif len(iso_date) > 10:
        return iso_date
    return date_time


linked_art_context = 'https://linked.art/ns/v1/linked-art.json'
linked_art_application_profile = requests.get(linked_art_context)

# cache = {}
# def caching_document_loader(url):
#     loader = jsonld.requests_document_loader()
#     if url not in cache:
#         resp = loader(url)
#         cache[url] = dict(resp)
#     return cache[url]


# jsonld.set_document_loader(caching_document_loader(linked_art_context))

jsonld.set_document_loader(jsonld.requests_document_loader(timeout=30))

# Collect default properties/classes to allow user to omit.
defaults = {}
emoji_types = {}
with open('defaults.json', 'r') as in_file:
    d = json.load(in_file)
    for key in d:
        default_property = d[key]['default_property']
        if default_property:
            defaults[key] = d[key]['default_property']
        for emoji in d[key]['emoji']:
            emoji_types[emoji] = key

# Reverse dictionary to allow property->type lookup.
for k in dict(defaults):
    v = defaults[k]
    defaults[v] = k
