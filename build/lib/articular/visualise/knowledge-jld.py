'''
Draw all triples using plain JSON.
'''


import json
import requests
import textwrap
from models import Visualisation
from models import attributes
from pathlib import Path


class KnowledgeGraph(object):

    def __init__(self, *paths, draw_vocabulary=False):
        self.id_ = 'knowledge'
        self.label = 'knowledge_label'
        self.ids = list()
        self.nodes = dict()
        self.edges = dict()
        self.context = dict()

        for path in paths:
            with open(path, 'r') as inf:
                j = json.load(inf)

                # Get contexts.
                for c in j['@context']:
                    if isinstance(c, dict):
                        self.context.update(c)
                    elif c.startswith('http'):
                        response = requests.get(c)
                        context = response.json()['@context']
                        self.context.update(context)
            
                j.pop('@context')
                self.walk(j)

        # Prune vocabulary.
        if not draw_vocabulary:
            for e in dict(self.edges):
                if self.edges[e]['label'] == 'type':
                    n = e[1]
                    self.nodes.pop(n, None)
                    self.edges.pop(e)

    def __repr__(self):
        return self.dot()

    def dot(self):
        dot = str()
        dot += f'subgraph cluster_{self.id_} {{\n'
        # Label.
        dot += f'\tlabel="{self.label}"\n'
        # Nodes.
        for n in self.nodes:
            if n not in self.ids:
                self.ids.append(n)
            nid = str(self.id_) + str(self.ids.index(n))
            dot += f'\t{nid} [\n'
            for key in self.nodes[n]:
                value = self.nodes[n][key]
                dot += f'\t\t{key}="{value}"\n'
            dot += '\t]\n'
        # Edges.
        for relation in self.edges:
            a = str(self.id_) + str(self.ids.index(relation[0]))
            b = str(self.id_) + str(self.ids.index(relation[1]))
            dot += f'\t{a} -> {b} [\n'
            # dot += f'\t\tlabel="{self.edges[relation]}"\n'
            for key in self.edges[relation]:
                value = self.edges[relation][key]
                dot += f'\t\t{key}="{value}"\n'
            dot += '\t]\n'

        dot += '}\n'
        return dot

    def walk(self, d):
        '''
        Recurse.
        '''
        # Create node.
        node = dict()
        if '_label' in d:
            node['label'] = d['_label']
        else:
            node['label'] = ' '
        if 'id' in d:
            id_ = d['id']
            node['href'] = id_
            node['tooltip'] = id_
            node['target'] = '_blank'
            node['penwidth'] = 1
            # File.
            if id_.endswith('.md'):
                node['color'] = 'red'
                node['label'] = id_
            else:
                node['color'] = 'blue'
        else:
            id_ = id(d)
        
        if id_ in self.nodes:
            if node['label'] != ' ':
                self.nodes[id_].update(node)
            else:
                node.pop('label')
                self.nodes[id_].update(node)
        else:
            self.nodes[id_] = node

        for key, item in d.items():
            # Relationship attributes.
            relationship = dict()
            relationship['label'] = key
            if key in self.context:
                try:
                    context_id = self.context[key]['@id']
                    prefix, term = context_id.split(':')
                    if prefix in self.context:
                        value = self.context[prefix] + term
                    url = value
                except KeyError:
                    url = self.context[key]['@reverse']['@id']
                except TypeError:
                    url = self.context[key]

                relationship['href'] = url
                relationship['tooltip'] = url
                relationship['target'] = '_blank'

            if isinstance(item, dict):
                item_id = item.get('id', id(item))
                relation = (id_, item_id)
                self.edges[relation] = relationship
                self.walk(item)
            elif isinstance(item, list):
                for obj in item:
                    obj_id = obj.get('id', id(obj))
                    relation = (id_, obj_id)
                    self.edges[relation] = relationship
                    self.walk(obj)
            else:
                if key not in ['_label', 'id']:
                    # Node attributes.
                    obj = dict()
                    # Word wrap.
                    wrapped_text = textwrap.fill(item, 40)
                    if wrapped_text != item:
                        # Left justify.
                        wrapped_text = wrapped_text.replace('\n', '\l') + '\l'
                        obj['label'] = wrapped_text
                        # obj['labeljust'] = 'l'
                        obj['margin'] = '0.8,0.2'
                    else:
                        obj['label'] = item

                    # Vocabulary.
                    if item in self.context:
                        obj['class'] = 'Vocabulary'
                        try:
                            context_id = self.context[item]['@id']
                            prefix, term = context_id.split(':')
                            if prefix in self.context:
                                value = self.context[prefix] + term
                            url = value
                        except TypeError:
                            url = self.context[item]

                        obj['href'] = url
                        obj['tooltip'] = url
                        obj['color'] = 'blue'
                        obj['penwidth'] = 1

                    if 'href' in obj:
                        item_id = obj['href']
                    else:
                        item_id = id(item)

                    relation = (id_, item_id)
                    self.nodes[item_id] = obj
                    self.edges[relation] = relationship


a = attributes
a['graph']['layout'] = 'neato'

paths = [path for path in Path('../out/').glob('*.json')]
kg = KnowledgeGraph(*paths, draw_vocabulary=True)
v = Visualisation([kg], attributes=a)
print(v)
