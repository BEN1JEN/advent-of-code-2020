local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local sum = 0
local yesed = {}
for ll in f:lines() do
	for l in ll:gmatch(".?") do
		if l == "" then
			local len = 0
			for k, v in pairs(yesed) do
				len = len + 1
			end
			sum = sum + len
			yesed = {}
		else
			yesed[l] = true
		end
	end
end

print(sum)
