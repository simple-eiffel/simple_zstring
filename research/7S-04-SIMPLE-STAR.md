# 7S-04-SIMPLE-STAR.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Dependencies on simple_* Ecosystem

| Library | Purpose | Integration Point |
|---------|---------|-------------------|
| None | Self-contained foundation | - |

### Libraries Depending on simple_zstring

| Library | Usage |
|---------|-------|
| simple_xml | XML escaping |
| simple_json | JSON escaping |
| simple_html | HTML escaping |
| simple_csv | CSV escaping |

### Ecosystem Patterns Followed

1. **Modular Classes** - Separate concerns into utility classes
2. **Fluent API** - Builder returns self for chaining
3. **Functional Style** - Many methods return new strings
4. **In-Place Options** - Editor modifies existing strings

### Class Organization

| Category | Classes |
|----------|---------|
| Core | SIMPLE_ZSTRING |
| Format | SIMPLE_ZSTRING_BUILDER, SIMPLE_ZSTRING_FORMATTER |
| Editor | SIMPLE_ZSTRING_EDITOR, SIMPLE_ZSTRING_ESCAPER |
| Splitter | SIMPLE_ZSTRING_SPLITTER |
| Search | SIMPLE_ZSTRING_SEARCHER |
| Encoding | SIMPLE_ZCODEC, SIMPLE_ISO_8859_15_ZCODEC |
| Internal | SIMPLE_COMPACT_SUBSTRINGS_32, SIMPLE_ZSTRING_CURSOR |

### Foundation Role
simple_zstring is a **foundation library** - it has no simple_* dependencies but is used by many other simple_* libraries for string operations.
