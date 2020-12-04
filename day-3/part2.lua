local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local map = {}

for l in f:lines() do
	table.insert(map, l:rep(1000))
end

local n = {}
local slopes = {{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}}
for _, slope in ipairs(slopes) do
	local count = 0
	for i = 1, #map, slope[2] do
		local y, x = i, 1+slope[1]/slope[2]*(i-1)
		if map[y]:sub(x, x) == "#" then
			count = count + 1
		end
	end
	table.insert(n, count)
	print(count)
end
local m = 1
for _, nn in ipairs(n) do
	m = m * nn
end
print(m)
