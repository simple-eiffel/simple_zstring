note
	description: "Combined test runner for simple_zstring"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_RUNNER

create
	make

feature {NONE} -- Initialization

	make
			-- Run all tests
		local
			main_tests: ZSTRING_TESTS
			adversarial: ADVERSARIAL_TESTS
		do
			print ("===============================================%N")
			print ("        SIMPLE_ZSTRING FULL TEST SUITE         %N")
			print ("===============================================%N%N")

			print (">>> Running Main Tests...%N")
			create main_tests.make

			print ("%N>>> Running Adversarial Tests...%N")
			create adversarial.make

			print ("%N===============================================%N")
			print ("           ALL TEST SUITES COMPLETE             %N")
			print ("===============================================%N")
		end

end
