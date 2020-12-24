local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

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
	local newTile = {id=tile.id}
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
	local newTile = {id=tile.id}
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
		str = tile[1]
	elseif edge == "bottom" then
		str = tile[#tile]
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

local function findAllMatches(tile, edge, checkEdge, used)
	local se = strEdge(tile, edge)
	local matches = {}
	for _, tileb in pairs(tiles) do
		if tileb.id ~= tile.id then
			for r = 0, 7 do
				local tilebrot = tileb[r>3][r%4]
				if strEdge(tilebrot, checkEdge) == se then
					if not used or not used[tileb.id] then
						table.insert(matches, {tile=tilebrot})
					end
				end
			end
		end
	end
	return matches, se
end

local start
for _, tile in pairs(tiles) do
	if #findAllMatches(tile[false][0], "right", "top") == 0 and
		#findAllMatches(tile[false][0], "left", "top") > 0 and
		#findAllMatches(tile[false][0], "top", "top") == 0 and
		#findAllMatches(tile[false][0], "bottom", "top") > 0 then
		start = {tile=tile[false][0]}
		break
	end
	if #findAllMatches(tile[false][0], "right", "top") == 0 and
		#findAllMatches(tile[false][0], "left", "top") > 0 and
		#findAllMatches(tile[false][0], "top", "top") > 0 and
		#findAllMatches(tile[false][0], "bottom", "top") == 0 then
		start = {tile=tile[false][3]}
		break
	end
	if #findAllMatches(tile[false][0], "right", "top") > 0 and
		#findAllMatches(tile[false][0], "left", "top") == 0 and
		#findAllMatches(tile[false][0], "top", "top") > 0 and
		#findAllMatches(tile[false][0], "bottom", "top") == 0 then
		start = {tile=tile[false][2]}
		break
	end
	if #findAllMatches(tile[false][0], "right", "top") > 0 and
		#findAllMatches(tile[false][0], "left", "top") == 0 and
		#findAllMatches(tile[false][0], "top", "top") == 0 and
		#findAllMatches(tile[false][0], "bottom", "top") > 0 then
		start = {tile=tile[false][1]}
		break
	end
end

local map = {{rotation=start.rotation, start}}
local used = {}
while true do
	local maptab = map[#map][#map[#map]]
	local matches = findAllMatches(maptab.tile, "left", "right", used)
	if #matches == 0 then
		local maptab = map[#map][1]
		local matches = findAllMatches(maptab.tile, "bottom", "top", used)
		if #matches > 1 then
			error("recursion time")
		elseif #matches == 0 then
			break
		end
		used[matches[1].tile.id] = true
		table.insert(map, {matches[1]})
	elseif #matches == 1 then
		used[matches[1].tile.id] = true
		table.insert(map[#map], matches[1])
	elseif #matches > 1 then
		error("recursion time")
	end
end

local width, height = 0, #map
for _, row in ipairs(map) do
	width = math.max(width, #row)
	for _, col in ipairs(row) do
		io.write(col.tile.id, " ")
	end
	io.write("\n")
end

local images = {[false]={[0]={}}, [true]={}}
for _, row in ipairs(map) do
	for y = 2, 9 do
		local str = ""
		for _, col in ipairs(row) do
			local flipStr = col.tile[y]
			for i = 9, 2, -1 do
				str = str .. flipStr:sub(i, i)
			end
		end
		table.insert(images[false][0], str)
	end
end

images[false][1] = rotateCW(images[false][0])
images[false][2] = rotateCW(images[false][1])
images[false][3] = rotateCW(images[false][2])
images[true][0] = flip(images[false][0])
images[true][1] = rotateCW(images[true][0])
images[true][2] = rotateCW(images[true][1])
images[true][3] = rotateCW(images[true][2])

local seaMonster = {
	"^..................#.",
	"^#....##....##....###",
	"^.#..#..#..#..#..#...",
}
local hashesPerMonster = 15
local function findSeaMonsters(im)
	local monsters = 0
	local seaYs = {}
	for y = 1, #im-#seaMonster+1 do
		for x = 1, #im[1] do
			local allMatches = true
			for y2 = 1, #seaMonster do
				if not im[y+y2-1]:sub(x, -1):find(seaMonster[y2]) then
					allMatches = false
				end
			end
			if allMatches then
				monsters = monsters + 1
			end
		end
	end
	return monsters
end

local monsters = 0
for _, ims in pairs(images) do
	for _, im in pairs(ims) do
		monsters = monsters + findSeaMonsters(im)
	end
end

local hashes = 0
for _, row in ipairs(images[false][0]) do
	for i = 1, #row do
		if row:sub(i, i) == "#" then
			hashes = hashes + 1
		end
	end
end
print(hashes, monsters, hashes-monsters*hashesPerMonster)
