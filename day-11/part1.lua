local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local map = {}
for l in f:lines() do
	table.insert(map, l)
end

local function doRound()
	local newMap = {}
	for y, row in ipairs(map) do
		newMap[y] = row
		for x = 1, #row do
			local totalEmpty = 0
			local totalOc = 0
			if x > 1    and map[y]:sub(x-1, x-1) == "L" then totalEmpty = totalEmpty + 1 end
			if x < #row and map[y]:sub(x+1, x+1) == "L" then totalEmpty = totalEmpty + 1 end
			if y > 1    and map[y-1]:sub(x, x) == "L" then totalEmpty = totalEmpty + 1 end
			if y < #map and map[y+1]:sub(x, x) == "L" then totalEmpty = totalEmpty + 1 end
			if x > 1    and y > 1    and map[y-1]:sub(x-1, x-1) == "L" then totalEmpty = totalEmpty + 1 end
			if x < #row and y > 1    and map[y-1]:sub(x+1, x+1) == "L" then totalEmpty = totalEmpty + 1 end
			if x > 1    and y < #map and map[y+1]:sub(x-1, x-1) == "L" then totalEmpty = totalEmpty + 1 end
			if x < #row and y < #map and map[y+1]:sub(x+1, x+1) == "L" then totalEmpty = totalEmpty + 1 end

			if x > 1    and map[y]:sub(x-1, x-1) == "#" then totalOc = totalOc + 1 end
			if x < #row and map[y]:sub(x+1, x+1) == "#" then totalOc = totalOc + 1 end
			if y > 1    and map[y-1]:sub(x, x) == "#" then totalOc = totalOc + 1 end
			if y < #map and map[y+1]:sub(x, x) == "#" then totalOc = totalOc + 1 end
			if x > 1    and y > 1    and map[y-1]:sub(x-1, x-1) == "#" then totalOc = totalOc + 1 end
			if x < #row and y > 1    and map[y-1]:sub(x+1, x+1) == "#" then totalOc = totalOc + 1 end
			if x > 1    and y < #map and map[y+1]:sub(x-1, x-1) == "#" then totalOc = totalOc + 1 end
			if x < #row and y < #map and map[y+1]:sub(x+1, x+1) == "#" then totalOc = totalOc + 1 end

			if map[y]:sub(x, x) == "L" and totalOc == 0 then
				newMap[y] = newMap[y]:sub(1, x-1) .. "#" .. newMap[y]:sub(x+1, -1)
			elseif map[y]:sub(x, x) == "#" and totalOc >= 4 then
				newMap[y] = newMap[y]:sub(1, x-1) .. "L" .. newMap[y]:sub(x+1, -1)
			end
		end
	end
	return newMap
end

local function calcTotal()
	local oc = 0
	for y, row in ipairs(map) do
		for x = 1, #row do
			if map[y]:sub(x, x) == "#" then
				oc = oc + 1
			end
		end
	end
	return oc
end

local function strRound()
	local str = ""
	for y, row in ipairs(map) do
		str = str .. row .. "\n"
	end
	return str
end

local count = 0
repeat
	last = strRound()
	map = doRound()
	count = count + 1
	print(count)
until strRound() == last
print(count, calcTotal())
