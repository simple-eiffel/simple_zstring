note
	description: "String formatting and templates"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_FORMATTER

feature -- Padding

	pad_left (a_string: READABLE_STRING_GENERAL; a_width: INTEGER; a_char: CHARACTER_32): STRING_32
			-- Pad `a_string` to `a_width` with `a_char` on left
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
			i: INTEGER
		do
			l_padding := (a_width - a_string.count).max (0)
			create Result.make (a_width)
			from i := 1 until i > l_padding loop
				Result.append_character (a_char)
				i := i + 1
			end
			Result.append_string_general (a_string)
		ensure
			result_exists: Result /= Void
			correct_width: Result.count = a_width.max (a_string.count)
			original_preserved: Result.ends_with_general (a_string)
		end

	pad_right (a_string: READABLE_STRING_GENERAL; a_width: INTEGER; a_char: CHARACTER_32): STRING_32
			-- Pad `a_string` to `a_width` with `a_char` on right
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
			i: INTEGER
		do
			l_padding := (a_width - a_string.count).max (0)
			create Result.make (a_width)
			Result.append_string_general (a_string)
			from i := 1 until i > l_padding loop
				Result.append_character (a_char)
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
			correct_width: Result.count = a_width.max (a_string.count)
			original_preserved: Result.starts_with_general (a_string)
		end

	center (a_string: READABLE_STRING_GENERAL; a_width: INTEGER; a_char: CHARACTER_32): STRING_32
			-- Center `a_string` in field of `a_width`
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_left_pad, l_right_pad: INTEGER
			i: INTEGER
		do
			if a_string.count >= a_width then
				Result := a_string.to_string_32
			else
				l_left_pad := (a_width - a_string.count) // 2
				l_right_pad := a_width - a_string.count - l_left_pad
				create Result.make (a_width)
				from i := 1 until i > l_left_pad loop
					Result.append_character (a_char)
					i := i + 1
				end
				Result.append_string_general (a_string)
				from i := 1 until i > l_right_pad loop
					Result.append_character (a_char)
					i := i + 1
				end
			end
		ensure
			result_exists: Result /= Void
			correct_width: Result.count = a_width.max (a_string.count)
		end

feature -- Template Substitution

	substitute (a_template: READABLE_STRING_GENERAL; a_values: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]): STRING_32
			-- Substitute ${key} placeholders with values
		require
			template_exists: a_template /= Void
			values_exist: a_values /= Void
		local
			l_pos, l_end: INTEGER
			l_key: STRING_32
		do
			create Result.make (a_template.count)
			from l_pos := 1 until l_pos > a_template.count loop
				if l_pos + 1 <= a_template.count and then
				   a_template [l_pos] = '$' and then a_template [l_pos + 1] = '{' then
					l_end := a_template.index_of ('}', l_pos + 2)
					if l_end > 0 then
						l_key := a_template.substring (l_pos + 2, l_end - 1).to_string_32
						if a_values.has (l_key) and then attached a_values [l_key] as l_val then
							Result.append_string_general (l_val)
						else
							Result.append_string_general (a_template.substring (l_pos, l_end))
						end
						l_pos := l_end + 1
					else
						Result.append_character (a_template [l_pos])
						l_pos := l_pos + 1
					end
				else
					Result.append_character (a_template [l_pos])
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

	substitute_indexed (a_template: READABLE_STRING_GENERAL; a_values: ARRAY [READABLE_STRING_GENERAL]): STRING_32
			-- Substitute $1, $2, etc. with values
		require
			template_exists: a_template /= Void
			values_exist: a_values /= Void
		local
			l_pos: INTEGER
			l_digit: INTEGER
		do
			create Result.make (a_template.count)
			from l_pos := 1 until l_pos > a_template.count loop
				if a_template [l_pos] = '$' and l_pos < a_template.count and then
				   a_template [l_pos + 1].is_digit then
					l_digit := a_template [l_pos + 1].code - ('0').code
					if l_digit >= a_values.lower and l_digit <= a_values.upper then
						Result.append_string_general (a_values [l_digit])
					end
					l_pos := l_pos + 2
				else
					Result.append_character (a_template [l_pos])
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Number Formatting

	format_integer (a_value: INTEGER_64; a_width: INTEGER): STRING_32
			-- Format integer with leading zeros (negative numbers not padded)
		require
			positive_width: a_width >= 0
		do
			Result := a_value.out.to_string_32
			if a_value >= 0 and Result.count < a_width then
				Result := pad_left (Result, a_width, '0')
			end
		ensure
			result_exists: Result /= Void
		end

	format_decimal (a_value: REAL_64; a_decimals: INTEGER): STRING_32
			-- Format decimal with fixed decimal places
		require
			non_negative_decimals: a_decimals >= 0
		local
			l_multiplier: REAL_64
			l_int_part: INTEGER_64
			l_frac_part: INTEGER_64
			l_frac_str: STRING_32
		do
			l_multiplier := (10 ^ a_decimals).truncated_to_real
			l_int_part := a_value.truncated_to_integer_64
			l_frac_part := ((a_value - l_int_part).abs * l_multiplier).rounded

			create Result.make (20)
			Result.append_string_general (l_int_part.out)
			if a_decimals > 0 then
				Result.append_character ('.')
				l_frac_str := l_frac_part.out.to_string_32
				Result.append_string (pad_left (l_frac_str, a_decimals, '0'))
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Wrapping

	word_wrap (a_string: READABLE_STRING_GENERAL; a_width: INTEGER): ARRAYED_LIST [STRING_32]
			-- Wrap text at word boundaries
		require
			string_exists: a_string /= Void
			positive_width: a_width > 0
		local
			l_words: ARRAYED_LIST [STRING_32]
			l_line: STRING_32
			l_splitter: SIMPLE_ZSTRING_SPLITTER
		do
			create l_splitter
			l_words := l_splitter.split_words (a_string)
			create Result.make (10)
			create l_line.make (a_width)

			across l_words as ic loop
				if l_line.is_empty then
					l_line.append (ic)
				elseif l_line.count + 1 + ic.count <= a_width then
					l_line.append_character (' ')
					l_line.append (ic)
				else
					Result.extend (l_line.twin)
					create l_line.make (a_width)
					l_line.append (ic)
				end
			end

			if not l_line.is_empty then
				Result.extend (l_line)
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Joining

	join (a_strings: ITERABLE [READABLE_STRING_GENERAL]; a_separator: READABLE_STRING_GENERAL): STRING_32
			-- Join strings with separator
		require
			strings_exist: a_strings /= Void
			separator_exists: a_separator /= Void
		local
			l_first: BOOLEAN
		do
			create Result.make (100)
			l_first := True
			across a_strings as ic loop
				if l_first then
					l_first := False
				else
					Result.append_string_general (a_separator)
				end
				Result.append_string_general (ic)
			end
		ensure
			result_exists: Result /= Void
		end

end
