note
	description: "Abstract base for character encoding codecs"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_ZCODEC

feature -- Access

	name: STRING
			-- Codec name (e.g., "ISO-8859-15")
		deferred
		ensure
			result_exists: Result /= Void
			not_empty: not Result.is_empty
		end

	unicode_table: SPECIAL [CHARACTER_32]
			-- Maps 8-bit codes (128-255) to Unicode
			-- Codes 0-127 are identical to ASCII
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = 128
		end

feature -- Encoding

	encoded_character (a_char: CHARACTER_32): CHARACTER_8
			-- Encode Unicode character to 8-bit
			-- Returns Substitute if not encodable
		local
			l_code: NATURAL_32
			i: INTEGER
		do
			l_code := a_char.natural_32_code
			if l_code < 128 then
				Result := l_code.to_character_8
			else
				-- Search unicode_table for character
				Result := Substitute
				from i := 0 until i >= 128 or Result /= Substitute loop
					if unicode_table [i] = a_char then
						Result := (i + 128).to_character_8
					end
					i := i + 1
				end
			end
		end

	can_encode (a_char: CHARACTER_32): BOOLEAN
			-- Can `a_char` be encoded by this codec?
		do
			Result := encoded_character (a_char) /= Substitute or else a_char = Substitute.to_character_32
		end

feature -- Decoding

	decoded_character (a_char: CHARACTER_8): CHARACTER_32
			-- Decode 8-bit character to Unicode
		local
			l_code: INTEGER
		do
			l_code := a_char.code
			if l_code < 128 then
				Result := a_char.to_character_32
			else
				Result := unicode_table [l_code - 128]
			end
		end

feature -- Constants

	Substitute: CHARACTER_8 = '%/026/'
			-- Marker for unencodable characters (ASCII SUB)

invariant
	unicode_table_exists: unicode_table /= Void
	unicode_table_correct_size: unicode_table.count = 128

end
