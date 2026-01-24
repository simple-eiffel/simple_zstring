# S04-FEATURE-SPECS.md
**BACKWASH** | Date: 2026-01-23

## Library: simple_zstring

### SIMPLE_ZSTRING Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | (capacity: INTEGER) | Create with capacity |
| make_empty | | Create empty |
| make_from_string | (s: READABLE_STRING_GENERAL) | Create from string |
| make_from_utf_8 | (utf8: READABLE_STRING_8) | Create from UTF-8 |
| item | (i: INTEGER): CHARACTER_32 | Get character |
| z_code | (i: INTEGER): NATURAL_32 | Get code point |
| count | : INTEGER | Character count |
| capacity | : INTEGER | Current capacity |
| utf_8_byte_count | : INTEGER | UTF-8 size needed |
| is_empty | : BOOLEAN | Empty? |
| valid_index | (i: INTEGER): BOOLEAN | Valid index? |
| has_mixed_encoding | : BOOLEAN | Has Unicode overflow? |
| is_ascii | : BOOLEAN | All ASCII? |
| is_valid_as_string_8 | : BOOLEAN | Convertible to STRING_8? |
| put | (char: CHARACTER_32; i: INTEGER) | Set character |
| append_character | (char: CHARACTER_32) | Append char |
| append_string_general | (s: READABLE_STRING_GENERAL) | Append string |
| append_string_8 | (s: READABLE_STRING_8) | Append STRING_8 |
| append_utf_8 | (utf8: READABLE_STRING_8) | Append UTF-8 |
| prepend_character | (char: CHARACTER_32) | Prepend char |
| insert_character | (char: CHARACTER_32; i: INTEGER) | Insert char |
| remove | (i: INTEGER) | Remove char |
| wipe_out | | Clear string |
| to_string_32 | : STRING_32 | Convert to STRING_32 |
| to_string_8 | : STRING_8 | Convert to STRING_8 |
| to_utf_8 | : STRING_8 | Convert to UTF-8 |
| is_equal | (other: like Current): BOOLEAN | Equality |
| is_less | (other: like Current): BOOLEAN | Comparison |
| same_string | (other: READABLE_STRING_GENERAL): BOOLEAN | Content equality |
| copy_of | : like Current | Clone |
| substring | (start, end: INTEGER): like Current | Substring |

### SIMPLE_ZSTRING_BUILDER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | | Create default capacity |
| make_with_capacity | (cap: INTEGER) | Create with capacity |
| append | (s: READABLE_STRING_GENERAL): like Current | Append (fluent) |
| append_character | (c: CHARACTER_32): like Current | Append char (fluent) |
| append_integer | (n: INTEGER_64): like Current | Append int (fluent) |
| append_natural | (n: NATURAL_64): like Current | Append nat (fluent) |
| append_real | (r: REAL_64): like Current | Append real (fluent) |
| append_boolean | (b: BOOLEAN): like Current | Append bool (fluent) |
| append_line | (s: READABLE_STRING_GENERAL): like Current | Append + newline |
| append_new_line | : like Current | Append newline |
| append_tab | : like Current | Append tab |
| append_space | : like Current | Append space |
| append_repeated | (c: CHARACTER_32; n: INTEGER): like Current | Repeat char |
| to_string_32 | : STRING_32 | Get result |
| to_string_8 | : STRING_8 | Get as STRING_8 |
| count | : INTEGER | Current length |
| is_empty | : BOOLEAN | Empty? |
| clear | | Reset builder |

### SIMPLE_ZSTRING_FORMATTER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| pad_left | (s: READABLE_STRING_GENERAL; w: INTEGER; c: CHARACTER_32): STRING_32 | Left pad |
| pad_right | (s: READABLE_STRING_GENERAL; w: INTEGER; c: CHARACTER_32): STRING_32 | Right pad |
| center | (s: READABLE_STRING_GENERAL; w: INTEGER; c: CHARACTER_32): STRING_32 | Center |
| substitute | (template: READABLE_STRING_GENERAL; values: HASH_TABLE[...]): STRING_32 | ${key} substitution |
| substitute_indexed | (template: READABLE_STRING_GENERAL; values: ARRAY[...]): STRING_32 | $1, $2 substitution |
| format_integer | (value: INTEGER_64; width: INTEGER): STRING_32 | Leading zeros |
| format_decimal | (value: REAL_64; decimals: INTEGER): STRING_32 | Fixed decimals |
| word_wrap | (s: READABLE_STRING_GENERAL; width: INTEGER): ARRAYED_LIST[STRING_32] | Wrap text |
| join | (strings: ITERABLE[...]; sep: READABLE_STRING_GENERAL): STRING_32 | Join with separator |

