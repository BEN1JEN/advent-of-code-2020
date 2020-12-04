local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local map = {}

for l in f:lines() do
	table.insert(map, l:rep(100))
end

local count = 0
for i = 1, #map do
	print(map[i], 1+(3*(i-1)))
	if map[i]:sub(1+(3*(i-1)), 1+(3*(i-1))) == "#" then
		count = count + 1
	end
end
print(count)
