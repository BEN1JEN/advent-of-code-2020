local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local feilds = {}
for l in f:lines() do
	if l == "" then
		break
	else
		local feild, min1, max1, min2, max2 = l:match("([a-zA-Z ]+): ([0-9]+)%-([0-9]+) or ([0-9]+)%-([0-9]+)")
		min1, max1, min2, max2 = tonumber(min1), tonumber(max1), tonumber(min2), tonumber(max2)
		table.insert(feilds, {name=feild, check=function(n)return (n >= min1 and n <= max1) or (n >= min2 and n <= max2) end})
	end
end

f:read("*line")
local mine = f:read("*line")
f:read("*line")
f:read("*line")

local tickets = {}
local er = 0
for l in f:lines() do
	local ticket = {invalid=false}
	for c in l:gmatch("[^,]+") do
		local number = tonumber(c)
		local invalid = true
		for i, feild in ipairs(feilds) do
			ticket[feild.name] = {value=number, valid=feild.check(number)}
			if feild.check(number) then
				invalid = false
			end
		end
		if invalid then
			er = er + number
			ticket.invalid = true
		end
	end
	table.insert(tickets, ticket)
end
print(er)
