local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local nodes = {}
local parents = {}
for l in f:lines() do
	local leaf = l:match("^([^ ]+ [^ ]+) bags contain no other bags")
	local branch, subNodes = l:match("^([^ ]+ [^ ]+) bags contain (.*)")
	nodes[branch] = {children={}}
	if not leaf then
		for subNodeCount, subNodeType in subNodes:gmatch("([0-9]+) ([^,]-) bag") do
			table.insert(nodes[branch], {count=tonumber(subNodeCount), type=subNodeType})
			if not parents[subNodeType] then
				parents[subNodeType] = {}
			end
			table.insert(parents[subNodeType], branch)
		end
	end
end

for nodeType, info in pairs(nodes) do
	local function getChildren(name)
		info.children[name] = true
		for _, child in ipairs(nodes[name]) do
			getChildren(child.type)
		end
	end
	getChildren(nodeType)
end

local count = 0
for nodeType, info in pairs(nodes) do
	if info.children["shiny gold"] then
		count = count + 1
		print(nodeType, info)
	end
end

print(count, count-1)
