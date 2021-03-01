
import re
import tempfile
from pathlib import Path
import datetime


def urlify(match):
    return match.group(1).replace(' ', '-').lower()


# JSON
files = Path('data').glob('**/*.json')
for json_doc in files:
    tmp = tempfile.TemporaryFile(mode='r+')
    with open(json_doc, 'r') as in_file:
        json_str = in_file.read()

        # Patch local hash parameter URIs
        folder = str(json_doc.parent).split('/')[1]
        current_document_uri = f'{folder}/{json_doc.stem}'
        patched = re.sub(r'"id": "#(.*)"', fr'"id": "{current_document_uri}#\1"', json_str)
        tmp.writelines(patched)

    tmp.seek(0)
    with open(json_doc, 'w') as out_file:
        for line in tmp:
            out_file.write(line)


# # Pelican
# files = Path('data').glob('**/*.md')
# for markdown_doc in files:
#     tmp = tempfile.TemporaryFile(mode='r+')
#     with open(markdown_doc, 'r') as in_file:
#         text = in_file.read()

#         # Patch local URI fragments
#         filename = r'{filename}'
#         patched = re.sub(r'\[(.*)\]\(#(.*)\)', fr'[\1]({filename}../{markdown_doc.stem}.html#\2)', text)

#         # Patch local URIs for relative Pelican paths.
#         patched = re.sub(r'\[(.*)\]\((?!\{)(?!\<?http)(.*)\)', r'[\1]({filename}../\2.md)', patched)

#         # Patch <h1> headings to Pelican YAML title and date.
#         date_str = datetime.datetime.now().isoformat()
#         pelican_date_str = date_str[:10] + ' ' + date_str[11:16]
#         patched = re.sub(r'^# (.*)', fr'Title: \1\nDate: {pelican_date_str}', patched)

#         # Patch spaces to dashes in local URIs
#         patched = re.sub(r'(\(\{filename}.*\))', urlify, patched)

#         tmp.writelines(patched)

#     tmp.seek(0)
#     with open(markdown_doc, 'w') as out_file:
#         for line in tmp:
#             out_file.write(line)
    
#     tmp.close()
