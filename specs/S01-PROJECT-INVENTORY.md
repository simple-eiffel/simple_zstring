# S01-PROJECT-INVENTORY.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Source Files

| File | Path | Purpose |
|------|------|---------|
| simple_zstring.e | src/core/ | Main string class |
| simple_zstring_builder.e | src/format/ | Fluent string builder |
| simple_zstring_formatter.e | src/format/ | Padding, templates |
| simple_zstring_editor.e | src/editor/ | In-place editing |
| simple_zstring_escaper.e | src/editor/ | Context-specific escaping |
| simple_zstring_splitter.e | src/splitter/ | String splitting |
| simple_zstring_searcher.e | src/search/ | Pattern matching |
| simple_zcodec.e | src/codec/ | Base codec |
| simple_iso_8859_15_zcodec.e | src/codec/ | Default codec |
| simple_compact_substrings_32.e | src/internal/ | Unicode overflow storage |
| simple_zstring_cursor.e | src/internal/ | Iteration cursor |

### Test Files

| File | Path | Purpose |
|------|------|---------|
| test_app.e | testing/ | Test application entry |
| lib_tests.e | testing/ | Test suite |

### Configuration Files

| File | Purpose |
|------|---------|
| simple_zstring.ecf | Library ECF |
| simple_zstring_tests.ecf | Test target ECF |

### Dependencies
- EiffelBase only (self-contained)

### Directory Structure
```
simple_zstring/
  src/
    core/
      simple_zstring.e
    format/
      simple_zstring_builder.e
      simple_zstring_formatter.e
    editor/
      simple_zstring_editor.e
      simple_zstring_escaper.e
    splitter/
      simple_zstring_splitter.e
    search/
      simple_zstring_searcher.e
    codec/
      simple_zcodec.e
      simple_iso_8859_15_zcodec.e
    internal/
      simple_compact_substrings_32.e
      simple_zstring_cursor.e
  testing/
    test_app.e
    lib_tests.e
  research/
  specs/
```
