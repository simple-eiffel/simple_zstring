note
	description: "ISO-8859-15 (Latin-9) codec with Euro sign support"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ISO_8859_15_ZCODEC

inherit
	SIMPLE_ZCODEC

feature -- Access

	name: STRING = "ISO-8859-15"

	unicode_table: SPECIAL [CHARACTER_32]
			-- Latin-9 to Unicode mapping (codes 128-255)
		once
			create Result.make_filled ('%U', 128)
			-- 0x80-0x9F: C1 control characters (same code points)
			across 0 |..| 31 as i loop
				Result [i] := (128 + i).to_character_32
			end
			-- 0xA0-0xFF: Printable characters
			-- Most are same as Latin-1, fill them first
			across 32 |..| 127 as i loop
				Result [i] := (128 + i).to_character_32
			end
			-- ISO-8859-15 specific differences from Latin-1:
			Result [0xA4 - 128] := (0x20AC).to_character_32  -- Euro sign €
			Result [0xA6 - 128] := (0x0160).to_character_32  -- Š (S caron)
			Result [0xA8 - 128] := (0x0161).to_character_32  -- š (s caron)
			Result [0xB4 - 128] := (0x017D).to_character_32  -- Ž (Z caron)
			Result [0xB8 - 128] := (0x017E).to_character_32  -- ž (z caron)
			Result [0xBC - 128] := (0x0152).to_character_32  -- Œ (OE ligature)
			Result [0xBD - 128] := (0x0153).to_character_32  -- œ (oe ligature)
			Result [0xBE - 128] := (0x0178).to_character_32  -- Ÿ (Y diaeresis)
		end

end
