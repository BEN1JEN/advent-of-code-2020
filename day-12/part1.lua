local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local x, y, direction = 0, 0, 0
for l in f:lines() do
	local d, n = l:sub(1, 1), tostring(l:sub(2, -1))
	if d == "N" then
		y = y + n
	elseif d == "S" then
		y = y - n
	elseif d == "E" then
		x = x + n
	elseif d == "W" then
		x = x - n
	elseif d == "F" then
		if direction == 0 then
			x = x + n
		elseif direction == 1 then
			y = y - n
		elseif direction == 2 then
			x = x - n
		elseif direction == 3 then
			y = y + n
		end
	elseif d == "R" then
		direction = (direction + n/90)%4
	elseif d == "L" then
		direction = (direction - n/90)%4
	end
	print(x, y)
end

print(x, y, math.abs(x)+math.abs(y), direction)
