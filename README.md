# 🦾 Articular

Articular is a framework for building [Linked Art](https://linked.art/) knowledge graphs with conventional Markdown documents. It enables you to describe [GLAM](https://en.wikipedia.org/wiki/GLAM_%28industry%29) collections with plain text files, but query and publish the metadata as Linked Open Data.



## Example

Here is a short document describing features of Roy Lichtenstein's painting _Whaam!_ (1963):

`whaam.md`
```markdown
# 🏺 [Whaam!](http://www.wikidata.org/entity/Q3567592)
* 🔤 [Painting](http://vocab.getty.edu/aat/300033618)

## 🏷️ Title
> Whaam!

* 🔤 [Primary Title](http://vocab.getty.edu/aat/300404670)
* 💬 [English](http://vocab.getty.edu/aat/300388277)

## 🏭 Creation
* _carried out by_ [Roy Lichtenstein](http://vocab.getty.edu/ulan/500013596) `Actor`

### ⌛ Creation date
* _begin of the begin_ **1963-01-01**
* _end of the end_ **1963-12-31**
* `Name`
    * _content_ **1963**

## 📃 Summary
> **Whaam!** is a 1963 diptych painting by the American artist [Roy Lichtenstein](https://en.wikipedia.org/wiki/Roy_Lichtenstein). It is one of the best-known works of [pop art](https://en.wikipedia.org/wiki/Pop_art), and among Lichtenstein's most important paintings.

* 🔤 [Description](http://vocab.getty.edu/aat/300411780)
    * 🔤 [Brief Text](http://vocab.getty.edu/aat/300418049)
* 💬 [English](http://vocab.getty.edu/aat/300388277)

## 🖼️ Depictions
![Wikipedia](https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg)

![Tate](https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg)

* _about_ [war](http://vocab.getty.edu/aat/300055314) 🔤
* _depicts_ [projectiles, explosives, etc. (+ combat planes, fighters)](<http://iconclass.org/45C17+41>) `Type`
```

This is how Articular serialises `whaam.md` as Linked Open Data:

<details>
<summary>Linked Art JSON-LD</summary>

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
      "end_of_the_end": "1963-12-31T23:59:59Z"
    }
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
      "_label": "Painting"
    }
  ],
  "shows": [
    {
      "type": "VisualItem",
      "about": [
        {
          "id": "http://vocab.getty.edu/aat/300055314",
          "type": "Type",
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
  "_label": "Whaam!"
}
```

</details>

<details>
<summary>CIDOC-CRM Turtle</summary>

```turtle
@prefix crm: <http://www.cidoc-crm.org/cidoc-crm/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dig: <http://www.ics.forth.gr/isl/CRMdig/> .
@prefix la: <https://linked.art/ns/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<http://www.wikidata.org/entity/Q3567592> a crm:E22_Human-Made_Object ;
    rdfs:label "Whaam!" ;
    crm:P108i_was_produced_by [ a crm:E12_Production ;
            crm:P14_carried_out_by <http://vocab.getty.edu/ulan/500013596> ;
            crm:P4_has_time-span [ a crm:E52_Time-Span ;
                    crm:P1_is_identified_by [ a crm:E33_E41_Linguistic_Appellation ;
                            crm:P190_has_symbolic_content "1963" ] ;
                    crm:P82a_begin_of_the_begin "1963-01-01T00:00:00+00:00"^^xsd:dateTime ;
                    crm:P82b_end_of_the_end "1963-12-31T23:59:59+00:00"^^xsd:dateTime ] ] ;
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
            crm:P72_has_language <http://vocab.getty.edu/aat/300388277> ] .

<http://iconclass.org/45C17+41> a crm:E55_Type ;
    rdfs:label "projectiles, explosives, etc. (+ combat planes, fighters)" .

<http://vocab.getty.edu/aat/300033618> a crm:E55_Type ;
    rdfs:label "Painting" .

<http://vocab.getty.edu/aat/300055314> a crm:E55_Type ;
    rdfs:label "war" .

<http://vocab.getty.edu/aat/300404670> a crm:E55_Type ;
    rdfs:label "Primary Title" .

<http://vocab.getty.edu/aat/300411780> a crm:E55_Type ;
    rdfs:label "Description" ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300418049> .

<http://vocab.getty.edu/aat/300418049> a crm:E55_Type ;
    rdfs:label "Brief Text" .

<http://vocab.getty.edu/ulan/500013596> a crm:E39_Actor ;
    rdfs:label "Roy Lichtenstein" .

<https://upload.wikimedia.org/wikipedia/en/b/b7/Roy_Lichtenstein_Whaam.jpg> a dig:D1_Digital_Object .

<https://www.tate.org.uk/art/images/work/T/T00/T00897_10.jpg> a dig:D1_Digital_Object .

<http://vocab.getty.edu/aat/300215302> a crm:E55_Type ;
    rdfs:label "Digital Image" .

<http://vocab.getty.edu/aat/300388277> a crm:E56_Language ;
    rdfs:label "English" .
```

</details>



See the [specification](specification.md) for detailed guidance on writing Articular flavoured Markdown.