### SIMPLE_ZSTRING_EDITOR Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| trim | (s: STRING_32) | Trim whitespace (in-place) |
| trim_left | (s: STRING_32) | Trim leading (in-place) |
| trim_right | (s: STRING_32) | Trim trailing (in-place) |
| trimmed | (s: READABLE_STRING_GENERAL): STRING_32 | Trimmed copy |
| replace_all | (s: STRING_32; old, new: READABLE_STRING_GENERAL) | Replace all (in-place) |
| replace_first | (s: STRING_32; old, new: READABLE_STRING_GENERAL) | Replace first (in-place) |
| replaced_all | (s, old, new: READABLE_STRING_GENERAL): STRING_32 | Replaced copy |
| to_upper | (s: STRING_32) | Uppercase (in-place) |
| to_lower | (s: STRING_32) | Lowercase (in-place) |
| to_title_case | (s: STRING_32) | Title case (in-place) |
| as_upper | (s: READABLE_STRING_GENERAL): STRING_32 | Uppercase copy |
| as_lower | (s: READABLE_STRING_GENERAL): STRING_32 | Lowercase copy |
| remove_all | (s: STRING_32; c: CHARACTER_32) | Remove all chars |
| remove_substring_all | (s: STRING_32; sub: READABLE_STRING_GENERAL) | Remove all substrings |
| pad_left/right | (s: STRING_32; w: INTEGER; c: CHARACTER_32) | Pad (in-place) |

### SIMPLE_ZSTRING_ESCAPER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| escape_xml | (s: READABLE_STRING_GENERAL): STRING_32 | Escape for XML |
| unescape_xml | (s: READABLE_STRING_GENERAL): STRING_32 | Unescape XML entities |
| escape_json | (s: READABLE_STRING_GENERAL): STRING_32 | Escape for JSON |
| unescape_json | (s: READABLE_STRING_GENERAL): STRING_32 | Unescape JSON |
| escape_csv_field | (s: READABLE_STRING_GENERAL): STRING_32 | Escape for CSV |
| escape_shell_argument | (s: READABLE_STRING_GENERAL): STRING_32 | Escape for shell |
| url_encode | (s: READABLE_STRING_GENERAL): STRING_8 | Percent encode |
| url_decode | (s: READABLE_STRING_8): STRING_32 | Percent decode |

### SIMPLE_ZSTRING_SPLITTER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| split_by_character | (s: READABLE_STRING_GENERAL; sep: CHARACTER_32): ARRAYED_LIST[STRING_32] | Split by char |
| split_by_any_character | (s: READABLE_STRING_GENERAL; seps: READABLE_STRING_GENERAL): ARRAYED_LIST[STRING_32] | Split by any |
| split_by_string | (s, sep: READABLE_STRING_GENERAL): ARRAYED_LIST[STRING_32] | Split by string |
| split_n | (s: READABLE_STRING_GENERAL; sep: CHARACTER_32; n: INTEGER): ARRAYED_LIST[STRING_32] | Limited split |
| split_lines | (s: READABLE_STRING_GENERAL): ARRAYED_LIST[STRING_32] | Split by newlines |
| split_words | (s: READABLE_STRING_GENERAL): ARRAYED_LIST[STRING_32] | Split by whitespace |

### SIMPLE_ZSTRING_SEARCHER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| index_of | (s, sub: READABLE_STRING_GENERAL; start: INTEGER): INTEGER | Find substring |
| last_index_of | (s, sub: READABLE_STRING_GENERAL): INTEGER | Find last |
| all_indices_of | (s, sub: READABLE_STRING_GENERAL): ARRAYED_LIST[INTEGER] | Find all |
| occurrence_count | (s, sub: READABLE_STRING_GENERAL): INTEGER | Count occurrences |
| index_of_case_insensitive | (s, sub: READABLE_STRING_GENERAL; start: INTEGER): INTEGER | Case-insensitive find |
| matches_wildcard | (s, pattern: READABLE_STRING_GENERAL): BOOLEAN | * and ? wildcards |
| contains_any | (s: READABLE_STRING_GENERAL; subs: ITERABLE[...]): BOOLEAN | Contains any? |
| contains_all | (s: READABLE_STRING_GENERAL; subs: ITERABLE[...]): BOOLEAN | Contains all? |
| starts_with | (s, prefix: READABLE_STRING_GENERAL): BOOLEAN | Prefix check |
| ends_with | (s, suffix: READABLE_STRING_GENERAL): BOOLEAN | Suffix check |
| starts_with_case_insensitive | (s, prefix: READABLE_STRING_GENERAL): BOOLEAN | CI prefix |
| ends_with_case_insensitive | (s, suffix: READABLE_STRING_GENERAL): BOOLEAN | CI suffix |
