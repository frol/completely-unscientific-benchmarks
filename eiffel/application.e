note
	description: "Treap application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
	local
		t: TREE2
		i, res, cur, mode: INTEGER
	do
		create t.make
		from
			i := 1
			cur := 5
			res := 0
		until i = 1000000
		loop
			mode := i \\ 3
			cur := (cur * 57 + 43) \\ 10007
			if mode = 0 then
				t.insert (cur)
			elseif mode = 1 then
				t.erase (cur)
			else
				res := res + t.has_value (cur)
			end
			i := i + 1
		end
		print(res)
	end

end
