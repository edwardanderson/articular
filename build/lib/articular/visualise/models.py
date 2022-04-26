

import json
import textwrap
import requests


class Visualisation(object):

    def __init__(self, graphs, attributes=None, layout='dot'):
        self.layout = layout
        self.attributes = attributes
        self.graphs = list(graphs)

    def __repr__(self):
        dot = str()
        dot += 'digraph {\n'
        # Layout.
        dot += f'\tlayout="{self.layout}"\n'
        # Style.
        for section in self.attributes:
            dot += '\t' + section + ' [\n'
            for field in self.attributes[section]:
                value = self.attributes[section][field]
                if value:
                    dot += f'\t\t{field}="{value}"\n'
                else:
                    dot += f'\t\t{field}="none"\n'
            dot += '\t' + ']\n'
        # Data.
        for subgraph in self.graphs:
            subdot = subgraph.dot()
            for line in subdot.split('\n'):
                dot += f'\t{line}\n'
        dot += '}\n'
        return dot


attributes = {
    'graph': {
        'concentrate': 'true',
        'overlap': 'false',
        'style':'rounded,dashed',
        'penwidth': '0.2',
        'labeljust': 'l',
        'labelloc': 't',
        'fontname': 'Mono',
        'fontsize': '8'
    },
    'node': {
        'fontname': 'DejaVu Sans',
        'shape': 'rectangle',
        'style': 'rounded,dashed',
        'color': 'black',
        'fontsize': '10',
        'margin': '0.2',
        'penwidth': '0.2'
    },
    'edge': {
        'style': 'dashed',
        'fontsize': 8,
        'arrowhead': 'empty',
        'penwidth': '0.2'
    }
}


class Graph(object):

    def __init__(self, data):
        self.label = data['id']
        self.id_ = self.label.split('.')[0].replace('-', '_').replace(' ', '_')

        # Contexts.
        self.context = dict()
        for c in data['@context']:
            if isinstance(c, dict):
                self.context.update(c)
            elif c.startswith('http'):
                response = requests.get(c)
                context = response.json()['@context']
                self.context.update(context)

        # Parse.
        self.data = data['_describes']
        self.ids = list()
        self.nodes = dict()
        self.edges = dict()
        self.walk(self.data)

    def __repr__(self):
        return self.dot()

    def __str__(self):
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
            try:
                a = str(self.id_) + str(self.ids.index(relation[0]))
                b = str(self.id_) + str(self.ids.index(relation[1]))
            except Exception as e:
                print(e)
                continue
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
            node['href'] = d['id']
            node['tooltip'] = d['id']
            node['target'] = '_blank'
            node['penwidth'] = 1
            node['color'] = 'blue'
        
        self.nodes[id(d)] = node

        for key, item in d.items():
            # Relationship attributes.
            relation = (id(d), id(item))
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
                self.edges[relation] = relationship
                self.walk(item)
            elif isinstance(item, list):
                for obj in item:
                    relation = (id(d), id(obj))
                    self.edges[relation] = relationship
                    if isinstance(obj, dict):
                        self.walk(obj)
            else:
                if key not in ['_label', 'id']:
                    # Node attributes.
                    relation = (id(d), id(item))
                    obj = dict()
                    # Word wrap.
                    wrapped_text = textwrap.fill(item, 40)
                    if wrapped_text != item:
                        # Left justify.
                        wrapped_text = wrapped_text.replace('\n', '\l') + '\l'
                        obj['label'] = wrapped_text
                        obj['margin'] = '0.8,0.2'
                    else:
                        obj['label'] = item

                    # Vocabulary.
                    if item in self.context:
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

                    self.nodes[id(item)] = obj
                    self.edges[relation] = relationship


if __name__ == '__main__':   
    graphs = list()
    # files = ['../out/the-big-sleep.json', '../out/whaam.json']
    files = ['out/material-skos.json']
    for f in files:
        with open(f, 'r') as inf:
            j = json.load(inf)
            print(j)

        g = Graph(j)
        graphs.append(g)

    v = Visualisation(graphs, attributes=attributes)
    print(v)
