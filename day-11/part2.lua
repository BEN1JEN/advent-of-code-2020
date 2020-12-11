local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local map = {}
for l in f:lines() do
	table.insert(map, l)
end

local function get(x, y)
	if x > 0 and x <= #map[1] and y > 0 and y <= #map then
		return map[y]:sub(x, x)
	else
		return false
	end
end

local function findSeat(x, y, dx, dy)
	local spot
	repeat
		x = x + dx
		y = y + dy
		spot = get(x, y)
	until spot ~= "."
	return spot == "#"
end

local function doRound()
	local newMap = {}
	for y, row in ipairs(map) do
		newMap[y] = row
		for x = 1, #row do
			local totalOc = 0
			if findSeat(x, y, 1,  0)  then totalOc = totalOc + 1 end
			if findSeat(x, y, -1, 0)  then totalOc = totalOc + 1 end
			if findSeat(x, y, 0, 1)   then totalOc = totalOc + 1 end
			if findSeat(x, y, 0, -1)  then totalOc = totalOc + 1 end
			if findSeat(x, y, 1, 1)   then totalOc = totalOc + 1 end
			if findSeat(x, y, -1, 1)  then totalOc = totalOc + 1 end
			if findSeat(x, y, 1, -1)  then totalOc = totalOc + 1 end
			if findSeat(x, y, -1, -1) then totalOc = totalOc + 1 end

			if map[y]:sub(x, x) == "L" and totalOc == 0 then
				newMap[y] = newMap[y]:sub(1, x-1) .. "#" .. newMap[y]:sub(x+1, -1)
			elseif map[y]:sub(x, x) == "#" and totalOc >= 5 then
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
	print(strRound())
	print(count)
until strRound() == last
print(count, calcTotal())
