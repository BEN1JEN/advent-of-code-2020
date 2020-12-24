local lib = require "lib"
local arg = {...}

local function str(x, y)
	return tostring(x) .. "," .. tostring(y)
end

f = io.open("data.txt", "r")
--  . . w . .   . .
-- .-2-. .-31. .-53.
--  . .-20. .-32. .
-- .-1-. .-21. .-43.
--  . .-10. .-22. .
-- .0-1. .-11. .-33.
--s . .0 0. .-12. . n
-- .1-1. .0 1. .-23.
--  . . e . .   . .
local map = {}
for l in f:lines() do
	local x, y = 0, 0
	local i = 1
	while i <= #l do
		-- nw, w, sw, e, e
		-- 1x-1, 0x-1, 
		if l:sub(i, i+1) == "ne" then
			y = y + 1
			i = i + 2
		elseif l:sub(i, i+1) == "nw" then
			x, y = x-1, y+1
			i = i + 2
		elseif l:sub(i, i+1) == "se" then
			x, y = x+1, y-1
			i = i + 2
		elseif l:sub(i, i+1) == "sw" then
			y = y - 1
			i = i + 2
		elseif l:sub(i, i) == "e" then
			x = x + 1
			i = i + 1
		elseif l:sub(i, i) == "w" then
			x = x - 1
			i = i + 1
		else
			error(l, i)
		end
	end
	local pos = str(x, y)
	map[pos] = not map[pos]
end

local directions = {
	{x= 0, y= 1},
	{x=-1, y= 1},
	{x= 1, y=-1},
	{x= 0, y=-1},
	{x= 1, y= 0},
	{x=-1, y= 0},
}

for i = 1, 100 do
	local newMap = {}
	local toUpdate = {}
	for pos, flipped in pairs(map) do
		toUpdate[pos] = flipped
		local x, y = pos:match("([%-0-9]+),([%-0-9]+)")
		x, y = tonumber(x), tonumber(y)
		for _, dir in ipairs(directions) do
			local dx, dy = x+dir.x, y+dir.y
			local pos = str(dx, dy)
			if not map[pos] then
				toUpdate[pos] = false
			end
		end
	end
	for pos, flipped in pairs(toUpdate) do
		local x, y = pos:match("([%-0-9]+),([%-0-9]+)")
		x, y = tonumber(x), tonumber(y)
		local surrounding = 0
		for _, dir in ipairs(directions) do
			local dx, dy = x+dir.x, y+dir.y
			if map[str(dx, dy)] then
				surrounding = surrounding + 1
			end
		end
		if flipped and (surrounding == 0 or surrounding > 2) then
			newMap[pos] = false
		elseif (surrounding == 2) then
			newMap[pos] = true
		else
			newMap[pos] = flipped
		end
	end
	map = newMap
	print(i)
end

local count = 0
for pos, dir in pairs(map) do
	if dir then
		count = count + 1
	end
end

print(count)
