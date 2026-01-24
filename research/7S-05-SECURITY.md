# 7S-05-SECURITY.md

**Date**: 2026-01-23

**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Security Considerations

#### Output Escaping
1. **XML Escaping**
   - `escape_xml` handles < > & " '
   - `unescape_xml` parses entities
   - Numeric references supported
   - PREVENTS: XSS in XML contexts

2. **JSON Escaping**
   - `escape_json` handles quotes, backslash, controls
   - `\uXXXX` for special chars
   - PREVENTS: JSON injection

3. **URL Encoding**
   - `url_encode` percent-encodes unsafe chars
   - `url_decode` reverses
   - UTF-8 encoding for non-ASCII
   - PREVENTS: URL injection

4. **CSV Escaping**
   - RFC 4180 compliant
   - Quote doubling
   - PREVENTS: CSV injection

5. **Shell Escaping**
   - Single-quote wrapping
   - Quote escaping within
   - PREVENTS: Command injection

#### Input Handling
1. **UTF-8 Validation**
   - Invalid sequences skipped
   - No crashes on malformed input

2. **Buffer Overflow**
   - Dynamic sizing via Eiffel SPECIAL
   - No fixed-size buffers

### Recommendations
- Always use appropriate escaper for context
- Validate input encoding where possible
- Use escaper before embedding in output
