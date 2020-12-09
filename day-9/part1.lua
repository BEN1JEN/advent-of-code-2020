local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local numbers = {}
for l in f:lines() do
	table.insert(numbers, tonumber(l))
end

for i = 26, #numbers do
	local valid = false
	for j = i-25, i-1 do
		for k = i-25, i-1 do
			if j ~= k then
				if numbers[j]+numbers[k] == numbers[i] then
					valid = true
					break
				end
			end
		end
		if valid then
			break
		end
	end
	if not valid then
		print(i, numbers[i])
		break
	end
end
