note
	description: "Adversarial tests for simple_zstring - boundary conditions and edge cases"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARIAL_TESTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run adversarial tests
		do
			create test_count.put (0)
			create pass_count.put (0)
			create fail_count.put (0)

			print ("Adversarial Tests for simple_zstring%N")
			print ("=====================================%N%N")

			run_zstring_boundary_tests
			run_utf8_edge_cases
			run_dual_storage_edge_cases
			run_splitter_edge_cases
			run_searcher_edge_cases
			run_escaper_edge_cases
			run_formatter_edge_cases

			print ("%N=====================================%N")
			print ("Results: ")
			print (pass_count.item.out)
			print (" passed, ")
			print (fail_count.item.out)
			print (" failed, ")
			print (test_count.item.out)
			print (" total%N")

			if fail_count.item > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL ADVERSARIAL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Infrastructure

	test_count: CELL [INTEGER]
	pass_count: CELL [INTEGER]
	fail_count: CELL [INTEGER]

	assert (a_name: STRING; a_condition: BOOLEAN)
		do
			test_count.put (test_count.item + 1)
			if a_condition then
				pass_count.put (pass_count.item + 1)
				print ("  [PASS] " + a_name + "%N")
			else
				fail_count.put (fail_count.item + 1)
				print ("  [FAIL] " + a_name + "%N")
			end
		end

	section (a_name: STRING)
		do
			print ("%N" + a_name + "%N")
			print (create {STRING}.make_filled ('-', a_name.count))
			print ("%N")
		end

feature {NONE} -- ZSTRING Boundary Tests

	run_zstring_boundary_tests
		local
			z: SIMPLE_ZSTRING
		do
			section ("ZSTRING Boundary Tests")

			-- Empty string operations
			create z.make_empty
			assert ("empty count is 0", z.count = 0)
			assert ("empty is_empty", z.is_empty)
			assert ("empty capacity >= 0", z.capacity >= 0)
			assert ("empty is_ascii", z.is_ascii)
			assert ("empty is_valid_as_string_8", z.is_valid_as_string_8)
			assert ("empty to_string_32", z.to_string_32.is_empty)
			assert ("empty utf8", z.to_utf_8.is_empty)

			-- Single character string
			create z.make_from_string ("X")
			assert ("single count", z.count = 1)
			assert ("single item 1", z.item (1) = 'X')
			assert ("single not empty", not z.is_empty)
			assert ("single valid_index 1", z.valid_index (1))
			assert ("single invalid_index 0", not z.valid_index (0))
			assert ("single invalid_index 2", not z.valid_index (2))

			-- Append to empty
			create z.make_empty
			z.append_character ('A')
			assert ("append_empty count", z.count = 1)
			assert ("append_empty item", z.item (1) = 'A')

			-- Insert at position 1 (prepend)
			create z.make_from_string ("BC")
			z.insert_character ('A', 1)
			assert ("insert_1 count", z.count = 3)
			assert ("insert_1 content", z.to_string_32.same_string ("ABC"))

			-- Insert at end position
			create z.make_from_string ("AB")
			z.insert_character ('C', 3)
			assert ("insert_end count", z.count = 3)
			assert ("insert_end content", z.to_string_32.same_string ("ABC"))

			-- Remove first character
			create z.make_from_string ("ABC")
			z.remove (1)
			assert ("remove_1 count", z.count = 2)
			assert ("remove_1 content", z.to_string_32.same_string ("BC"))

			-- Remove last character
			create z.make_from_string ("ABC")
			z.remove (3)
			assert ("remove_last count", z.count = 2)
			assert ("remove_last content", z.to_string_32.same_string ("AB"))

			-- Substring empty range
			create z.make_from_string ("ABC")
			assert ("substring 2,1 empty", z.substring (2, 1).is_empty)

			-- Substring full
			create z.make_from_string ("ABC")
			assert ("substring full", z.substring (1, 3).to_string_32.same_string ("ABC"))

			-- Equality with empty
			create z.make_empty
			assert ("empty equals empty", z.is_equal (create {SIMPLE_ZSTRING}.make_empty))

			-- Wipe out already empty
			create z.make_empty
			z.wipe_out
			assert ("wipe_out_empty", z.is_empty)
		end

