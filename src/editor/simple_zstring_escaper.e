note
	description: "Escape and unescape strings for various contexts"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_ESCAPER

feature -- XML Escaping

	escape_xml (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Escape for XML content
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_string.count + 10)
			from i := 1 until i > a_string.count loop
				c := a_string [i]
				inspect c
				when '<' then Result.append_string_general ("&lt;")
				when '>' then Result.append_string_general ("&gt;")
				when '&' then Result.append_string_general ("&amp;")
				when '"' then Result.append_string_general ("&quot;")
				when '%'' then Result.append_string_general ("&apos;")
				else Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	unescape_xml (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Unescape XML entities
		require
			string_exists: a_string /= Void
		local
			l_pos, l_end: INTEGER
			l_entity: STRING_32
		do
			create Result.make (a_string.count)
			from l_pos := 1 until l_pos > a_string.count loop
				if a_string [l_pos] = '&' then
					l_end := a_string.index_of (';', l_pos)
					if l_end > l_pos then
						l_entity := a_string.substring (l_pos + 1, l_end - 1).to_string_32
						Result.append_character (entity_to_character (l_entity))
						l_pos := l_end + 1
					else
						Result.append_character (a_string [l_pos])
						l_pos := l_pos + 1
					end
				else
					Result.append_character (a_string [l_pos])
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature -- JSON Escaping

	escape_json (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Escape for JSON string
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
			c: CHARACTER_32
			l_code: NATURAL_32
		do
			create Result.make (a_string.count + 10)
			from i := 1 until i > a_string.count loop
				c := a_string [i]
				l_code := c.natural_32_code
				inspect c
				when '"' then Result.append_string_general ("\%"")
				when '\' then Result.append_string_general ("\\")
				when '%N' then Result.append_string_general ("\n")
				when '%R' then Result.append_string_general ("\r")
				when '%T' then Result.append_string_general ("\t")
				when '%B' then Result.append_string_general ("\b")
				when '%F' then Result.append_string_general ("\f")
				else
					if l_code < 32 then
						Result.append_string_general ("\u")
						Result.append_string_general (l_code.to_hex_string.as_lower.substring (5, 8))
					else
						Result.append_character (c)
					end
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	unescape_json (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Unescape JSON escape sequences
		require
			string_exists: a_string /= Void
		local
			l_pos: INTEGER
			l_next: CHARACTER_32
		do
			create Result.make (a_string.count)
			from l_pos := 1 until l_pos > a_string.count loop
				if a_string [l_pos] = '\' and l_pos < a_string.count then
					l_next := a_string [l_pos + 1]
					inspect l_next
					when '"' then Result.append_character ('"'); l_pos := l_pos + 2
					when '\' then Result.append_character ('\'); l_pos := l_pos + 2
					when 'n' then Result.append_character ('%N'); l_pos := l_pos + 2
					when 'r' then Result.append_character ('%R'); l_pos := l_pos + 2
					when 't' then Result.append_character ('%T'); l_pos := l_pos + 2
					when 'b' then Result.append_character ('%B'); l_pos := l_pos + 2
					when 'f' then Result.append_character ('%F'); l_pos := l_pos + 2
					when 'u' then
						if l_pos + 5 <= a_string.count then
							Result.append_character (parse_unicode_escape (a_string, l_pos + 2))
							l_pos := l_pos + 6
						else
							Result.append_character ('\')
							l_pos := l_pos + 1
						end
					else
						Result.append_character ('\')
						l_pos := l_pos + 1
					end
				else
					Result.append_character (a_string [l_pos])
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature -- CSV Escaping

	escape_csv_field (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Escape for CSV field (RFC 4180)
		require
			string_exists: a_string /= Void
		local
			l_needs_quotes: BOOLEAN
			i: INTEGER
			c: CHARACTER_32
		do
			l_needs_quotes := a_string.has (',') or a_string.has ('"')
				or a_string.has ('%N') or a_string.has ('%R')

			if l_needs_quotes then
				create Result.make (a_string.count + 10)
				Result.append_character ('"')
				from i := 1 until i > a_string.count loop
					c := a_string [i]
					if c = '"' then
						Result.append_string_general ("%"%"")
					else
						Result.append_character (c)
					end
					i := i + 1
				end
				Result.append_character ('"')
			else
				Result := a_string.to_string_32
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Shell Escaping

	escape_shell_argument (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Escape for shell argument (Unix-style single quotes)
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_string.count + 10)
			Result.append_character ('%'')
			from i := 1 until i > a_string.count loop
				c := a_string [i]
				if c = '%'' then
					Result.append_string_general ("'\'")
					Result.append_character ('%'')
				else
					Result.append_character (c)
				end
				i := i + 1
			end
			Result.append_character ('%'')
		ensure
			result_exists: Result /= Void
			single_quoted: Result.starts_with ("'") and Result.ends_with ("'")
		end

feature -- URL Encoding

	url_encode (a_string: READABLE_STRING_GENERAL): STRING_8
			-- URL-encode (percent encoding)
		require
			string_exists: a_string /= Void
		local
			i: INTEGER
			c: CHARACTER_32
			l_code: NATURAL_32
			l_hex: STRING_8
		do
			create Result.make (a_string.count * 3)
			from i := 1 until i > a_string.count loop
				c := a_string [i]
				l_code := c.natural_32_code
				if is_url_safe (c) then
					Result.append_character (c.to_character_8)
				elseif l_code <= 255 then
					l_hex := l_code.to_hex_string
					Result.append_character ('%%')
					Result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				else
					-- UTF-8 encode then percent-encode each byte
					append_utf8_percent_encoded (Result, l_code)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	url_decode (a_string: READABLE_STRING_8): STRING_32
			-- Decode URL-encoded string
		require
			string_exists: a_string /= Void
		local
			l_pos: INTEGER
			l_hex: STRING_8
			l_code: INTEGER
		do
			create Result.make (a_string.count)
			from l_pos := 1 until l_pos > a_string.count loop
				if a_string [l_pos] = '%%' and l_pos + 2 <= a_string.count then
					l_hex := a_string.substring (l_pos + 1, l_pos + 2).to_string_8
					l_code := hex_to_integer (l_hex)
					Result.append_character (l_code.to_character_32)
					l_pos := l_pos + 3
				elseif a_string [l_pos] = '+' then
					Result.append_character (' ')
					l_pos := l_pos + 1
				else
					Result.append_character (a_string [l_pos].to_character_32)
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

	entity_to_character (a_entity: READABLE_STRING_GENERAL): CHARACTER_32
			-- Convert XML entity name to character
		do
			if a_entity.same_string ("lt") then Result := '<'
			elseif a_entity.same_string ("gt") then Result := '>'
			elseif a_entity.same_string ("amp") then Result := '&'
			elseif a_entity.same_string ("quot") then Result := '"'
			elseif a_entity.same_string ("apos") then Result := '%''
			elseif a_entity.count > 1 and then a_entity [1] = '#' then
				if a_entity.count > 2 and then (a_entity [2] = 'x' or a_entity [2] = 'X') then
					Result := hex_to_integer (a_entity.substring (3, a_entity.count).to_string_8).to_character_32
				else
					Result := a_entity.substring (2, a_entity.count).to_integer.to_character_32
				end
			else
				Result := '?'
			end
		end

	is_url_safe (c: CHARACTER_32): BOOLEAN
			-- Is `c` safe in URL without encoding?
		do
			Result := (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z')
				or (c >= '0' and c <= '9') or c = '-' or c = '_' or c = '.' or c = '~'
		end

	hex_to_integer (a_hex: READABLE_STRING_8): INTEGER
			-- Convert hex string to integer
		local
			i: INTEGER
			l_char: CHARACTER_8
			l_digit: INTEGER
		do
			from i := 1 until i > a_hex.count loop
				l_char := a_hex [i].as_lower
				if l_char >= '0' and l_char <= '9' then
					l_digit := l_char.code - ('0').code
				elseif l_char >= 'a' and l_char <= 'f' then
					l_digit := l_char.code - ('a').code + 10
				else
					l_digit := 0
				end
				Result := Result * 16 + l_digit
				i := i + 1
			end
		end

	parse_unicode_escape (a_string: READABLE_STRING_GENERAL; a_start: INTEGER): CHARACTER_32
			-- Parse \uXXXX escape sequence
		local
			l_hex: STRING_8
		do
			create l_hex.make (4)
			if a_start + 3 <= a_string.count then
				l_hex.append_character (a_string [a_start].to_character_8)
				l_hex.append_character (a_string [a_start + 1].to_character_8)
				l_hex.append_character (a_string [a_start + 2].to_character_8)
				l_hex.append_character (a_string [a_start + 3].to_character_8)
			end
			Result := hex_to_integer (l_hex).to_character_32
		end

	append_utf8_percent_encoded (a_result: STRING_8; a_code: NATURAL_32)
			-- Append UTF-8 bytes as percent-encoded to `a_result`
		local
			l_hex: STRING_8
			l_byte: NATURAL_32
		do
			if a_code <= 0x7F then
				l_hex := a_code.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
			elseif a_code <= 0x7FF then
				-- 2-byte sequence
				l_byte := 0xC0 | (a_code |>> 6)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | (a_code & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
			elseif a_code <= 0xFFFF then
				-- 3-byte sequence
				l_byte := 0xE0 | (a_code |>> 12)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | ((a_code |>> 6) & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | (a_code & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
			else
				-- 4-byte sequence
				l_byte := 0xF0 | (a_code |>> 18)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | ((a_code |>> 12) & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | ((a_code |>> 6) & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
				l_byte := 0x80 | (a_code & 0x3F)
				l_hex := l_byte.to_hex_string
				a_result.append_character ('%%')
				a_result.append_string (l_hex.substring (l_hex.count - 1, l_hex.count))
			end
		end

end
