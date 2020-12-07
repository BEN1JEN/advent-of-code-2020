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
	local function getChildren(name, count)
		if not info.children[name] then
			info.children[name] = 0
		end
		info.children[name] = info.children[name] + count
		for _, child in ipairs(nodes[name]) do
			getChildren(child.type, count*child.count)
		end
	end
	getChildren(nodeType, 1)
end

print(nodes["shiny gold"])
local total = 0 -- itself
for k, v in pairs(nodes["shiny gold"].children) do
	total = total + v
end
print(total, total-1)
