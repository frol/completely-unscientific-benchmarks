note
	description: "Summary description for {SPLIT_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DOUBLE_NODE

inherit ANY redefine default_create end

create
	default_create, empty, with_values

feature { ANY }

	default_create
	do
		lower := Void
		greater_equal := Void
	end

	empty
	do
		lower := Void
		greater_equal := Void
	end

	with_values(l, g: detachable NODE)
	do
		lower := l
		greater_equal := g
	end

feature { ANY }

	set_lower(to: like lower)
	do
		lower := to
	end

	set_greater_equal(to: like greater_equal)
	do
		greater_equal := to
	end

	lower: detachable NODE assign set_lower
	greater_equal: detachable NODE assign set_greater_equal

end
