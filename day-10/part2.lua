local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local list = {}
for l in f:lines() do
	table.insert(list, tonumber(l))
end
table.sort(list)
local gaps = {}
local last = 0
local gap1, gap3 = 0, 1
for _, v in ipairs(list) do
	local gap = v-last
	table.insert(gaps, gap)
	last = v
end

local lens, len = {}, 0
for i, gap in ipairs(gaps) do
	if gaps[i] == 3 or len > 3 then
		if len ~= 0 then
			table.insert(lens, len)
			len = 0
		end
	elseif gaps[1] == 1 then
		len = len + 1
	else
		print("FUN")
	end
end
if len ~= 0 then
	table.insert(lens, len)
end

local function getBin(n)
	local str = ""
	for i = 0, math.log(n)/math.log(2) do
		str = tostring(math.floor(n/(2^i))%2) .. str
	end
	return str
end

print(lens)
local total = 1
for _, len in ipairs(lens) do
	if len > 1 then
		local add = 0
		for i = 0, 2^(len-1)-1 do
			if not getBin(i+2^(len-1)):find("000") then
				add = add + 1
			end
		end
		print(len, add)
		total = total * add
	end
end
print(total)
