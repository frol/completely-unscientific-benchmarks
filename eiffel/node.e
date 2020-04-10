note
	description: "{NODE} for the {TREAP} class"
	author: "John Perry"
	date: "$Date$"
	revision: "$Revision$"

class NODE

create make

feature { NONE } -- Initialization

	make(static: INTEGER; random: INTEGER)
	-- Initialization for `Current'.
	do
		x := static
		y := random
		left := Void
		right := Void
	ensure
		x = static and y = random
		left = Void and right = Void
	end

feature { ANY } -- Assignment

	set_x(val: INTEGER)
	do
		x := val
	ensure x = val
	end

	set_y(val: INTEGER)
	do
		y := val
	ensure y = val
	end

	set_left(where: detachable NODE)
	do
		left := where
	ensure left = where
	end

	set_right(where: detachable NODE)
	do
		right := where
	ensure right = where
	end

feature { ANY } -- Data

	x: INTEGER assign set_x
	y: INTEGER assign set_y
	left: detachable NODE assign set_left
	right: detachable NODE assign set_right

end
