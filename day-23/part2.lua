local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local l = f:read("*all")
local cups = {}
for n in l:gmatch("[0-9]") do
	table.insert(cups, tonumber(n))
end

---[[
local num = 10
while #cups < 1000000 do
	table.insert(cups, num)
	num = num + 1
end

assert(#cups == 1000000)
--]]

local current = {value=cups[1]}
current.next = current
current.prev = current
local hashboi = {[cups[1]]=current}
local function insertAfter(ele, val)
	local new = {value=val}
	new.prev = ele
	new.next = ele.next
	ele.next.prev = new
	ele.next = new
	return new
end
local function insertNodeAfter(ele, new)
	new.prev = ele
	new.next = ele.next
	ele.next.prev = new
	ele.next = new
	return new
end
local function remove(ele)
	ele.next.prev = ele.prev
	ele.prev.next = ele.next
	return ele
end

do
	local n = current
	for i, cup in ipairs(cups) do
		if i ~= 1 then
			n = insertAfter(n, cup)
			hashboi[cup] = n
		end
	end
end

local function disp()
	local n = current
	for i = 1, 100 do
		io.write(n.value, " ")
		n = n.next
	end
	io.write("\n")
end
for i = 1, 10000000 do
	if i%100000 == 0 then
		print(tostring(i/100000) .. "%")
		collectgarbage()
	end
	--io.write("cups: ")
	--disp()
	local a, b, c = remove(current.next), remove(current.next), remove(current.next)
	--print("pick up:", a.value, b.value, c.value)
	local destValue = current.value
	local destNode = false
	repeat
		destValue = destValue - 1
		if destValue < 1 then destValue = 1000000 end
		if destValue ~= a.value and destValue ~= b.value and destValue ~= c.value then
			destNode = hashboi[destValue]
		end
	until destNode
	--print("destination:", destNode.value)
	insertNodeAfter(destNode, c)
	insertNodeAfter(destNode, b)
	insertNodeAfter(destNode, a)
	current = current.next
end

print(hashboi[1].next.value, hashboi[1].next.next.value)
