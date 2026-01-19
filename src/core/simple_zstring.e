note
	description: "Memory-efficient Unicode string with dual-storage architecture"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING

inherit
	COMPARABLE
		redefine
			is_equal
		end

	ITERABLE [CHARACTER_32]
		undefine
			is_equal
		end

create
	make, make_empty, make_from_string, make_from_string_8, make_from_utf_8

feature {NONE} -- Initialization

	make (a_capacity: INTEGER)
			-- Create with capacity for `a_capacity` characters
		require
			non_negative: a_capacity >= 0
		do
			create area.make_filled ('%U', a_capacity)
			count := 0
		ensure
			capacity_set: capacity >= a_capacity
			empty: count = 0
		end

	make_empty
			-- Create empty string
		do
			make (0)
		ensure
			empty: is_empty
		end

	make_from_string (a_string: READABLE_STRING_GENERAL)
			-- Create from general string
		require
			string_exists: a_string /= Void
		do
			make (a_string.count)
			append_string_general (a_string)
		ensure
			count_set: count = a_string.count
		end

	make_from_string_8 (a_string: READABLE_STRING_8)
			-- Create from STRING_8 (assumes codec-compatible)
		require
			string_exists: a_string /= Void
		do
			make (a_string.count)
			append_string_8 (a_string)
		ensure
			count_set: count = a_string.count
		end

	make_from_utf_8 (a_utf8: READABLE_STRING_8)
			-- Create from UTF-8 encoded bytes
		require
			utf8_exists: a_utf8 /= Void
		do
			make (a_utf8.count)
			append_utf_8 (a_utf8)
		end

feature -- Access

	item alias "[]" (i: INTEGER): CHARACTER_32
			-- Character at position `i`
		require
			valid_index: valid_index (i)
		local
			l_code: NATURAL_8
		do
			l_code := area [i - 1].code.to_natural_8
			if l_code = Substitute_code then
				if attached unencoded_area as l_unenc and then l_unenc.has (i) then
					Result := l_unenc.item (i)
				else
					Result := Substitute
				end
			elseif l_code < 128 then
				Result := l_code.to_character_32
			else
				Result := codec.decoded_character (area [i - 1])
			end
		end

	z_code (i: INTEGER): NATURAL_32
			-- Hybrid code at position `i`
		require
			valid_index: valid_index (i)
		do
			Result := item (i).natural_32_code
		end

feature -- Measurement

	count: INTEGER
			-- Number of characters

	capacity: INTEGER
			-- Available space
		do
			Result := area.count
		end

	utf_8_byte_count: INTEGER
			-- Number of bytes needed for UTF-8 encoding
		local
			i: INTEGER
			l_code: NATURAL_32
		do
			from i := 1 until i > count loop
				l_code := item (i).natural_32_code
				if l_code <= 0x7F then
					Result := Result + 1
				elseif l_code <= 0x7FF then
					Result := Result + 2
				elseif l_code <= 0xFFFF then
					Result := Result + 3
				else
					Result := Result + 4
				end
				i := i + 1
			end
		ensure
			at_least_count: Result >= count
		end

