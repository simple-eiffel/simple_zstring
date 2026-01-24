# 7S-03-SOLUTIONS.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Alternative Solutions Evaluated

| Solution | Pros | Cons |
|----------|------|------|
| STRING_32 only | Full Unicode | Memory overhead |
| STRING_8 only | Compact | No Unicode |
| ICU library | Full features | Heavy FFI |
| Eiffel-Loop ZSTRING | Proven | External dependency |

### Why simple_zstring
1. **Memory Efficiency** - Dual storage minimizes overhead
2. **No Dependencies** - Pure Eiffel implementation
3. **DBC Integration** - Contracts throughout
4. **Ecosystem Fit** - Consistent with simple_* patterns
5. **Feature Rich** - Building, formatting, escaping, splitting, searching

### Architecture Decision
- Inspired by Eiffel-Loop ZSTRING concept
- Simplified implementation for simple_* ecosystem
- Modular design with separate utility classes
- Fluent API where appropriate

### Trade-offs Accepted
- ISO 8859-15 as default (not Unicode-universal)
- No full regex (simple wildcards only)
- Memory overhead for sparse Unicode
- Single-threaded operations
