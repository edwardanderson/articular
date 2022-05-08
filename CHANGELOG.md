# Change Log

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
