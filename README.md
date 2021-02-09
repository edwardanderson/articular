# 🦾 Articular

Articular is a framework for building [Linked Art](https://linked.art/) knowledge graphs with conventional Markdown documents. It enables you to describe [GLAM](https://en.wikipedia.org/wiki/GLAM_%28industry%29) collections with plain text files, but query and publish the metadata as Linked Open Data.



## Overview

With Articular, you create webs of information by using styled text to connect trees of headings, images, lists and block quotes representing events in the lifecycle of an artwork (or person, event, place, etc.). Metadata is managed in directories of files instead of inside a database. Concise and readable documentation is automatically converted into rich semantic data.

Here is an example file containing a snippet of Articular Markdown:

```text
documents/
└── PhysicalObjects/
    └── nefertiti.md
```

```markdown
# Nefertiti Bust
* _classified as_ `Type` [Sculpture](http://vocab.getty.edu/aat/300047090)
* _current location_ `Place` [Egyptian Museum of Berlin](http://www.wikidata.org/entity/Q254156)
```

The document is transformed into this interoperable Linked Art JSON-LD by the framework:

```json
{
  "@context": "https://linked.art/ns/v1/linked-art.json",
  "id": ".../PhysicalObjects/nefertiti",
  "type": "HumanMadeObject",
  "_label": "Nefertiti Bust",
  "classified_as": [
    {
      "id": "http://vocab.getty.edu/aat/300047090",
      "type": "Type",
      "_label": "Sculpture"
    }
  ],
  "current_location": {
    "id": "http://www.wikidata.org/entity/Q254156",
    "type": "Place",
    "_label": "Egyptian Museum of Berlin"
  }
}
```



## Features

Articular has several features to help keep documentation succinct.



### Default Types and Properties

1. Built-in [defaults](defaults.json) for common types and properties mean less boiler-plate syntax. Both of these two patterns populate the same JSON structure with data:

    ```markdown
    # Queen Nefertiti
    ## `Name`
    > Neferneferuaten Nefertiti
    ```

    ```markdown
    # Frida Kahlo
    ## _identified by_ `Name`
    * _content_ **Magdalena Carmen Frida Kahlo y Calderón**
    ```

2. Authorities and vocabularies on the web map to default types. For example, URIs from the [Thesaurus for Geographic Names](http://www.getty.edu/research/tools/vocabularies/tgn/index.html) are instances of `Place`, while those from the [Art and Architecture Thesaurus](https://www.getty.edu/research/tools/vocabularies/aat/) are instances of `Type` by default. The default property for `Place` is _took place at_; for `Type` it is _classified as_.

    ```text
    documents/
    └── People/
        └── queen-nefertiti.md
    ```

    ```markdown
    # Queen Nefertiti
    * [Female](http://vocab.getty.edu/aat/300189557)
      * [Gender](http://vocab.getty.edu/aat/300055147)
    ## `Birth`
    * [Thebes](http://vocab.getty.edu/tgn/7001297)
    ```

    <details>
    <summary>JSON-LD</summary>


    ```json
    {
      "@context": "https://linked.art/ns/v1/linked-art.json",
      "id": "../People/queen-nefertiti",
      "type": "Person",
      "_label": "Queen Nefertiti",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300189557",
          "type": "Type",
          "_label": "Female",
          "classified_as": [
            {
              "id": "http://vocab.getty.edu/aat/300055147",
              "type": "Type",
              "_label": "Gender"
            }
          ]
        }
      ],
      "born": {
        "type": "Birth",
        "took_place_at": [
          {
            "id": "http://vocab.getty.edu/tgn/7001297",
            "type": "Place",
            "_label": "Thebes"
          }
        ]
      }
    }
    ```

    </details>



### Emojis

Emojis can be used as aliases for types.

1.  Frida Kahlo died in Coyoacán.

    ```markdown
    # Frida Kahlo
    ## 💀
    * 📍 [Coyoacán](http://www.wikidata.org/entity/Q661315)
    ```

    <details>
    <summary>JSON-LD</summary>

    ```json
    {
      "_label": "Frida Kahlo",
      "died": {
        "type": "Death",
        "took_place_at": [
          {
            "id": "http://www.wikidata.org/entity/Q661315",
            "type": "Place",
            "_label": "Coyoacán"
          }
        ]
      }
    }
    ```

    </details>

2.  This description of Alfred Hitchcock is in English.

    ```markdown
    # Alfred Hitchcock
    ## 📃
    > Sir Alfred Joseph Hitchcock KBE (13 August 1899 – 29 April 1980) was an English film director, producer, and screenwriter.

    * 🔤 [Description](http://vocab.getty.edu/aat/300411780)
    * 💬 [English](http://vocab.getty.edu/aat/300388277)
    ```

    <details>
    <summary>JSON-LD</summary>

    ```json
    {
      "_label": "Alfred Hitchcock",
      "referred_to_by": [
        {
          "type": "LinguisticObject",
          "classified_as": [
            {
              "id": "http://vocab.getty.edu/aat/300411780",
              "type": "Type",
              "_label": "Description"
            }
          ],
          "language": [
            {
              "id": "http://vocab.getty.edu/aat/300388277",
              "type": "Language",
              "_label": "English"
            }
          ]
        }
      ]
    }
    ```

    </details>


### Dates

A [date parser](https://dateparser.readthedocs.io/en/latest/) shortens the syntax necessary for `TimeSpan` definition when textual dates are block quoted. This means simple time periods can be described without having to specify pairs of _begin of the begin_ and _end of the end_ properties.

```markdown
# Frida Kahlo
## `Birth`
### `TimeSpan`
> 6 July 1907

## _carried out_ `Activity`
* [painter](http://vocab.getty.edu/aat/300025136)
### `TimeSpan`
> c.1925 - 1954
```

<details>
<summary>JSON-LD</summary>

```json
{
  "type": "Person",
  "_label": "Frida Kahlo",
  "born": {
    "type": "Birth",
    "timespan": {
      "type": "TimeSpan",
      "begin_of_the_begin": "1907-07-06T00:00:00Z",
      "end_of_the_end": "1907-07-06T23:59:59Z",
      "identified_by": [
        {
          "type": "Name",
          "content": "6 July 1907"
        }
      ]
    }
  },
  "carried_out": [
    {
      "type": "Activity",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300025136",
          "type": "Type",
          "_label": "painter"
        }
      ],
      "timespan": {
        "type": "TimeSpan",
        "begin_of_the_begin": "1925-01-01T00:00:00Z",
        "end_of_the_end": "1954-12-31T23:59:59Z",
        "identified_by": [
          {
            "type": "Name",
            "content": "c.1925 - 1954"
          }
        ]
      }
    }
  ]
}
```

</details>



### Images

Expressing the relationship between image files on the web and the content they represent is simplified using the Markdown image tag.

1.  Artwork

    ```markdown
    # Regents of the Old Men's House
    ## `VisualItem`
    ![Wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Frans_Hals_-_Regents_of_the_Old_Men%27s_Almshouse_-_WGA11182.jpg/330px-Frans_Hals_-_Regents_of_the_Old_Men%27s_Almshouse_-_WGA11182.jpg)

    * _depicts_ [Regents](http://iconclass.org/44B1161)
    ```

    <details>
    <summary>JSON-LD</summary>

    ```json
    {
      "_label": "Regents of the Old Men's House",
      "shows": [
        {
          "type": "VisualItem",
          "depicts": [
            {
              "id": "http://iconclass.org/44B1161",
              "type": "Type",
              "_label": "Regents"
            }
          ],
          "digitally_shown_by": [
            {
              "type": "DigitalObject",
              "format": "image/jpeg",
              "classified_as": [
                {
                  "id": "http://vocab.getty.edu/aat/300215302",
                  "type": "Type",
                  "_label": "Digital Image"
                }
              ],
              "_label": "Wikipedia",
              "access_point": [
                {
                  "id": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Frans_Hals_-_Regents_of_the_Old_Men%27s_Almshouse_-_WGA11182.jpg/330px-Frans_Hals_-_Regents_of_the_Old_Men%27s_Almshouse_-_WGA11182.jpg",
                  "type": "DigitalObject"
                }
              ]
            }
          ]
        }
      ]
    }
    ```

    </details>


2.  Person

    ```markdown
    # Charlie Mingus
    ## _representation_ `VisualItem`
    * _digitally carried by_ ![Wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Charles_Mingus_1976_cropped.jpg/330px-Charles_Mingus_1976_cropped.jpg)
    ```

    <details>
    <summary>JSON-LD</summary>

    ```json
    {
      "_label": "Charlie Mingus",
      "representation": [
        {
          "type": "VisualItem",
          "digitally_carried_by": [
            {
              "type": "DigitalObject",
              "format": "image/jpeg",
              "classified_as": [
                {
                  "id": "http://vocab.getty.edu/aat/300215302",
                  "type": "Type",
                  "_label": "Digital Image"
                }
              ],
              "_label": "Wikipedia",
              "access_point": [
                {
                  "id": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Charles_Mingus_1976_cropped.jpg/330px-Charles_Mingus_1976_cropped.jpg",
                  "type": "DigitalObject"
                }
              ]
            }
          ]
        }
      ]
    }
    ```

    </details>


### Rich Text

Text styling inside block quotes is preserved as HTML in the output data.

```markdown
# Nefertiti Bust
## `LinguisticObject`
> The **Nefertiti Bust** is a painted [stucco](https://en.wikipedia.org/wiki/Stucco)-coated [limestone](https://en.wikipedia.org/wiki/Limestone) sculpture.
```

<details>
<summary>JSON-LD</summary>

```json
{
  "_label": "Nefertiti Bust",
  "referred_to_by": [
    {
      "type": "LinguisticObject",
      "format": "text/html",
      "content": "<p>The <strong>Nefertiti Bust</strong> is a painted <a href=\"https://en.wikipedia.org/wiki/Stucco\">stucco</a>-coated <a href=\"https://en.wikipedia.org/wiki/Limestone\">limestone</a>.</p>"
    }
  ]
}
```

</details>



## Example

Here is a short document describing features of Roy Lichtenstein's painting _Whaam!_ (1963) illustrating the various features of Articular Markdown:

```text
documents/
└── PhysicalObjects/
    └── whaam.md
```

```markdown
# Whaam!
* [Painting](http://vocab.getty.edu/aat/300033618)
    * [Type of Work](http://vocab.getty.edu/aat/300435443)
* _equivalent_ 🏺 [Wikidata](http://www.wikidata.org/entity/Q3567592)

## `Name`
> Whaam!

* 🔤 [Primary Title](http://vocab.getty.edu/aat/300404670)
* 💬 [English](http://vocab.getty.edu/aat/300388277)

## `Production`
* _carried out by_ `Actor` [Roy Lichtenstein](http://vocab.getty.edu/ulan/500013596)
* 📍 [USA](http://vocab.getty.edu/tgn/7012149)

### `TimeSpan`
> 1963

## 📃
> **Whaam!** is a 1963 diptych painting by the American artist [Roy Lichtenstein](https://en.wikipedia.org/wiki/Roy_Lichtenstein). It is one of the best-known works of [pop art](https://en.wikipedia.org/wiki/Pop_art), and among Lichtenstein's most important paintings.

* [Description](http://vocab.getty.edu/aat/300411780)
    * [Brief Text](http://vocab.getty.edu/aat/300418049)
* 💬 [English](http://vocab.getty.edu/aat/300388277)

## 🖼️
![Wikipedia](https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg)

![Tate](https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg)

* _about_ [war](http://vocab.getty.edu/aat/300055314)
* _depicts_ 🔤 [projectiles, explosives, etc. (+ combat planes, fighters)](<http://iconclass.org/45C17+41>)
```

<details>
<summary>JSON-LD</summary>

```json
{
  "@context": "https://linked.art/ns/v1/linked-art.json",
  "id": "https://github.com/example-museum/physical-objects/whaam",
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
      "end_of_the_end": "1963-12-31T23:59:59Z"
    },
    "took_place_at": [
      {
        "id": "http://vocab.getty.edu/tgn/7012149",
        "type": "Place",
        "_label": "USA"
      }
    ]
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
      ]
    }
  ],
  "classified_as": [
    {
      "id": "http://vocab.getty.edu/aat/300033618",
      "type": "Type",
      "classified_as": [
        {
          "id": "http://vocab.getty.edu/aat/300435443",
          "type": "Type",
          "_label": "Type of Work"
        }
      ],
      "_label": "Painting"
    }
  ],
  "shows": [
    {
      "type": "VisualItem",
      "about": [
        {
          "id": "http://vocab.getty.edu/aat/300055314",
          "_label": "war"
        }
      ],
      "depicts": [
        {
          "id": "http://iconclass.org/45C17+41",
          "type": "Type",
          "_label": "projectiles, explosives, etc. (+ combat planes, fighters)"
        }
      ],
      "digitally_shown_by": [
        {
          "type": "DigitalObject",
          "format": "image/jpeg",
          "classified_as": [
            {
              "id": "http://vocab.getty.edu/aat/300215302",
              "type": "Type",
              "_label": "Digital Image"
            }
          ],
          "_label": "Wikipedia",
          "access_point": [
            {
              "id": "https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg",
              "type": "DigitalObject"
            }
          ]
        },
        {
          "type": "DigitalObject",
          "format": "image/jpeg",
          "classified_as": [
            {
              "id": "http://vocab.getty.edu/aat/300215302",
              "type": "Type",
              "_label": "Digital Image"
            }
          ],
          "_label": "Tate",
          "access_point": [
            {
              "id": "https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg",
              "type": "DigitalObject"
            }
          ]
        }
      ]
    }
  ],
  "referred_to_by": [
    {
      "type": "LinguisticObject",
      "format": "text/html",
      "content": "<p><strong>Whaam!</strong> is a 1963 diptych painting by the American artist <a href=\"https://en.wikipedia.org/wiki/Roy_Lichtenstein\">Roy Lichtenstein</a>. It is one of the best-known works of <a href=\"https://en.wikipedia.org/wiki/Pop_art\">pop art</a>, and among Lichtenstein's most important paintings.</p>",
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
      ]
    }
  ],
  "_label": "Whaam!",
  "equivalent": [
    {
      "id": "http://www.wikidata.org/entity/Q3567592",
      "type": "HumanMadeObject",
      "_label": "Wikidata"
    }
  ]
}
```

</details>



Refer to these [examples](examples/) and review the [specification](specification.md) for detailed guidance on writing Articular flavoured Markdown.
