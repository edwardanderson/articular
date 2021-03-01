
import json
import models
from pathlib import Path
from tqdm import tqdm
from rdflib import Graph
import os


graph = Graph()

repository = 'https://github.com/example-museum'

endpoints = {
    'Digital Objects': 'digital',
    'Events': 'event',
    'Groups': 'group',
    'People': 'person',
    'Physical Objects': 'object',
    'Places': 'place',
    'Provenance Activities': 'provenance',
    'Sets': 'set',
    'Textual Works': 'textual_work',
    'Visual Works': 'visual_work'
}

classes = {
    'Digital Objects': 'DigitalObject',
    'Events': 'Event',
    'Groups': 'Group',
    'People': 'Person',
    'Physical Objects': 'HumanMadeObject',
    'Places': 'Place',
    'Provenance Activities': 'Activity',
    'Sets': 'Set',
    'Textual Works': 'LinguisticObject',
    'Visual Works': 'VisualItem'
}

files = Path('documents').glob('**/*.md')
for articular_doc in tqdm(list(files)):
    folder = str(articular_doc.parent).split('/')[1]
    document_dir = endpoints[folder]
    document_class = classes[folder]

    with open(articular_doc, 'r', encoding='utf-8') as input_file:
        text = input_file.read()
        document = models.LinkedArtDocument(text, type=document_class)

        document_id = repository + '/' + document_dir + '/' + articular_doc.stem.replace(' ', '-').lower()
        if 'id' not in document:
            document['id'] = document_id

        if 'type' not in document:
            document['type'] = document_class
 
        json_ld = document.jsonld()

        # target_folder = folder.lower()
        out_path = os.path.join('data', document_dir)
        if not os.path.exists(out_path):
            p = Path(out_path)
            try:
                p.mkdir(parents=True)
            except:
                pass

        out_file = os.path.join(out_path, articular_doc.stem.replace(' ', '-').lower())
        # out_file = f'data/{document_class}/{articular_doc.stem}'.replace(' ', '-').lower()
        with open(f'{out_file}.json', 'w') as of:
            of.write(json_ld)

        turtle = document.turtle()
        with open(f'{out_file}.ttl', 'w') as of:
            of.write(turtle)

        with open(f'{out_file}.md', 'w') as of:
            of.write(text)
        
        # with open(f'{out_file}.html', 'w') as of:
        #     of.write(document.html())

        graph.parse(data=turtle, format='turtle')

graph.serialize('data/graph.ttl', format='turtle')
