# Specification

This document describes Articular conventions for writing Linked Art in Markdown.

## Example

```markdown
# `🏺` [Whaam!](http://www.wikidata.org/entity/Q3567592)

* [Painting](http://vocab.getty.edu/aat/300033618) `Type`
* [acrylics](http://vocab.getty.edu/aat/300015058) `Material`
* [oil paint](http://vocab.getty.edu/aat/300015050) `Material`

## `🏷️` Title
> Whaam!

* `🔤` [Primary Title](http://vocab.getty.edu/aat/300404670)
* `💬` [English](http://vocab.getty.edu/aat/300388277)

## `🆔` Persistent identifier
> https://artuk.org/discover/artworks/whaam-117785

* `🔤` [URI](http://vocab.getty.edu/aat/300404629)

### `📝` PID Assignment
* _carried out by_ [Art UK] `Group`

## `📃` Summary
> 1963 diptych painting by American artist Roy Lichtenstein

* `🔤` [Description](http://vocab.getty.edu/aat/300411780)
    * `🔤` [Brief Text](http://vocab.getty.edu/aat/300418049)
* `💬` [English](http://vocab.getty.edu/aat/300388277)

## `🏭` Creation
* _carried out by_ [Roy Lichtenstein](http://vocab.getty.edu/ulan/500013596) `Actor`

### `⌛` Dating
* _begin of the begin_ **1963-01-01T00:00:00Z**
* _end of the end_ **1963-12-31T23:59:59Z**

#### `🏷️`
> 1963
```

```json
{
  "@context": "https://linked.art/ns/v1/linked-art.json",
  "id": "http://www.wikidata.org/entity/Q3567592",
  "type": "HumanMadeObject",
  "produced_by": {
    "type": "Production",
    "carried_out_by": [
      {
        "id": "http://vocab.getty.edu/ulan/500013596",
        "type": "Actor",
        "_label": "Roy Lichtenstein"
      }
    ],
    "timespan": {
      "type": "TimeSpan",
      "identified_by": [
        {
          "type": "Name",
          "content": "1963"
        }
      ],
      "begin_of_the_begin": "1963-01-01T00:00:00Z",
      "end_of_the_end": "1963-12-31T23:59:59Z",
      "_label": "Dating"
    },
    "_label": "Creation"
  },
  "identified_by": [
    {
      "type": "Name",
      "content": "Whaam!",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300404670",
          "type": "Type",
          "_label": "Primary Title"
        }
      ],
      "language": [
        {
          "id": "http://vocab.getty.edu/aat/300388277",
          "type": "Language",
          "_label": "English"
        }
      ],
      "_label": "Title"
    },
    {
      "type": "Identifier",
      "assigned_by": [
        {
          "type": "AttributeAssignment",
          "carried_out_by": [
            {
              "type": "Group",
              "_label": "[Art UK]"
            }
          ],
          "_label": "PID Assignment"
        }
      ],
      "content": "https://artuk.org/discover/artworks/whaam-117785",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300404629",
          "type": "Type",
          "_label": "URI"
        }
      ],
      "_label": "Persistent identifier"
    }
  ],
  "classified_as": [
    {
      "id": "http://vocab.getty.edu/aat/300033618",
      "type": "Type",
      "_label": "Painting"
    }
  ],
  "made_of": [
    {
      "id": "http://vocab.getty.edu/aat/300015058",
      "type": "Material",
      "_label": "acrylics"
    },
    {
      "id": "http://vocab.getty.edu/aat/300015050",
      "type": "Material",
      "_label": "oil paint"
    }
  ],
  "referred_to_by": [
    {
      "type": "LinguisticObject",
      "content": "1963 diptych painting by American artist Roy Lichtenstein",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300411780",
          "type": "Type",
          "classified_as": [
            {
              "id": "http://vocab.getty.edu/aat/300418049",
              "type": "Type",
              "_label": "Brief Text"
            }
          ],
          "_label": "Description"
        }
      ],
      "language": [
        {
          "id": "http://vocab.getty.edu/aat/300388277",
          "type": "Language",
          "_label": "English"
        }
      ],
      "_label": "Summary"
    }
  ],
  "_label": "Whaam!"
}
```

## Primitives

### Type

Types MUST be enclosed in back ticks. They SHOULD be written in PascalCase. They MAY be either a Linked Art class name string or a Lark class emoji.

```markdown
`LinguisticObject`
```

```Markdown
`📃`
```

```json
{
    "type": "LinguisticObject"
}
```



### Property

Properties MUST be written in italics. If multiple words, they MAY be delimited with either spaces or underscores. They SHOULD be in lower case.

```markdown
_identified by_
```

```json
{
    "identified_by": []
}
```



### Label

Labels MAY be enclosed in square brackets. They MAY be the name of a hyperlink.

```markdown
Example painting
```

```markdown
[Example painting]
```

```json
{
    "_label": "Example painting"
}
```



### ID

IDs MUST be labelled hyperlinks.

```markdown
[Material Statement](http://vocab.getty.edu/aat/300435429)
```

```json
{
    "id": "http://vocab.getty.edu/aat/300435429",
    "_label": "Material Statement"
}
```



## Structure

