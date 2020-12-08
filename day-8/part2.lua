local lib = require "lib"
local arg = {...}

local function sim(code)
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
	end
	return acc, pc-#code
end

local code = {}
for l in io.lines("data.txt") do
	table.insert(code, {ins=l:sub(1, 3), value=tonumber(l:sub(5))})
end
for i = 1, #code do
	local code = {}
	for l in io.lines("data.txt") do
		table.insert(code, {ins=l:sub(1, 3), value=tonumber(l:sub(5))})
	end

	if code[i].ins ~= "acc" then
		if code[i].ins == "jmp" then
			code[i].ins = "nop"
		else
			code[i].ins = "jmp"
		end
		--[[local newcode = {}
		for k, v in ipairs(code) do
			if k == i then
				if code[k].ins == "jmp" then
					newcode[k] = {ins="nop", value=code[k].value}
				elseif code[k].ins == "nop" then
					newcode[k] = {ins="jmp", value=code[k].value}
				end
			else
				newcode[k] = v
			end
		end--]]
		local acc, pc = sim(code)
		if pc == 0 then
			print("acc:", acc, "mod:", i, "pc:", pc)
			break
		else
			print("acc:", acc, "mod:", i, "pc:", pc)
		end
	end
end
