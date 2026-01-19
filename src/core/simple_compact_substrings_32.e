note
	description: "Compacted storage for Unicode characters not encodable by codec"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_COMPACT_SUBSTRINGS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty storage
		do
			create positions.make (4)
			create characters.make (4)
		ensure
			empty: is_empty
		end

feature -- Access

	item (a_index: INTEGER): CHARACTER_32
			-- Character at logical position `a_index`
		require
			has_position: has (a_index)
		local
			i: INTEGER
		do
			i := position_index (a_index)
			Result := characters.i_th (i)
		end

feature -- Status Query

	is_empty: BOOLEAN
			-- No unencoded characters?
		do
			Result := positions.is_empty
		end

	has (a_index: INTEGER): BOOLEAN
			-- Is there an unencoded character at position `a_index`?
		do
			Result := position_index (a_index) > 0
		end

feature -- Measurement

	count: INTEGER
			-- Total unencoded characters
		do
			Result := positions.count
		end

feature -- Element Change

	put (a_char: CHARACTER_32; a_index: INTEGER)
			-- Store `a_char` at position `a_index`
		require
			valid_index: a_index >= 1
		local
			i: INTEGER
		do
			i := position_index (a_index)
			if i > 0 then
				-- Update existing
				characters.put_i_th (a_char, i)
			else
				-- Insert new, maintaining sorted order
				insert_at_position (a_char, a_index)
			end
		ensure
			stored: item (a_index) = a_char
			has_position: has (a_index)
		end

	remove (a_index: INTEGER)
			-- Remove character at position `a_index`
		local
			i: INTEGER
		do
			i := position_index (a_index)
			if i > 0 then
				positions.go_i_th (i)
				positions.remove
				characters.go_i_th (i)
				characters.remove
			end
		ensure
			removed: not has (a_index)
		end

	shift_from (a_start_pos: INTEGER; a_offset: INTEGER)
			-- Shift all positions >= `a_start_pos` by `a_offset`
		local
			i: INTEGER
		do
			from i := 1 until i > positions.count loop
				if positions.i_th (i) >= a_start_pos then
					positions.put_i_th (positions.i_th (i) + a_offset, i)
				end
				i := i + 1
			end
		end

	wipe_out
			-- Clear all
		do
			positions.wipe_out
			characters.wipe_out
		ensure
			empty: is_empty
		end

feature {NONE} -- Implementation

	positions: ARRAYED_LIST [INTEGER]
			-- Sorted list of string positions with unencoded characters

	characters: ARRAYED_LIST [CHARACTER_32]
			-- Characters at corresponding positions

	position_index (a_pos: INTEGER): INTEGER
			-- Index in `positions` array for position `a_pos`, or 0 if not found
			-- Returns 1-based index (compatible with ARRAYED_LIST)
		local
			i: INTEGER
		do
			Result := 0
			from i := 1 until i > positions.count or Result > 0 loop
				if positions.i_th (i) = a_pos then
					Result := i
				end
				i := i + 1
			end
		end

	insert_at_position (a_char: CHARACTER_32; a_index: INTEGER)
			-- Insert character maintaining sorted order by position
		local
			i: INTEGER
			l_inserted: BOOLEAN
		do
			from i := 1 until i > positions.count or l_inserted loop
				if positions.i_th (i) > a_index then
					positions.go_i_th (i)
					positions.put_left (a_index)
					characters.go_i_th (i)
					characters.put_left (a_char)
					l_inserted := True
				end
				i := i + 1
			end
			if not l_inserted then
				positions.extend (a_index)
				characters.extend (a_char)
			end
		end

invariant
	same_counts: positions.count = characters.count

end
