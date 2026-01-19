note
	description: "Cursor for iterating over SIMPLE_ZSTRING"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ZSTRING_CURSOR

inherit
	ITERATION_CURSOR [CHARACTER_32]

create
	make

feature {NONE} -- Initialization

	make (a_target: SIMPLE_ZSTRING)
			-- Create cursor for `a_target`
		require
			target_exists: a_target /= Void
		do
			target := a_target
			index := 1
		ensure
			target_set: target = a_target
			at_start: index = 1
		end

feature -- Access

	item: CHARACTER_32
			-- Current character
		do
			Result := target.item (index)
		end

feature -- Status Report

	after: BOOLEAN
			-- Is cursor past last position?
		do
			Result := index > target.count
		end

feature -- Cursor Movement

	forth
			-- Move to next position
		do
			index := index + 1
		end

feature {NONE} -- Implementation

	target: SIMPLE_ZSTRING
			-- String being iterated

	index: INTEGER
			-- Current position

end
