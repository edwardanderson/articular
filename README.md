# Knowledge Representation Markup Language

- [Knowledge Representation Markup Language](#knowledge-representation-markup-language)
  - [Overview](#overview)
  - [Example](#example)
    - [Input](#input)
    - [Output](#output)
  - [Model](#model)
    - [Logical](#logical)
    - [Physical](#physical)
  - [Quickstart](#quickstart)

## Overview

Knowledge Representation Markup Language (KRML) is a simple language for creating RDF knowledge graphs using [Markdown](https://en.wikipedia.org/wiki/Markdown) elements: lists of hyperlinks, images, tables and styled or plain text.

As a readable, content-first, low-syntax document format, KRML is optimised for humans. It's intended to facilitate the exchange of structured data between researchers, writers and developers to support the construction of databases of networked information.

The language is defined in this [Specification](docs/specification.md).

> [!NOTE]
> KRML is an on-going research project and is not yet ready for use in production.

## Example

The following description of the [Mona Lisa](https://en.wikipedia.org/wiki/Mona_Lisa) demonstrates many of the features of the language.

```bash
krml examples/mona_lisa.md --embed-context
```

### Input

[`mona_lisa.md`](examples/mona_lisa.md)

```markdown
---
title: Mona Lisa
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
      - [date of birth](https://schema.org/birthDate)
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

### Output

```json
{
  "@context": [
    {
      "@version": 1.1,
      "dcmitype": "http://purl.org/dc/dcmitype/",
      "dcterms": "http://purl.org/dc/terms/",
      "owl": "http://www.w3.org/2002/07/owl#",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "schema": "https://schema.org/",
      "xsd": "http://www.w3.org/2001/XMLSchema#",
      "_Dataset": {
        "@id": "dcmitype:Dataset"
      },
      "_HTML": {
        "@id": "rdf:HTML"
      },
      "_Image": {
        "@id": "dcmitype:Image"
      },
      "_Table": {
        "@id": "schema:Table"
      },
      "_Text": {
        "@id": "dcmitype:Text"
      },
      "_boolean": {
        "@id": "xsd:boolean"
      },
      "_content": {
        "@id": "rdf:value"
      },
      "_format": {
        "@id": "dcterms:format"
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
        "@container": "@set"
      },
      "date": {
        "@id": "http://www.w3.org/2001/XMLSchema#date",
        "@type": "@id"
      }
    }
  ],
  "@id": "mona_lisa.md",
  "_label": "Mona Lisa",
  "@graph": [
    {
      "@id": "http://www.wikidata.org/entity/Q12418",
      "_label": "Mona Lisa",
      "@type": [
        "Painting"
      ],
      "title": [
        {
          "@language": "en",
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
      "description": [
        {
          "@type": [
            "_Text"
          ],
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
              "_label": "Mona_Lisa"
            }
          ]
        }
      ],
      "image": [
        {
          "@id": "https://w.wiki/C4dN",
          "@type": [
            "_Image"
          ],
          "_label": "Mona Lisa, by Leonardo da Vinci"
        }
      ],
      "creator": [
        {
          "@id": "http://www.wikidata.org/entity/Q762",
          "_label": "Leonardo da Vinci",
          "description": [
            {
              "@language": "en",
              "@value": "Italian Renaissance polymath (1452−1519)"
            }
          ],
          "https://schema.org/birthDate": [
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

<details><summary><code>text/turtle</code></summary>

```turtle
PREFIX dcmitype: <http://purl.org/dc/dcmitype/>
PREFIX ex: <http://example.org/>
PREFIX exterms: <http://example.org/terms/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <https://schema.org/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

ex:mona_lisa.md
    rdfs:label "Mona Lisa"@en ;
.

<http://www.wikidata.org/entity/Q12418>
    a exterms:Painting ;
    rdfs:label "Mona Lisa"@en ;
    exterms:creator <http://www.wikidata.org/entity/Q762> ;
    exterms:description [
            a dcmitype:Text ;
            exterms:source <https://en.wikipedia.org/wiki/Mona_Lisa> ;
            rdf:value "<p lang=\"en\">Considered an archetypal <a href=\"https://en.wikipedia.org/wiki/Masterpiece\">masterpiece</a> of the <a 
href=\"https://en.wikipedia.org/wiki/Italian_Renaissance\">Italian Renaissance</a>, it has been described as \"the best known, the most visited, the most written about, the most sung about, [and] the most parodied work of art in the world.\"</p>"^^rdf:HTML ;
            rdfs:seeAlso
                <https://en.wikipedia.org/wiki/Italian_Renaissance> ,
                <https://en.wikipedia.org/wiki/Masterpiece>
        ] ;
    exterms:image <https://w.wiki/C4dN> ;
    owl:sameAs <https://collections.louvre.fr/ark:/53355/cl010062370> ;
    schema:name
        "Mona Lisa"@en ,
        "La joconde"@fr ,
        "la Gioconda"@it ,
        "モナ・リザ"@jp ;
.

<http://www.wikidata.org/entity/Q762>
    rdfs:label "Leonardo da Vinci"@en ;
    exterms:description "Italian Renaissance polymath (1452−1519)"@en ;
    schema:birthDate "1452-04-15"^^xsd:date ;
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
    rdfs:label "Mona_Lisa"@en ;
.

<https://w.wiki/C4dN>
    a dcmitype:Image ;
    rdfs:label "Mona Lisa, by Leonardo da Vinci"@en ;
.
```

</details>

<details><summary><code>application/trig</code></summary>

```trig
@prefix dcmitype: <http://purl.org/dc/dcmitype/> .
@prefix ex: <http://example.org/> .
@prefix exterms: <http://example.org/terms/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

ex:mona_lisa.md {
    ex:mona_lisa.md a dcmitype:Dataset ;
        rdfs:label "mona_lisa"@en .

    <http://www.wikidata.org/entity/Q12418> a exterms:Painting ;
        rdfs:label "Mona Lisa"@en ;
        exterms:creator <http://www.wikidata.org/entity/Q762> ;
        exterms:description [ a dcmitype:Text ;
                exterms:source <https://en.wikipedia.org/wiki/Mona_Lisa> ;
                rdf:value "<p lang=\"en\">Considered an archetypal <a href=\"https://en.wikipedia.org/wiki/Masterpiece\">masterpiece</a> of the <a href=\"https://en.wikipedia.org/wiki/Italian_Renaissance\">Italian Renaissance</a>, it has been described as \"the best known, the most visited, the most written about, the most sung about, [and] the most parodied work of art in the world.\"</p>"^^rdf:HTML ;
                rdfs:seeAlso <https://en.wikipedia.org/wiki/Italian_Renaissance>,
                    <https://en.wikipedia.org/wiki/Masterpiece> ] ;
        exterms:image <https://w.wiki/C4dN> ;
        owl:sameAs <https://collections.louvre.fr/ark:/53355/cl010062370> ;
        schema:name "Mona Lisa"@en,
            "La joconde"@fr,
            "la Gioconda"@it,
            "モナ・リザ"@jp .

    <http://www.wikidata.org/entity/Q762> rdfs:label "Leonardo da Vinci"@en ;
        exterms:description "Italian Renaissance polymath (1452−1519)"@en ;
        schema:birthDate "1452-04-15"^^xsd:date .

    <https://collections.louvre.fr/ark:/53355/cl010062370> rdfs:label "Mona Lisa"@en .

    <https://en.wikipedia.org/wiki/Italian_Renaissance> rdfs:label "Italian Renaissance"@en .

    <https://en.wikipedia.org/wiki/Masterpiece> rdfs:label "masterpiece"@en .

    <https://en.wikipedia.org/wiki/Mona_Lisa> rdfs:label "https://en.wikipedia.org/wiki/Mona_Lisa"@en .

    <https://w.wiki/C4dN> a dcmitype:Image ;
        rdfs:label "Mona Lisa, by Leonardo da Vinci"@en .
}
```

</details>

## Model

### Logical

A KRML document is a list of **Resources** connected to each other via **Relationships**.

### Physical

Documents are composed of nests of ordered or unordered lists of resources, relationships and types.

- Resources are identified by [hyperlinks](https://www.markdownguide.org/basic-syntax/#links), [image links](https://www.markdownguide.org/basic-syntax/#images-1) or plain-text
- Relationships are identified by hyperlinks or plain-text
- Texts are [blockquotes](https://www.markdownguide.org/basic-syntax/#blockquotes-1), with or without styling
- Types are optional qualifiers for human languages or [datatypes](https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/#section-Datatypes) of Texts as [code-fenced text](https://www.markdownguide.org/basic-syntax/#code)

```text
- Resource
  - relationship
    - Resource
  - relationship
    - > Text `Type`
      - relationship
        - ...
```

```text
- John
  - knows
    - Paul
  - name
    - > John Winston Lennon `en`
```

Definition lists can identify any plain text resources, relationships or types.

```text
- John
  - date of birth
    - > 1940-10-09 `date`
  - born in
    - Liverpool
- Paul
  - born in
    - Liverpool

date
: <http://www.w3.org/2001/XMLSchema#>

born in
: <https://schema.org/birthPlace>

Liverpool
: <http://www.wikidata.org/entity/Q24826>
```

Document configuration parameters can be set in the frontmatter.

```markdown
---
base: http://www.example.org/
id: http://www/example.org/doc/1
import: file:///path/to/file.md
language: en
title: Lorem Ipsum
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
krml /path/to/file.md --help
```
