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
		local pp = {}
		for i = 1, 20 do
			pp[i] = true
		end
		table.insert(feilds, {name=feild, check=function(n)return (n >= min1 and n <= max1) or (n >= min2 and n <= max2) end, possiblePositions=pp})
	end
end

f:read("*line")
local myTicket = {}
for c in f:read("*line"):gmatch("[^,]+") do
	table.insert(myTicket, tonumber(c))
end
f:read("*line")
f:read("*line")

local tickets = {}
for l in f:lines() do
	local ticket = {invalid=false, numbers={}}
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
			ticket.invalid = true
		end
		table.insert(ticket.numbers, number)
	end
	if not ticket.invalid then
		table.insert(tickets, ticket)
	end
end
for _, ticket in ipairs(tickets) do
	for pos, number in ipairs(ticket.numbers) do
		for i, feild in ipairs(feilds) do
			if not feild.check(number) then
				feild.possiblePositions[pos] = nil
			end
		end
	end
end
local positions = {}
for i = 1, 20 do
	for _, feild in ipairs(feilds) do
		local pos
		for i, p in pairs(feild.possiblePositions) do
			if p and not pos then
				pos = i
			elseif p and pos then
				pos = false
				break
			end
		end
		if pos then
			positions[pos] = feild.name
			for _, f2 in ipairs(feilds) do
				f2.possiblePositions[pos] = nil
			end
		end
	end
end
local numbers = {}
for pos, posName in ipairs(positions) do
	if posName:find("departure") then
		table.insert(numbers, myTicket[pos])
	end
end
print(numbers)
local mult = 1
for _, n in ipairs(numbers) do
	mult = mult * n
end
print(mult)
