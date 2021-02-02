# 🦾 Articular

Articular is a framework for building [Linked Art](https://linked.art/) knowledge graphs from conventional Markdown documents. It enables you to maintain [GLAM](https://en.wikipedia.org/wiki/GLAM_%28industry%29) collection documentation in plain text files but query and publish it as Linked Open Data.



## Example

Here is a short record for Roy Lichtenstein's painting _Whaam!_ (1963):

`whaam.md`
```markdown
# `🏺` [Whaam!](http://www.wikidata.org/entity/Q3567592)
* `🔤` [Painting](http://vocab.getty.edu/aat/300033618)

## `🏷️` Title
> Whaam!

* `🔤` [Primary Title](http://vocab.getty.edu/aat/300404670)
* `💬` [English](http://vocab.getty.edu/aat/300388277)

## `🏭` Creation
* _carried out by_ [Roy Lichtenstein](http://vocab.getty.edu/ulan/500013596) `Actor`

### `⌛` Dating
* _begin of the begin_ **1963-01-01T00:00:00Z**
* _end of the end_ **1963-12-31T23:59:59Z**

## `📃` Summary
> **Whaam!** is a 1963 diptych painting by the American artist [Roy Lichtenstein](https://en.wikipedia.org/wiki/Roy_Lichtenstein). It is one of the best-known works of [pop art](https://en.wikipedia.org/wiki/Pop_art), and among Lichtenstein's most important paintings.

* `🔤` [Description](http://vocab.getty.edu/aat/300411780)
    * `🔤` [Brief Text](http://vocab.getty.edu/aat/300418049)
* `💬` [English](http://vocab.getty.edu/aat/300388277)
```

This is how Articular serialises Linked Open Data from the document above:

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
      "begin_of_the_begin": "1963-01-01T00:00:00+00:00",
      "end_of_the_end": "1963-12-31T23:59:59+00:00",
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
    }
  ],
  "classified_as": [
    {
      "id": "http://vocab.getty.edu/aat/300033618",
      "type": "Type",
      "_label": "Painting"
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
      ],
      "_label": "Summary"
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
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<http://www.wikidata.org/entity/Q3567592> a crm:E22_Human-Made_Object ;
    rdfs:label "Whaam!" ;
    crm:P108i_was_produced_by [ a crm:E12_Production ;
            rdfs:label "Creation" ;
            crm:P14_carried_out_by <http://vocab.getty.edu/ulan/500013596> ;
            crm:P4_has_time-span [ a crm:E52_Time-Span ;
                    rdfs:label "Dating" ;
                    crm:P82a_begin_of_the_begin "1963-01-01T00:00:00+00:00"^^xsd:dateTime ;
                    crm:P82b_end_of_the_end "1963-12-31T23:59:59+00:00"^^xsd:dateTime ] ] ;
    crm:P1_is_identified_by [ a crm:E33_E41_Linguistic_Appellation ;
            rdfs:label "Title" ;
            crm:P190_has_symbolic_content "Whaam!" ;
            crm:P2_has_type <http://vocab.getty.edu/aat/300404670> ;
            crm:P72_has_language <http://vocab.getty.edu/aat/300388277> ] ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300033618> ;
    crm:P67i_is_referred_to_by [ a crm:E33_Linguistic_Object ;
            rdfs:label "Summary" ;
            dc:format "text/html" ;
            crm:P190_has_symbolic_content "<p><strong>Whaam!</strong> is a 1963 diptych painting by the American artist <a href=\"https://en.wikipedia.org/wiki/Roy_Lichtenstein\">Roy Lichtenstein</a>. It is one of the best-known works of <a href=\"https://en.wikipedia.org/wiki/Pop_art\">pop art</a>, and among Lichtenstein's most important paintings.</p>" ;
            crm:P2_has_type <http://vocab.getty.edu/aat/300411780> ;
            crm:P72_has_language <http://vocab.getty.edu/aat/300388277> ] .

<http://vocab.getty.edu/aat/300033618> a crm:E55_Type ;
    rdfs:label "Painting" .

<http://vocab.getty.edu/aat/300404670> a crm:E55_Type ;
    rdfs:label "Primary Title" .

<http://vocab.getty.edu/aat/300411780> a crm:E55_Type ;
    rdfs:label "Description" ;
    crm:P2_has_type <http://vocab.getty.edu/aat/300418049> .

<http://vocab.getty.edu/aat/300418049> a crm:E55_Type ;
    rdfs:label "Brief Text" .

<http://vocab.getty.edu/ulan/500013596> a crm:E39_Actor ;
    rdfs:label "Roy Lichtenstein" .

<http://vocab.getty.edu/aat/300388277> a crm:E56_Language ;
    rdfs:label "English" .
```

</details>



See the [specification](specification.md) for detailed guidance on writing Articular flavoured Markdown.
