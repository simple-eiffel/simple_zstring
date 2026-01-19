# simple_zstring

[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![simple-eiffel](https://img.shields.io/badge/simple--eiffel-ecosystem-orange.svg)](https://github.com/simple-eiffel)

Memory-efficient Unicode string library with dual-storage architecture for the Simple Eiffel ecosystem.

## Overview

SIMPLE_ZSTRING provides memory-efficient Unicode string handling using a dual-storage architecture:

- **Primary Storage**: 8-bit characters encoded using ISO-8859-15 (Latin-9)
- **Secondary Storage**: Compact storage for Unicode characters outside the codec range

This approach provides significant memory savings (~70%) for Western European text while supporting the full Unicode range.

## Features

- **Dual-Storage Architecture**: Efficient memory usage for mixed ASCII/Unicode content
- **UTF-8 Support**: Full UTF-8 encoding and decoding
- **ISO-8859-15 Codec**: Latin-9 encoding with Euro sign support
- **String Operations**: Splitting, searching, escaping, formatting
- **Design by Contract**: Full preconditions, postconditions, and invariants
- **SCOOP Compatible**: Thread-safe design for concurrent applications
- **Void Safety**: Fully void-safe implementation

## Installation

Add to your ECF file:

```xml
<library name="simple_zstring" location="path/to/simple_zstring/simple_zstring.ecf"/>
```

## Quick Start

```eiffel
local
    z: SIMPLE_ZSTRING
do
    -- Create from string
    create z.make_from_string ("Hello World")

    -- Create from UTF-8
    create z.make_from_utf_8 ("Bonjour le monde")

    -- Append Unicode characters
    z.append_character ((0x1F600).to_character_32)  -- Emoji

    -- Convert back
    print (z.to_string_32)
    print (z.to_utf_8)
end
```

## Classes

| Class | Description |
|-------|-------------|
| `SIMPLE_ZSTRING` | Main dual-storage string class |
| `SIMPLE_ZCODEC` | Abstract character encoding codec |
| `SIMPLE_ISO_8859_15_ZCODEC` | ISO-8859-15 (Latin-9) codec |
| `SIMPLE_COMPACT_SUBSTRINGS_32` | Storage for unencoded characters |
| `SIMPLE_ZSTRING_SPLITTER` | String splitting operations |
| `SIMPLE_ZSTRING_SEARCHER` | String searching and matching |
| `SIMPLE_ZSTRING_ESCAPER` | XML, JSON, URL escaping |
| `SIMPLE_ZSTRING_EDITOR` | In-place string modifications |
| `SIMPLE_ZSTRING_FORMATTER` | Formatting and templates |
| `SIMPLE_ZSTRING_BUILDER` | Fluent string construction |

## Architecture

```
SIMPLE_ZSTRING
    area: SPECIAL [CHARACTER_8]           -- Primary 8-bit storage
    unencoded_area: SIMPLE_COMPACT_SUBSTRINGS_32  -- Unicode overflow
    codec: SIMPLE_ZCODEC                  -- Character encoding
```

Characters are stored in the primary 8-bit area when possible. Characters outside the codec's range are stored in the secondary area with a substitute marker (ASCII 26) in the primary area.

## Dependencies

- EiffelBase
- simple_encoding (for codec foundations)

## Tests

182 tests covering:
- Core ZSTRING operations
- Codec encoding/decoding
- UTF-8 conversion
- Dual-storage edge cases
- All utility classes

```bash
ec -batch -config simple_zstring.ecf -target simple_zstring_tests -c_compile
./EIFGENs/simple_zstring_tests/W_code/simple_zstring.exe
```

## License

MIT License - see LICENSE file for details.

## Part of Simple Eiffel

This library is part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem of production-ready Eiffel libraries.