feature -- Status Query

	is_empty: BOOLEAN
			-- Is string empty?
		do
			Result := count = 0
		ensure
			definition: Result = (count = 0)
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i` a valid index?
		do
			Result := i >= 1 and i <= count
		end

	has_mixed_encoding: BOOLEAN
			-- Does string contain characters outside codec range?
		do
			Result := attached unencoded_area as l_unenc and then not l_unenc.is_empty
		end

	is_ascii: BOOLEAN
			-- Are all characters ASCII (0-127)?
		local
			i: INTEGER
		do
			if has_mixed_encoding then
				-- Unencoded characters cannot be ASCII
				Result := False
			else
				Result := True
				from i := 0 until i >= count or not Result loop
					Result := area [i].code < 128
					i := i + 1
				end
			end
		end

	is_valid_as_string_8: BOOLEAN
			-- Can be converted to STRING_8 without data loss?
		do
			Result := not has_mixed_encoding
		end

feature -- Element Change

	put (a_char: CHARACTER_32; i: INTEGER)
			-- Replace character at position `i` with `a_char`
		require
			valid_index: valid_index (i)
		local
			l_encoded: CHARACTER_8
		do
			l_encoded := codec.encoded_character (a_char)
			if l_encoded = Substitute and then a_char /= Substitute then
				-- Character not encodable, store in unencoded area
				ensure_unencoded_area
				check attached unencoded_area as l_unenc then
					l_unenc.put (a_char, i)
				end
				area [i - 1] := Substitute
			else
				area [i - 1] := l_encoded
				-- Remove from unencoded if it was there
				if attached unencoded_area as l_unenc then
					l_unenc.remove (i)
				end
			end
		ensure
			character_set: item (i) = a_char
		end

	append_character (a_char: CHARACTER_32)
			-- Append `a_char` at end
		local
			l_encoded: CHARACTER_8
		do
			grow_if_needed (count + 1)
			count := count + 1
			l_encoded := codec.encoded_character (a_char)
			if l_encoded = Substitute and then a_char /= Substitute then
				ensure_unencoded_area
				check attached unencoded_area as l_unenc then
					l_unenc.put (a_char, count)
				end
				area [count - 1] := Substitute
			else
				area [count - 1] := l_encoded
			end
		ensure
			count_increased: count = old count + 1
			character_appended: item (count) = a_char
		end

	append_string_general (a_string: READABLE_STRING_GENERAL)
			-- Append `a_string`
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
		do
			grow_if_needed (count + a_string.count)
			from i := 1 until i > a_string.count loop
				append_character (a_string [i])
				i := i + 1
			end
		ensure
			count_increased: count = old count + a_string.count
		end

	append_string_8 (a_string: READABLE_STRING_8)
			-- Append STRING_8 (optimized path for ASCII/codec chars)
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
		do
			grow_if_needed (count + a_string.count)
			from i := 1 until i > a_string.count loop
				area [count] := a_string [i]
				count := count + 1
				i := i + 1
			end
		ensure
			count_increased: count = old count + a_string.count
		end

	append_utf_8 (a_utf8: READABLE_STRING_8)
			-- Append UTF-8 encoded bytes
		require
			utf8_exists: a_utf8 /= Void
		local
			i, n: INTEGER
			l_byte: NATURAL_8
			l_code: NATURAL_32
		do
			n := a_utf8.count
			from i := 1 until i > n loop
				l_byte := a_utf8 [i].code.to_natural_8
				if l_byte <= 0x7F then
					-- Single byte (ASCII)
					append_character (l_byte.to_character_32)
					i := i + 1
				elseif (l_byte & 0xE0) = 0xC0 then
					-- 2-byte sequence
					l_code := (l_byte & 0x1F).to_natural_32
					if i + 1 <= n then
						l_code := (l_code |<< 6) | (a_utf8 [i + 1].code.to_natural_8 & 0x3F).to_natural_32
					end
					append_character (l_code.to_character_32)
					i := i + 2
				elseif (l_byte & 0xF0) = 0xE0 then
					-- 3-byte sequence
					l_code := (l_byte & 0x0F).to_natural_32
					if i + 2 <= n then
						l_code := (l_code |<< 6) | (a_utf8 [i + 1].code.to_natural_8 & 0x3F).to_natural_32
						l_code := (l_code |<< 6) | (a_utf8 [i + 2].code.to_natural_8 & 0x3F).to_natural_32
					end
					append_character (l_code.to_character_32)
					i := i + 3
				elseif (l_byte & 0xF8) = 0xF0 then
					-- 4-byte sequence
					l_code := (l_byte & 0x07).to_natural_32
					if i + 3 <= n then
						l_code := (l_code |<< 6) | (a_utf8 [i + 1].code.to_natural_8 & 0x3F).to_natural_32
						l_code := (l_code |<< 6) | (a_utf8 [i + 2].code.to_natural_8 & 0x3F).to_natural_32
						l_code := (l_code |<< 6) | (a_utf8 [i + 3].code.to_natural_8 & 0x3F).to_natural_32
					end
					append_character (l_code.to_character_32)
					i := i + 4
				else
					-- Invalid UTF-8, skip byte
					i := i + 1
				end
			end
		end

	prepend_character (a_char: CHARACTER_32)
			-- Insert `a_char` at beginning
		do
			insert_character (a_char, 1)
		ensure
			count_increased: count = old count + 1
			character_prepended: item (1) = a_char
		end

	insert_character (a_char: CHARACTER_32; i: INTEGER)
			-- Insert `a_char` at position `i`
		require
			valid_position: i >= 1 and i <= count + 1
		local
			j: INTEGER
		do
			grow_if_needed (count + 1)
			-- Shift existing characters
			from j := count until j < i loop
				area [j] := area [j - 1]
				j := j - 1
			end
			if attached unencoded_area as l_unenc then
				l_unenc.shift_from (i, 1)
			end
			count := count + 1
			put (a_char, i)
		ensure
			count_increased: count = old count + 1
			character_inserted: item (i) = a_char
		end

feature -- Removal

	remove (i: INTEGER)
			-- Remove character at position `i`
		require
			valid_index: valid_index (i)
		local
			j: INTEGER
		do
			from j := i until j >= count loop
				area [j - 1] := area [j]
				j := j + 1
			end
			if attached unencoded_area as l_unenc then
				l_unenc.remove (i)
				l_unenc.shift_from (i + 1, -1)
			end
			count := count - 1
		ensure
			count_decreased: count = old count - 1
		end

	wipe_out
			-- Clear string
		do
			count := 0
			if attached unencoded_area as l_unenc then
				l_unenc.wipe_out
			end
		ensure
			empty: is_empty
		end

feature -- Conversion

	to_string_32: STRING_32
			-- Full Unicode string
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result.append_character (item (i))
				i := i + 1
			end
		ensure
			same_count: Result.count = count
		end

	to_string_8: STRING_8
			-- Convert to STRING_8 (only if no mixed encoding)
		require
			valid: is_valid_as_string_8
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 0 until i >= count loop
				Result.append_character (area [i])
				i := i + 1
			end
		ensure
			same_count: Result.count = count
		end

	to_utf_8: STRING_8
			-- UTF-8 encoded bytes
		local
			i: INTEGER
			l_code: NATURAL_32
		do
			create Result.make (utf_8_byte_count)
			from i := 1 until i > count loop
				l_code := item (i).natural_32_code
				if l_code <= 0x7F then
					Result.append_character (l_code.to_character_8)
				elseif l_code <= 0x7FF then
					Result.append_character ((0xC0 | (l_code |>> 6)).to_character_8)
					Result.append_character ((0x80 | (l_code & 0x3F)).to_character_8)
				elseif l_code <= 0xFFFF then
					Result.append_character ((0xE0 | (l_code |>> 12)).to_character_8)
					Result.append_character ((0x80 | ((l_code |>> 6) & 0x3F)).to_character_8)
					Result.append_character ((0x80 | (l_code & 0x3F)).to_character_8)
				else
					Result.append_character ((0xF0 | (l_code |>> 18)).to_character_8)
					Result.append_character ((0x80 | ((l_code |>> 12) & 0x3F)).to_character_8)
					Result.append_character ((0x80 | ((l_code |>> 6) & 0x3F)).to_character_8)
					Result.append_character ((0x80 | (l_code & 0x3F)).to_character_8)
				end
				i := i + 1
			end
		end

	as_string_32: STRING_32
			-- Alias for to_string_32
		do
			Result := to_string_32
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Same content?
		local
			i: INTEGER
		do
			if count = other.count then
				Result := True
				from i := 1 until i > count or not Result loop
					Result := item (i) = other.item (i)
					i := i + 1
				end
			end
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Lexicographic comparison
		local
			i, l_min: INTEGER
		do
			l_min := count.min (other.count)
			from i := 1 until i > l_min or Result or item (i) > other.item (i) loop
				Result := item (i) < other.item (i)
				i := i + 1
			end
			if not Result and i > l_min then
				Result := count < other.count
			end
		end

	same_string (other: READABLE_STRING_GENERAL): BOOLEAN
			-- Same content as `other`?
		require
			other_exists: other /= Void
		local
			i: INTEGER
		do
			if count = other.count then
				Result := True
				from i := 1 until i > count or not Result loop
					Result := item (i) = other [i]
					i := i + 1
				end
			end
		end

feature -- Duplication

	copy_of: like Current
			-- Fresh copy
		do
			create Result.make (count)
			Result.append_string_general (to_string_32)
		ensure
			different_object: Result /= Current
		end

	substring (start_index, end_index: INTEGER): like Current
			-- Substring from `start_index` to `end_index`
		require
			valid_start: start_index >= 1
			valid_end: end_index <= count
			valid_range: start_index <= end_index + 1
		local
			i: INTEGER
		do
			create Result.make ((end_index - start_index + 1).max (0))
			from i := start_index until i > end_index loop
				Result.append_character (item (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = (end_index - start_index + 1).max (0)
		end

feature -- Iteration

	new_cursor: ITERATION_CURSOR [CHARACTER_32]
			-- Fresh cursor for iteration
		do
			create {SIMPLE_ZSTRING_CURSOR} Result.make (Current)
		end

feature {SIMPLE_ZSTRING_CURSOR} -- Implementation access

	area: SPECIAL [CHARACTER_8]
			-- Primary 8-bit character storage

feature {NONE} -- Implementation

	unencoded_area: detachable SIMPLE_COMPACT_SUBSTRINGS_32
			-- Secondary storage for non-encodable Unicode characters

	ensure_unencoded_area
			-- Create unencoded_area if not exists
		do
			if unencoded_area = Void then
				create unencoded_area.make
			end
		ensure
			exists: unencoded_area /= Void
		end

	grow_if_needed (n: INTEGER)
			-- Ensure capacity for `n` characters
		local
			l_new_area: like area
		do
			if n > capacity then
				create l_new_area.make_filled ('%U', (n * 3) // 2)
				l_new_area.copy_data (area, 0, 0, count)
				area := l_new_area
			end
		ensure
			sufficient: capacity >= n
		end

	codec: SIMPLE_ZCODEC
			-- Character encoding codec
		do
			Result := shared_codec
		end

	shared_codec: SIMPLE_ZCODEC
			-- Thread-local shared codec
		once
			create {SIMPLE_ISO_8859_15_ZCODEC} Result
		end

	Substitute: CHARACTER_8 = '%/026/'
			-- Marker for unencoded characters

	Substitute_code: NATURAL_8 = 26
			-- Code of substitute character

invariant
	count_non_negative: count >= 0
	count_bounded: count <= capacity
	area_exists: area /= Void

end
