note
	description: "Summary description for {TREE2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE2

inherit
  MEMORY

create
	make

feature { NONE } -- Initialization

	make
	local
		now: TIME
	do
		root := Void
		create now.make_now
		create gen.set_seed(now.minute * 60 + now.second * 360 + now.hour * 24)
	end

feature { ANY }

	merge(lower, greater: detachable NODE): detachable NODE
	do
		if lower = Void or greater = Void then
			if lower = Void then
				Result := greater
			else
				Result := lower
			end
		elseif lower.y < greater.y then
			lower.right := merge(lower.right, greater)
			Result := lower
		else
			greater.left := merge(lower, greater.left)
			Result := greater
		end
	end

	merge3(lower, eq, greater: detachable NODE): detachable NODE
	do
		Result := merge(merge(lower, eq), greater)
	end

	split(orig: detachable NODE; val: INTEGER)
	local
		lower, greater: NODE
	do
		if orig = Void then
			subnodes2.lower := Void
			subnodes2.greater_equal := Void
		elseif orig.x < val then
			lower := orig
			subnodes2.lower := lower.right
			split(lower.right, val)
			lower.right := subnodes2.lower
			subnodes2.lower := lower
		else
			greater := orig
			subnodes2.greater_equal := greater.left
			split(greater.left, val)
			greater.left := subnodes2.greater_equal
			subnodes2.greater_equal := greater
		end
	end

	split3(orig: detachable NODE; val: INTEGER)
	local
		equal_or_greater: NODE
	do
		subnodes2.with_values(subnodes3.lower, Void)
		split(orig, val)
		subnodes3.lower := subnodes2.lower
		equal_or_greater := subnodes2.greater_equal
		subnodes2.with_values (subnodes3.eq, subnodes3.greater)
		split(equal_or_greater, val + 1)
		subnodes3.eq := subnodes2.lower
		subnodes3.greater := subnodes2.greater_equal
	end

	has_value(x: INTEGER): INTEGER
	do
		subnodes3.empty
		split3(root, x)
		if subnodes3.eq = Void then
			Result := 0
		else
			Result := 1
		end
		root := merge3(subnodes3.lower, subnodes3.eq, subnodes3.greater)
	end

	insert(x: INTEGER)
	local
		eq: NODE
	do
		subnodes3.empty
		split3(root, x)
		if subnodes3.eq = Void then
			gen.forth
			create eq.make (x, gen.item)
			subnodes3.eq := eq
		end
		root := merge3(subnodes3.lower, subnodes3.eq, subnodes3.greater)
	ensure
		has_value(x) = 1
	end

	erase(x: INTEGER)
	do
		subnodes3.empty
		split3(root, x)
		root := merge(subnodes3.lower, subnodes3.greater)
	ensure
		has_value(x) = 0
	end

feature { TREE2 }

	root: detachable NODE;
	gen: RANDOM
	subnodes2: expanded DOUBLE_NODE
	subnodes3: expanded TRIPLE_NODE

end
