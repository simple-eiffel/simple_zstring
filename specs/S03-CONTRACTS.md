# S03-CONTRACTS.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### SIMPLE_ZSTRING Contracts

```eiffel
make (a_capacity: INTEGER)
  require
    non_negative: a_capacity >= 0
  ensure
    capacity_set: capacity >= a_capacity
    empty: count = 0

item alias "[]" (i: INTEGER): CHARACTER_32
  require
    valid_index: valid_index (i)

put (a_char: CHARACTER_32; i: INTEGER)
  require
    valid_index: valid_index (i)
  ensure
    character_set: item (i) = a_char

append_character (a_char: CHARACTER_32)
  ensure
    count_increased: count = old count + 1
    character_appended: item (count) = a_char

append_string_general (a_string: READABLE_STRING_GENERAL)
  require
    string_exists: a_string /= Void
  ensure
    count_increased: count = old count + a_string.count

substring (start_index, end_index: INTEGER): like Current
  require
    valid_start: start_index >= 1
    valid_end: end_index <= count
    valid_range: start_index <= end_index + 1
  ensure
    correct_count: Result.count = (end_index - start_index + 1).max (0)
```

### SIMPLE_ZSTRING_BUILDER Contracts

```eiffel
append (a_string: READABLE_STRING_GENERAL): like Current
  require
    string_exists: a_string /= Void
  ensure
    chained: Result = Current
    appended: buffer.ends_with_general (a_string)

append_line (a_string: READABLE_STRING_GENERAL): like Current
  require
    string_exists: a_string /= Void
  ensure
    chained: Result = Current
    ends_with_newline: buffer.ends_with ("%N")

to_string_32: STRING_32
  ensure
    result_exists: Result /= Void
    same_content: Result ~ buffer
```

### SIMPLE_ZSTRING_ESCAPER Contracts

```eiffel
escape_xml (a_string: READABLE_STRING_GENERAL): STRING_32
  require
    string_exists: a_string /= Void
  ensure
    result_exists: Result /= Void

escape_json (a_string: READABLE_STRING_GENERAL): STRING_32
  require
    string_exists: a_string /= Void
  ensure
    result_exists: Result /= Void

url_encode (a_string: READABLE_STRING_GENERAL): STRING_8
  require
    string_exists: a_string /= Void
  ensure
    result_exists: Result /= Void

escape_shell_argument (a_string: READABLE_STRING_GENERAL): STRING_32
  require
    string_exists: a_string /= Void
  ensure
    result_exists: Result /= Void
    single_quoted: Result.starts_with ("'") and Result.ends_with ("'")
```

### Class Invariants

```eiffel
SIMPLE_ZSTRING:
  count_non_negative: count >= 0
  count_bounded: count <= capacity
  area_exists: area /= Void

SIMPLE_ZSTRING_BUILDER:
  buffer_exists: buffer /= Void

SIMPLE_ZSTRING_SPLITTER:
  -- No state, stateless utility

SIMPLE_ZSTRING_SEARCHER:
  -- No state, stateless utility
```
