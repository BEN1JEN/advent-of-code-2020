local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local list = {}
for l in f:lines() do
	table.insert(list, tonumber(l))
end
table.sort(list)
print(list)
local last = 0
local gap1, gap3 = 0, 1
for _, v in ipairs(list) do
	local gap = v-last
	if gap == 1 then
		gap1 = gap1 + 1
	elseif gap == 3 then
		gap3 = gap3 + 1
	else
		print(gap)
	end
	last = v
end

print(gap1, gap3, gap1*gap3)
