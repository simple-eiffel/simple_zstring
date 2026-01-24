# 7S-02-STANDARDS.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Applicable Standards

1. **Unicode Standard**
   - UTF-8 encoding/decoding
   - UTF-32 code points
   - Basic Multilingual Plane focus

2. **ISO 8859-15** (Latin-9)
   - Default codec for single-byte storage
   - Western European character set
   - Euro sign support

3. **RFC 3986** - URI Encoding
   - Percent-encoding for URLs
   - Reserved/unreserved characters

4. **RFC 4180** - CSV Format
   - Field escaping rules
   - Quote doubling

5. **XML 1.0** - Entity References
   - `&lt;`, `&gt;`, `&amp;`, `&quot;`, `&apos;`
   - Numeric character references

6. **JSON (RFC 8259)** - String Escaping
   - Backslash escapes
   - `\uXXXX` Unicode escapes

### Character Encoding Flow
```
Input (any) -> SIMPLE_ZSTRING (dual storage)
                |
                +-- area: SPECIAL[CHARACTER_8] (codec-encoded)
                |
                +-- unencoded_area: Unicode overflow

Output -> STRING_8 (if ASCII/codec)
       -> STRING_32 (full Unicode)
       -> UTF-8 bytes (for I/O)
```
