local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local h = 0
for l in f:lines() do
	local row, col = 0, 0
	for i = 1, 7 do
		local r = 2^(7-i)
		if l:sub(i, i) == "B" then
			row = row + r
		end
	end	
	for i = 1, 3 do
		local c = 2^(3-i)
 		if l:sub(i+7, i+7) == "R" then
			col = col + c
		end
	end
	print(l, row, col, row*8+col)
	h = math.max(h, row*8+col)
end

print(h)
