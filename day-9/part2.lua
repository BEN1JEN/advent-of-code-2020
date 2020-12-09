local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local numbers = {}
for l in f:lines() do
	table.insert(numbers, tonumber(l))
end

local invalid = 0
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
		invalid = numbers[i]
		break
	end
end
local rs, re = 0, 0
local done = false
for i = 1, #numbers do
	local sum = 0
	for j = i, #numbers do
		sum = sum + numbers[j]
		if sum == invalid then
			rs, re = i, j
			done = true
			break
		end
	end
	if done then
		break
	end
end
print(rs, re)
local min, max = math.huge, -1
for i = rs, re do
	min = math.min(numbers[i], min)
	max = math.max(numbers[i], max)
end
print(min, max, min+max)
