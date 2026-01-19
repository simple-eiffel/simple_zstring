# simple_zstring Hardening Report

## Date: 2026-01-19

## Summary

Maintenance Xtreme workflow completed with 180 tests (69 main + 111 adversarial).

## Adversarial Test Coverage

### Areas Tested:
1. **ZSTRING Boundary Tests** - Empty strings, single characters, insert/remove at boundaries
2. **UTF-8 Edge Cases** - Empty, ASCII, 2/3/4-byte sequences, mixed encoding
3. **Dual Storage Edge Cases** - Unencoded character insertion, removal, replacement, position shifting
4. **Splitter Edge Cases** - Empty strings, no separators, separators at start/end, all separators
5. **Searcher Edge Cases** - Empty strings, empty patterns, pattern longer than string, wildcards
6. **Escaper Edge Cases** - Empty strings, no special characters, CSV, shell escaping
7. **Formatter Edge Cases** - Padding wider strings, centering, empty templates, negative numbers

## Bugs Found and Fixed

### Bug 1: search_empty_pattern
- **Location**: `SIMPLE_ZSTRING_SEARCHER.index_of`
- **Issue**: Searching for empty pattern returned non-zero (delegated to substring_index)
- **Fix**: Added early return of 0 when pattern is empty
- **Code change**:
```eiffel
if a_string.is_empty or a_substring.is_empty then
    Result := 0
else
    Result := a_string.substring_index (a_substring, a_start)
end
```

### Bug 2: format_int_negative
- **Location**: `SIMPLE_ZSTRING_FORMATTER.format_integer`
- **Issue**: Padding negative numbers with zeros produced "0-5" instead of "-5"
- **Fix**: Skip zero-padding for negative numbers
- **Code change**:
```eiffel
if a_value >= 0 and Result.count < a_width then
    Result := pad_left (Result, a_width, '0')
end
```

## Defensive Measures in Place

1. **Void Safety**: All classes compile with void_safety=all
2. **SCOOP Compatibility**: Library configured for SCOOP concurrency
3. **Design by Contract**: All public features have preconditions and postconditions
4. **Class Invariants**: SIMPLE_ZSTRING and SIMPLE_COMPACT_SUBSTRINGS_32 have invariants
5. **Boundary Handling**: All index operations validated by preconditions

### Bug 3: is_ascii false positive (Bug Hunting H02)
- **Location**: `SIMPLE_ZSTRING.is_ascii`
- **Issue**: Returned True when string had unencoded characters (substitute markers < 128)
- **Fix**: Added check for `has_mixed_encoding` at the start
- **Code change**:
```eiffel
if has_mixed_encoding then
    Result := False
else
    -- existing byte check
end
```

## Test Results

```
Main Tests:        69 passed, 0 failed
Adversarial Tests: 113 passed, 0 failed
Total:             182 passed, 0 failed
```

## Conclusion

Library hardened and all edge cases handled correctly.
