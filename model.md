# Data Model

* [Files](#files)
* [Headings](#headings)
* [Sub-headings](#sub-headings)
* [Text](#text)
* [Blockquotes](#blockquotes)
* [Images](#images)
* [Hyperlinks](#hyperlinks)
* [Unordered lists](#unordered-lists)
  * [Literals](#literals)
  * [Anonymous types](#anonymous-types)
  * [Data types](#data-types)
  * [Inverse properties](#inverse-properties)
* [Tables](#tables)
* [Context](#context)
  * [Context JSON](#context-json)
  * [Vocabulary](#vocabulary)
  * [Overriding terms](#overriding-terms)

## Files

Articular creates Linked Data resources identified by URIs. These are created by removing the extension from the Markdown source files.

| File                         | URI                                              |
|------------------------------|--------------------------------------------------|
| `books/wuthering-heights.md` | `http://www.example.com/books/wuthering-heights` |
| `the-beatles.md`             | `http://www.example.com/the-beatles`             |

## Headings

The title heading annotates the resource.

```markdown
# Wuthering Heights
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights"
}
```

Headings and [sub-headings](#sub-headings) can be [hyperlinks](#hyperlinks). These links create [`schema:sameAs`](https://schema.org/sameAs) relationships.

```markdown
# [Wuthering Heights](http://www.wikidata.org/entity/Q202975)
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "_same_as": {
    "id": "http://www.wikidata.org/entity/Q202975",
    "_label": "Wuthering Heights"
  }
}
```

## Sub-headings

Sub-headings are resources identified by [URI fragments](https://en.wikipedia.org/wiki/URI_fragment) appended to the resource URI. Document sections are connected together with [`rdfs:seeAlso`](https://www.w3.org/TR/rdf-schema/#ch_seealso) relations. Sub-headings must be unique strings. They can be nested up to depth `h7`.

When hyperlinks are used in sub-headings, [`schema:sameAs`](https://schema.org/sameAs) relations are created.

```markdown
# Wuthering Heights
## Plot
## [Publication](https://en.wikipedia.org/wiki/Wuthering_Heights#Publication_history "Article")
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "_see_also": [
    {
      "id": "#plot",
      "_label": "Plot"
    },
    {
      "id": "#publication",
      "type": "Article",
      "_label": "Publication",
      "_same_as": {
        "id": "https://en.wikipedia.org/wiki/Wuthering_Heights#Publication_history",
        "type": "Article",
        "_label": "Publication
      }

    }
  ]
}
```

## Text

Paragraph text is encoded as HTML. Hyperlinks create [`schema:mentions`](https://schema.org/mentions) relationships.

```markdown
# Wuthering Heights

**Wuthering Heights** is an 1847 novel by [Emily Brontë](http://www.wikidata.org/entity/Q80137).
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "_comment": {
    "type": "_Comment",
    "_comment": "<p><strong>Wuthering Heights</strong> is an 1847 novel by <href=\"http://www.wikidata.org/entity/Q80137\">Emily Brontë</a>/</p>",
    "_format": "text/html",
    "_mentions": {
      "id": "http://www.wikidata.org/entity/Q80137",
      "_label": "Emily Brontë"
    }
  }
}
```

## Blockquotes

Quoted rich text is encoded as HTML, otherwise it is plain text. Unlike [paragraph text](#text), hyperlinks are not parsed. An [unordered list](#unordered-lists) may be added to attribute the quotation.

```markdown
# Wuthering Heights

> Whatever our souls are made of, his and mine are the same.
>
> * said by
>   * Catherine

```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "_comment": {
    "type": "_Quotation",
    "_comment": "Whatever our souls are made of, his and mine are the same.",
    "said_by": {
      "_label": "Catherine"
    }
  }
}
```

## Images

Images of resources are connected by [`schema:image`](https://schema.org/image) relations to instances of [`schema:ImageObject`](https://schema.org/ImageObject).

```markdown
#  Wuthering Heights

![Title page of the first edition](https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Houghton_Lowell_1238.5_%28A%29_-_Wuthering_Heights%2C_1847.jpg/300px-Houghton_Lowell_1238.5_%28A%29_-_Wuthering_Heights%2C_1847.jpg)
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "_image": {
    "id": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Houghton_Lowell_1238.5_%28A%29_-_Wuthering_Heights%2C_1847.jpg/300px-Houghton_Lowell_1238.5_%28A%29_-_Wuthering_Heights%2C_1847.jpg",
    "type": "_Image",
    "_label": "Title page of the first edition"
  }
}
```

## Hyperlinks

Hyperlinks label, identify and classify resources. Type classifications may be URLs or strings.

```markdown
# [Wuthering Heights](http://www.wikidata.org/entity/Q202975 "Book")
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "type": "Book",
  "_label": "Wuthering Heights"
}
```

## Unordered lists

Use unordered lists to describe a resource with predicate-object pairs. Objects may be:

* Plain text - creating labelled blank nodes
* Hyperlinks - identifying other resources
* Quoted text - creating literals

Predicates may be plain text or hyperlinks.

Lists may be nested.

```markdown
# Wuthering Heights

* author
  * [Emily Brontë](http://www.wikidata.org/entity/Q80137 "Person")
    * sister of
      * Charlotte Brontë
* published in
  * "1847"
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "author": {
    "id": "http://www.wikidata.org/entity/Q80137",
    "type": "Person",
    "_label": "Emily Brontë",
    "sister_of": {
      "_label": "Charlotte Brontë"
    }
  },
  "published_in": "1847"
}
```

### Literals

Literal string values must be wrapped in double quotes.

### Anonymous types

A backtick-wrapped term in the object position creates a blank node.


```markdown
# Wuthering Heights

* publication
  * `PublicationEvent`
    * location
      * United Kingdom
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "publication": {
    "id": "PublicationEvent",
    "location": {
      "_label": "United Kingdom"
    }
  }
}
```

### Data types

Classifying a predicate hyperlink sets the [data type](https://www.w3.org/TR/rdf11-concepts/#section-Datatypes) of the child object.

```markdown
# Wuthering Heights

* [publication date](https://schema.org/datePublished "https://schema.org/Date")
  * "1847"
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "publication_date": {
        "@id": "https://schema.org/datePublished",
        "@type": "https://schema.org/Date"
      },
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "_label": "Wuthering Heights",
  "publication_date": "1847"
}
```

### Inverse properties

Specify that a predicate is an [inverse property](https://www.w3.org/TR/json-ld11/#reverse-properties) by setting its type to `inverse`.

```markdown
# The Beatles

* [members](https://schema.org/memberOf "inverse")
  * [John](#john)
  * [Paul](#paul)
  * [George](#george)
  * [Ringo](#ringo)

## John

## Paul

## George

## Ringo
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "members": {
        "@reverse": "https://schema.org/memberOf"
      },
      "@base": "http://www.example.com/the-beatles#",
      "@vocab": "http:/www.example.com/terms/"
    }
  ],
  "id": "the-beatles",
  "_label": "The Beatles",
  "_see_also": [
    {
      "id": "#john",
      "_label": "John",
      "schema:memberOf": {
        "id": "the-beatles"
      }
    },
    {
      "id": "#paul",
      "_label": "Paul",
      "schema:memberOf": {
        "id": "the-beatles"
      }
    },
    {
      "id": "#george",
      "_label": "George",
      "schema:memberOf": {
        "id": "the-beatles"
      }
    },
    {
      "id": "#ringo",
      "_label": "Ringo",
      "schema:memberOf": {
        "id": "the-beatles"
      }
    }
  ]
}
```

## Tables

Tables are encoded as `text/csv`. **This is liable to change in future releases.** Refer to [Issue #14](https://github.com/edwardanderson/articular/issues/14). Currently, no semantic data is parsed from tables.

## Context

A front matter `context` section may be used to map terms used in the document to other ontologies. Terms containing spaces should be mapped using snake_case. Terms which are not defined in the `context` are expected to be available at the `@base` location.

```markdown
---
context:
  Book: https://schema.org/Book
  written_by: https://schema.org/author
---

# [Wuthering Heights]("Book")

* written by
  * Emily Brontë
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    {
      "Book": "https://schema.org/Book",
      "written_by": "https://schema.org/author",
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "type": "Book",
  "_label": "Wuthering Heights",
  "written_by": {
      "_label": "Emily Brontë"
  }
}
```

### Context JSON

A link to a JSON-LD `@context` document may be used instead of a map.

```markdown
---
context: https://schema.org/docs/jsonldcontext.json
---

# [Wuthering Heights]("Book")
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json",
    "https://schema.org/docs/jsonldcontext.json"
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/books/wuthering-heights#"
    }
  ],
  "id": "wuthering-heights",
  "type": "Book",
  "_label": "Wuthering Heights"
}
```

### Vocabulary

Add a [`"@vocab"`](https://www.w3.org/TR/json-ld11/#default-vocabulary) key to set the document's default vocabulary.

### Overriding terms

Articular terms may be overriden. **Warning: this may have unintended consequences.**

```markdown
---
  context:
    _see_also: https://schema.org/member
---

# The Beatles

## John

## Paul

## George

## Ringo
```

```json
{
  "@context": [
    "https://articular.netlify.app/articular.json"
    {
      "@vocab": "http://www.example.com/terms/",
      "@base": "http://www.example.com/the-beatles#"
    }
  ],
  "id": "the-beatles",
  "_label": "The Beatles",
  "member": [
    {
      "id": "#john",
      "_label": "John"
    },
    {
      "id": "#paul",
      "_label": "Paul"
    },
    {
      "id": "#george",
      "_label": "George"
    },
    {
      "id": "#ringo",
      "_label": "Ringo"
    }
  ]
}
```
