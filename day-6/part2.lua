local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local sum = 0
local yesed = {}
for ll in f:lines() do
	print(ll)
	if ll == "" then
		local all = {}
		for i = 1, 26 do
			all[string.char(i+96)] = true
		end
		print(yesed)
		for i, v in ipairs(yesed) do
			local notin = {}
			for i = 1, 26 do
				notin[string.char(i+96)] = true
			end
			for k in pairs(v) do
				notin[k] = nil
				print("yesin", k)
			end
			for k, _ in pairs(notin) do
				all[k] = nil
				print("notin", k)
			end
		end
		len = 0
		for _ in pairs(all) do
			len = len + 1
		end
		print(len)
		sum = sum + len
		yesed = {}
	else
		table.insert(yesed, {})
		for l in ll:gmatch(".") do
			yesed[#yesed][l] = true
		end
	end
end

print(sum)
