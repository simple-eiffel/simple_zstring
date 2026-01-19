note
	description: "String searching and matching operations"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_SEARCHER

feature -- Basic Search

	index_of (a_string: READABLE_STRING_GENERAL; a_substring: READABLE_STRING_GENERAL; a_start: INTEGER): INTEGER
			-- Index of `a_substring` in `a_string` starting at `a_start`, or 0
		require
			string_exists: a_string /= Void
			substring_exists: a_substring /= Void
			valid_start: a_start >= 1 and a_start <= a_string.count + 1
		do
			if a_string.is_empty or a_substring.is_empty then
				Result := 0
			else
				Result := a_string.substring_index (a_substring, a_start)
			end
		ensure
			zero_or_valid: Result = 0 or (Result >= a_start and Result <= a_string.count - a_substring.count + 1)
		end

	last_index_of (a_string: READABLE_STRING_GENERAL; a_substring: READABLE_STRING_GENERAL): INTEGER
			-- Last index of `a_substring`, or 0
		require
			string_exists: a_string /= Void
			substring_exists: a_substring /= Void
		local
			l_pos: INTEGER
		do
			from l_pos := a_string.substring_index (a_substring, 1)
			until l_pos = 0
			loop
				Result := l_pos
				l_pos := a_string.substring_index (a_substring, l_pos + 1)
			end
		ensure
			zero_or_valid: Result = 0 or Result <= a_string.count - a_substring.count + 1
		end

feature -- Multiple Occurrences

	all_indices_of (a_string: READABLE_STRING_GENERAL; a_substring: READABLE_STRING_GENERAL): ARRAYED_LIST [INTEGER]
			-- All indices where `a_substring` occurs
		require
			string_exists: a_string /= Void
			substring_exists: a_substring /= Void
		local
			l_pos: INTEGER
		do
			create Result.make (10)
			from l_pos := a_string.substring_index (a_substring, 1)
			until l_pos = 0
			loop
				Result.extend (l_pos)
				l_pos := a_string.substring_index (a_substring, l_pos + 1)
			end
		ensure
			result_exists: Result /= Void
		end

	occurrence_count (a_string: READABLE_STRING_GENERAL; a_substring: READABLE_STRING_GENERAL): INTEGER
			-- Number of occurrences of `a_substring`
		require
			string_exists: a_string /= Void
			substring_exists: a_substring /= Void
		do
			Result := all_indices_of (a_string, a_substring).count
		ensure
			non_negative: Result >= 0
		end

feature -- Case-Insensitive Search

	index_of_case_insensitive (a_string: READABLE_STRING_GENERAL; a_substring: READABLE_STRING_GENERAL; a_start: INTEGER): INTEGER
			-- Case-insensitive index of `a_substring`
		require
			string_exists: a_string /= Void
			substring_exists: a_substring /= Void
			valid_start: a_start >= 1 and a_start <= a_string.count + 1
		local
			l_upper_string, l_upper_sub: STRING_32
		do
			l_upper_string := a_string.as_upper.to_string_32
			l_upper_sub := a_substring.as_upper.to_string_32
			Result := l_upper_string.substring_index (l_upper_sub, a_start)
		end

feature -- Pattern Matching (Simple)

	matches_wildcard (a_string: READABLE_STRING_GENERAL; a_pattern: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_string` match `a_pattern` with * and ? wildcards?
		require
			string_exists: a_string /= Void
			pattern_exists: a_pattern /= Void
		do
			Result := matches_wildcard_recursive (a_string, a_pattern, 1, 1)
		end

feature -- Contains

	contains_any (a_string: READABLE_STRING_GENERAL; a_substrings: ITERABLE [READABLE_STRING_GENERAL]): BOOLEAN
			-- Does `a_string` contain any of `a_substrings`?
		require
			string_exists: a_string /= Void
			substrings_exist: a_substrings /= Void
		do
			across a_substrings as ic until Result loop
				Result := a_string.has_substring (ic)
			end
		end

	contains_all (a_string: READABLE_STRING_GENERAL; a_substrings: ITERABLE [READABLE_STRING_GENERAL]): BOOLEAN
			-- Does `a_string` contain all of `a_substrings`?
		require
			string_exists: a_string /= Void
			substrings_exist: a_substrings /= Void
		do
			Result := True
			across a_substrings as ic until not Result loop
				Result := a_string.has_substring (ic)
			end
		end

feature -- Prefix/Suffix

	starts_with (a_string: READABLE_STRING_GENERAL; a_prefix: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_string` start with `a_prefix`?
		require
			string_exists: a_string /= Void
			prefix_exists: a_prefix /= Void
		do
			if a_string.count >= a_prefix.count then
				Result := a_string.substring (1, a_prefix.count).same_string (a_prefix)
			end
		end

	ends_with (a_string: READABLE_STRING_GENERAL; a_suffix: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_string` end with `a_suffix`?
		require
			string_exists: a_string /= Void
			suffix_exists: a_suffix /= Void
		local
			l_start: INTEGER
		do
			if a_string.count >= a_suffix.count then
				l_start := a_string.count - a_suffix.count + 1
				Result := a_string.substring (l_start, a_string.count).same_string (a_suffix)
			end
		end

	starts_with_case_insensitive (a_string: READABLE_STRING_GENERAL; a_prefix: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_string` start with `a_prefix` (case-insensitive)?
		require
			string_exists: a_string /= Void
			prefix_exists: a_prefix /= Void
		do
			if a_string.count >= a_prefix.count then
				Result := a_string.substring (1, a_prefix.count).as_upper.same_string (a_prefix.as_upper)
			end
		end

	ends_with_case_insensitive (a_string: READABLE_STRING_GENERAL; a_suffix: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_string` end with `a_suffix` (case-insensitive)?
		require
			string_exists: a_string /= Void
			suffix_exists: a_suffix /= Void
		local
			l_start: INTEGER
		do
			if a_string.count >= a_suffix.count then
				l_start := a_string.count - a_suffix.count + 1
				Result := a_string.substring (l_start, a_string.count).as_upper.same_string (a_suffix.as_upper)
			end
		end

feature {NONE} -- Implementation

	matches_wildcard_recursive (a_string: READABLE_STRING_GENERAL; a_pattern: READABLE_STRING_GENERAL;
			s_pos, p_pos: INTEGER): BOOLEAN
			-- Recursive wildcard matching helper
		do
			if p_pos > a_pattern.count then
				Result := s_pos > a_string.count
			elseif a_pattern [p_pos] = '*' then
				Result := matches_wildcard_recursive (a_string, a_pattern, s_pos, p_pos + 1)
					or (s_pos <= a_string.count and then
						matches_wildcard_recursive (a_string, a_pattern, s_pos + 1, p_pos))
			elseif s_pos > a_string.count then
				Result := False
			elseif a_pattern [p_pos] = '?' or a_pattern [p_pos] = a_string [s_pos] then
				Result := matches_wildcard_recursive (a_string, a_pattern, s_pos + 1, p_pos + 1)
			end
		end

end
