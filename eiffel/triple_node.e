note
	description: "used to pass information on three {NODE}s between functions"
	author: "John Perry"
	date: "$Date$"
	revision: "$Revision$"

expanded class TRIPLE_NODE

inherit ANY redefine default_create end

create empty, default_create

feature { ANY } -- Initialization

	empty
			-- Initialization for `Current'.
		do
			lower := Void
			eq := Void
			greater := Void
		ensure
			is_empty
		end

	default_create
	do
		empty
	end

feature { ANY } -- Queries

	is_empty: BOOLEAN
	do
		Result := lower = Void and eq = Void and greater = Void
	ensure
		Result implies (lower = Void and eq = Void and greater = Void)
	end

feature { ANY } -- Assignment

	set_lower(val: detachable NODE)
	do
		lower := val
	ensure lower = val
	end

	set_equal(val: detachable NODE)
	do
		eq := val
	ensure eq = val
	end

	set_greater(val: detachable NODE)
	do
		greater := val
	ensure greater = val
	end

feature { ANY } -- Data

	lower: detachable NODE assign set_lower
	eq: detachable NODE assign set_equal
	greater: detachable NODE assign set_greater

end
