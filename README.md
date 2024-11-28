# Knowledge Representation Markup Language

- [Knowledge Representation Markup Language](#knowledge-representation-markup-language)
  - [Overview](#overview)
  - [Example](#example)
    - [Source](#source)
    - [Result](#result)
      - [JSON-LD](#json-ld)
      - [Turtle](#turtle)
  - [Model](#model)
    - [Logical](#logical)
    - [Physical](#physical)
  - [Quickstart](#quickstart)

## Overview

Knowledge Representation Markup Language (KRML) is a simple data markup language for creating RDF knowledge graphs using [Markdown](https://en.wikipedia.org/wiki/Markdown) syntax.

As a readable, content-first, low-syntax document format, KRML is intended to facilitate the exchange of structured data between researchers, writers and developers to support the construction of databases of networked information.

The language is defined in this [Specification](docs/specification.md).

> [!NOTE]
> KRML is an on-going research project and is not yet ready for use in production.

## Example

The following description of the [Mona Lisa](https://en.wikipedia.org/wiki/Mona_Lisa) demonstrates many of the features of the language.

### Source

[`mona_lisa.md`](example/mona_lisa.md)

```markdown
---
language: en
---

- Mona Lisa
  - title
    - > Mona Lisa
    - > La joconde `fr`
    - > la Gioconda `it`
    - > モナ・リザ `jp`
  - a
    - Painting
  - description
    - > Considered an archetypal [masterpiece](https://en.wikipedia.org/wiki/Masterpiece) of the [Italian Renaissance](https://en.wikipedia.org/wiki/Italian_Renaissance), it has been described as "the best known, the most visited, the most written about, the most sung about, [and] the most parodied work of art in the world."
      - source
        - <https://en.wikipedia.org/wiki/Mona_Lisa>
  - image
    - ![Mona Lisa, by Leonardo da Vinci](https://w.wiki/C4dN)
  - creator
    - [Leonardo da Vinci](http://www.wikidata.org/entity/Q762)
      - description
        - > Italian Renaissance polymath (1452−1519)
      - date of birth
        - > 1452-04-15 `date`

---
<!-- Term definitions -->

Mona Lisa
: <http://www.wikidata.org/entity/Q12418>
: <https://collections.louvre.fr/ark:/53355/cl010062370>

title
: <https://schema.org/name>

date
: <http://www.w3.org/2001/XMLSchema#date>
```

### Result

#### JSON-LD

```json
{
  "@context": [
    {
      "@version": 1.1,
      "dcmitype": "http://purl.org/dc/dcmitype/",
      "owl": "http://www.w3.org/2002/07/owl#",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_HTML": {
        "@id": "rdf:HTML"
      },
      "_Image": {
        "@id": "dcmitype:Image"
      },
      "_content": {
        "@id": "rdf:value"
      },
      "_label": {
        "@id": "rdfs:label"
      },
      "_sameAs": {
        "@id": "owl:sameAs",
        "@container": "@set"
      },
      "_seeAlso": {
        "@id": "rdfs:seeAlso",
        "@container": "@set"
      }
    },
    {
      "@base": "http://example.org/",
      "@language": "en",
      "@vocab": "http://example.org/terms/",
      "title": {
        "@id": "https://schema.org/name",
        "@container": "@set",
        "@type": "@id"
      },
      "date": {
        "@id": "http://www.w3.org/2001/XMLSchema#date",
        "@type": "@id"
      }
    }
  ],
  "@graph": [
    {
      "@id": "http://www.wikidata.org/entity/Q12418",
      "_label": "Mona Lisa",
      "title": [
        {
          "@value": "Mona Lisa"
        },
        {
          "@language": "fr",
          "@value": "La joconde"
        },
        {
          "@language": "it",
          "@value": "la Gioconda"
        },
        {
          "@language": "jp",
          "@value": "モナ・リザ"
        }
      ],
      "@type": "Painting",
      "description": [
        {
          "@type": "_Text",
          "_content": {
            "@type": "_HTML",
            "@value": "<p lang=\"en\">Considered an archetypal <a href=\"https://en.wikipedia.org/wiki/Masterpiece\">masterpiece</a> of the <a href=\"https://en.wikipedia.org/wiki/Italian_Renaissance\">Italian Renaissance</a>, it has been described as \"the best known, the most visited, the most written about, the most sung about, [and] the most parodied work of art in the world.\"</p>"
          },
          "_seeAlso": [
            {
              "@id": "https://en.wikipedia.org/wiki/Masterpiece",
              "_label": "masterpiece"
            },
            {
              "@id": "https://en.wikipedia.org/wiki/Italian_Renaissance",
              "_label": "Italian Renaissance"
            }
          ],
          "source": [
            {
              "@id": "https://en.wikipedia.org/wiki/Mona_Lisa",
              "_label": "https://en.wikipedia.org/wiki/Mona_Lisa"
            }
          ]
        }
      ],
      "image": [
        {
          "@id": "https://w.wiki/C4dN",
          "@type": "_Image",
          "_label": "Mona Lisa, by Leonardo da Vinci"
        }
      ],
      "creator": [
        {
          "@id": "http://www.wikidata.org/entity/Q762",
          "_label": "Leonardo da Vinci",
          "description": [
            {
              "@value": "Italian Renaissance polymath (1452−1519)"
            }
          ],
          "date_of_birth": [
            {
              "@type": "date",
              "@value": "1452-04-15"
            }
          ]
        }
      ]
    },
    {
      "@id": "http://www.wikidata.org/entity/Q12418",
      "_label": "Mona Lisa",
      "_sameAs": [
        {
          "@id": "https://collections.louvre.fr/ark:/53355/cl010062370",
          "_label": "Mona Lisa"
        }
      ]
    }
  ]
}
```

#### Turtle

```turtle
PREFIX : <http://example.org/terms/>
PREFIX dcmitype: <http://purl.org/dc/dcmitype/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <https://schema.org/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

<http://www.wikidata.org/entity/Q12418>
    a :Painting ;
    rdfs:label "Mona Lisa"@en ;
    :creator <http://www.wikidata.org/entity/Q762> ;
    :description [
            a dcmitype:Text ;
            :source <https://en.wikipedia.org/wiki/Mona_Lisa> ;
            rdf:value "<p lang=\"en\">Considered an archetypal <a href=\"https://en.wikipedia.org/wiki/Masterpiece\">masterpiece</a> of the <a href=\"https://en.wikipedia.org/wiki/Italian_Renaissance\">Italian Renaissance</a>, it has been described as \"the best known, the most visited, the most written about, the most sung about, [and] the most parodied work of art in the world.\"</p>"^^rdf:HTML ;
            rdfs:seeAlso
                <https://en.wikipedia.org/wiki/Italian_Renaissance> ,
                <https://en.wikipedia.org/wiki/Masterpiece>
        ] ;
    :image <https://w.wiki/C4dN> ;
    owl:sameAs <https://collections.louvre.fr/ark:/53355/cl010062370> ;
    schema:name
        "Mona Lisa" ,
        "La joconde"@fr ,
        "la Gioconda"@it ,
        "モナ・リザ"@jp ;
.

<http://www.wikidata.org/entity/Q762>
    rdfs:label "Leonardo da Vinci"@en ;
    :date_of_birth "1452-04-15"^^xsd:date ;
    :description "Italian Renaissance polymath (1452−1519)" ;
.

<https://collections.louvre.fr/ark:/53355/cl010062370>
    rdfs:label "Mona Lisa"@en ;
.

<https://en.wikipedia.org/wiki/Italian_Renaissance>
    rdfs:label "Italian Renaissance"@en ;
.

<https://en.wikipedia.org/wiki/Masterpiece>
    rdfs:label "masterpiece"@en ;
.

<https://en.wikipedia.org/wiki/Mona_Lisa>
    rdfs:label "https://en.wikipedia.org/wiki/Mona_Lisa"@en ;
.

<https://w.wiki/C4dN>
    a dcmitype:Image ;
    rdfs:label "Mona Lisa, by Leonardo da Vinci"@en ;
.
```

## Model

### Logical

A KGML document is a list of **Things** and **Texts** connected to each other via **Relationships**.

### Physical

Documents are nested lists of these components.

```text
- Thing
  - Relationship
    - Thing
  - Relationship
    - > Text `Type`
      - Relationship
        - ...
```

```text
- John
  - knows
    - Paul
  - name
    - > John Winston Lennon `en`
```

* **Things** are [hyperlinks](https://www.markdownguide.org/basic-syntax/#links), [images](https://www.markdownguide.org/basic-syntax/#images-1) or plain-text identifiers
* **Relationships** are hyperlinks or plain-text identifiers
* **Texts** are [blockquotes](https://www.markdownguide.org/basic-syntax/#blockquotes-1), with or without styling
* **Types** are optional qualifiers for human language or [datatype](https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/#section-Datatypes) of **Texts** as [code](https://www.markdownguide.org/basic-syntax/#code)

Definition lists can identify multiple references of the same **Thing**.

```text
- John
  - born in
    - Liverpool
- Paul
  - born in
    - Liverpool

Liverpool
: <http://www.wikidata.org/entity/Q24826>
```

Parameters are set in the YAML frontmatter.

```markdown
---
base: http://www.example.org/
language: fr
title: lorem ipsum
vocab: https://schema.org/
---
```

## Quickstart

```bash
git clone git@github.com:edwardanderson/krml.git
cd krml
python3 -m venv .venv
source .venv/bin/activate
pip install --editable .
```

```bash
krml /path/to/file.md
```
