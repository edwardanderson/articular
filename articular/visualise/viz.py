'''
Draw JSON-LD as DOT.
'''


import json


def walk(node):
    node_to_dot(node)
    for key, item in node.items():
        if isinstance(item, dict):
            a = node_to_dot(node)
            b = node_to_dot(item)
            print(f'{a} -> {b}')
            walk(item)
        elif isinstance(item, list):
            for i in item:
                item_to_dot(i)
        else:
            item_to_dot(item)


def node_to_dot(node):
    return '_' + str(id(node))


def item_to_dot(item):
    pass


with open('../out/whaam.json', 'r') as in_file:
    j = json.load(in_file)
    walk(j)

