local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local code = {}
for l in f:lines() do
	table.insert(code, {ins=l:sub(1, 3), value=tonumber(l:sub(5))})
end

local visited = {}
local acc, pc = 0, 1
while pc > 0 and pc < #code do
	if visited[pc] then
		break
	end
	visited[pc] = true
	local ins = code[pc].ins
	local value = code[pc].value
	if ins ~= "jmp" then
		pc = pc + 1
	end
	if ins == "nop" then
	elseif ins == "acc" then
		acc = acc + value
	elseif ins == "jmp" then
		pc = pc + value
	end
	print(pc)
end
print(pc, #code)
print(acc)
