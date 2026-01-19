note
	description: "Tests for simple_zstring library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ZSTRING_TESTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run all tests
		do
			create test_count.put (0)
			create pass_count.put (0)
			create fail_count.put (0)

			print ("simple_zstring Test Suite%N")
			print ("========================%N%N")

			run_zstring_core_tests
			run_codec_tests
			run_splitter_tests
			run_escaper_tests
			run_editor_tests
			run_formatter_tests
			run_searcher_tests
			run_builder_tests

			print ("%N========================%N")
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
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Infrastructure

	test_count: CELL [INTEGER]
	pass_count: CELL [INTEGER]
	fail_count: CELL [INTEGER]

	assert (a_name: STRING; a_condition: BOOLEAN)
			-- Assert `a_condition` is true, report result
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
			-- Start a new test section
		do
			print ("%N" + a_name + "%N")
			print (create {STRING}.make_filled ('-', a_name.count))
			print ("%N")
		end

feature {NONE} -- ZSTRING Core Tests

	run_zstring_core_tests
		local
			z, z2: SIMPLE_ZSTRING
			l_emoji: CHARACTER_32
			l_count: INTEGER
		do
			section ("ZSTRING Core Tests")

			-- test_make_empty
			create z.make_empty
			assert ("make_empty is empty", z.is_empty)
			assert ("make_empty count zero", z.count = 0)

			-- test_make_with_capacity
			create z.make (100)
			assert ("make capacity empty", z.is_empty)
			assert ("make capacity set", z.capacity >= 100)

			-- test_make_from_string
			create z.make_from_string ("Hello World")
			assert ("make_from_string count", z.count = 11)
			assert ("make_from_string content", z.to_string_32.same_string ("Hello World"))

			-- test_make_from_string_8
			create z.make_from_string_8 ("ASCII text")
			assert ("make_from_string_8 count", z.count = 10)
			assert ("make_from_string_8 is_ascii", z.is_ascii)

			-- test_latin_characters (UTF-8 encoded source)
			create z.make_from_utf_8 ("Héllo Wörld")
			assert ("latin count", z.count = 11)
			assert ("latin no mixed", not z.has_mixed_encoding)

			-- test_euro_sign (UTF-8 encoded source)
			create z.make_from_utf_8 ("Price: 100€")
			assert ("euro count", z.count = 11)
			assert ("euro no mixed", not z.has_mixed_encoding)

			-- test_unicode_emoji
			l_emoji := (0x1F600).to_character_32
			create z.make_from_string ("Hi ")
			z.append_character (l_emoji)
			assert ("emoji count", z.count = 4)
			assert ("emoji has mixed", z.has_mixed_encoding)
			assert ("emoji stored", z.item (4) = l_emoji)

			-- test_append_character
			create z.make_empty
			z.append_character ('A')
			z.append_character ('B')
			z.append_character ('C')
			assert ("append_char count", z.count = 3)
			assert ("append_char content", z.to_string_32.same_string ("ABC"))

			-- test_put
			create z.make_from_string ("ABC")
			z.put ('X', 2)
			assert ("put", z.to_string_32.same_string ("AXC"))

			-- test_insert_character
			create z.make_from_string ("AC")
			z.insert_character ('B', 2)
			assert ("insert count", z.count = 3)
			assert ("insert content", z.to_string_32.same_string ("ABC"))

			-- test_remove
			create z.make_from_string ("ABCD")
			z.remove (2)
			assert ("remove count", z.count = 3)
			assert ("remove content", z.to_string_32.same_string ("ACD"))

			-- test_substring
			create z.make_from_string ("Hello World")
			z2 := z.substring (1, 5)
			assert ("substring count", z2.count = 5)
			assert ("substring content", z2.to_string_32.same_string ("Hello"))

			-- test_wipe_out
			create z.make_from_string ("Hello")
			z.wipe_out
			assert ("wipe_out empty", z.is_empty)

			-- test_is_equal
			create z.make_from_string ("Test")
			create z2.make_from_string ("Test")
			assert ("is_equal", z.is_equal (z2))

			-- test_is_less
			create z.make_from_string ("ABC")
			create z2.make_from_string ("ABD")
			assert ("is_less", z < z2)

			-- test_utf8_conversion
			create z.make_from_utf_8 ("Héllo")
			create z2.make_from_utf_8 (z.to_utf_8)
			assert ("utf8 roundtrip", z2.to_string_32.same_string (z.to_string_32))

			-- test_iteration
			create z.make_from_string ("ABC")
			l_count := 0
			across z as ic loop
				l_count := l_count + 1
			end
			assert ("iteration count", l_count = 3)
		end

feature {NONE} -- Codec Tests

	run_codec_tests
		local
			codec: SIMPLE_ISO_8859_15_ZCODEC
			l_euro: CHARACTER_32
		do
			section ("Codec Tests")

			create codec
			assert ("codec name", codec.name.same_string ("ISO-8859-15"))
			assert ("encode A", codec.encoded_character ('A') = 'A')
			assert ("encode 0", codec.encoded_character ('0') = '0')

			l_euro := (0x20AC).to_character_32
			assert ("can encode euro", codec.can_encode (l_euro))
			assert ("encode euro", codec.encoded_character (l_euro) = (0xA4).to_character_8)
			assert ("decode A", codec.decoded_character ('A') = 'A')
			assert ("decode euro", codec.decoded_character ((0xA4).to_character_8) = l_euro)
		end

