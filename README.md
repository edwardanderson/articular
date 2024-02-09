# Articular

- [Articular](#articular)
  - [Install](#install)
  - [Model](#model)
    - [Logical](#logical)
    - [Physical](#physical)
  - [Example](#example)
    - [Input](#input)
    - [Output](#output)
      - [Visualisation](#visualisation)

Articular is a tool for creating knowledge graphs with [Markdown](https://daringfireball.net/projects/markdown/) elements: lists of hyperlinks, images, and styled or plain text.

As a readable, content-first, low-syntax document format, Articular is intended to facilitate the exchange of structured data between researchers, writers and developers to support the construction of databases of networked information.

## Install

```bash
pip install git+https://github.com/edwardanderson/articular
```

## Model

### Logical

An Articular document is a list of **Things** and **Texts** connected to each other via **Relationships**.

```mermaid
graph LR
    Thing("📦 Thing")
    Text>"✏️ Text"]
    Type["⚙️ Type"]

    Thing -- Relationship --> Thing
    Thing <-- Relationship --> Text
    Text .-> Type
```

### Physical

* **Things** are [hyperlinks](https://daringfireball.net/projects/markdown/syntax#link), [images](https://daringfireball.net/projects/markdown/syntax#img) or identifying plain-text strings
* **Relationships** are hyperlinks or identifying plain-text strings
* **Texts** are [blockquotes](https://daringfireball.net/projects/markdown/syntax#blockquote), with or without [emphasis](https://daringfireball.net/projects/markdown/syntax#em)
* **Types** are optional qualifiers for language or [datatype](https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/#section-Datatypes) of **Texts** as [code](https://daringfireball.net/projects/markdown/syntax#code)

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

Parameters are set in the YAML frontmatter.

```markdown
---
base: http://www.example.org/
vocab: https://schema.org/
language: fr
autotype: true
---
```

## Example

```bash
articular examples/adventures_of_huckleberry_finn.md
```

### Input

```markdown
---
language: en
autotype: false
---

- [Adventures of Huckleberry Finn](1)
  - a
    - Book
  - description
    - > **Adventures of Huckleberry Finn** is a novel by American author [Mark Twain](https://en.wikipedia.org/wiki/Mark_Twain).
      - [source](https://schema.org/isBasedOn)
        - <https://en.wikipedia.org/wiki/Adventures_of_Huckleberry_Finn>
  - author
    - [Mark Twain](http://www.wikidata.org/entity/Q7245)
      - date of birth
        - > 1835-11-30 `date`
      - name
        - > Samuel Longhorn Clemens
        - > صمويل لانغهورن كليمنس `ar`
        - > 塞姆·朗赫恩·克莱門斯 `zh`
```

### Output

| Syntax             | Example |
|--------------------|----------------------------------------------------------------------------------------------|
| `application/json` | [examples/adventures_of_huckleberry_finn.json](examples/adventures_of_huckleberry_finn.json) |
| `text/turtle`      | [examples/adventures_of_huckleberry_finn.ttl](examples/adventures_of_huckleberry_finn.ttl)   |

#### Visualisation

![Visualisation](examples/adventures_of_huckleberry_finn.png).

Generated with [RDF Sketch](https://sketch.zazuko.com/)
