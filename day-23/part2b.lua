local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local l = f:read("*all")
local cups = {}
for n in l:gmatch("[0-9]") do
	table.insert(cups, tonumber(n))
end

local num = 10
while #cups < 1000000 do
	table.insert(cups, num)
	num = num + 1
end

assert(#cups == 1000000)

local starting = 1
local function disp()
	for _, c in ipairs(cups) do
		io.write(tostring(c), " ")
	end
	io.write(" starting at ", tostring(starting))
	io.write("\n")
end

for i = 1, 10 do
	--io.write("cups: ")
	--disp()
	local a, b, c = table.remove(cups, 2), table.remove(cups, 2), table.remove(cups, 2)
	--print("pick up:", a, b, c)
	local dest = cups[1]
	local destPos = false
	repeat
		dest = dest - 1
		if dest < 1 then dest = 9 end
		for i, cup in ipairs(cups) do
			if cup == dest then
				destPos = i
				break
			end
		end
	until destPos
	--print("destination:", dest, "@", destPos)
	assert(destPos)
	table.insert(cups, destPos+1, c)
	table.insert(cups, destPos+1, b)
	table.insert(cups, destPos+1, a)
	table.insert(cups, table.remove(cups, 1))
	starting = starting%#cups + 1
end

disp()

for i = 1, starting-1 do
	table.insert(cups, 1, table.remove(cups, #cups))
end
starting = 1

disp()
