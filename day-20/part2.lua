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

local edges = {"top", "bottom", "left", "right", "top-flip", "bottom-flip", "left-flip", "right-flip"}
local function findAllMatches(tile, edge, used)
	local se = strEdge(tile, edge)
	local matches = {}
	for _, tileb in pairs(tiles) do
		if tileb.id ~= tile.id then
			for _, edgeb in ipairs(edges) do
				if strEdge(tileb, edgeb) == se then
					if not used or not used[tileb.id] then
						table.insert(matches, {tile=tileb, edge=edgeb})
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
	if #findAllMatches(tile, "right") == 0 and
		#findAllMatches(tile, "top") == 0 and
		#findAllMatches(tile, "left") > 0 and
		#findAllMatches(tile, "bottom") > 0 then
		start = {tile=tile, edge="right"}
		break
	end
	if #findAllMatches(tile, "right") > 0 and
		#findAllMatches(tile, "top") > 0 and
		#findAllMatches(tile, "left") == 0 and
		#findAllMatches(tile, "bottom") == 0 then
		start = {tile=tile, edge="left"}
		break
	end
	if #findAllMatches(tile, "right") > 0 and
		#findAllMatches(tile, "top") == 0 and
		#findAllMatches(tile, "left") == 0 and
		#findAllMatches(tile, "bottom") > 0 then
		start = {tile=tile, edge="top"}
		break
	end
	if #findAllMatches(tile, "right") == 0 and
		#findAllMatches(tile, "top") > 0 and
		#findAllMatches(tile, "left") > 0 and
		#findAllMatches(tile, "bottom") == 0 then
		start = {tile=tile, edge="bottom"}
		break
	end
end

print("start", start.tile.id)

local map = {{start, edge=""}}
local used = {}

--[[
local rotateStr = {
	["right"] = "left",
	["left"] = "right-flip",
	["top"] = "bottom-flip",
	["bottom"] = "top",
	["right-flip"] = "left-flip",
	["left-flip"] = "right",
	["top-flip"] = "bottom",
	["bottom-flip"] = "top-flip",
}
local rotateCWStr = {
	["right"] = "bottom",
	["left"] = "top-flip",
	["top"] = "right",
	["bottom"] = "left-flip",
	["right-flip"] = "top-flip",
	["left-flip"] = "bottom",
	["top-flip"] = "left-flip",
	["bottom-flip"] = "right",
}
--]]

local rotateStr = {
	["right"] = "left",
	["left"] = "right",
	["top"] = "bottom",
	["bottom"] = "top",
	["right-flip"] = "left-flip",
	["left-flip"] = "right-flip",
	["top-flip"] = "bottom-flip",
	["bottom-flip"] = "top-flip",
}
local rotateCWStr = {
	["right"] = "bottom",
	["left"] = "top-flip",
	["top"] = "right-flip",
	["bottom"] = "left",
	["right-flip"] = "top",
	["left-flip"] = "bottom-flip",
	["top-flip"] = "left-flip",
	["bottom-flip"] = "right",
}
local rotateCCWStr = {
	["right"] = "bottom-flip",
	["left"] = "bottom",
	["top"] = "right",
	["bottom"] = "right",
	["right-flip"] = "bottom",
	["left-flip"] = "top",
	["top-flip"] = "right-flip",
	["bottom-flip"] = "left-flip",
}
while true do
	local maptab = map[#map][#map[#map]]
	local matches = findAllMatches(tiles[maptab.tile.id], rotateStr[maptab.edge], used)
	if #matches == 0 then
		local maptab = map[#map][1]
		local matches = findAllMatches(tiles[maptab.tile.id], rotateCWStr[maptab.edge], used)
		print(rotateCWStr[maptab.edge], #map)
		if #matches > 1 then
			error("recursion time")
		elseif #matches == 0 then
			break
		end
		used[matches[1].tile.id] = true
		matches[1].edge = rotateCWStr[matches[1].edge]
		table.insert(map, {edge=rotateCWStr[maptab.edge], matches[1]})
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
	io.write("\t", row.edge)
	io.write("\n")
end
