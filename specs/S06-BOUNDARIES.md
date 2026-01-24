# S06-BOUNDARIES.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### API Boundaries

#### Core API (SIMPLE_ZSTRING)
- Creation: `make`, `make_empty`, `make_from_*`
- Access: `item`, `z_code`, `count`, `capacity`
- Status: `is_empty`, `valid_index`, `is_ascii`
- Modification: `put`, `append_*`, `prepend_*`, `insert_*`, `remove`, `wipe_out`
- Conversion: `to_string_32`, `to_string_8`, `to_utf_8`
- Comparison: `is_equal`, `is_less`, `same_string`
- Duplication: `copy_of`, `substring`

#### Utility Classes (Public)
- `SIMPLE_ZSTRING_BUILDER` - Construction
- `SIMPLE_ZSTRING_FORMATTER` - Formatting
- `SIMPLE_ZSTRING_EDITOR` - Editing
- `SIMPLE_ZSTRING_ESCAPER` - Escaping
- `SIMPLE_ZSTRING_SPLITTER` - Splitting
- `SIMPLE_ZSTRING_SEARCHER` - Searching

#### Internal Classes
- `SIMPLE_ZCODEC` - Base codec (may be exposed for extension)
- `SIMPLE_ISO_8859_15_ZCODEC` - Default codec
- `SIMPLE_COMPACT_SUBSTRINGS_32` - Overflow storage
- `SIMPLE_ZSTRING_CURSOR` - Iteration

### Export Policies

```eiffel
SIMPLE_ZSTRING:
  feature {SIMPLE_ZSTRING_CURSOR}
    area  -- For iteration

SIMPLE_COMPACT_SUBSTRINGS_32:
  feature {SIMPLE_ZSTRING}
    -- All features (internal use)

SIMPLE_ZCODEC:
  feature {SIMPLE_ZSTRING}
    encoded_character
    decoded_character
```

### Integration Points

| External System | Integration Method |
|-----------------|-------------------|
| EiffelBase | STRING_8, STRING_32, SPECIAL |
| Other simple_* | Import this library |

### Library Consumers

| Library | Usage |
|---------|-------|
| simple_xml | `escape_xml` for output |
| simple_json | `escape_json` for output |
| simple_html | `escape_xml` for HTML |
| simple_csv | `escape_csv_field` for output |
