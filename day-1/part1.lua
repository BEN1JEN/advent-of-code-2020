local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local entries = {}
for l in f:lines() do
	table.insert(entries, tonumber(l))
end
for i1, v1 in ipairs(entries) do
	for i2, v2 in ipairs(entries) do
		if i1 ~= i2 and v1+v2 == 2020 then
			print(v1*v2)
			os.exit()
		end
	end
end