feature {NONE} -- UTF-8 Edge Cases

	run_utf8_edge_cases
		local
			z: SIMPLE_ZSTRING
		do
			section ("UTF-8 Edge Cases")

			-- Empty UTF-8 string
			create z.make_from_utf_8 ("")
			assert ("utf8 empty", z.is_empty)

			-- Pure ASCII UTF-8
			create z.make_from_utf_8 ("Hello")
			assert ("utf8 ascii", z.count = 5)
			assert ("utf8 ascii is_ascii", z.is_ascii)

			-- 2-byte UTF-8 sequences
			create z.make_from_utf_8 ("é")
			assert ("utf8 2byte count", z.count = 1)
			assert ("utf8 2byte char", z.item (1).natural_32_code = 0xE9)

			-- 3-byte UTF-8 sequence (Euro sign)
			create z.make_from_utf_8 ("€")
			assert ("utf8 3byte count", z.count = 1)
			assert ("utf8 3byte char", z.item (1).natural_32_code = 0x20AC)

			-- 4-byte UTF-8 sequence (emoji)
			create z.make_from_utf_8 (emoji_utf8)
			assert ("utf8 4byte count", z.count = 1)
			assert ("utf8 4byte char", z.item (1).natural_32_code = 0x1F600)

			-- Mixed encoding roundtrip
			create z.make_from_utf_8 ("Hello€World")
			assert ("utf8 mixed count", z.count = 11)
			assert ("utf8 roundtrip", z.to_utf_8.same_string ("Hello€World"))

			-- Long UTF-8 string
			create z.make_from_utf_8 (long_utf8_string)
			assert ("utf8 long not empty", not z.is_empty)
		end

	emoji_utf8: STRING_8
			-- UTF-8 bytes for 😀 (U+1F600)
		once
			create Result.make (4)
			Result.append_character ((0xF0).to_character_8)
			Result.append_character ((0x9F).to_character_8)
			Result.append_character ((0x98).to_character_8)
			Result.append_character ((0x80).to_character_8)
		end

	long_utf8_string: STRING_8
		once
			create Result.make (1000)
			across 1 |..| 100 as i loop
				Result.append ("éàü")
			end
		end

feature {NONE} -- Dual Storage Edge Cases

	run_dual_storage_edge_cases
		local
			z: SIMPLE_ZSTRING
			l_emoji: CHARACTER_32
		do
			section ("Dual Storage Edge Cases")

			l_emoji := (0x1F600).to_character_32

			-- Unencoded at position 1
			create z.make_empty
			z.append_character (l_emoji)
			assert ("unencoded_1 count", z.count = 1)
			assert ("unencoded_1 item", z.item (1) = l_emoji)
			assert ("unencoded_1 has_mixed", z.has_mixed_encoding)

			-- Unencoded followed by ASCII
			create z.make_empty
			z.append_character (l_emoji)
			z.append_character ('A')
			assert ("unencoded_then_ascii count", z.count = 2)
			assert ("unencoded_then_ascii item1", z.item (1) = l_emoji)
			assert ("unencoded_then_ascii item2", z.item (2) = 'A')

			-- ASCII followed by unencoded
			create z.make_empty
			z.append_character ('A')
			z.append_character (l_emoji)
			assert ("ascii_then_unencoded count", z.count = 2)
			assert ("ascii_then_unencoded item1", z.item (1) = 'A')
			assert ("ascii_then_unencoded item2", z.item (2) = l_emoji)

			-- Replace ASCII with unencoded
			create z.make_from_string ("ABC")
			z.put (l_emoji, 2)
			assert ("replace_with_unencoded count", z.count = 3)
			assert ("replace_with_unencoded item1", z.item (1) = 'A')
			assert ("replace_with_unencoded item2", z.item (2) = l_emoji)
			assert ("replace_with_unencoded item3", z.item (3) = 'C')

			-- Replace unencoded with ASCII
			z.put ('B', 2)
			assert ("replace_unencoded_with_ascii", z.item (2) = 'B')
			assert ("replaced_no_mixed", not z.has_mixed_encoding)

			-- Remove unencoded character
			create z.make_empty
			z.append_character ('A')
			z.append_character (l_emoji)
			z.append_character ('B')
			z.remove (2)
			assert ("remove_unencoded count", z.count = 2)
			assert ("remove_unencoded item1", z.item (1) = 'A')
			assert ("remove_unencoded item2", z.item (2) = 'B')
			assert ("remove_unencoded no_mixed", not z.has_mixed_encoding)

			-- Insert shifts unencoded positions
			create z.make_empty
			z.append_character ('A')
			z.append_character (l_emoji)
			z.insert_character ('X', 1)
			assert ("insert_shifts count", z.count = 3)
			assert ("insert_shifts item1", z.item (1) = 'X')
			assert ("insert_shifts item2", z.item (2) = 'A')
			assert ("insert_shifts item3", z.item (3) = l_emoji)

			-- Multiple unencoded characters
			create z.make_empty
			z.append_character (l_emoji)
			z.append_character ('A')
			z.append_character ((0x1F601).to_character_32)
			assert ("multi_unencoded count", z.count = 3)
			assert ("multi_unencoded has_mixed", z.has_mixed_encoding)

			-- Regression test: is_ascii must return False when unencoded chars present
			create z.make_empty
			z.append_character (l_emoji)
			assert ("emoji_not_ascii", not z.is_ascii)
			assert ("emoji_not_valid_string_8", not z.is_valid_as_string_8)
		end

