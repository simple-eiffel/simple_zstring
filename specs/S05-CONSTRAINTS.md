# S05-CONSTRAINTS.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Technical Constraints

1. **Default Codec**
   - ISO 8859-15 (Latin-9)
   - 256 single-byte characters
   - Euro sign support

2. **Unicode Support**
   - Full UTF-32 code points
   - Non-codec chars in overflow area
   - Memory overhead for non-Latin text

3. **String Limits**
   - Max length: INTEGER_32_MAX
   - Practical limit: available memory

4. **Pattern Matching**
   - Simple wildcards: * and ?
   - No regex support
   - Recursive matching

### Dependency Constraints

1. **Self-Contained**
   - No external dependencies
   - Only EiffelBase required

2. **EiffelStudio Version**
   - Requires EiffelStudio 22.05 or later
   - Void-safe mode required

### Performance Constraints

1. **Memory**
   - Dual storage architecture
   - Growth factor 1.5x on resize

2. **Thread Safety**
   - Not thread-safe
   - No SCOOP annotations
   - Shared codec is once-per-thread

3. **Operations**
   - Most operations O(n)
   - Search is O(n*m) naive
   - No Boyer-Moore optimization
