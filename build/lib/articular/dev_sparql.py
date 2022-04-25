

from articular import SPARQLTemplate
from lxml import etree


md = '''
---
context: https://schema.org/docs/jsonldcontext.jsonld
---

# Who wrote Tortilla Flat?

* ?
  * author
    * <https://www.wikidata.org/entity/Q606720>

'''

query = SPARQLTemplate.transform(md)
print(query)
