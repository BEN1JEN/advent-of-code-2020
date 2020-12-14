local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local mem = {}
local function doMask(mask, num)
	local out = 0
	for i = 0, 35 do
		local bit = mask:sub(36-i, 36-i)
		if bit == "1" then
			out = out | (1<<i)
		elseif bit == "X" then
			out = out | (((num>>i)&1)<<i)
		elseif bit ~= "0" then
			error("badmask" .. bit)
		end
	end
	return out
end

local mask = ""
for l in f:lines() do
	if l:sub(1, 7) == "mask = " then
		mask = l:sub(8, -1)
	else
		local addr, num = l:match("^mem%[([0-9]+)%] = ([0-9]+)$")
		addr, num = tonumber(addr), tonumber(num)
		local num = doMask(mask, num)
		mem[addr] = num
	end
end

print(mem)
local total = 0
for k, v in pairs(mem) do
	total = total + v
end
print(total)
