local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local valid = 0
for l in f:lines() do
	local min, max, letter, pass = l:match("([0-9]*)%-([0-9]*) (.): (.*)")
	min, max = tonumber(min), tonumber(max)
	local amnt = 0
	for i = 1, #pass do
		if pass:sub(i, i) == letter then
			amnt = amnt + 1
		end
	end
	if amnt >= min and amnt <= max then
		valid = valid + 1
	end
end

print(valid)
