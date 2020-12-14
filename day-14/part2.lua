local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local mem = {}
local function doMask(mask, num)
	local out = {0}
	for i = 0, 35 do
		local bit = mask:sub(36-i, 36-i)
		if bit == "1" then
			for j, o in ipairs(out) do
				out[j] = o | (1<<i)
			end
		elseif bit == "0" then
			for j, o in ipairs(out) do
				out[j] = o | (((num>>i)&1)<<i)
			end
		elseif bit == "X" then
			local new = {}
			for _, o in ipairs(out) do
				table.insert(new, o | (1<<i))
			end
			for _, n in ipairs(new) do
				table.insert(out, n)
			end
		else
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
		local staddr, num = l:match("^mem%[([0-9]+)%] = ([0-9]+)$")
		staddr, num = tonumber(staddr), tonumber(num)
		local addrs = doMask(mask, staddr)
		for _, addr in ipairs(addrs) do
			mem[addr] = num
		end
	end
end

local total = 0
for k, v in pairs(mem) do
	total = total + v
end
print(total)
