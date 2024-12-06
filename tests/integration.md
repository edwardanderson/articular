# Integration Tests

```markdown
- John
  - knows
    - Paul
```

```markdown
- John
  - [knows](https://schema.org/knows)
    - Paul
    - George
    - Ringo
```

```markdown
- John
  - knows
    - "John"
```

```markdown
- John
  - knows
    - Paul
      - knows
        - John
```

```markdown
- John
  - knows
    - Paul

John
: <http://example.org/1>

knows
: <https://schema.org/knows>

Paul
: <http://example.org/2>
```

```markdown
- John
  - knows
    1. Paul
    2. George
    3. Ringo
```

```markdown
- John
  - name
    - > John Winston Lennon
```

```markdown
- John
  - name
    - > John Winston Lennon `en`
```

```markdown
- John
  - born
    - > 1940-10-09 `date`
```

```markdown
- John
  - born
    - > 1940-10-09 `date`

date
: <http://www.w3.org/2001/XMLSchema#>
```

