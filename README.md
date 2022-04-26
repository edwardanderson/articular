# Articular

**Articular** is a tool for creating knowledge graphs from Markdown documents.

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
  Book: https://schema.org/Book
  author: https://schema.org/author
  date: https://schema.org/dateCreated
---

# [Tortilla Flat](http://www.wikidata.org/entity/Q606720 "Book")

* author
  * [John Steinbeck](http://www.wikidata.org/entity/Q39212 "Person")
* date
  * "1935"

Tortilla Flat (1935) is an early [John Steinbeck](http://www.wikidata.org/entity/Q39212) novel set in Monterey, California.

> Thoughts are slow and deep and golden in the morning.

```

```bash
articular examples/tortilla-flat.md --base http://www.example.com/
```

<details>
  <summary>JSON-LD</summary>

  ```json
  {
    "@context": [
      "ns/v1/articular.json",
      {
        "author": "https://schema.org/author",
        "date": "https://schema.org/dateCreated",
        "Book": "https://schema.org/Book",
        "@base": "http://www.example.com/examples/tortilla-flat#"
      }
    ],
    "id": "http://www.example.com/examples/tortilla-flat",
    "_label": "Tortilla Flat",
    "type": "Book",
    "_same_as": {
      "id": "http://www.wikidata.org/entity/Q606720",
      "type": "Book",
      "_label": "Tortilla Flat"
    },
    "_comment": [
      {
        "type": "_Comment",
        "_content": "<p>Tortilla Flat (1935) is an early <a href=\"http://www.wikidata.org/entity/Q39212\">John Steinbeck</a> novel set in Monterey, California.</p>",
        "_format": "text/html",
        "_mentions": {
          "id": "http://www.wikidata.org/entity/Q39212",
          "_label": "John Steinbeck"
        }
      },
      {
        "type": "_Quotation",
        "_content": "Thoughts are slow and deep and golden in the morning."
      }
    ],
    "author": {
      "id": "http://www.wikidata.org/entity/Q39212",
      "type": "Person",
      "_label": "John Steinbeck"
    },
    "date": "1935"
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
      schema:dateCreated "1935" ;
      schema:sameAs <http://www.wikidata.org/entity/Q606720> .

  <http://www.wikidata.org/entity/Q606720> a schema:Book ;
      rdfs:label "Tortilla Flat" .

  <http://www.wikidata.org/entity/Q39212> a <http://www.example.com/examples/Person> ;
      rdfs:label "John Steinbeck" .
  ```

</details>
