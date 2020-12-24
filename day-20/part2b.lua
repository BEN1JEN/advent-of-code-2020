local lib = require "lib"
local arg = {...}

f = io.open("data-test.txt", "r")

local tile = {}
local tiles = {}
for l in f:lines() do
	if l == "" then
		tiles[tile.id] = {id=tile.id, [false]={[0]=tile}, [true]={}}
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

local function rotateCW(tile)
	local newTile = {}
	for y = 1, #tile[1] do
		local str = ""
		for x = 1, #tile do
			str = str .. getPixel(tile, y, #tile-x+1)
		end
		table.insert(newTile, str)
	end
	return newTile
end

local function flip(tile)
	local newTile = {}
	for y = 1, #tile[1] do
		local str = ""
		for x = 1, #tile do
			str = str .. getPixel(tile, x, #tile-y+1)
		end
		table.insert(newTile, str)
	end
	return newTile
end

for _, tile in pairs(tiles) do
	tile[false][1] = rotateCW(tile[false][0])
	tile[false][2] = rotateCW(tile[false][1])
	tile[false][3] = rotateCW(tile[false][2])
	tile[true][0] = flip(tile[false][0])
	tile[true][1] = rotateCW(tile[true][0])
	tile[true][2] = rotateCW(tile[true][1])
	tile[true][3] = rotateCW(tile[true][2])
end

local function findAllMatches(tile, edgeRot, edgeFlip, used)
	local se = tile[edgeFlip][edgeRot][1]
	local matches = {}
	for _, tileb in pairs(tiles) do
		if tileb.id ~= tile.id then
			for r = 0, 7 do
				if tileb[r>3][r%4][1] == se then
					if not used or not used[tileb.id] then
						table.insert(matches, {tile=tileb, edge=r%4, flip=r>3})
					else
						print("nom", tileb.id)
					end
				end
			end
		end
	end
	return matches, se
end

local start
for _, tile in pairs(tiles) do
	if #findAllMatches(tile, 3, false) == 0 and
		#findAllMatches(tile, 0, false) == 0 and
		#findAllMatches(tile, 1, false) > 0 and
		#findAllMatches(tile, 2, false) > 0 then
		start = {tile=tile, edge=3, flip=false}
		break
	end
	if #findAllMatches(tile, 3, false) > 0 and
		#findAllMatches(tile, 0, false) > 0 and
		#findAllMatches(tile, 1, false) == 0 and
		#findAllMatches(tile, 2, false) == 0 then
		start = {tile=tile, edge=1, flip=false}
		break
	end
	if #findAllMatches(tile, 3, false) > 0 and
		#findAllMatches(tile, 0, false) == 0 and
		#findAllMatches(tile, 1, false) == 0 and
		#findAllMatches(tile, 2, false) > 0 then
		start = {tile=tile, edge=0, flip=false}
		break
	end
	if #findAllMatches(tile, 3, false) == 0 and
		#findAllMatches(tile, 0, false) > 0 and
		#findAllMatches(tile, 1, false) > 0 and
		#findAllMatches(tile, 2, false) == 0 then
		start = {tile=tile, edge=2, flip=false}
		break
	end
end

local map = {{edge=start.edge, start}}
local used = {}
while true do
	local maptab = map[#map][#map[#map]]
	local matches = findAllMatches(maptab.tile, (maptab.edge+2)%4, maptab.flip, used)
	if #matches == 0 then
		local maptab = map[#map][1]
		local matches = findAllMatches(maptab.tile, (maptab.edge-1)%4, maptab.flip, used)
		if #matches > 1 then
			error("recursion time")
		elseif #matches == 0 then
			break
		end
		used[matches[1].tile.id] = true
		matches[1].edge = (matches[1].edge-1)%4
		matches[1].flip = not matches[1].flip
		table.insert(map, {edge=matches[1].flip, matches[1]})
	elseif #matches == 1 then
		used[matches[1].tile.id] = true
		table.insert(map[#map], matches[1])
	elseif #matches > 1 then
		error("recursion time")
	end
end

for _, row in ipairs(map) do
	for _, col in ipairs(row) do
		io.write(col.tile.id, " ")
	end
	io.write(" ", tostring(row.edge))
	io.write("\n")
end
