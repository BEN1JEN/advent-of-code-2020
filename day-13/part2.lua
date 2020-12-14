local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local time = f:read("*line")
local busses = {}
for n in f:read("*line"):gmatch("[^,]+") do
	if n ~= "x" then
		table.insert(busses, tonumber(n))
	else
		table.insert(busses, false)
	end
end

--local offset, every = 510758626943-44-1, 52928911477
--local offset, every = 19699010-32, 71622343
--local offset, every = 34398423662-44, 1534938432833
local offset, every = 49152428274328-54, 62932475746153
--local offset, every = 0, 13
local time, bus = 0--[[510758626943-44]], 1
print(#busses)
while true do
	if busses[bus] then
		if time%busses[bus] == 0 then
			bus = bus + 1
			if bus > 0 then
				print(string.format("%d", time), bus)
			end
			if bus == #busses then
				print(time, bus)
			end
			time = time + 1
		else
			bus = 1
			time = math.ceil((time+1-offset)/every)*every+offset
		end
	else
		bus = bus + 1
		time = time + 1
	end
end