An Articular document describes a single entity, for example an artwork, an event, a person, etc. Structure the document with [headings](#Headings), [lists](#Lists) and [block quotes](#BlockQuotes) to add information.



### Headings

### h1

The `h1` heading MUST provide the class of the entity the document is describing. It MAY identify it with a URI given as a labelled hyperlink.

```markdown
# [Example painting](www.example.com/painting/1) `HumanMadeObject`
```

```markdown
# `🏺` [Example painting](www.example.com/painting/1) 
```

```json
{
    "id": "www.example.com/painting/1",
    "_label": "Example painting",
    "type": "HumanMadeObject"
}
```



### h2+

All subsequent deeper headings ascribe information to the `h1` class entity. Headings MAY be nested if they themselves provide qualification.

```markdown
# `🏺` [Example painting](www.example.com/painting/1) 
## _referred to by_ `LinguisticObject`
### _classified as_ [Description](http://vocab.getty.edu/aat/300411780) `Type`
## _identified by_ `Name`
```

```json
{
    "id": "www.example.com/painting/1",
    "_label": "Example painting",
    "type": "HumanMadeObject",
    "referred_to_by_": [
        {
            "type": "LinguisticObject",
            "classified_as": [
                {
                    "id": "http://vocab.getty.edu/aat/300411780",
                    "type": "Type",
                    "_label": "Description"
                }
            ]
        }
    ],
    "identified_by": [
        {
            "type": "Name"
        }
    ]
}
```



Properties MAY be omitted if a default property for the Linked Art class is available, or specified to explicitly overwrite the default.



### Lists

Lists MUST be sequences of bullet points (either `*` or `-`). They MAY be nested. A list item MAY contain a property AND a type AND a label AND an ID.

```markdown
# `🏺` [Example painting]
* _classified as_ [Painting](http://vocab.getty.edu/aat/300033618) `Type`
    * _classified as_ [Type of Work](http://vocab.getty.edu/aat/300435443) `Type`
```

```json
{
    "type": "HumanMadeObject",
    "_label": "Example painting",
    "classified_as": [
        {
            "id": "http://vocab.getty.edu/aat/300033618",
            "type": "Type",
            "_label": "Painting",
            "classified_as": [
                {
                    "id": "http://vocab.getty.edu/aat/300435443",
                    "type": "Type",
                    "_label": "Type of Work"
                }
            ]
        }
    ]
}
```


Emoji classes and default properties MAY be used.

```markdown
# `🏺` [Example painting]
## `🏭` Creation
* _took place at_ `📍` [Amsterdam](http://vocab.getty.edu/tgn/7006952)
* _carried out by_ `🙋` [Rembrandt van Rijn](http://vocab.getty.edu/ulan/500011051)
```

```json
{
    "type": "HumanMadeObject",
    "_label": "Example painting",
    "produced_in": {
        "type": "Production",
        "_label": "Creation",
        "took_place_at": [
            {
                "id": "http://vocab.getty.edu/tgn/7006952",
                "type": "Place",
                "_label": "Amsterdam"
            }
        ],
        "carried_out_by": [
            {
                "id": "http://vocab.getty.edu/ulan/500011051",
                "type": "Actor",
                "_label": "Rembrandt van Rijn"
            }
        ]
    }
}
```



#### Block Quotes

Textual information and numeric values MUST be written as block quotes. A blank line MUST follow the block quote.

```markdown
## `LinguisticObject`
> Fascinating and beguiling

```

```json
{
    "referred_to_by": [
        {
            "type": "LinguisticObject",
            "content": "Fascinating and beguiling"
        }
    ]
}
```



Text MAY be styled Markdown. It is automatically converted to HTML.

```markdown
> An extremely **important** artwork.

```

```json
{
    "content": "<p>An extremely <strong>important</strong> artwork.</p>",
    "format": "text/html"
}
```



### Class/Property Defaults

Framework default properties are used (if available) when none is specified.

| Class                 | Alias  | Default Property  |
| --------------------- | ------ | ----------------- |
| `Acquisition`         | `🛒`   |                   |
| `Activity`            | `👋`   |                   |
| `Actor`               | `🙋`   |                   |
| `Addition`            | `➕`   | _added member by_ |
| `AttributeAssignment` | `📝`   | _assigned by_     |
| `Birth`               | `👶`   | _born_            |
| `Creation`            | `🆕`   | _created by_      |
| `Currency`            | `💲`   | _currency_        |
| `Death`               | `💀`   | _died_            |
| `Destruction`         | `💣`   | _destroyed by_    |
| `DigitalObject`       | `💾`   |                   |
| `DigitalService`      | `🤖`   |                   |
| `Dimension`           | `📐`   | _dimension_       |
| `Dissolution`         | `💔`   | _dissolved by_    |
| `Encounter`           | `🔎`   |                   |
| `Formation`           | `🤝`   | _formed by_       |
| `Group`               | `👥`   |                   |
| `HumanMadeObject`     | `🏺`   |                   |
| `Identifier`          | `🆔`   | _identified by_   |
| `InformationObject`   | `📖`   |                   |
| `Language`            | `💬`   | _language_        |
| `LinguisticObject`    | `📃`   | _referred to by_  |
| `Material`            | `🧱`   | _made of_         |
| `MeasurementUnit`     | `📏`   | _unit_            |
| `MonetaryAmount`      | `💶`   | _paid amount_     |
| `Move`                | `📨`   | _part_            |
| `Name`                | `🏷️`   | _identified by_   |
| `PartRemoval`         | `🧩`   | _removed by_      |
| `Payment`             | `💳`   | _part_            |
| `Person`              | `👤`   |                   |
| `Place`               | `📍`   | _took place at_   |
| `Production`          | `🏭`   | _produced by_     |
| `PropositionalObject` | `💭`   |                   |
| `Right`               | `📜`   |                   |
| `RightAcquisition`    | `🧾`   |                   |
| `Set`                 | `🗃️`   |                   |
| `TimeSpan`            | `⌛`   | _timespan_        |
| `TransferOfCustody`   | `📦`   |                   |
| `Type`                | `🔤`   | _classified as_   |
| `VisualItem`          | `🖼️`   | _shows_           |
