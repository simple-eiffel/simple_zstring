<p align="center">
  <img src="docs/images/logo.png" alt="simple_zstring logo" width="200">
</p>

<h1 align="center">simple_zstring</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_zstring/">Documentation</a> •
  <a href="https://github.com/simple-eiffel/simple_zstring">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

**Memory-efficient Unicode string library with dual-storage architecture** — Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 11 classes
- **373 tests total**
  - 191 internal (DBC contract assertions)
  - 182 external (AutoTest unit tests)

## Overview

SIMPLE_ZSTRING provides memory-efficient Unicode string handling using a dual-storage architecture. Inspired by the ZSTRING implementation in [Eiffel-Loop](https://github.com/finnianr/Eiffel-Loop). Characters are stored in an 8-bit primary area using ISO-8859-15 (Latin-9) encoding, with Unicode characters outside the codec range stored in a compact secondary area.

This approach provides ~70% memory savings for Western European text while supporting the full Unicode range including emoji and CJK characters. The library includes utilities for splitting, searching, escaping, formatting, and fluent string building.

## Quick Start

```eiffel
local
    z: SIMPLE_ZSTRING
do
    create z.make_from_string ("Hello World")
    create z.make_from_utf_8 ("Bonjour le monde")
    z.append_character ((0x1F600).to_character_32)  -- Emoji
    print (z.to_string_32)
    print (z.to_utf_8)
end
```

## API Reference

### SIMPLE_ZSTRING

| Feature | Description |
|---------|-------------|
| `make (n)` | Create with capacity for n characters |
| `make_empty` | Create empty string |
| `make_from_string (s)` | Create from general string |
| `make_from_utf_8 (s)` | Create from UTF-8 bytes |
| `item (i)` | Character at position i |
| `put (c, i)` | Replace character at position i |
| `append_character (c)` | Append character at end |
| `insert_character (c, i)` | Insert character at position i |
| `remove (i)` | Remove character at position i |
| `substring (s, e)` | Extract substring from s to e |
| `to_string_32` | Convert to full Unicode STRING_32 |
| `to_utf_8` | Convert to UTF-8 encoded STRING_8 |
| `is_ascii` | True if all characters are ASCII |
| `has_mixed_encoding` | True if contains unencoded characters |

### SIMPLE_ZSTRING_SPLITTER

| Feature | Description |
|---------|-------------|
| `split_by_character (s, c)` | Split string by character |
| `split_by_string (s, sep)` | Split by string separator |
| `split_lines (s)` | Split into lines |
| `split_words (s)` | Split into words |

### SIMPLE_ZSTRING_SEARCHER

| Feature | Description |
|---------|-------------|
| `index_of (s, pat, start)` | Find pattern starting at position |
| `occurrence_count (s, pat)` | Count occurrences of pattern |
| `matches_wildcard (s, pat)` | Match with * and ? wildcards |
| `starts_with (s, prefix)` | Check prefix |
| `ends_with (s, suffix)` | Check suffix |

### SIMPLE_ZSTRING_ESCAPER

| Feature | Description |
|---------|-------------|
| `escape_xml (s)` | Escape for XML |
| `unescape_xml (s)` | Unescape XML entities |
| `escape_json (s)` | Escape for JSON |
| `unescape_json (s)` | Unescape JSON |
| `url_encode (s)` | URL percent-encoding |
| `url_decode (s)` | URL decoding |

### SIMPLE_ZSTRING_FORMATTER

| Feature | Description |
|---------|-------------|
| `pad_left (s, w, c)` | Pad to width with character on left |
| `pad_right (s, w, c)` | Pad to width with character on right |
| `center (s, w, c)` | Center in field of width |
| `substitute (t, vals)` | Replace ${key} placeholders |
| `join (list, sep)` | Join strings with separator |

### SIMPLE_ZSTRING_BUILDER

| Feature | Description |
|---------|-------------|
| `make` | Create empty builder |
| `append (s)` | Append string (fluent) |
| `append_character (c)` | Append character (fluent) |
| `append_integer (n)` | Append integer (fluent) |
| `append_new_line` | Append newline (fluent) |
| `to_string_32` | Get result as STRING_32 |

## Features

- ✅ Dual-storage architecture (8-bit primary + 32-bit overflow)
- ✅ UTF-8 encoding/decoding
- ✅ ISO-8859-15 codec (Latin-9 with Euro sign)
- ✅ String splitting, searching, escaping
- ✅ Formatting and templates
- ✅ Fluent builder pattern
- ✅ Design by Contract throughout
- ✅ Void-safe
- ✅ SCOOP-compatible

## Installation

### Using as ECF Dependency

Add to your `.ecf` file:

```xml
<library name="simple_zstring" location="$SIMPLE_LIBS/simple_zstring/simple_zstring.ecf"/>
```

### Environment Setup

Set the `SIMPLE_LIBS` environment variable:
```bash
export SIMPLE_LIBS=/path/to/simple/libraries
```

## Dependencies

| Library | Purpose |
|---------|---------|
| EiffelBase | Standard library |
| simple_encoding | Codec foundations |

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
