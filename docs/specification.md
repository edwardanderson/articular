---
title: Specification of the Knowledge Representation Markup Language
author: Edward Anderson
---

# Specification of the Knowledge Representation Markup Language

- [Specification of the Knowledge Representation Markup Language](#specification-of-the-knowledge-representation-markup-language)
  - [1. Body](#1-body)
    - [1.1. Structure](#11-structure)
      - [1.1.1. Graph](#111-graph)
        - [1.1.1.1. Unordered](#1111-unordered)
        - [1.1.1.2. Ordered](#1112-ordered)
      - [1.1.2. Comment](#112-comment)
    - [1.2. Resource](#12-resource)
      - [1.2.1. Hyperlink](#121-hyperlink)
        - [1.2.1.1. Label](#1211-label)
        - [1.2.1.2. Class](#1212-class)
      - [1.2.2. Plain Text](#122-plain-text)
        - [1.2.2.1. Anonymous](#1221-anonymous)
        - [1.2.2.2. Identified](#1222-identified)
      - [1.2.3. Blockquote](#123-blockquote)
        - [1.2.3.1. Identified](#1231-identified)
        - [1.2.3.2. Reified](#1232-reified)
        - [1.2.3.3. Language](#1233-language)
        - [1.2.3.4. Style](#1234-style)
        - [1.2.3.5. Reference](#1235-reference)
        - [1.2.3.6. Datatype](#1236-datatype)
          - [1.2.3.6.1. Boolean](#12361-boolean)
        - [1.2.3.7. Number](#1237-number)
      - [1.2.4. Image](#124-image)
      - [1.2.5. Code Block](#125-code-block)
      - [1.2.6. Table](#126-table)
    - [1.3. Syntax](#13-syntax)
      - [1.3.1. Predicate Modifier](#131-predicate-modifier)
        - [1.3.1.1. Inverse Path](#1311-inverse-path)
        - [1.3.1.2. Inverse Direction](#1312-inverse-direction)
        - [1.3.1.3. Symetric](#1313-symetric)
        - [1.3.1.4. Product](#1314-product)
  - [2. Frontmatter](#2-frontmatter)
    - [2.1. Base](#21-base)
    - [2.2. Vocab](#22-vocab)
    - [2.3. Language](#23-language)
    - [2.4. Import](#24-import)

This document specifies the Knowledge Representation Markup Language (KRML). It includes [go-testmark](https://github.com/warpfork/go-testmark) integration test fixtures, with input scenarios each accompanied by an expected graph shape (in Turtle) and an expected serialisation (JSON-LD).

A KRML document is a plain-text Markdown document that complies with the following conventions for structure format and syntax.

## 1. Body

### 1.1. Structure

#### 1.1.1. Graph

Graphs of triples are composed of nests of either [unordered](#unordered) or [ordered](#ordered) lists of [resources](#resources).

##### 1.1.1.1. Unordered

[testmark]:# (1.1.1.1.a. arrange)
```markdown
- John
  - knows
    - Paul
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.1.1.1.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :knows [ rdfs:label "Paul" ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.1.1.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "knows": [
        {
          "_label": "Paul"
        }
      ]
    }
  ]
}
```

</details>

##### 1.1.1.2. Ordered

Objects may be listed in sequence.

[testmark]:# (1.1.1.2.a. arrange)
```markdown
- John
  - spouse
    1. Cynthia
    2. Yoko
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.1.1.2.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :spouse (
        [ rdfs:label "Cynthia" ]
        [ rdfs:label "Yoko" ]
    ) .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.1.1.2.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
       "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "spouse": {
        "@list": [
           {
             "_label": "Cynthia"
           },
           {
             "_label": "Yoko"
           }
         ]
       }
    }
  ]
}
```

</details>

#### 1.1.2. Comment

Comments not intended to be represented in data may be given in HTML.

[testmark]:# (1.1.2.a. arrange)
```markdown
<!-- Content inside HTML comment tags is ignored. -->

- John
  <!-- Consider using foaf:knows -->
  - knows
    - Paul
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.1.2.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :knows [ rdfs:label "Paul" ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.1.2.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "knows": [
        {
          "_label": "Paul"
        }
      ]
    }
  ]
}
```

</details>

### 1.2. Resource

Resources may be [hyperlinks](#hyperlink), [plain-text](#plain-text), [blockquotes](#blockquote) or [images](#image).

#### 1.2.1. Hyperlink

Hyperlinks are composed of an IRI and, optionally, a [label](#label) and/or a [class](#class). If no label is provided, the resource is labelled with the last segment of the path.

IRIs may be absolute or relative. Resources are resolved relative to the [base](#base), which can be set in the document frontmatter.

[testmark]:# (1.2.1.a. arrange)
```markdown
- [John](http://example.org/john)
- <http://example.org/paul>
- [](http://example.org/george)
- [Ringo][1]

[1]: http://example.com/ringo
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.a. assert-graph)
```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/john> rdfs:label "John" .

<http://example.org/paul> rdfs:label "paul" .

<http://example.org/george> rdfs:label "george" .

<http://example.org/ringo> rdfs:label "Ringo" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    }
  ],
  "@graph": [
    {
      "@id": "http://example.org/john",
      "_label": "John"
    },
    {
      "@id": "http://example.org/paul",
      "_label": "paul"
    },
    {
      "@id": "http://example.org/george",
      "_label": "george"
    },
    {
      "@id": "http://example.org/ringo",
      "_label": "Ringo"
    }
  ]
}
```

</details>

##### 1.2.1.1. Label

The language of the label may be specified.

[testmark]:# (1.2.1.1.a. arrange)
```markdown
- [John `en`](http://example.org/john)
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.1.a. assert-graph)
```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/john> rdfs:label "John"@en .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    }
  ],
  "@graph": [
    {
      "_label": {
        "@language": "en",
        "@value":  "John"
      }
    }
  ]
}
```

</details>

Trailing spaces are not preserved. To preserve the trailing space use a [whitespace character](https://en.wikipedia.org/wiki/Whitespace_character).

The label may be [styled](#style).

[testmark]:# (1.2.1.1.b. arrange)
```markdown
- [**John**](http://example.org/john)
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.1.b. assert-graph)
```turtle
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/john> rdfs:label "<p><strong>John</strong></p>"^^rdf:HTML .
```

</details>

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.1.b. assert-json)
```json
{
  "@context": [
    {
      "@vocab": "http://example.org/",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_HTML": "rdf:HTML"
    }
  ],
  "@graph": [
    {
      "@id": "http://example.org/john",
      "_label": {
        "@type": "_HTML",
        "@value":  "<p><strong>John</strong></p>"
      }
    }
  ]
}
```

</details>

##### 1.2.1.2. Class

The predicate keyword `a` can be provided to specify the `rdf:type` of a resource.

[testmark]:# (1.2.1.2.a. arrange)
```markdown
- John
  - a
    - Person
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.2.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    a :Person .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.2.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "@type": "Person"
    }
  ]
}
```

</details><br/>

The tokens `â` or `^a` may be used to inverse the direction of the class assignment.

[testmark]:# (1.2.1.2.b. arrange)
```markdown
- Person
  - â
    - John
    - Paul
    - George
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.2.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    a :Person .

[] rdfs:label "Paul" ;
    a :Person .

[] rdfs:label "George" ;
    a :Person .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.2.b. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "@type": "Person"
    },
    {
      "_label": "Paul",
      "@type": "Person"
    },
    {
      "_label": "George",
      "@type": "Person"
    }
  ]
}
```

</details>

Hyperlinks may include a class by overloading the hyperlink's `title` attribute with an IRI or a defined term.

[testmark]:# (1.2.1.2.c. arrange)
```markdown
- [John](http://example.org/john "http://example.org/Person")
  - [knows](http://xmlns.com/foaf/0.1/knows "http://www.w3.org/2002/07/owl#SymmetricProperty")
    - [Paul](http://example.org/paul "Person")

Person
: <http://schema.org/Person>
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.1.2.c. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/john> rdfs:label "John" ;
    a <http://example.org/Person> ;
    foaf:knows <http://example.org/paul> .

<http://example.org/paul> rdfs:label "Paul" ;
    a <http://example.org/Person> .

foaf:knows a owl:SymmetricProperty .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.1.2.c. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "knows": {
        "@id": "http://xmlns.com/foaf/0.1/knows"
      },
      "Person": {
        "@id": "http://schema.org/Person"
      }
    }
  ],
  "@graph": [
    {
      "@id": "http://example.org/john",
      "@type": "Person",
      "_label": "John",
      "knows": [
        {
          "@id": "http://example.org/paul",
          "@type": "Person",
          "_label": "Paul"
        }
      ]
    },
    {
      "@id": "http://xmlns.com/foaf/0.1/knows",
      "@type": "http://www.w3.org/2002/07/owl#SymmetricProperty"
    }
  ]
}
```

</details>

#### 1.2.2. Plain Text

##### 1.2.2.1. Anonymous

Subject and object resources in plain text are labelled anonymous (blank node) resources. They can be referred to by their label within the document.

[testmark]:# (1.2.2.1.a. arrange)
```markdown
- John
  - knows
    - Paul
      - knows
        - John
- Paul
  - birth place
    - Liverpool
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.2.1.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

_:John rdfs:label "John" ;
  :knows _:Paul .

_:Paul rdfs:label "Paul" ;
  :knows _:John ;
  :birth_place [ rdfs:label "Liverpool" ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.2.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "@id": "_:John",
      "_label": "John",
      "knows": [
        {
          "@id": "_:Paul",
          "_label": "Paul",
          "knows": [
            {
              "@id": "_:John"
            }
          ],
          "birth_place": [
            {
              "_label": "Liverpool"
            }
          ]
        }
      ]
    }
  ]
}
```

</details>

Resources that share labels but are unique from eachother can be disambiguated by wrapping the label in double quotation marks.

[testmark]:# (1.2.2.1.b. arrange)
```markdown
- John
  - mother
    - "Julia"
  - half sister
    - "Julia"
  - wrote
    - Julia
      - a
        - Song
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.2.1.b. assert-graph)

```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :mother [ rdfs:label "Julia" ] ;
    :half_sister [ rdfs:label "Julia" ] ;
    :wrote [
        rdfs:label "Julia" ;
        a :Song
    ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.2.1.b. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "mother": [
        {
          "_label": "Julia"
        }
      ],
      "half_sister": [
        {
          "_label": "Julia"
        },
      ],
      "wrote": [
        {
          "_label": "Julia",
          "@type": "Song"
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.2.2. Identified

Plain text resources may be identified with definition lists.

[testmark]:# (1.2.2.2.a. arrange)
```markdown
- John
  - knows
    - Paul

John
: <http://www.wikidata.org/entity/Q1203>

knows
: <http://xmlns.com/foaf/0.1/knows>
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.2.2.a. assert-graph)
```turtle
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" ;
    foaf:knows [ rdfs:label "Paul" ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.2.2.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "knows": "http://xmlns.com/foaf/0.1/knows"
    }
  ],
  "@graph": [
    {
      "@id": "http://www.wikidata.org/entity/Q1203",
      "_label": "John",
      "knows": [
        {
          "_label": "Paul"
        }
      ]
    }
  ]
}
```

</details>

Resources with multiple definitions have the same identity.

[testmark]:# (1.2.2.d. arrange)
```
- John

John
: <http://www.wikidata.org/entity/Q1203>
: <https://vocab.getty.edu/ulan/500106615>
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.2.d. assert-graph)
```turtle
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" ;
    owl:sameAs <https://vocab.getty.edu/ulan/500106615> .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.2.d. assert-json)
```json
{
  "@context": [
    {
      "owl": "http://www.w3.org/2002/07/owl#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_same_as": {
        "@id": "owl:sameAs",
        "@container": "@set"
      }
    }
  ],
  "@graph": [
    {
      "@id": "http://www.wikidata.org/entity/Q1203",
      "_label": "John",
      "_same_as": [
        {
          "@id": "https://vocab.getty.edu/ulan/500106615"
        }
      ]
    }
  ]
}
```

</details>

#### 1.2.3. Blockquote

Blockquotes contain literal text.

[testmark]:# (1.2.3.a. arrange)
```markdown
- John
  - name
    - > John Winston Lennon
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :name "John Winston Lennon" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "name": [
        {
          "@value": "John Winston Lennon"
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.1. Identified

A preceding sibling hyperlink identifies the blockquote.

[testmark]:# (1.2.3.1.a. arrange)
```markdown
- John
  - description
    - [bio](http://example.org/biography/1)
      > Born in Liverpool, Lennon became involved in the skiffle craze as a teenager.
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.1.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :description <http://example.org/biography/1> .

<http://example.org/biography/1> rdfs:label "bio" ;
    rdf:value "Born in Liverpool, Lennon became involved in the skiffle craze as a teenager." .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_content": "rdf:value"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "description": [
        {
          "@id": "http://example.org/biography/1",
          "_label": "bio",
          "_content": "Born in Liverpool, Lennon became involved in the skiffle craze as a teenager."
        }
      ]
    }
  ]
}
```

</details>

A plain-text resource may also identify the blockquote in the local scope.

[testmark]:# (1.2.3.1.b. arrange)
```markdown
- John
  - name
    - a
      > John Winston Lennon
    - b
      > John Winston Ono Lennon
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.1.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :name _:a , _:b .

_:a rdfs:label "a" ;
    rdf:value "John winston Lennon" .

_:b rdfs:label "b" ;
    rdf:value "John Winston Ono Lennon" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.1.b. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_content": "rdf:value"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "name": [
        {
          "@id": "_:a",
          "_label": "a",
          "_content": "John Winston Lennon"
        },
        {
          "@id": "_:b",
          "_label": "b",
          "_content": "John Winston Ono Lennon"
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.2. Reified

Making a statement about a blockquote reifies it.

[testmark]:# (1.2.3.2.a. arrange)
```markdown
- John
  - description
    - > He gained worldwide fame as the founder, co-lead vocalist and rhythm guitarist of the Beatles.
      - source
        - [Wikipedia](http://www.wikidata.org/entity/Q52)
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.2.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :description [
        rdf:value "He gained worldwide fame as the founder, co-lead vocalist and rhythm guitarist of the Beatles." ;
        :source <http://www.wikidata.org/entity/Q52>
    ] .

<http://www.wikidata.org/entity/Q52> rdfs:label "Wikipedia" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.2.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_content": "rdf:value"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "description": [
        {
          "_content": "He gained worldwide fame as the founder, co-lead vocalist and rhythm guitarist of the Beatles.",
          "source": [
            {
              "@id": "http://www.wikidata.org/entity/Q52",
              "_label": "Wikipedia"
            }
          ]
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.3. Language

A [BCP47](https://en.wikipedia.org/wiki/IETF_language_tag) language tag may be specified in code fences at the end of the line.

[testmark]:# (1.2.3.3.a. arrange)
```markdown
- John
  - said
    - > You may say I'm a dreamer `en`
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.3.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :said "You may say I'm a dreamer"@en .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.3.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "said": [
        {
          "@language": "en",
          "@value": "You may say I'm a dreamer"
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.4. Style

Styled text is serialised as HTML.

[testmark]:# (1.2.3.4.a. arrange)
```markdown
- John
  - note
    - > **John Winston Ono Lennon** was an English singer, songwriter and musician. 
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.4.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :note "<p><strong>John Winston Ono Lennon</strong> was an English singer, songwriter and musician</p>"^^rdf:HTML .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.4.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_HTML": "rdf:HTML"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "note": [
        {
          "@type": "_HTML",
          "@value": "<p><strong>John Winston Ono Lennon</strong> was an English singer, songwriter and musician</p>"
        }
      ]
    }
  ]
}
```

</details>

Specifying the language of styled text attributes the paragraph `p`.

[testmark]:# (1.2.3.4.b. arrange)
```markdown
- Paul
  - note
    - > **Sir James Paul McCartney** CH MBE (born 18 June 1942) is an English singer `en`
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.4.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "Paul" ;
    :note "<p lang=\"en\"><strong>Sir James Paul McCartney</strong> CH MBE (born 18 June 1942) is an English singer</p>"^^rdf:HTML .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.4.b. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_content": {
        "@id": "rdf:value",
        "@type": "rdf:HTML"
      },
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "Paul",
      "note": [
        {
          "@type": "_HTML",
          "@value": "<p lang=\"en\"><strong>Sir James Paul McCartney</strong> CH MBE (born 18 June 1942) is an English singer</p>"
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.5. Reference

[Hyperlinks](#hyperlink) and [images](#image) inside blockquotes are materialised as references.

[testmark]:# (1.2.3.5.a. arrange)
```markdown
- John
  - description
    - > In 1956, he formed the [Quarrymen](https://en.wikipedia.org/wiki/The_Quarrymen)
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.5.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :description [
        rdf:value "<p>In 1956, he formed the <a href=\"https://en.wikipedia.org/wiki/The_Quarrymen\">Quarrymen</a></p>"^^rdf:HTML ;
        rdfs:seeAlso <https://en.wikipedia.org/wiki/The_Quarrymen>
    ] .

<https://en.wikipedia.org/wiki/The_Quarrymen> rdfs:label "Quarrymen" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.5.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_HTML": "rdf:HTML",
      "_content": {
        "@id": "rdf:value"
      },
      "_label": "rdfs:label",
      "_see_also": "rdfs:seeAlso"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "description": [
          {
          "_content": {
            "@type": "_HTML",
            "@value": "<p>In 1956, he formed the <a href=\"https://en.wikipedia.org/wiki/The_Quarrymen\">Quarrymen</a></p>"
          },
          "_see_also": [
            {
              "@id": "https://en.wikipedia.org/wiki/The_Quarrymen",
              "_label": "Quarrymen"
            }
          ]
        }
      ]
    }
  ]
}
```

</details>

##### 1.2.3.6. Datatype

An arbitrary datatype may be given.

[testmark]:# (1.2.3.6.a. arrange)
```markdown
- John
  - date of birth
    - > 1940-10-09 `date`
```

[testmark]:# (1.2.3.6.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :date-of-birth "1940-10-09"^^:date .
```

[testmark]:# (1.2.3.6.b. assert-json)
```json
```

A datatype may be given as a code-fenced reference to a defined term.

[testmark]:# (1.2.3.6.b. arrange)
```markdown
- John
  - date of birth
    - > 1940-10-09 `date`

date
: <http://www.w3.org/2001/XMLSchema#date>
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.6.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
    :date-of-birth "1940-10-09"^^xsd:date .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.6.b. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/",
      "date": "http://www.w3.org/2001/XMLSchema#date"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "date_of_birth": [
        {
          "@type": "date",
          "@value": "1940-10-09"
        }
      ]
    }  
  ]
}
```

</details>

###### 1.2.3.6.1. Boolean

Booleans may be set using the built-in `boolean` datatype token.

[testmark]:# (1.2.3.6.1.a. arrange)
```markdown
- John
  - alive
    - > false `boolean`
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.6.1.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
    :alive false .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.6.1.a. assert-json)
```json
{
  "@context": [
    {
      "@vocab": "http://example.org/terms/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "alive": [
        {
          "@value": false
        }
      ]
    }
  ]
}
```

</details>

To escape a code-fenced term from being processed as a [language](#language) or [datatype](#datatype), add a line-feed character `&#xA;`.

[testmark]:# (1.2.3.6.b. arrange)
```markdown
- John
  - said
    - > It's been too long since we took the `time`&#xA;
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.6.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :said "It's been too long since we took the <code>time</code>"^^rdf:HTML .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.6.b. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_HTML": "rdf:HTML"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "said": [
        {
          "@type": "_HTML",
          "@value": "It's been too long since we took the <code>time</code>"
        }
      ]
    }  
  ]
}
```

</details>

##### 1.2.3.7. Number

Numbers are detected automatically.

[testmark]:# (1.2.3.7.a. arrange)
```
- John
  - children
    - > 2
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.3.7.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
    :children 2 .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.3.7.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_HTML": "rdf:HTML"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "children": [
        {
          "@value": 2
        }
      ]
    }  
  ]
}
```

</details>

#### 1.2.4. Image

[testmark]:# (1.2.4.a. arrange)
```markdown
- ![John Lennon, 1974 (restored cropped)](https://shorturl.at/SacIh)
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.4.a. assert-graph)
```turtle
@prefix dcmitype: <http://purl.org/dc/dcmitype/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<https://shorturl.at/SacIh> a dcmitype:Image ;
  rdfs:label "John Lennon, 1974 (restored cropped)" .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.4.a. assert-json)
```json
{
  "@context": [
    {
      "dcmitype": "http://purl.org/dc/dcmitype/",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label",
      "_Image": "dcmitype:Image"
    }
  ],
  "@graph": [
    {
      "@id": "https://shorturl.at/SacIh",
      "_label": "John Lennon, 1974 (restored cropped)",
      "@type": "_Image"
    }  
  ]
}
```

</details>

Image classes may be specified in the same way as for [hyperlink classes](#class).

#### 1.2.5. Code Block

[testmark]:# (1.2.5.a. arrange)
````markdown
- Yesterday
  - lyrics
    - ```text
      There are places I remember
      All my life, though some have changed
      ```
````

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.5.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "Yesterday" ;
  :lyrics [
    dcterms:format "text" ;
    rdf:value "There are places I remember\nAll my life, though some have changed"
  ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.5.a. assert-json)
```json
{
  "@context": [
    {
      "dcterms": "http://purl.org/dc/terms/",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_content": "rdf:value",
      "_label": "rdfs:label",
      "_format": "dcterms:format"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "Yesterday",
      "lyrics": [
        {
          "_format": "text",
          "_content": "There are places I remember\nAll my life, though some have changed"
        }
      ]
    }
  ]
}
```

</details>

Another example.

[testmark]:# (1.2.5.b. arrange)
````markdown
- ```text
  . 　　 　　　　　
  　·   ·   　    　
  　 ·  ✦ * 
   ✵  . 　　　　·  ·  ⋆  　 
     ✫  ✵  ·　　✵   　　 ˚ 
  · 　  ✵ 　　 　 .  ·
  ```
  - source
    - <https://x.com/tiny_star_field/status/1681381641753640960>
````

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.5.b. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .

[] dcterms:format "text" ; 
  rdf:value """  . 　　 　　　　　
  　·   ·   　    　
  　 ·  ✦ * 
   ✵  . 　　　　·  ·  ⋆  　 
     ✫  ✵  ·　　✵   　　 ˚ 
  · 　  ✵ 　　 　 .  ·""" ;
  :source <https://x.com/tiny_star_field/status/1681381641753640960> .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.5.b. assert-json)
```json
{
  "@context": [
    {
      "dcterms": "http://purl.org/dc/terms/",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_content": "rdf:value",
      "_format": "dcterms:format"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_format": "text",
      "_content": "\n  . \u3000\u3000 \u3000\u3000\u3000\u3000\u3000\n  \u3000\u00b7   \u00b7   \u3000    \u3000\n  \u3000 \u00b7  \u2726 * \n   \u2735  . \u3000\u3000\u3000\u3000\u00b7  \u00b7  \u22c6  \u3000 \n     \u272b  \u2735  \u00b7\u3000\u3000\u2735   \u3000\u3000 \u02da \n  \u00b7 \u3000  \u2735 \u3000\u3000 \u3000 .  \u00b7\n",
      "source": [
        {
          "@id": "https://x.com/tiny_star_field/status/1681381641753640960"
        }
      ]
    }
  ]
}
```

</details>

#### 1.2.6. Table

Tables are handled as HTML. It may be preferable to represent information semantically instead or as well.

[testmark]:# (1.2.6.a. arrange)
```markdown
- The Beatles
  - albums
    - | Title              | Year |
      |-                   |-     |
      | Please Please Me   | 1963 |
      | With the Beatles   | 1963 |
      | A Hard Day's Night | 1964 |
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.2.6.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "The Beatles" ;
  :albums "<table><thead><tr><th>Title<th>Year<tbody><tr><td>Please Please Me<td>1963<tr><td>With the Beatles<td>1963<tr><td>A Hard Day's Night<td>1964</table>"^^rdf:HTML .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.2.6.a. assert-json)
```json
{
  "@context": [
    {
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_HTML": "rdf:HTML"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "The Beatles",
      "albums": {
        "@type": "_HTML",
        "@value": "<table><thead><tr><th>Title<th>Year<tbody><tr><td>Please Please Me<td>1963<tr><td>With the Beatles<td>1963<tr><td>A Hard Day's Night<td>1964</table>"
      }
    }
  ]
}
```

</details>

Inserting hyperlinks or images into cells will reify the table as a blank node and generate [references](#reference).

### 1.3. Syntax

#### 1.3.1. Predicate Modifier

##### 1.3.1.1. Inverse Path

Materialise the inverse path of a given predicate by separating it with a `|` token.

[testmark]:# (1.3.1.1.a. arrange)
```markdown
- John
  - has child | has parent
    - Julian
```

[testmark]:# (1.3.1.1.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

_:John rdfs:label "John" ;
    :has_child [
        rdfs:label "Julian" ;
        :has_parent _:John
    ] .

:has_child owl:inverseOf :has_parent .
```

##### 1.3.1.2. Inverse Direction

Reverse the direction of the predicate from object to subject.

[testmark]:# (1.3.1.2.a. arrange)
```markdown
- John
  - knows `^`
    - Paul
```

<details><summary><code>text/turtle</code></summary>

```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "Paul" ;
  :knows [ rdfs:label "John" ] .
```

</details>

##### 1.3.1.3. Symetric

Add the token `o` to materialise a predicate's relationships in both directions for all object resources.

[testmark]:# (1.3.1.3.a. arrange)
```markdown
- John
  - knows `o`
   - Paul
   - George
   - Ringo
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.3.1.3.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

_:John rdfs:label "John" ;
  :knows [
    rdfs:label "Paul" ;
    :knows _:John
  ] , [
    rdfs:label "George" ;
    :knows _:John
  ] , [
    rdfs:label "Ringo" ;
    :knows _:John
  ] .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (1.3.1.3.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "@id": "_:John",
      "_label": "John",
      "knows": [
        {
          "_label": "Paul",
          "knows": [
            {
              "@id": "_:John"
            }
          ]
        },
        {
          "_label": "George",
          "knows": [
            {
              "@id": "_:John"
            }
          ]
        },
        {
          "_label": "Ringo",
          "knows": [
            {
              "@id": "_:John"
            }
          ]
        }
      ]
    }
  ]
}
```

</details>

##### 1.3.1.4. Product

Relate all the members of the combined set of subject and object resources via the predicate in both directions, excluding reflexive relations.

[testmark]:# (1.3.1.4.a. arrange)
```markdown
- John
  - knows `x`
    - Paul
    - George
    - Ringo
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (1.3.1.4.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

_:John rdfs:label "John" ;
    :knows _:Paul , _:George , _:Ringo .
  
_:Paul rdfs:label "Paul" ;
    :knows _:John , _:George , _:Ringo .

_:George rdfs:label "George" ;
    :knows _:John , _:Paul , _:Ringo .

_:Ringo rdfs:label "Ringo" ;
    :knows _:John , _:Paul , _:George .
```

</details>

## 2. Frontmatter

### 2.1. Base

Resolve relative IRIs against the specified base.

[testmark]:# (2.1.a. arrange)
```markdown
---
base: http://example.org/
---

- [John](people/1 "Person")
- [Paul](people/2 "Person")
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (2.1.a. assert-graph)
```turtle
@base <http://example.org/> .
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<people/1> rdfs:label "John" ;
  a :Person .

<people/2> rdfs:label "Paul" ;
  a :Person .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (2.1.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#"
    },
    {
      "@base": "http://example.org/",
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "@id": "people/1",
      "@type": "Person",
      "_label": "John"
    },
    {
      "@id": "people/2",
      "@type": "Person",
      "_label": "Person"
    }
  ]
}
```

</details>

### 2.2. Vocab

Set the default vocabulary, which can be overriden by local or [imported](#24-import) identity definitions.

[testmark]:# (2.2.a. arrange)
```markdown
---
vocab: https://schema.org/
---

- John
  - a
    - [Person](http://xmlns.com/foaf/0.1/Person)
  - knows
    - Paul
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (2.2.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

:John a foaf:Person ;
    rdfs:label "John" ;
    schema:knows [ rdfs:label "Paul" ] .

foaf:Person rdfs:label "Person" .
```

</details>

### 2.3. Language

Set the default language for all strings, unless overridden in-line.

[testmark]:# (2.3.a. arrange)
```markdown
---
language: en
---

- John
  - said
    - > I believe in everything until it's disproved
- Yoko
  - name
    - > 小野 洋子 `jp`
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (2.3.a. assert-graph)
```turtle
@prefix : <http://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John"@en ;
  :said "I believe in everything until it's disproved"@en .

[] rdfs:label "Yoko"@en ;
  :name "小野 洋子"@jp .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (2.3.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "@base": "http://example.org/",
      "@language": "en",
      "@vocab": "http://example.org/"
    }
  ],
  "@graph": [
    {
      "_label": "John",
      "said": "I believe in everything until it's disproved"
    },
    {
      "_label": "Yoko",
      "name": [
        {
          "@language": "jp",
          "@value": "小野 洋子"
        }
      ]
    }
  ]
}
```

</details>

### 2.4. Import

Import data from another file.

> ```markdown
> John
> : <http://www.wikidata.org/entity/Q1203>
>
> date
> : <http://www.w3.org/2001/XMLSchema#date>
>
> date of birth
> : <https://schema.org/birthDate>
> ```
>
> -- <http://example.org/terms.md>

[testmark]:# (2.4.a. arrange)
```markdown
---
import: http://example.org/terms.md
---

- John
  - date of birth
    - > 1940-10-09 `date`
```

<details><summary><code>text/turtle</code></summary>

[testmark]:# (2.4.a. assert-graph)
```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" ;
    schema:birthDate "1940-10-09"^^xsd:date .
```

</details>

<details><summary><code>application/ld+json</code></summary>

[testmark]:# (2.4.a. assert-json)
```json
{
  "@context": [
    {
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "_label": "rdfs:label"
    },
    {
      "date": "http://www.w3.org/2001/XMLSchema#date",
      "date_of_birth": "https://schema.org/birthDate"
    }
  ],
  "@graph": [
    {
      "@id": "http://www.wikidata.org/entity/Q1203",
      "_label": "John",
      "date_of_birth": [
        {
          "@type": "date",
          "@value": "1940-10-09"
        }
      ]
    }
  ]
}
```

</details>
