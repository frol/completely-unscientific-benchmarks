note
	description: "Summary description for {NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NODE

create
	make

feature { NONE } -- Initialization

	make(static: INTEGER; random: INTEGER)
	-- Initialization for `Current'.
	do

		x := static
		y := random
		left := Void
		right := Void

	end

feature { ANY }

	set_x(val: INTEGER)
	do
		x := val
	end

	set_y(val: INTEGER)
	do
		y := val
	end

	set_left(where: detachable NODE)
	do
		left := where
	end

	set_right(where: detachable NODE)
	do
		right := where
	end

	left: detachable NODE assign set_left
	right: detachable NODE assign set_right
	x: INTEGER assign set_x
	y: INTEGER assign set_y

end
