# S02-CLASS-CATALOG.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Class Hierarchy

```
ANY
  COMPARABLE
    ITERABLE [CHARACTER_32]
      SIMPLE_ZSTRING           -- Main string class

  SIMPLE_ZSTRING_BUILDER       -- Fluent builder
  SIMPLE_ZSTRING_FORMATTER     -- Formatting utilities
  SIMPLE_ZSTRING_EDITOR        -- In-place editing
  SIMPLE_ZSTRING_ESCAPER       -- Context escaping
  SIMPLE_ZSTRING_SPLITTER      -- String splitting
  SIMPLE_ZSTRING_SEARCHER      -- Pattern matching

  SIMPLE_ZCODEC                -- Base codec
    SIMPLE_ISO_8859_15_ZCODEC  -- Default codec

  SIMPLE_COMPACT_SUBSTRINGS_32 -- Unicode overflow

  ITERATION_CURSOR [CHARACTER_32]
    SIMPLE_ZSTRING_CURSOR      -- String iteration
```

### Class Descriptions

| Class | Responsibility | Key Collaborators |
|-------|----------------|-------------------|
| SIMPLE_ZSTRING | Unicode string with dual storage | SIMPLE_ZCODEC, SIMPLE_COMPACT_SUBSTRINGS_32 |
| SIMPLE_ZSTRING_BUILDER | Fluent string construction | STRING_32 (internal buffer) |
| SIMPLE_ZSTRING_FORMATTER | Padding, templates, wrapping | SIMPLE_ZSTRING_SPLITTER |
| SIMPLE_ZSTRING_EDITOR | Trim, replace, case conversion | - |
| SIMPLE_ZSTRING_ESCAPER | XML/JSON/URL/CSV/shell escaping | - |
| SIMPLE_ZSTRING_SPLITTER | Split by char, string, lines | - |
| SIMPLE_ZSTRING_SEARCHER | Find, match patterns | - |
| SIMPLE_ZCODEC | Encode/decode characters | - |
| SIMPLE_ISO_8859_15_ZCODEC | Latin-9 encoding | SIMPLE_ZCODEC |
| SIMPLE_COMPACT_SUBSTRINGS_32 | Store non-codec characters | HASH_TABLE |
| SIMPLE_ZSTRING_CURSOR | Iterate over ZSTRING | SIMPLE_ZSTRING |

### Creation Procedures

| Class | Creators |
|-------|----------|
| SIMPLE_ZSTRING | make, make_empty, make_from_string, make_from_string_8, make_from_utf_8 |
| SIMPLE_ZSTRING_BUILDER | make, make_with_capacity |
| SIMPLE_ZSTRING_FORMATTER | (default_create) |
| SIMPLE_ZSTRING_EDITOR | (default_create) |
| SIMPLE_ZSTRING_ESCAPER | (default_create) |
| SIMPLE_ZSTRING_SPLITTER | (default_create) |
| SIMPLE_ZSTRING_SEARCHER | (default_create) |
| SIMPLE_ZCODEC | (deferred) |
| SIMPLE_ISO_8859_15_ZCODEC | (default_create) |
| SIMPLE_COMPACT_SUBSTRINGS_32 | make |
| SIMPLE_ZSTRING_CURSOR | make |
