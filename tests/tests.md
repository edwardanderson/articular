# Tests

- [Tests](#tests)
  - [Document](#document)
    - [Label anonymous resources](#label-anonymous-resources)
    - [Identify and label resources locally](#identify-and-label-resources-locally)
    - [Identify and label resources globally (in-line)](#identify-and-label-resources-globally-in-line)
    - [Identify and label resources globally (definition list)](#identify-and-label-resources-globally-definition-list)
    - [Identify equivalent global resources](#identify-equivalent-global-resources)
    - [Relate resources with local term](#relate-resources-with-local-term)
    - [Relate multiple resources with local term](#relate-multiple-resources-with-local-term)
    - [Relate resources with global term](#relate-resources-with-global-term)
    - [Assign local class](#assign-local-class)
    - [Assign global class](#assign-global-class)
    - [Object literal (plain)](#object-literal-plain)
    - [Object literal (language)](#object-literal-language)
    - [Object literal (type: xsd:gYear)](#object-literal-type-xsdgyear)
    - [Object literal (type: xsd:gMonth)](#object-literal-type-xsdgmonth)
    - [Object literal (type: xsd:date)](#object-literal-type-xsddate)
    - [Object literal (styled)](#object-literal-styled)
    - [Object literal (styled, with language)](#object-literal-styled-with-language)
    - [Subject literal](#subject-literal)
    - [Image](#image)
  - [Frontmatter](#frontmatter)
    - [Default language](#default-language)
    - [Base](#base)
    - [Vocabulary](#vocabulary)
    - [Metadata](#metadata)
    - [Autotype](#autotype)

## Document

### Label anonymous resources

```markdown
- John
- Paul
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" .

[] rdfs:label "Paul" .
```

### Identify and label resources locally

```markdown
- [John](1)
- [Paul](2)
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/1> rdfs:label "John" .

<http://example.org/2> rdfs:label "Paul" .
```

### Identify and label resources globally (in-line)

```markdown
- [John](http://www.wikidata.org/entity/Q1203)
- [Paul](http://www.wikidata.org/entity/Q2599)
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" .

<http://www.wikidata.org/entity/Q2599> rdfs:label "Paul" .
```

### Identify and label resources globally (definition list)


```markdown
- John
- Paul

John
: <http://www.wikidata.org/entity/Q1203>

Paul
: <http://www.wikidata.org/entity/Q2599>
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" .

<http://www.wikidata.org/entity/Q2599> rdfs:label "Paul" .
```

### Identify equivalent global resources

```markdown
- John
- Paul

John
: <http://www.wikidata.org/entity/Q1203>
: <https://vocab.getty.edu/ulan/500106615>

Paul
: <http://www.wikidata.org/entity/Q2599>
: <https://vocab.getty.edu/ulan/500249736>
```

```turtle
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" ;
  owl:sameAs <https://vocab.getty.edu/ulan/500106615> .

<https://vocab.getty.edu/ulan/500106615> rdfs:label "John" .

<http://www.wikidata.org/entity/Q2599> rdfs:label "Paul" ;
  owl:sameAs <https://vocab.getty.edu/ulan/500249736> .

<https://vocab.getty.edu/ulan/500249736> rdfs:label "Paul" .
```

### Relate resources with local term

```markdown
- John
  - knows
    - Paul
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :knows [ rdfs:label "Paul" ] .
```

### Relate multiple resources with local term

```markdown
- John
  - knows
    - Paul
    - George
    - Ringo
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :knows [ rdfs:label "Paul" ],
    [ rdfs:label "George" ],
    [ rdfs:label "Ringo" ] .
```

### Relate resources with global term

```markdown
- John
  - [knows](http://xmlns.com/foaf/0.1/knows)
    - Paul
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  foaf:knows [ rdfs:label "Paul" ] .
```

### Assign local class

```markdown
- John
  - a
    - Person
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] a :Person ;
  rdfs:label "John" .
```

### Assign global class

```markdown
- John
  - a
    - [Person](https://schema.org/Person)
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

[] a schema:Person ;
  rdfs:label "John" .
```

### Object literal (plain)

```markdown
- John
  - name
    - > John Winston Lennon
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :name "John Winston Lennon" .
```

### Object literal (language)

```markdown
- John
  - name
    - > John Winston Lennon `en`
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :name "John Winston Lennon"@en .
```

### Object literal (type: xsd:gYear)

```markdown
- John
  - date of birth
    - > 1940 `date`
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
  :date_of_birth "1940"^^xsd:gYear .
```

### Object literal (type: xsd:gMonth)

```markdown
- John
  - date of birth
    - > 1940-10 `date`
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
  :date_of_birth "1940-10"^^xsd:gMonth .
```

### Object literal (type: xsd:date)

```markdown
- John
  - date of birth
    - > 1940-10-09 `date`
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
  :date_of_birth "1940-10-09"^^xsd:date .
```

### Object literal (styled)

```markdown
- John
  - description
    - > **John Winston Lennon** was an English singer, songwriter and musician who gained worldwide fame as the founder, co-songwriter, co-lead vocalist and rhythm guitarist of [the Beatles](https://en.wikipedia.org/wiki/The_Beatles).
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix html: <http://www.w3.org/1999/xhtml/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
  :description [
    a html:blockquote ;
    rdf:value "<p><strong>John Winston Lennon</strong> was an English singer, songwriter and musician who gained worldwide fame as the founder, co-songwriter, co-lead vocalist and rhythm guitarist of <a href=\"https://en.wikipedia.org/wiki/The_Beatles\">the Beatles</a>.</p>"^^rdf:HTML ;
    rdfs:seeAlso <https://en.wikipedia.org/wiki/The_Beatles> ;
    rdf:value "John Winston Lennon was an English singer, songwriter and musician who gained worldwide fame as the founder, co-songwriter, co-lead vocalist and rhythm guitarist of the Beatles."
  ] .

<https://en.wikipedia.org/wiki/The_Beatles> rdfs:label "the Beatles" .
```

### Object literal (styled, with language)

```markdown
- John
  - description
    - > **John Winston Lennon** was an English singer, songwriter and musician `en`
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :description "<p lang=\"en\"><strong>John Winston Lennon</strong> was an English singer, songwriter and musician</p>"^^rdf:HTML .
```

* TODO: This should generate a plain-text version too.

### Subject literal

```markdown
- > Life is what happens while you are busy making other plans.
  - said by
    - John
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix html: <http://www.w3.org/1999/xhtml/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] :said_by [ rdfs:label "John" ] ;
  rdf:value "Life is what happens while you are busy making other plans." .
```

### Image

```markdown
- John
  - portrait
    - ![John Lennon being interviewed in Los Angeles](https://digital.library.ucla.edu/catalog/ark:/21198/zz0002pv3r)
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix html: <http://www.w3.org/1999/xhtml/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" ;
  :portrait <https://digital.library.ucla.edu/catalog/ark:/21198/zz0002pv3r> .

<https://digital.library.ucla.edu/catalog/ark:/21198/zz0002pv3r> a html:img ;
    rdfs:label "John Lennon being interviewed in Los Angeles" .
```

## Frontmatter

### Default language

```markdown
---
language: fr
---

- John `en`
  - description
    - > John Lennon né le 9 octobre 1940 à Liverpool et mort assassiné le 8 décembre 1980 à New York
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John"@en ;
  :description "John Lennon né le 9 octobre 1940 à Liverpool et mort assassiné le 8 décembre 1980 à New York"@fr .
```

### Base

```markdown
---
base: http://other-example.org/
---

- [John](1)
- [Paul](2)
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://other-example.org/1> rdfs:label "John" .

<http://other-example.org/2> rdfs:label "Paul" .
```

### Vocabulary

```markdown
---
vocab: https://schema.org/
---

- Imagine
  - a
    - CreativeWork
  - creator
    - John
      - a
        - Person
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

[] a schema:CreativeWork ;
  rdfs:label "Imagine" ;
  schema:creator [
    a schema:Person ;
    rdfs:label "John"
  ] .
```

### Metadata

```markdown
---
frontmatter-metadata: true
graph-name: example.md
---

- John
```

```turtle
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcmitype: <http://purl.org/dc/dcmitype/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

{
  <http://example.org/example.md> dc:format "text/markdown" ;
      dc:type dcmitype:Dataset .
}

<http://example.org/example.md> {
  [] rdfs:label "John" .
}
```

### Autotype

```markdown
---
autotype: true
---

- John
  - date of birth
    - > 1940-10-09
```

```turtle
@prefix : <http://example.org/terms/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

[] rdfs:label "John" ;
  :date_of_birth "1940-10-09"^^xsd:date .
```
