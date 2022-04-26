

import json
import pygraphviz as pgv


with open('../out/whaam.json', 'r') as inf:
    j = json.load(inf)

G = pgv.AGraph(j)
print(G)