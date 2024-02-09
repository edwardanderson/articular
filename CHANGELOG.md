# Changelog

## 2.1.0

* Add support for tables

## 2.0.0

* Simply everything

## 0.1.5

### Fixed

* Replaced semantics for `_comment` from `rdfs:comment` to `schema:comment` as range was Literal.
* `Path()` was mangling `@vocab`

## 0.1.4

### Fixed

* Update installation instructions.

## 0.1.3

### Fixed

* Update licence in setup.py.

## 0.1.2

### Fixed

* Fixed bug in Markdown resource URI-ification causing ".md" substring to be replaced when not in end position.

## 0.1.1

### Fixed

* Links to Markdown resources are now URI-ified:
  * `[](location.md)` → `{"id": "location"}`
  * `[](location.md#section)` → `{"id": "location#section"}`
