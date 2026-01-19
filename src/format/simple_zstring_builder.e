note
	description: "Efficient string construction with fluent interface"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_BUILDER

inherit
	ANY
		redefine
			out
		end

create
	make, make_with_capacity

feature {NONE} -- Initialization

	make
			-- Create with default capacity
		do
			make_with_capacity (Default_capacity)
		ensure
			buffer_created: buffer /= Void
		end

	make_with_capacity (a_capacity: INTEGER)
			-- Create with specified capacity
		require
			positive_capacity: a_capacity > 0
		do
			create buffer.make (a_capacity)
		ensure
			buffer_created: buffer /= Void
			capacity_set: buffer.capacity >= a_capacity
		end

feature -- Appending (fluent)

	append (a_string: READABLE_STRING_GENERAL): like Current
			-- Append string, return self for chaining
		require
			string_exists: a_string /= Void
		do
			buffer.append_string_general (a_string)
			Result := Current
		ensure
			chained: Result = Current
			appended: buffer.ends_with_general (a_string)
		end

	append_character (c: CHARACTER_32): like Current
			-- Append character, return self for chaining
		do
			buffer.append_character (c)
			Result := Current
		ensure
			chained: Result = Current
		end

	append_integer (n: INTEGER_64): like Current
			-- Append integer, return self for chaining
		do
			buffer.append_string_general (n.out)
			Result := Current
		ensure
			chained: Result = Current
		end

	append_natural (n: NATURAL_64): like Current
			-- Append natural number, return self for chaining
		do
			buffer.append_string_general (n.out)
			Result := Current
		ensure
			chained: Result = Current
		end

	append_real (r: REAL_64): like Current
			-- Append real number, return self for chaining
		do
			buffer.append_string_general (r.out)
			Result := Current
		ensure
			chained: Result = Current
		end

	append_boolean (b: BOOLEAN): like Current
			-- Append boolean, return self for chaining
		do
			if b then
				buffer.append_string_general ("True")
			else
				buffer.append_string_general ("False")
			end
			Result := Current
		ensure
			chained: Result = Current
		end

	append_line (a_string: READABLE_STRING_GENERAL): like Current
			-- Append string followed by newline
		require
			string_exists: a_string /= Void
		do
			buffer.append_string_general (a_string)
			buffer.append_character ('%N')
			Result := Current
		ensure
			chained: Result = Current
			ends_with_newline: buffer.ends_with ("%N")
		end

	append_new_line: like Current
			-- Append newline
		do
			buffer.append_character ('%N')
			Result := Current
		ensure
			chained: Result = Current
		end

	append_tab: like Current
			-- Append tab character
		do
			buffer.append_character ('%T')
			Result := Current
		ensure
			chained: Result = Current
		end

	append_space: like Current
			-- Append space character
		do
			buffer.append_character (' ')
			Result := Current
		ensure
			chained: Result = Current
		end

	append_repeated (a_char: CHARACTER_32; a_count: INTEGER): like Current
			-- Append `a_char` repeated `a_count` times
		require
			non_negative_count: a_count >= 0
		local
			i: INTEGER
		do
			from i := 1 until i > a_count loop
				buffer.append_character (a_char)
				i := i + 1
			end
			Result := Current
		ensure
			chained: Result = Current
		end

feature -- Access

	to_string_32: STRING_32
			-- Result as STRING_32
		do
			Result := buffer.twin
		ensure
			result_exists: Result /= Void
			same_content: Result ~ buffer
		end

	to_string_8: STRING_8
			-- Result as STRING_8 (for ASCII content)
		do
			Result := buffer.to_string_8
		ensure
			result_exists: Result /= Void
		end

	out: STRING
			-- Result as STRING
		do
			Result := buffer.to_string_8
		end

feature -- Status

	count: INTEGER
			-- Number of characters in buffer
		do
			Result := buffer.count
		ensure
			non_negative: Result >= 0
		end

	is_empty: BOOLEAN
			-- Is buffer empty?
		do
			Result := buffer.is_empty
		ensure
			definition: Result = (count = 0)
		end

feature -- Modification

	clear
			-- Clear buffer
		do
			buffer.wipe_out
		ensure
			empty: is_empty
		end

feature {NONE} -- Implementation

	buffer: STRING_32
			-- Internal buffer

	Default_capacity: INTEGER = 256
			-- Default initial capacity

invariant
	buffer_exists: buffer /= Void

end
