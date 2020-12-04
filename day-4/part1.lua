local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

--[[
	byr (Birth Year)
	iyr (Issue Year)
	eyr (Expiration Year)
	hgt (Height)
	hcl (Hair Color)
	ecl (Eye Color)
	pid (Passport ID)
	cid (Country ID)
]]

local tmpf = {}
local total = 0
for ll in f:lines() do
	for l in ll:gmatch("[^ ]*") do
		print(l)
		if l == "" then
			if tmpf.byr and tmpf.iyr and tmpf.eyr and tmpf.hgt and tmpf.hcl and tmpf.ecl and tmpf.pid then
				print(tmpf)
				total = total + 1
			end
			tmpf = {}
		else
			tmpf[l:sub(1, 3)] = true
		end
	end
end

print(total)
