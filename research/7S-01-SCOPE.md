# 7S-01-SCOPE.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Problem Domain
Memory-efficient Unicode string handling with comprehensive manipulation operations for Eiffel applications.

### Core Use Cases
1. Store Unicode strings with memory efficiency
2. Build strings efficiently with fluent API
3. Format strings with templates and padding
4. Edit strings in-place (trim, replace, case)
5. Escape/unescape strings for various contexts (XML, JSON, URL, CSV)
6. Split strings by characters, delimiters, lines
7. Search strings with pattern matching

### Target Users
- Eiffel developers needing Unicode support
- Applications with heavy string processing
- XML/JSON/Web applications needing escaping
- Text parsing and manipulation tasks

### Boundaries
- **In Scope**: Unicode storage, building, formatting, editing, escaping, splitting, searching, UTF-8 conversion
- **Out of Scope**: Full regex support, locale-aware sorting, complex collation

### Success Criteria
- Efficient storage for mixed ASCII/Unicode
- Complete escaping for XML, JSON, URL, CSV, shell
- Fluent builder pattern for construction
- Comprehensive search and split operations
