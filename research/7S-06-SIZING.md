# 7S-06-SIZING.md

**Date**: 2026-01-23

**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### Code Metrics

| Class | Lines | Features | Complexity |
|-------|-------|----------|------------|
| SIMPLE_ZSTRING | ~595 | 48 | High |
| SIMPLE_ZSTRING_BUILDER | ~225 | 18 | Low |
| SIMPLE_ZSTRING_FORMATTER | ~255 | 12 | Medium |
| SIMPLE_ZSTRING_EDITOR | ~260 | 20 | Medium |
| SIMPLE_ZSTRING_ESCAPER | ~390 | 16 | Medium |
| SIMPLE_ZSTRING_SPLITTER | ~165 | 8 | Low |
| SIMPLE_ZSTRING_SEARCHER | ~205 | 16 | Medium |
| SIMPLE_ZCODEC | ~80 | 6 | Low |
| SIMPLE_ISO_8859_15_ZCODEC | ~150 | 4 | Low |
| SIMPLE_COMPACT_SUBSTRINGS_32 | ~180 | 12 | Medium |
| SIMPLE_ZSTRING_CURSOR | ~60 | 6 | Low |

### Total Estimated
- **Lines of Code**: ~2,565
- **Classes**: 11
- **Features**: ~166

### Memory Characteristics

| Scenario | Memory |
|----------|--------|
| Pure ASCII string | 1 byte/char + overhead |
| Latin-1/ISO-8859-15 | 1 byte/char + overhead |
| Mixed Unicode | 1 byte/char + 4 bytes per non-codec char |
| Full Unicode | 1 byte/char + 4 bytes/char (sparse) |

### Performance Targets
- Append 1M chars: < 500ms
- Search 1M string: < 100ms
- Escape 10K string: < 50ms
- UTF-8 round-trip: < 100ms for 100K chars