feature {NONE} -- Splitter Edge Cases

	run_splitter_edge_cases
		local
			splitter: SIMPLE_ZSTRING_SPLITTER
			parts: ARRAYED_LIST [STRING_32]
		do
			section ("Splitter Edge Cases")

			create splitter

			-- Split empty string
			parts := splitter.split_by_character ("", ',')
			assert ("split_empty has one part", parts.count = 1)
			assert ("split_empty part is empty", parts [1].is_empty)

			-- Split no separator
			parts := splitter.split_by_character ("abc", ',')
			assert ("split_no_sep has one part", parts.count = 1)
			assert ("split_no_sep content", parts [1].same_string ("abc"))

			-- Split separator at start
			parts := splitter.split_by_character (",abc", ',')
			assert ("split_sep_start count", parts.count = 2)
			assert ("split_sep_start first empty", parts [1].is_empty)

			-- Split separator at end
			parts := splitter.split_by_character ("abc,", ',')
			assert ("split_sep_end count", parts.count = 2)
			assert ("split_sep_end last empty", parts [2].is_empty)

			-- Split only separators
			parts := splitter.split_by_character (",,", ',')
			assert ("split_only_seps count", parts.count = 3)

			-- Split lines empty
			parts := splitter.split_lines ("")
			assert ("split_lines_empty", parts.count >= 0)

			-- Split words all spaces
			parts := splitter.split_words ("   ")
			assert ("split_words_spaces empty", parts.is_empty)

			-- Split words single word
			parts := splitter.split_words ("hello")
			assert ("split_words_single", parts.count = 1)
		end

feature {NONE} -- Searcher Edge Cases

	run_searcher_edge_cases
		local
			searcher: SIMPLE_ZSTRING_SEARCHER
		do
			section ("Searcher Edge Cases")

			create searcher

			-- Search in empty string
			assert ("search_in_empty", searcher.index_of ("", "a", 1) = 0)

			-- Search empty pattern
			assert ("search_empty_pattern", searcher.index_of ("abc", "", 1) = 0)

			-- Search pattern longer than string
			assert ("search_longer_pattern", searcher.index_of ("ab", "abc", 1) = 0)

			-- Search at end of string
			assert ("search_at_end", searcher.index_of ("abc", "c", 1) = 3)

			-- Search pattern is entire string
			assert ("search_whole_string", searcher.index_of ("abc", "abc", 1) = 1)

			-- Wildcard empty string
			assert ("wildcard_empty", searcher.matches_wildcard ("", "*"))

			-- Wildcard star only
			assert ("wildcard_star_only", searcher.matches_wildcard ("anything", "*"))

			-- Wildcard question marks
			assert ("wildcard_questions", searcher.matches_wildcard ("abc", "???"))

			-- Starts with empty
			assert ("starts_with_empty", searcher.starts_with ("abc", ""))

			-- Ends with empty
			assert ("ends_with_empty", searcher.ends_with ("abc", ""))

			-- Contains any empty list
			assert ("contains_any_empty_list", not searcher.contains_any ("abc", create {ARRAYED_LIST [STRING_32]}.make (0)))

			-- Contains all empty list
			assert ("contains_all_empty_list", searcher.contains_all ("abc", create {ARRAYED_LIST [STRING_32]}.make (0)))
		end

