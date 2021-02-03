# Specification

Articular documents are written using conventional Markdown syntax. Each document describes a single entity, for example an artwork, an event, a person, etc.

## Quickstart
Documents can be composed of:

* [headings](#Headings)
* [unordered lists](#Lists)
* [blockquotes](#Block-Quotes)
* [images](#Images)

Text styling is used to mark-up data [primitives](#primitives):

* `type`
* _property_
* [URI](id)
* **value**

Certain [Emojis](#Class/Property-Defaults) may be used in place of text for types.

When either a property or type is omitted, a [default](#Class/Property-Defaults) is used.

Refer to the [Linked Art data model](https://linked.art/model/index.html) for descriptive patterns.



## Primitives

### Type

Types written as text MUST be enclosed in back ticks. They SHOULD be written in PascalCase. They MAY be either a Linked Art class name string or a Articular class emoji.

```markdown
`LinguisticObject`
```

```Markdown
📃
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

IDs MUST be labelled hyperlinks. URLs containing parentheses SHOULD be wrapped in brackets.

```markdown
[projectiles, explosives, etc. (+ combat planes, fighters)](<http://iconclass.org/45C17(+41)>)
```

```json
{
    "id": "http://iconclass.org/45C17(+41)",
    "_label": "projectiles, explosives, etc. (+ combat planes, fighters)"
}
```



### Value

Values MUST be written in bold. Dates given as ISO fragments are automatically normalised to `dateTime` values.

```markdown
* `TimeSpan`
    * _begin of the begin_ **1965-04**
    * _end of the end_ **1970**
    * `Name`
        * _content_ **From April 1965 to late 1970**
```

```json
{
    "timespan": {
        "type": "TimeSpan",
        "begin_of_the_begin": "1965-04-01T00:00:00Z",
        "end_of_the_end": "1970-12-31T23:59:59Z",
        "identified_by": [
            {
                "type": "Name",
                "content": "From April 1965 to late 1970"
            }
        ]
    }
}
```



## Structure

### Headings

### h1

The `h1` heading MUST provide the class of the entity the document is describing. It MAY identify it with a URI given as a labelled hyperlink.

```markdown
# [Example painting](www.example.com/painting/1) `HumanMadeObject`
```

```markdown
# 🏺 [Example painting](www.example.com/painting/1)
```

```json
{
    "id": "www.example.com/painting/1",
    "_label": "Example painting",
    "type": "HumanMadeObject"
}
```



### h2+

All subsequent deeper headings ascribe information to the `h1` class entity. Headings MAY be nested.

```markdown
# 🏺 [Example painting](www.example.com/painting/1)
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

Lists MUST be sequences of bullet points (either `*` or `-`). Items MAY be nested.

```markdown
# 🏺 [Example painting]
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
# 🏺 [Example painting]
## 🏭 Creation
* 📍 [Amsterdam](http://vocab.getty.edu/tgn/7006952)
* _carried out by_ 🙋 [Rembrandt van Rijn](http://vocab.getty.edu/ulan/500011051)
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

Text MAY be styled Markdown. It is converted to HTML.

```markdown
> An extremely **important** artwork.

```

```json
{
    "content": "<p>An extremely <strong>important</strong> artwork.</p>",
    "format": "text/html"
}
```



#### Images

```markdown
![Self-Portrait with Thorn Necklace and Hummingbird](https://upload.wikimedia.org/wikipedia/en/1/1e/Frida_Kahlo_%28self_portrait%29.jpg)
```

```json
{
    "digitally_shown_by": {
        "type": "DigitalObject",
        "_label": "Self-Portrait with Thorn Necklace and Hummingbird",
        "format": "image/jpeg",
        "access_point": [
            {
                "id": "https://upload.wikimedia.org/wikipedia/en/1/1e/Frida_Kahlo_%28self_portrait%29.jpg",
                "type": "DigitalObject"
            }
        ],
        "classified_as": [
            {
                "id": "http://vocab.getty.edu/aat/300215302",
                "_label": "Digital Image",
                "type": "Type"
            }
        ]
    }
}
```



### Class/Property Defaults

Framework default properties are used (if available) when none is specified.

| Class                 | Alias | Default Property  |
| --------------------- | ----- | ----------------- |
| `Acquisition`         | 🛒    |                   |
| `Activity`            | 👋    |                   |
| `Actor`               | 🙋    |                   |
| `Addition`            | ➕    | _added member by_ |
| `AttributeAssignment` | 📝    | _assigned by_     |
| `Birth`               | 👶    | _born_            |
| `Creation`            | 🆕`   | _created by_      |
| `Currency`            | 💲    | _currency_        |
| `Death`               | 💀    | _died_            |
| `Destruction`         | 💣    | _destroyed by_    |
| `DigitalObject`       | 💾    |                   |
| `DigitalService`      | 🤖    |                   |
| `Dimension`           | 📐    | _dimension_       |
| `Dissolution`         | 💔    | _dissolved by_    |
| `Encounter`           | 🔎    |                   |
| `Formation`           | 🤝    | _formed by_       |
| `Group`               | 👥    |                   |
| `HumanMadeObject`     | 🏺    |                   |
| `Identifier`          | 🆔`   | _identified by_   |
| `InformationObject`   | 📖    |                   |
| `Language`            | 💬    | _language_        |
| `LinguisticObject`    | 📃    | _referred to by_  |
| `Material`            | 🧱    | _made of_         |
| `MeasurementUnit`     | 📏    | _unit_            |
| `MonetaryAmount`      | 💶    | _paid amount_     |
| `Move`                | 📨    | _part_            |
| `Name`                | 🏷️    | _identified by_   |
| `PartRemoval`         | 🧩    | _removed by_      |
| `Payment`             | 💳    | _part_            |
| `Person`              | 👤    |                   |
| `Place`               | 📍    | _took place at_   |
| `Production`          | 🏭    | _produced by_     |
| `PropositionalObject` | 💭    |                   |
| `Right`               | 📜    |                   |
| `RightAcquisition`    | 🧾    |                   |
| `Set`                 | 🗃️    |                   |
| `TimeSpan`            | ⌛    | _timespan_        |
| `TransferOfCustody`   | 📦    |                   |
| `Type`                | 🔤    | _classified as_   |
| `VisualItem`          | 🖼️    | _shows_           |
