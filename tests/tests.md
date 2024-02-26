# Tests

- [Tests](#tests)
  - [Label anonymous resources](#label-anonymous-resources)
  - [Identify and label resources locally](#identify-and-label-resources-locally)
  - [Identify and label resources globally](#identify-and-label-resources-globally)


## Label anonymous resources

```markdown
- John
- Paul
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

[] rdfs:label "John" .

[] rdfs:label "Paul" .
```

## Identify and label resources locally

```markdown
- [John](1)
- [Paul](2)
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://example.org/1> rdfs:label "John" .

<http://example.org/2> rdfs:label "Paul" .
```

## Identify and label resources globally

```markdown
- [John](http://www.wikidata.org/entity/Q1203)
- [Paul](http://www.wikidata.org/entity/Q2599)
```

```turtle
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

<http://www.wikidata.org/entity/Q1203> rdfs:label "John" .

<http://www.wikidata.org/entity/Q2599> rdfs:label "Paul" .
```
