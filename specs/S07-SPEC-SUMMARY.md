# S07-SPEC-SUMMARY.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Executive Summary
simple_zstring provides memory-efficient Unicode string handling for Eiffel applications. It uses a dual-storage architecture (single-byte + Unicode overflow) and offers comprehensive utilities for building, formatting, editing, escaping, splitting, and searching strings.

### Key Capabilities
1. **Efficient Storage** - Dual-storage minimizes memory for ASCII/Latin text
2. **Building** - Fluent API for string construction
3. **Formatting** - Padding, templates, wrapping
4. **Editing** - Trim, replace, case conversion
5. **Escaping** - XML, JSON, URL, CSV, shell
6. **Splitting** - By character, string, lines, words
7. **Searching** - Find, match wildcards, prefix/suffix

### Architecture
```
SIMPLE_ZSTRING (Core)
    |
    +-- area: SPECIAL[CHARACTER_8] (codec-encoded)
    +-- unencoded_area: SIMPLE_COMPACT_SUBSTRINGS_32
    +-- codec: SIMPLE_ZCODEC

Utilities:
  SIMPLE_ZSTRING_BUILDER    -- Construction
  SIMPLE_ZSTRING_FORMATTER  -- Formatting
  SIMPLE_ZSTRING_EDITOR     -- Modification
  SIMPLE_ZSTRING_ESCAPER    -- Escaping
  SIMPLE_ZSTRING_SPLITTER   -- Splitting
  SIMPLE_ZSTRING_SEARCHER   -- Searching
```

### Class Count
- Total: 11 classes
- Core: 1 (SIMPLE_ZSTRING)
- Utilities: 6 (BUILDER, FORMATTER, EDITOR, ESCAPER, SPLITTER, SEARCHER)
- Codec: 2 (ZCODEC, ISO_8859_15)
- Internal: 2 (COMPACT_SUBSTRINGS_32, CURSOR)

### Contract Coverage
- All public features have preconditions
- Fluent methods ensure Result = Current
- Invariants on core class state
- String bounds validated

### Ecosystem Role
- **Foundation library** - no simple_* dependencies
- **Widely used** - by simple_xml, simple_json, others
- **Security critical** - escaping functions prevent injection
