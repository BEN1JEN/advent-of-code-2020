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
		if l == "" then
			print(tmpf)
			if tmpf.byr and tmpf.iyr and tmpf.eyr and tmpf.hgt and tmpf.hcl and tmpf.ecl and tmpf.pid
				and tonumber(tmpf.byr) >= 1920 and tonumber(tmpf.byr) <= 2002
				and tonumber(tmpf.iyr) >= 2010 and tonumber(tmpf.iyr) <= 2020
				and tonumber(tmpf.eyr) >= 2020 and tonumber(tmpf.eyr) <= 2030
				and (
					(string.sub(tmpf.hgt, -2, -1) == "cm" and tonumber(string.sub(tmpf.hgt, 1, -3)) >= 150 and tonumber(string.sub(tmpf.hgt, 1, -3)) <= 193) or
					(string.sub(tmpf.hgt, -2, -1) == "in" and tonumber(string.sub(tmpf.hgt, 1, -3)) >= 59 and tonumber(string.sub(tmpf.hgt, 1, -3)) <= 76)
				)
				and tmpf.hcl:find("#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]")
				and (tmpf.ecl == "amb" or tmpf.ecl == "blu" or tmpf.ecl == "brn" or tmpf.ecl == "gry" or tmpf.ecl == "grn" or tmpf.ecl == "hzl" or tmpf.ecl == "oth")
				and #tmpf.pid == 9
				then
				total = total + 1
			else
				print("iv")
			end
			tmpf = {}
		else
			tmpf[l:sub(1, 3)] = l:sub(5, -1)
		end
	end
end

print(total)
