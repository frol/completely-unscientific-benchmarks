#!/usr/bin/env lua

local Node = {}
Node.__index = Node
setmetatable(Node, {
    __call = function(cls, x)
        local self = setmetatable({}, cls)
        self.x = x
        self.y = math.random(0, 2^31)
        self.left = nil
        self.right = nil
        return self
    end
})

local function merge(lower, greater)
    if not lower then
        return greater
    end
    
    if not greater then
        return lower
    end
    
    if lower.y < greater.y then
        lower.right = merge(lower.right, greater)
        return lower
    else
        greater.left = merge(lower, greater.left)
        return greater
    end
end

local function split_binary(orig, value)
    if not orig then
        return nil, nil
    end
    
    if orig.x < value then
        local origRight, origLeft = split_binary(orig.right, value)
        orig.right = origRight
        return orig, origLeft
    else
        local origRight, origLeft = split_binary(orig.left, value)
        orig.left = origLeft
        return origRight, orig
    end
end

local function merge3(lower, equal, greater)
    return merge(merge(lower, equal), greater)
end

local function split(orig, value)
    local lower, equalGreater = split_binary(orig, value)
    local equal, greater = split_binary(equalGreater, value + 1)
    return {
        lower = lower,
        equal = equal,
        greater = greater
    }
end

local Tree = {}
Tree.__index = Tree
function Tree:has_value(x)
    local splited = split(self.root, x)
    local res = splited.equal ~= nil
    self.root = merge3(splited.lower, splited.equal, splited.greater)
    return res
end

function Tree:insert(x)
    local splited = split(self.root, x)
    if not splited.equal then
        splited.equal = Node(x)
    end
    self.root = merge3(splited.lower, splited.equal, splited.greater)
end

function Tree:erase(x)
    local splited = split(self.root, x)
    self.root = merge(splited.lower, splited.greater)
end

setmetatable(Tree, {
    __call = function(cls)
        local self = setmetatable({}, Tree)
        self.root = nil
        return self
    end
})

local function main()
    local tree = Tree()
    local cur = 5
    local res = 0
    
    for i = 1, 1000000 do
        local a = i % 3
        cur = (cur * 57 + 43) % 10007
        if a == 0 then
            tree:insert(cur)
        elseif a == 1 then
            tree:erase(cur)
        elseif a == 2 then
            if tree:has_value(cur) then
                res = res + 1
            end
        end
    end
    print(res)
end

main()
