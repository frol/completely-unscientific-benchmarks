note
	description: "Summary description for {SPLIT3_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRIPLE_NODE

inherit ANY redefine default_create end

create
	default_create, empty, with_values

feature { ANY } -- Initialization

	default_create
	do
		lower := Void
		eq := Void
		greater := Void
	end

	empty
			-- Initialization for `Current'.
		do
			lower := Void
			eq := Void
			greater := Void
		end

	with_values(l, e, g: detachable NODE)
	do
		lower := l
		eq := e
		greater := g
	end

feature { ANY }

	set_lower(val: detachable NODE)
	do
		lower := val
	end

	set_equal(val: detachable NODE)
	do
		eq := val
	end

	set_greater(val: detachable NODE)
	do
		greater := val
	end

	lower: detachable NODE assign set_lower
	eq: detachable NODE assign set_equal
	greater: detachable NODE assign set_greater

end
