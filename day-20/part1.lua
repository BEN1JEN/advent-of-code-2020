local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local tile = {}
local tiles = {}
for l in f:lines() do
	if l == "" then
		tiles[tile.id] = tile
		tile = {}
	elseif not tile.id then
		tile.id = tonumber(l:sub(6, 9))
	else
		table.insert(tile, l)
	end
end

local function getPixel(tile, x, y)
	return tile[y]:sub(x, x)
end

local function strEdge(tile, edge)
	local flip = false
	if edge:sub(-5, -1) == "-flip" then
		flip = true
		edge = edge:sub(1, -6)
	end
	local str = ""
	if edge == "top" then
		str = tile[#tile]
	elseif edge == "bottom" then
		str = tile[1]
	elseif edge == "left" or edge == "right" then
		local x = edge == "left" and 1 or #tile[1]
		for y = 1, #tile do
			str = str .. tile[y]:sub(x, x)
		end
	end
	if str == "" then
		error(edge)
	end
	if flip then
		local fstr = ""
		for i = 1, #str do
			fstr = str:sub(i, i) .. fstr
		end
		return fstr
	else
		return str
	end
end

local edges = {"top", "bottom", "left", "right", "top-flip", "bottom-flip", "left-flip", "right-flip"}
local function findAllMatches(tile, edge)
	local se = strEdge(tile, edge)
	local matches = {}
	for _, tileb in pairs(tiles) do
		if tileb.id ~= tile.id then
			for _, edgeb in ipairs(edges) do
				if strEdge(tileb, edgeb) == se then
					table.insert(matches, {tile=tileb, edge=edgeb, se=se})
				end
			end
		end
	end
	return matches, se
end

--print(findAllMatches(tiles[2311], "bottom"))

---[[
local corners = {}
for _, tile in pairs(tiles) do
	local n =
		(#findAllMatches(tile, "right") > 0 and 1 or 0) +
		(#findAllMatches(tile, "left") > 0 and 1 or 0) +
		(#findAllMatches(tile, "top") > 0 and 1 or 0) +
		(#findAllMatches(tile, "bottom") > 0 and 1 or 0)
	if n == 2 then
		table.insert(corners, tile)
	end
end
print(corners)
--]]
