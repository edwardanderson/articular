# Articular

**Articular** is a tool for creating knowledge graphs with Markdown documents.

## Overview

**Articular** creates an [RDF](https://en.wikipedia.org/wiki/Resource_Description_Framework) graph representation of a plain Markdown document. Refer to the [Data Model](model.md).

## Requirements

* Python 3
* [Pandoc](https://pandoc.org/installing.html)

## Install

```bash
pip install git+https://github.com/edwardanderson/articular
```

## Example

[examples/tortilla-flat.md](examples/tortilla-flat.md)

```markdown
---
context:
  "@vocab": "https://schema.org/"
  born_in: schema:birthPlace
---

# [Tortilla Flat](http://www.wikidata.org/entity/Q606720 "Book")

* author
  * [John Steinbeck](http://www.wikidata.org/entity/Q39212 "Person")
    * born in
      * [Salinas, California](http://www.wikidata.org/entity/Q488125 "Place")
* [date](https://schema.org/dateCreated "Date")
  * "1935"

Tortilla Flat (1935) is an early [John Steinbeck](http://www.wikidata.org/entity/Q39212) novel set in Monterey, California.

> Thoughts are slow and deep and golden in the morning.

```

Convert the Markdown document into Linked Data.

```bash
articular examples/tortilla-flat.md --base http://www.example.com/
```

<details>
  <summary>JSON-LD</summary>

  ```json
  {
    "@context": [
      "https://articular.netlify.app/articular.json",
      {
        "born_in": "schema:birthPlace",
        "date": {
          "@id": "https://schema.org/dateCreated",
          "@type": "Date"
        },
        "@vocab": "https://schema.org/",
        "@base": "http://www.example.com/examples/tortilla-flat#"
      }
    ],
    "id": "tortilla-flat",
    "type": "Book",
    "_comment": [
      {
        "type": "_Comment",
        "_comment": "<p>Tortilla Flat (1935) is an early <a href=\"http://www.wikidata.org/entity/Q39212\">John Steinbeck</a> novel set in Monterey, California.</p>",
        "_format": "text/html",
        "_mentions": [
          {
            "id": "http://www.wikidata.org/entity/Q39212",
            "type": "Person",
            "_label": "John Steinbeck",
            "born_in": {
              "id": "http://www.wikidata.org/entity/Q488125",
              "type": "Place",
              "_label": "Salinas, California"
            }
          }
        ]
      },
      {
        "type": "_Quotation",
        "_comment": "Thoughts are slow and deep and golden in the morning."
      }
    ],
    "_label": "Tortilla Flat",
    "author": {
      "id": "http://www.wikidata.org/entity/Q39212",
      "type": "Person",
      "_label": "John Steinbeck",
      "born_in": {
        "id": "http://www.wikidata.org/entity/Q488125",
        "type": "Place",
        "_label": "Salinas, California"
      }
    },
    "date": "1935",
    "_same_as": [
      {
        "id": "http://www.wikidata.org/entity/Q606720",
        "type": "Book",
        "_label": "Tortilla Flat"
      }
    ]
  }
  ```

</details>

```bash
articular examples/tortilla-flat.md --base http://www.example.com/ --format turtle
```

<details>
  <summary>Turtle</summary>

  ```turtle
  @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
  @prefix schema: <https://schema.org/> .

  <http://www.example.com/examples/tortilla-flat> a schema:Book ;
      rdfs:label "Tortilla Flat" ;
      rdfs:comment [ a schema:Quotation ;
              rdfs:comment "Thoughts are slow and deep and golden in the morning." ],
          [ a schema:Comment ;
              rdfs:comment "<p>Tortilla Flat (1935) is an early <a href=\"http://www.wikidata.org/entity/Q39212\">John Steinbeck</a> novel set in Monterey, California.</p>" ;
              schema:encodingFormat "text/html" ;
              schema:mentions <http://www.wikidata.org/entity/Q39212> ] ;
      schema:author <http://www.wikidata.org/entity/Q39212> ;
      schema:dateCreated "1935"^^schema:Date ;
      schema:sameAs <http://www.wikidata.org/entity/Q606720> .

  <http://www.wikidata.org/entity/Q488125> a schema:Place ;
      rdfs:label "Salinas, California" .

  <http://www.wikidata.org/entity/Q606720> a schema:Book ;
      rdfs:label "Tortilla Flat" .

  <http://www.wikidata.org/entity/Q39212> a schema:Person ;
      rdfs:label "John Steinbeck" ;
      schema:birthPlace <http://www.wikidata.org/entity/Q488125> .
  ```

</details>