feature {NONE} -- Splitter Tests

	run_splitter_tests
		local
			splitter: SIMPLE_ZSTRING_SPLITTER
			parts: ARRAYED_LIST [STRING_32]
		do
			section ("Splitter Tests")

			create splitter

			parts := splitter.split_by_character ("a,b,c", ',')
			assert ("split_by_char count", parts.count = 3)
			assert ("split_by_char first", parts [1].same_string ("a"))
			assert ("split_by_char third", parts [3].same_string ("c"))

			parts := splitter.split_lines ("line1%Nline2%Nline3")
			assert ("split_lines count", parts.count = 3)

			parts := splitter.split_words ("  hello   world  ")
			assert ("split_words count", parts.count = 2)
			assert ("split_words first", parts [1].same_string ("hello"))
		end

feature {NONE} -- Escaper Tests

	run_escaper_tests
		local
			escaper: SIMPLE_ZSTRING_ESCAPER
		do
			section ("Escaper Tests")

			create escaper

			assert ("escape_xml lt", escaper.escape_xml ("<").same_string ("&lt;"))
			assert ("escape_xml gt", escaper.escape_xml (">").same_string ("&gt;"))
			assert ("escape_xml amp", escaper.escape_xml ("&").same_string ("&amp;"))

			assert ("unescape_xml lt", escaper.unescape_xml ("&lt;").same_string ("<"))
			assert ("unescape_xml numeric", escaper.unescape_xml ("&#65;").same_string ("A"))

			assert ("escape_json quote", escaper.escape_json ("%"").same_string ("\%""))
			assert ("escape_json newline", escaper.escape_json ("%N").same_string ("\n"))

			assert ("url_encode space", escaper.url_encode (" ").same_string ("%%20"))
			assert ("url_encode safe", escaper.url_encode ("abc").same_string ("abc"))
		end

feature {NONE} -- Editor Tests

	run_editor_tests
		local
			editor: SIMPLE_ZSTRING_EDITOR
			s: STRING_32
		do
			section ("Editor Tests")

			create editor

			s := "  hello  "
			editor.trim (s)
			assert ("trim", s.same_string ("hello"))

			s := "aXbXc"
			editor.replace_all (s, "X", "Y")
			assert ("replace_all", s.same_string ("aYbYc"))

			s := "hello world"
			editor.to_title_case (s)
			assert ("title_case", s.same_string ("Hello World"))
		end

feature {NONE} -- Formatter Tests

	run_formatter_tests
		local
			formatter: SIMPLE_ZSTRING_FORMATTER
			values: HASH_TABLE [STRING_32, STRING_32]
			parts: ARRAYED_LIST [STRING_32]
		do
			section ("Formatter Tests")

			create formatter

			assert ("pad_left", formatter.pad_left ("5", 3, '0').same_string ("005"))
			assert ("pad_right", formatter.pad_right ("5", 3, '0').same_string ("500"))
			assert ("center", formatter.center ("X", 5, '-').same_string ("--X--"))

			create values.make (2)
			values.put ("World", "name")
			assert ("substitute", formatter.substitute ("Hello ${name}!", values).same_string ("Hello World!"))

			create parts.make (3)
			parts.extend ("a")
			parts.extend ("b")
			parts.extend ("c")
			assert ("join", formatter.join (parts, ", ").same_string ("a, b, c"))
		end

feature {NONE} -- Searcher Tests

	run_searcher_tests
		local
			searcher: SIMPLE_ZSTRING_SEARCHER
		do
			section ("Searcher Tests")

			create searcher

			assert ("index_of found", searcher.index_of ("hello world", "world", 1) = 7)
			assert ("index_of not found", searcher.index_of ("hello", "world", 1) = 0)
			assert ("occurrence_count", searcher.occurrence_count ("ababa", "ab") = 2)
			assert ("matches_wildcard star", searcher.matches_wildcard ("hello.txt", "*.txt"))
			assert ("matches_wildcard question", searcher.matches_wildcard ("abc", "a?c"))
			assert ("starts_with", searcher.starts_with ("hello world", "hello"))
			assert ("ends_with", searcher.ends_with ("hello world", "world"))
		end

feature {NONE} -- Builder Tests

	run_builder_tests
		local
			builder: SIMPLE_ZSTRING_BUILDER
			ignore: SIMPLE_ZSTRING_BUILDER
		do
			section ("Builder Tests")

			create builder.make
			ignore := builder.append ("Hello").append_space.append ("World")
			assert ("builder append", builder.to_string_32.same_string ("Hello World"))

			create builder.make
			ignore := builder.append ("Name: ").append ("Test").append_new_line.append ("Age: ").append_integer (42)
			assert ("builder chaining", not builder.is_empty)

			create builder.make
			ignore := builder.append ("Hello")
			builder.clear
			assert ("builder clear", builder.is_empty)
		end

end
