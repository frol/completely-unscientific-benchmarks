note
	description: "Treap application root class"
	date: "$Date$"
	revision: "$Revision$"
	author: "John Perry"

class APPLICATION

create make

feature {NONE} -- Initialization

	make
	local
		t: TREAP
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
				res := res + (if t.has_value (cur) then 1 else 0 end)
			end
			i := i + 1
		end
		print(res)
	end

end
