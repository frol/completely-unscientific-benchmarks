note
	description: "Implementation of {TREAP} tree."
	author: "John Perry"
	date: "$Date$"
	revision: "$Revision$"

class TREAP

create make

feature { NONE } -- Initialization

	make
		-- initializes random number generator and subnodes
	local
		now: TIME
	do
		root := Void
		create now.make_now
		create gen.set_seed(now.minute * 60 + now.second * 360 + now.hour * 24)
	ensure
		root = Void
		gen /= Void
	end

feature { ANY } -- Modifiers

	merge(lower, greater: detachable NODE): detachable NODE
		-- merges lower and greater according to their y value
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
	ensure
		lower = Void implies Result = greater
		greater = Void implies Result = lower
		lower /= Void and then greater /= Void and then lower.y < greater.y implies Result = lower
		lower /= Void and then greater /= Void and then lower.y >= greater.y implies Result = greater
	end

	merge3(lower, eq, greater: detachable NODE): detachable NODE
	do
		Result := merge(merge(lower, eq), greater)
	ensure
		lower /= Void or eq /= Void or greater /= Void implies Result /= Void
	end

	split3(orig: detachable NODE; val: INTEGER)
			-- splits the tree into three parts:
			-- bounds.lower contains nodes with values smaller than val;
			-- bounds.greater contains nodes with values larger than val;
			-- bounds.eq contains nodes with values equal to val
	local
		greq: detachable Node
	do
		subnodes2.empty
		split(orig, Void, Void, val)
		subnodes3.lower := subnodes2.lower
		greq := subnodes2.greater_equal
		subnodes2.empty
		split(greq, Void, Void, val + 1)
		subnodes3.eq := subnodes2.lower
		-- this next line is here merely for the contract below
		if attached subnodes3.eq as seq then
			eq_x := seq.x
		end
		subnodes3.greater := subnodes2.greater_equal
	ensure
		subnodes3.eq /= Void implies eq_x = val
	end

	insert(x: INTEGER)
			-- inserts x into the tree
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
		has_value(x)
	end

	erase(x: INTEGER)
			-- erases x from the tree by rejoining the subtrees of nodes larger and smaller than it
	do
		subnodes3.empty
		split3(root, x)
		root := merge(subnodes3.lower, subnodes3.greater)
	ensure
		not has_value(x)
	end

feature { ANY } -- Queries

	has_value(x: INTEGER): BOOLEAN
			-- returns TRUE if and only if the tree has x
	do
		subnodes3.empty
		split3(root, x)
		Result := subnodes3.eq /= Void
		root := merge3(subnodes3.lower, subnodes3.eq, subnodes3.greater)
	end

feature { TREAP } -- private modifiers

	split(curr, smaller_parent, greq_parent: detachable NODE; val: INTEGER)
			-- splits tree;
			-- if curr's x is smaller than val, then we set subnodes2's lower and smaller_parent's right,
			-- then continue down to curr.right with curr in smaller_parent's place;
			-- otherwise, we set subnodes2's greater_equal and greq_parent's left,
			-- then continue down to curr.left with curr in greq_parent's place
	require
		subnodes2.lower /= Void implies smaller_parent /= Void
		subnodes2.greater_equal /= Void implies greq_parent /= Void
	do
		if curr = Void then
			if attached smaller_parent as sp then
				sp.right := Void
			end
			if attached greq_parent as gp then
				gp.left := Void
			end
		else
			if curr.x < val then
				if subnodes2.lower = Void then
					subnodes2.lower := curr
				else
					if attached smaller_parent as sp then
						sp.right := curr
					end
				end
				split(curr.right, curr, greq_parent, val)
			else
				if subnodes2.greater_equal = Void then
					subnodes2.greater_equal := curr
				else
					if attached greq_parent as gp then
						gp.left := curr
					end
				end
				split(curr.left, smaller_parent, curr, val)
			end
		end
	ensure
		curr = Void implies
				(smaller_parent = Void or else smaller_parent.right = Void) and
				(greq_parent = Void or else greq_parent.left = Void)
		curr /= Void implies
				( (curr.x < val and subnodes2.lower /= Void)
					or else (subnodes2.greater_equal /= Void) )
	end

feature { TREAP } -- Internal data

	root: detachable NODE;
	gen: RANDOM

	-- the next two fields are used to store results from split and split3, respectively
	subnodes2: DOUBLE_NODE
	subnodes3: TRIPLE_NODE

	eq_x: INTEGER -- used only to ensure a contract

end
