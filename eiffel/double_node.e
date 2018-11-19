note
	description: "used to pass two {NODE}s between functions in a way that they can be changed."
	author: "John Perry"
	date: "$Date$"
	revision: "$Revision$"

expanded class DOUBLE_NODE

inherit ANY redefine default_create end

create empty, default_create

feature { ANY } -- Initialization

	empty
	do
		lower := Void
		greater_equal := Void
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
		Result := lower = Void and greater_equal = Void
	end

feature { ANY } -- Assignment

	set_lower(to: like lower)
	do
		lower := to
	end

	set_greater_equal(to: like greater_equal)
	do
		greater_equal := to
	end

feature { ANY } -- Data

	lower: detachable NODE assign set_lower
	greater_equal: detachable NODE assign set_greater_equal

end
