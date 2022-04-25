# URIs

**mdul-json** creates URIs for documents as well as headings and sub-headings. When URLs are encountered in headings, `schema:sameAs` relations are created.

Bold and italics are permitted in heading labels.

## Document

The file represents a named graph and a subject.

```text
.
└── Dracula.md
```

```turtle
@base <http://www.example.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

<dracula.md> {
    <dracula.md> rdf:type schema:Dataset ;
        rdfs:label "Dracula.md" ;
        schema:about <dracula> .
}
```

## Heading 1

The Heading 1 annotates the graph subject with extra details, such as label, location and class.

```text
.
└── Dracula.md
```

```markdown
# Dracula
```

```turtle
@base <http://www.example.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

<dracula.md> {
    <dracula.md> rdf:type schema:Dataset ;
        rdfs:label "Dracula.md" ;
        schema:about <dracula> .

    <dracula> rdfs:label "Dracula" .
}
```

If the heading is a hyperlink, its location is added as a `schema:sameAs` relation:

```markdown
# [Dracula](http://www.wikidata.com/wiki/Q14542 "Book")
```

```turtle
@base <http://www.example.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .
@prefix user: <http://www.example.com/terms/> .

<dracula.md> {
    <dracula.md> rdf:type schema:Dataset ;
        rdfs:label "Dracula.md" ;
        schema:about <dracula> .

    <dracula> rdf:type user:Book ;
        rdfs:label "Dracula" ;
        schema:sameAs <http://www.wikidata.com/wiki/Q14542> .
}
```

## Heading 2+

Sub-headings are `rdfs:seeAlso` relations of the graph subject. Their URIs are created by concatenating the file name with the sub-heading.

```text
.
└── Wuthering Heights.md
```

```markdown
# [Wuthering Heights](https://www.wikidata.org/wiki/Q202975)
## [Cathy](http://www.wikidata.org/wiki/Q2411295)
## Heathcliff
```

```turtle
@base <http://www.example.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .

<wuthering-heights.md> {
    <wuthering-heights.md> rdf:type schema:Dataset ;
        rdfs:label "Wuthering Heights.md" ;
        schema:about <wuthering-heights> .

    <wuthering-heights> rdfs:label "Wuthering Heights" ;
        schema:sameAs <https://www.wikidata.org/wiki/Q202975> ;
        rdfs:seeAlso <wuthering-heights#cathy> , <wuthering-heights#heathcliff> .

    <wuthering-heights#cathy> rdfs:label "Cathy" ;
        schema:sameAs <http://www.wikidata.org/wiki/Q2411295> .

    <wuthering-heights#heathcliff> rdfs:label "Heathcliff" .
}
```
