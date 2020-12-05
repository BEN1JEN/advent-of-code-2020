local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local has, min, max = {}, 129, -1
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
	min = math.min(min, row*8+col)
	max = math.max(max, row*8+col)
	has[row*8+col] = true
end

for thing = min, max do
	if not has[thing] then
		print(thing)
	end
end

print(h)
