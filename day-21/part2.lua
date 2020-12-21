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
local others = {}
for i, alrs in pairs(possible) do
	local alr = {}
	for a in pairs(alrs) do
		table.insert(alr, a)
	end
	if #alr == 0 then
		table.insert(none, i)
	else
		table.insert(others, {name=i, alrs=alrs})
	end
end

for j = 1, 20 do
	for i, dat in pairs(others) do
		local alrs = dat.alrs
		local count = 0
		local alr
		for a in pairs(alrs) do
			count = count + 1
			alr = a
		end
		if count == 1 then
			for i2, dat2 in pairs(others) do
				if i ~= i2 then
					dat2.alrs[alr] = nil
				end
			end
		end
	end
end
local alergens = {}
for i, dat in pairs(others) do
	local alrs = dat.alrs
	local count = 0
	local alr
	for a in pairs(alrs) do
		count = count + 1
		alr = a
	end
	if count == 1 then
		table.insert(alergens, {name=dat.name, alr=alr})
	else
		error("poo poo")
	end
end
table.sort(alergens, function(a, b)return a.alr:byte(1)+a.alr:byte(2)/128 < b.alr:byte(1)+a.alr:byte(2)/128 end)
print(alergens)
