local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local time = f:read("*line")
local busses = {}
for n in f:read("*line"):gmatch("[^,]+") do
	if n ~= "x" then
		table.insert(busses, tonumber(n))
	end
end
local earliest = math.huge
local ebus = 0
for _, bus in ipairs(busses) do
	local at = math.ceil(time/bus)*bus
	if at < earliest then
		earliest = at
		ebus = bus
	end
end
print(time, ebus, earliest, ebus*(earliest-time))
