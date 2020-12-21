local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local ingCounts = {}
local totalIng = {}
local totalAlr = {}
local rules = {}
for l in f:lines() do
	local ingredients, alergens = l:match("^(.*) %(contains (.*)%)$")
	local ing = {}
	local alr = {}
	for i in ingredients:gmatch("[^ ]+") do
		if not ingCounts[i] then
			ingCounts[i] = 0
		end
		ingCounts[i] = ingCounts[i] + 1
		table.insert(totalIng, i)
		ing[i] = true
	end
	for a in alergens:gmatch("[^, ]+") do
		table.insert(totalAlr, a)
		alr[a] = true
	end
	table.insert(rules, {ing=ing, alr=alr})
end

local possible = {}
for _, i in ipairs(totalIng) do
	local alrs = {}
	for _, a in ipairs(totalAlr) do
		alrs[a] = true
	end
	possible[i] = alrs
end

for _, r in ipairs(rules) do
	for i, alrs in pairs(possible) do
		if not r.ing[i] then
			for a in pairs(r.alr) do
				alrs[a] = nil
			end
		end
	end
end

local none = {}
for i, alrs in pairs(possible) do
	local any = false
	for _ in pairs(alrs) do
		any = true
		break
	end
	if not any then
		table.insert(none, i)
	end
end

local total = 0
for _, i in ipairs(none) do
	total = total + ingCounts[i]
end
print(total)
