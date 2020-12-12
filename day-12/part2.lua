local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local x, y = 10, 1
local sx, sy = 0, 0
for l in f:lines() do
	local d, n = l:sub(1, 1), tonumber(l:sub(2, -1))
	if d == "N" then
		y = y + n
	elseif d == "S" then
		y = y - n
	elseif d == "E" then
		x = x + n
	elseif d == "W" then
		x = x - n
	elseif d == "F" then
		sx = sx + x*n
		sy = sy + y*n
	elseif d == "R" then
		for i = 1, n/90 do
			x, y = y, -x
		end
	elseif d == "L" then
		for i = 1, n/90 do
			x, y = -y, x
		end
	end
	print(l, "->")
	print(sx, sy, x, y)
end

print(sx, sy, math.abs(sx)+math.abs(sy))
