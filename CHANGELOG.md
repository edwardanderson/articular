# Changelog

## 2.7.1

- Create `rdfs:seeAlso` references for images inside block quotes
- Always use `-` list item delimiter in examples
- Fix missing default `@language` on untyped and unstyled blockquotes
- Resources referenced in blockquotes get labels with language tags:
  1. inherited from the language of the blockquote text
  2. according to the document default language
- Improve CLI error handling for unrecognised RDF serialisation syntax

## 2.7.0

- Support glossary sidecar file for external definition lists.
  Example: [glossary.md](examples/features/glossary.md)

## 2.6.0

- Add error reporting to transformation failure

## 2.5.0

- Support ordered lists (as objects only)
- Add input path validation

## 2.4.2

- Fix single class

## 2.4.1

- Fix bad handling of `None` when stripping new line characters from `li` elements

## 2.4.0

- Support definition lists for subjects and objects

## 2.3.0

- Support for typographic conventions like (c)
- Granular detection of `xsd` type when user specifies `date`

## 2.2.1

- Fix failure to map 'a' to `rdf:type` caused by unexpected newline

## 2.2.0

- Add support for named graphs

## 2.1.0

- Add support for tables

## 2.0.0

- Simplify everything

## 0.1.5

### Fixed

- Replaced semantics for `_comment` from `rdfs:comment` to `schema:comment` as range was Literal.
- `Path()` was mangling `@vocab`

## 0.1.4

### Fixed

- Update installation instructions.

## 0.1.3

### Fixed

- Update licence in setup.py.

## 0.1.2

### Fixed

- Fixed bug in Markdown resource URI-ification causing ".md" substring to be replaced when not in end position.

## 0.1.1

### Fixed

- Links to Markdown resources are now URI-ified:
  - `[](location.md)` → `{"id": "location"}`
  - `[](location.md#section)` → `{"id": "location#section"}`
