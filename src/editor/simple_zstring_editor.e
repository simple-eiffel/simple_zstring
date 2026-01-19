note
	description: "In-place string modifications"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_EDITOR

feature -- Trimming

	trim (a_string: STRING_32)
			-- Remove leading and trailing whitespace in place
		require
			string_exists: a_string /= Void
		do
			trim_left (a_string)
			trim_right (a_string)
		ensure
			no_leading_whitespace: a_string.is_empty or else not is_whitespace (a_string [1])
			no_trailing_whitespace: a_string.is_empty or else not is_whitespace (a_string [a_string.count])
		end

	trim_left (a_string: STRING_32)
			-- Remove leading whitespace in place
		require
			string_exists: a_string /= Void
		local
			l_first_non_ws: INTEGER
		do
			l_first_non_ws := 1
			from until l_first_non_ws > a_string.count or else not is_whitespace (a_string [l_first_non_ws]) loop
				l_first_non_ws := l_first_non_ws + 1
			end
			if l_first_non_ws > 1 then
				a_string.remove_head (l_first_non_ws - 1)
			end
		ensure
			no_leading_whitespace: a_string.is_empty or else not is_whitespace (a_string [1])
		end

	trim_right (a_string: STRING_32)
			-- Remove trailing whitespace in place
		require
			string_exists: a_string /= Void
		local
			l_last_non_ws: INTEGER
		do
			l_last_non_ws := a_string.count
			from until l_last_non_ws < 1 or else not is_whitespace (a_string [l_last_non_ws]) loop
				l_last_non_ws := l_last_non_ws - 1
			end
			if l_last_non_ws < a_string.count then
				a_string.remove_tail (a_string.count - l_last_non_ws)
			end
		ensure
			no_trailing_whitespace: a_string.is_empty or else not is_whitespace (a_string [a_string.count])
		end

	trimmed (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Copy of `a_string` with leading/trailing whitespace removed
		require
			string_exists: a_string /= Void
		do
			Result := a_string.to_string_32
			trim (Result)
		ensure
			result_exists: Result /= Void
		end

feature -- Replacement

	replace_all (a_string: STRING_32; a_old, a_new: READABLE_STRING_GENERAL)
			-- Replace all occurrences of `a_old` with `a_new` in place
		require
			string_exists: a_string /= Void
			old_not_empty: not a_old.is_empty
		local
			l_pos: INTEGER
		do
			from l_pos := a_string.substring_index (a_old, 1)
			until l_pos = 0
			loop
				a_string.replace_substring (a_new.to_string_32, l_pos, l_pos + a_old.count - 1)
				l_pos := a_string.substring_index (a_old, l_pos + a_new.count)
			end
		end

	replace_first (a_string: STRING_32; a_old, a_new: READABLE_STRING_GENERAL)
			-- Replace first occurrence of `a_old` with `a_new`
		require
			string_exists: a_string /= Void
			old_not_empty: not a_old.is_empty
		local
			l_pos: INTEGER
		do
			l_pos := a_string.substring_index (a_old, 1)
			if l_pos > 0 then
				a_string.replace_substring (a_new.to_string_32, l_pos, l_pos + a_old.count - 1)
			end
		end

	replaced_all (a_string: READABLE_STRING_GENERAL; a_old, a_new: READABLE_STRING_GENERAL): STRING_32
			-- Copy of `a_string` with all `a_old` replaced by `a_new`
		require
			string_exists: a_string /= Void
			old_not_empty: not a_old.is_empty
		do
			Result := a_string.to_string_32
			replace_all (Result, a_old, a_new)
		ensure
			result_exists: Result /= Void
		end

feature -- Case Conversion

	to_upper (a_string: STRING_32)
			-- Convert to uppercase in place
		require
			string_exists: a_string /= Void
		do
			a_string.to_upper
		end

	to_lower (a_string: STRING_32)
			-- Convert to lowercase in place
		require
			string_exists: a_string /= Void
		do
			a_string.to_lower
		end

	to_title_case (a_string: STRING_32)
			-- Convert to title case in place (capitalize first letter of each word)
		require
			string_exists: a_string /= Void
		local
			l_capitalize_next: BOOLEAN
			i: INTEGER
		do
			l_capitalize_next := True
			from i := 1 until i > a_string.count loop
				if is_whitespace (a_string [i]) then
					l_capitalize_next := True
				elseif l_capitalize_next then
					a_string.put (a_string [i].upper, i)
					l_capitalize_next := False
				else
					a_string.put (a_string [i].lower, i)
				end
				i := i + 1
			end
		end

	as_upper (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Uppercase copy of `a_string`
		require
			string_exists: a_string /= Void
		do
			Result := a_string.to_string_32
			to_upper (Result)
		ensure
			result_exists: Result /= Void
		end

	as_lower (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Lowercase copy of `a_string`
		require
			string_exists: a_string /= Void
		do
			Result := a_string.to_string_32
			to_lower (Result)
		ensure
			result_exists: Result /= Void
		end

feature -- Removal

	remove_all (a_string: STRING_32; a_char: CHARACTER_32)
			-- Remove all occurrences of `a_char`
		require
			string_exists: a_string /= Void
		local
			l_pos: INTEGER
		do
			from l_pos := a_string.index_of (a_char, 1)
			until l_pos = 0
			loop
				a_string.remove (l_pos)
				l_pos := a_string.index_of (a_char, l_pos)
			end
		ensure
			no_char: not a_string.has (a_char)
		end

	remove_substring_all (a_string: STRING_32; a_substring: READABLE_STRING_GENERAL)
			-- Remove all occurrences of `a_substring`
		require
			string_exists: a_string /= Void
			substring_not_empty: not a_substring.is_empty
		do
			replace_all (a_string, a_substring, "")
		end

feature -- Padding

	pad_left (a_string: STRING_32; a_width: INTEGER; a_char: CHARACTER_32)
			-- Pad `a_string` to `a_width` with `a_char` on left, in place
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
			i: INTEGER
		do
			l_padding := a_width - a_string.count
			if l_padding > 0 then
				from i := 1 until i > l_padding loop
					a_string.prepend_character (a_char)
					i := i + 1
				end
			end
		ensure
			at_least_width: a_string.count >= a_width
		end

	pad_right (a_string: STRING_32; a_width: INTEGER; a_char: CHARACTER_32)
			-- Pad `a_string` to `a_width` with `a_char` on right, in place
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
			i: INTEGER
		do
			l_padding := a_width - a_string.count
			if l_padding > 0 then
				from i := 1 until i > l_padding loop
					a_string.append_character (a_char)
					i := i + 1
				end
			end
		ensure
			at_least_width: a_string.count >= a_width
		end

feature {NONE} -- Implementation

	is_whitespace (c: CHARACTER_32): BOOLEAN
			-- Is `c` a whitespace character?
		do
			Result := c = ' ' or c = '%T' or c = '%N' or c = '%R'
		end

end
