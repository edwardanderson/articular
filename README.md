# 🦾 Articular

Articular is a framework for building [Linked Art](https://linked.art/) knowledge graphs with conventional Markdown documents. It enables you to describe [GLAM](https://en.wikipedia.org/wiki/GLAM_%28industry%29) collections with plain text files, but query and publish the metadata as Linked Open Data.



## Overview

With Articular, you create webs of information by using styled text to connect tree-like structures of headings, lists and block quotes. Metadata is managed in directories of files instead of inside a database. Concise and readable documentation is automatically converted into rich semantic data.

Here is an example of how a snippet of Articular Markdown is transformed into JSON-LD by the framework.

`PhysicalObjects/nefertiti.md`
```markdown
# Nefertiti Bust
* _classified as_ `Type` [Sculpture](http://vocab.getty.edu/aat/300047090)
* _current location_ `Place` [Egyptian Museum of Berlin](http://www.wikidata.org/entity/Q254156)
```

```json
{
  "@context": "https://linked.art/ns/v1/linked-art.json",
  "id": "...PhysicalObjects/nefertiti",
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

Articular has several features to help keep your documentation succinct.



### Defaults & Emojis

1. Built-in defaults for common types and properties mean less boiler-plate syntax.

    The following two patterns generate the same data, because the default property for a `Name` is _identified by_, and a block quote can be used to specify textual content instead of the `_property_ **value**` pattern.

    `People/nefertiti.md`
    ```markdown
    # Queen Nefertiti
    ## `Name`
    > Neferneferuaten Nefertiti
    ```

    `People/frida-kahlo.md`
    ```markdown
    # Frida Kahlo
    ## _identified by_ `Name`
    * _content_ **Magdalena Carmen Frida Kahlo y Calderón**
    ```

2. Certain authorities and vocabulary URIs have default types.

    For example, URIs from the [Thesaurus for Geographic Names](http://www.getty.edu/research/tools/vocabularies/tgn/index.html) are instances of `Place`. And the default property for `Place` is _took place at_

    `People/nefertiti.md`
    ```markdown
    ### `Birth`
    * [Thebes](http://vocab.getty.edu/tgn/7001297)
    ```

    ```json
    {
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

3. Emojis are aliases for textual types.

    Frida Kahlo _died in_ a `Death` which _took place at_ the `Place` of Coyacán in 1954.

    `People/frida-kahlo.md`
    ```markdown
    ### 💀
    * 📍 [Coyoacán](http://www.wikidata.org/entity/Q661315)
    #### ⌛
    > 13 July 1954
    ```


### Dates

A date parser shortens the syntax necessary for `TimeSpan` definition when dates are block quoted.

Either of the following patterns is possible.

1.  `People/frida-kahlo.md`
    ```markdown
    ### `Birth`
    #### `TimeSpan`
    > 6 July 1907
    ```

2.  ```markdown
    ### _born_ `Birth`
    #### _timespan_ `TimeSpan`
    * _begin of the begin_ **1907-07-06T00:00:00Z**
    * _end of the end_ **1907-07-06T23:59:59Z**
    * _identified by_ `Name`
        * _content_ **6 July 1907**
    ```

Both of the snippets generate the same output.

```json
{
  "died": {
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
  }
}
```

### Rich Text

Mark-up block quotes to preserve rich text formatting in the output.

`PhysicalObjects/nefertiti.md`
```markdown
## `LinguisticObject`
> The **Nefertiti Bust** is a painted [stucco](https://en.wikipedia.org/wiki/Stucco)-coated [limestone](https://en.wikipedia.org/wiki/Limestone).
```

```json
{
  "referred_to_by": [
    {
      "type": "LinguisticObject",
      "format": "text/html",
      "content": "<p>The <strong>Nefertiti Bust</strong> is a painted <a href=\"https://en.wikipedia.org/wiki/Stucco\">stucco</a>-coated <a href=\"https://en.wikipedia.org/wiki/Limestone\">limestone</a>.</p>"
    }
  ]
}
```



## Example

Here is a short document describing a few features of Roy Lichtenstein's painting _Whaam!_ (1963) illustrating the various features and brevity of Articular Markdown:

`whaam.md`
```markdown
# Whaam! `HumanMadeObject`
* [Painting](http://vocab.getty.edu/aat/300033618)
    * [Type of Work](http://vocab.getty.edu/aat/300435443)
* _equivalent_ [Wikidata](http://www.wikidata.org/entity/Q3567592)

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

This is how Articular serialises `whaam.md` as Linked Open Data:

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
      "_label": "Wikidata"
    }
  ]
}
```

</details>

<details>
<summary>Turtle</summary>

```turtle
@prefix crm: <http://www.cidoc-crm.org/cidoc-crm/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dig: <http://www.ics.forth.gr/isl/CRMdig/> .
@prefix la: <https://linked.art/ns/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://github.com/example-museum/physical-objects/whaam> a crm:E22_Human-Made_Object ;
    rdfs:label "Whaam!" ;
    crm:P108i_was_produced_by [ a crm:E12_Production ;
            crm:P14_carried_out_by <http://vocab.getty.edu/ulan/500013596> ;
            crm:P4_has_time-span [ a crm:E52_Time-Span ;
                    crm:P1_is_identified_by [ a crm:E33_E41_Linguistic_Appellation ;
                            crm:P190_has_symbolic_content "1963" ] ;
                    crm:P82a_begin_of_the_begin "1963-01-01T00:00:00+00:00"^^xsd:dateTime ;
                    crm:P82b_end_of_the_end "1963-12-31T23:59:59+00:00"^^xsd:dateTime ] ;
            crm:P7_took_place_at <http://vocab.getty.edu/tgn/7012149> ] ;
    crm:P1_is_identified_by [ a crm:E33_E41_Linguistic_Appellation ;
            crm:P190_has_symbolic_content "Whaam!" ;
            crm:P2_has_type <http://vocab.getty.edu/aat/300404670> ;
            crm:P72_has_language <http://vocab.getty.edu/aat/300388277> ] ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300033618> ;
    crm:P65_shows_visual_item [ a crm:E36_Visual_Item ;
            crm:P129_is_about <http://vocab.getty.edu/aat/300055314> ;
            crm:P62_depicts <http://iconclass.org/45C17+41> ;
            la:digitally_shown_by [ a dig:D1_Digital_Object ;
                    rdfs:label "Tate" ;
                    dc:format "image/jpeg" ;
                    crm:P2_has_type <http://vocab.getty.edu/aat/300215302> ;
                    la:access_point <https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg> ],
                [ a dig:D1_Digital_Object ;
                    rdfs:label "Wikipedia" ;
                    dc:format "image/jpeg" ;
                    crm:P2_has_type <http://vocab.getty.edu/aat/300215302> ;
                    la:access_point <https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg> ] ] ;
    crm:P67i_is_referred_to_by [ a crm:E33_Linguistic_Object ;
            dc:format "text/html" ;
            crm:P190_has_symbolic_content "<p><strong>Whaam!</strong> is a 1963 diptych painting by the American artist <a href=\"https://en.wikipedia.org/wiki/Roy_Lichtenstein\">Roy Lichtenstein</a>. It is one of the best-known works of <a href=\"https://en.wikipedia.org/wiki/Pop_art\">pop art</a>, and among Lichtenstein's most important paintings.</p>" ;
            crm:P2_has_type <http://vocab.getty.edu/aat/300411780> ;
            crm:P72_has_language <http://vocab.getty.edu/aat/300388277> ] ;
    la:equivalent <http://www.wikidata.org/entity/Q3567592> .

<http://iconclass.org/45C17+41> a crm:E55_Type ;
    rdfs:label "projectiles, explosives, etc. (+ combat planes, fighters)" .

<http://vocab.getty.edu/aat/300033618> a crm:E55_Type ;
    rdfs:label "Painting" ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300435443> .

<http://vocab.getty.edu/aat/300055314> rdfs:label "war" .

<http://vocab.getty.edu/aat/300404670> a crm:E55_Type ;
    rdfs:label "Primary Title" .

<http://vocab.getty.edu/aat/300411780> a crm:E55_Type ;
    rdfs:label "Description" ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300418049> .

<http://vocab.getty.edu/aat/300418049> a crm:E55_Type ;
    rdfs:label "Brief Text" .

<http://vocab.getty.edu/aat/300435443> a crm:E55_Type ;
    rdfs:label "Type of Work" .

<http://vocab.getty.edu/tgn/7012149> a crm:E53_Place ;
    rdfs:label "USA" .

<http://vocab.getty.edu/ulan/500013596> a crm:E39_Actor ;
    rdfs:label "Roy Lichtenstein" .

<http://www.wikidata.org/entity/Q3567592> a crm:E22_Human-Made_Object ;
    rdfs:label "Wikidata" .

<https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg> a dig:D1_Digital_Object .

<https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg> a dig:D1_Digital_Object .

<http://vocab.getty.edu/aat/300215302> a crm:E55_Type ;
    rdfs:label "Digital Image" .

<http://vocab.getty.edu/aat/300388277> a crm:E56_Language ;
    rdfs:label "English" .
```

</details>



See the [specification](specification.md) for detailed guidance on writing Articular flavoured Markdown.
