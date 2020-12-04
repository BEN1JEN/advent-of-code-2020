local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local function xor(a, b)
	return (a or b) and not (a and b)
end

local valid = 0
for l in f:lines() do
	local a, b, letter, pass = l:match("([0-9]*)%-([0-9]*) (.): (.*)")
	a, b = tonumber(a), tonumber(b)
	if xor(pass:sub(a, a) == letter, pass:sub(b, b) == letter) then
		valid = valid + 1
	end
end

print(valid)