feature {NONE} -- Escaper Edge Cases

	run_escaper_edge_cases
		local
			escaper: SIMPLE_ZSTRING_ESCAPER
		do
			section ("Escaper Edge Cases")

			create escaper

			-- Escape empty string
			assert ("escape_xml_empty", escaper.escape_xml ("").is_empty)
			assert ("escape_json_empty", escaper.escape_json ("").is_empty)
			assert ("url_encode_empty", escaper.url_encode ("").is_empty)

			-- Unescape empty string
			assert ("unescape_xml_empty", escaper.unescape_xml ("").is_empty)
			assert ("unescape_json_empty", escaper.unescape_json ("").is_empty)
			assert ("url_decode_empty", escaper.url_decode ("").is_empty)

			-- Escape string with no special chars
			assert ("escape_xml_plain", escaper.escape_xml ("hello").same_string ("hello"))
			assert ("escape_json_plain", escaper.escape_json ("hello").same_string ("hello"))

			-- URL encode with only safe chars
			assert ("url_encode_safe", escaper.url_encode ("abcXYZ123").same_string ("abcXYZ123"))

			-- CSV empty
			assert ("csv_empty", escaper.escape_csv_field ("").is_empty)

			-- CSV no special chars
			assert ("csv_plain", escaper.escape_csv_field ("hello").same_string ("hello"))

			-- Shell escape empty
			assert ("shell_empty", escaper.escape_shell_argument ("").same_string ("''"))
		end

feature {NONE} -- Formatter Edge Cases

	run_formatter_edge_cases
		local
			formatter: SIMPLE_ZSTRING_FORMATTER
			values: HASH_TABLE [STRING_32, STRING_32]
		do
			section ("Formatter Edge Cases")

			create formatter

			-- Pad left string already wider
			assert ("pad_left_wider", formatter.pad_left ("hello", 3, '0').same_string ("hello"))

			-- Pad right string already wider
			assert ("pad_right_wider", formatter.pad_right ("hello", 3, '0').same_string ("hello"))

			-- Center string already wider
			assert ("center_wider", formatter.center ("hello", 3, '-').same_string ("hello"))

			-- Center odd width
			assert ("center_odd", formatter.center ("X", 4, '-').same_string ("-X--"))

			-- Substitute empty template
			create values.make (1)
			assert ("substitute_empty", formatter.substitute ("", values).is_empty)

			-- Substitute no placeholders
			create values.make (1)
			values.put ("World", "name")
			assert ("substitute_no_placeholders", formatter.substitute ("Hello", values).same_string ("Hello"))

			-- Substitute missing key
			create values.make (1)
			assert ("substitute_missing_key", formatter.substitute ("Hello ${name}", values).same_string ("Hello ${name}"))

			-- Join empty list
			assert ("join_empty", formatter.join (create {ARRAYED_LIST [STRING_32]}.make (0), ", ").is_empty)

			-- Word wrap empty
			assert ("word_wrap_empty", formatter.word_wrap ("", 10).is_empty)

			-- Format integer zero
			assert ("format_int_zero", formatter.format_integer (0, 3).same_string ("000"))

			-- Format negative integer
			assert ("format_int_negative", formatter.format_integer (-5, 3).same_string ("-5"))
		end

end
