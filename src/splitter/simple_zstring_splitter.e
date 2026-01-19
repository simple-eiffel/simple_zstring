note
	description: "String splitting operations"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_SPLITTER

feature -- Character Splitting

	split_by_character (a_string: READABLE_STRING_GENERAL; a_separator: CHARACTER_32): ARRAYED_LIST [STRING_32]
			-- Split `a_string` at each `a_separator`
		require
			string_exists: a_string /= Void
		local
			l_start, l_pos: INTEGER
		do
			create Result.make (10)
			l_start := 1
			from l_pos := 1 until l_pos > a_string.count loop
				if a_string [l_pos] = a_separator then
					Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
					l_start := l_pos + 1
				end
				l_pos := l_pos + 1
			end
			Result.extend (a_string.substring (l_start, a_string.count).to_string_32)
		ensure
			at_least_one: not Result.is_empty
		end

	split_by_any_character (a_string: READABLE_STRING_GENERAL; a_separators: READABLE_STRING_GENERAL): ARRAYED_LIST [STRING_32]
			-- Split at any character in `a_separators`
		require
			string_exists: a_string /= Void
			separators_not_empty: not a_separators.is_empty
		local
			l_start, l_pos: INTEGER
		do
			create Result.make (10)
			l_start := 1
			from l_pos := 1 until l_pos > a_string.count loop
				if a_separators.has (a_string [l_pos]) then
					if l_pos > l_start then
						Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
					end
					l_start := l_pos + 1
				end
				l_pos := l_pos + 1
			end
			if l_start <= a_string.count then
				Result.extend (a_string.substring (l_start, a_string.count).to_string_32)
			end
		end

feature -- String Splitting

	split_by_string (a_string, a_separator: READABLE_STRING_GENERAL): ARRAYED_LIST [STRING_32]
			-- Split `a_string` at each occurrence of `a_separator`
		require
			string_exists: a_string /= Void
			separator_not_empty: not a_separator.is_empty
		local
			l_start, l_pos: INTEGER
		do
			create Result.make (10)
			l_start := 1
			from l_pos := a_string.substring_index (a_separator, l_start)
			until l_pos = 0
			loop
				Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
				l_start := l_pos + a_separator.count
				l_pos := a_string.substring_index (a_separator, l_start)
			end
			Result.extend (a_string.substring (l_start, a_string.count).to_string_32)
		ensure
			at_least_one: not Result.is_empty
		end

feature -- Limited Splitting

	split_n (a_string: READABLE_STRING_GENERAL; a_separator: CHARACTER_32; n: INTEGER): ARRAYED_LIST [STRING_32]
			-- Split into at most `n` parts
		require
			string_exists: a_string /= Void
			positive_n: n > 0
		local
			l_start, l_pos, l_count: INTEGER
		do
			create Result.make (n)
			l_start := 1
			l_count := 0
			from l_pos := 1 until l_pos > a_string.count or l_count >= n - 1 loop
				if a_string [l_pos] = a_separator then
					Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
					l_start := l_pos + 1
					l_count := l_count + 1
				end
				l_pos := l_pos + 1
			end
			Result.extend (a_string.substring (l_start, a_string.count).to_string_32)
		ensure
			at_most_n: Result.count <= n
			at_least_one: not Result.is_empty
		end

feature -- Line Splitting

	split_lines (a_string: READABLE_STRING_GENERAL): ARRAYED_LIST [STRING_32]
			-- Split into lines (handles CR, LF, CRLF)
		require
			string_exists: a_string /= Void
		local
			l_start, l_pos: INTEGER
			l_char: CHARACTER_32
		do
			create Result.make (10)
			l_start := 1
			from l_pos := 1 until l_pos > a_string.count loop
				l_char := a_string [l_pos]
				if l_char = '%N' then
					Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
					l_start := l_pos + 1
				elseif l_char = '%R' then
					Result.extend (a_string.substring (l_start, l_pos - 1).to_string_32)
					if l_pos < a_string.count and then a_string [l_pos + 1] = '%N' then
						l_pos := l_pos + 1
					end
					l_start := l_pos + 1
				end
				l_pos := l_pos + 1
			end
			if l_start <= a_string.count then
				Result.extend (a_string.substring (l_start, a_string.count).to_string_32)
			elseif l_start = a_string.count + 1 and then Result.is_empty then
				Result.extend (create {STRING_32}.make_empty)
			end
		end

feature -- Word Splitting

	split_words (a_string: READABLE_STRING_GENERAL): ARRAYED_LIST [STRING_32]
			-- Split into words (whitespace separated)
		require
			string_exists: a_string /= Void
		do
			Result := split_by_any_character (a_string, " %T%N%R")
			-- Remove empty entries
			from Result.start until Result.after loop
				if Result.item.is_empty then
					Result.remove
				else
					Result.forth
				end
			end
		ensure
			no_empty: across Result as ic all not ic.is_empty end
		end

end
