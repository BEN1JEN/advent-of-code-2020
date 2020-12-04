local lib = {}

local function printElement(element, insersion, key)
	local t = type(element)
	if insersion then
		for i = 1, insersion do
			io.write("\t")
		end
	end
	if not insersion then
		insersion = 0
	end
	if key then
		io.write(key)
	end
	if key or t == "table" then
		io.write("(" .. t .. "): ")
	end
	if t == "string" then
		io.write(element)
	elseif t == "number" then
		io.write(tostring(element))
	elseif t == "boolean" then
		if element then
			io.write("true")
		else
			io.write("false")
		end
	elseif t == "nil" then
		io.write("nil")
	elseif t ~= "table" then
		io.write(tostring(element))
	end
	if t == "table" then
		io.write("\n")
		local tmp = false
		for k, v in pairs(element) do
			if type(k) ~= "number" then
				tmp = true
			end
		end

		if tmp then
			for k, v in pairs(element) do
				printElement(v, insersion+1, k)
			end
		else
			for i, v in ipairs(element) do
				printElement(v, insersion+1, i)
			end
		end
	else
		io.write("\n")
	end
end

function print(...)
	for i, ele in pairs{...} do
		printElement(ele)
	end
end

function lib.read_data(f, seek, amount)
	local old = f:tell()
	f:seek(seek)
	local data = f:read(amount)
	f:seek(old)
	return data
end

function lib.sep_str(str, seperator)
	local sep = {}
	local m = ""
	for i = 1, #str do
		y = string.sub(str, i, i)
		if string.sub(str, i, i+#seperator-1) ~= seperator then
			m = m .. y
		else
			table.insert(sep, m)
			m = ""
		end
	end
	table.insert(sep, m)
	return sep
end

function lib.table_overlap(t1, t2, testKeys)
	out = {}
	for k, v in pairs(t1) do
		if type(t2[k]) ~= "nil" then
			if not testKeys or t2[k] == v then
				table.insert(out, k)
			end
		end
	end
	if #out == 0 then
		return false
	end
	return out
end

lib.instructions = {
	{
		name="ADD",
		params=3,
		call=function(memory, iStream, oStream, ia, ib, oc)
			memory[oc] = memory[ia] + memory[ib]
		end,
	},
	{
		name="MUL",
		params=3,
		call=function(memory, iStream, oStream, ia, ib, oc)
			memory[oc] = memory[ia] * memory[ib]
		end,
	},
	{
		name="UGT",
		params=1,
		call=function(memory, iStream, oStream, oa)
			if type(iStream) == "function" then
				memory[oa] = iStream()
			else
				if #iStream == 0 then
					return _, true
				end
				memory[oa] = table.remove(iStream, 1)
			end
		end,
	},
	{
		name="UPT",
		params=1,
		call=function(memory, iStream, oStream, ia)
			if type(oStream) == "function" then
				oStream(memory[ia])
			else
				table.insert(oStream, memory[ia])
			end
		end,
	},

	{
		name="JIT",
		params=2,
		call=function(memory, iStream, oStream, check, loc)
			if memory[check] ~= 0 then
				return memory[loc]
			end
		end,
	},
	{
		name="JIF",
		params=2,
		call=function(memory, iStream, oStream, check, loc)
			if memory[check] == 0 then
				return memory[loc]
			end
		end,
	},

	{
		name="TLT",
		params=3,
		call=function(memory, iStream, oStream, ia, ib, oc)
			memory[oc] = memory[ia] < memory[ib] and 1 or 0
		end,
	},
	{
		name="TEQ",
		params=3,
		call=function(memory, iStream, oStream, ia, ib, oc)
			memory[oc] = memory[ia] == memory[ib] and 1 or 0
		end,
	},
	{
		name="RBO",
		params=1,
		call=function(memory, iStream, oStream, ia)
			memory.relative = memory.relative + memory[ia]
		end,
	},
}

local function printParams(instruction, memory, memOrg, len)
	memCtr = memOrg-math.floor(len/2)
	local memLoc = tostring(memCtr) .. "-" .. tostring(memCtr+len)
	io.write(" ", memLoc, ":", string.rep(" ", 10-#memLoc))
	local len = len+1
	for i = 0, len-1 do
		if i ~= 0 then
			io.write(",")
		end
		local selChar = ""
		if memCtr+i == memOrg then
			selChar = "*"
		end
		io.write(selChar, tostring(memory[memCtr+i]):gsub("nil", "~"), selChar)
		len = len + #tostring(memory[memCtr+i])
	end
	if o ~= instruction.params then
		io.write(string.rep(" ", 32-len))
	end
end

function lib.simulate(program, iStream, oStream, debugLevel, pc)
	if not iStream then
		iStream = {}
	end
	if type(iStream) == "number" then
		iStream = {iStream}
	end
	if not oStream then
		oStream = iStream
	end
	if not debugLevel then
		debugLevel = 1
	end
	if not pc then
		pc = 0
	end

	local memory = setmetatable({relative=0}, {__index=function()return 0 end})
	for k, v in ipairs(program) do
		if tonumber(v) then
			memory[k-1] = tonumber(v)
		end
	end

	-- debug
	if debugLevel >= 2 then
		print("AoC 2019 Computer Debuger V2.2:")
		print("pc:     ins/op  pram1            pram2            pram3             memory...")
	end
	-- end debug

	while true do
		if not memory[pc] then
			-- debug
			if debugLevel >= 2 then
				print("WARNING: No instruction at: " .. tostring(pc))
			end
			-- end debug
			break
		end
		-- get opcode and param modes
		local opcode = memory[pc]%100
		local pMode = {math.floor(memory[pc]%1000/100), math.floor(memory[pc]%10000/1000), math.floor(memory[pc]%100000/10000)}
		local instruction = lib.instructions[opcode] -- get instruction from instruction list
		if opcode == 99 then -- halt if neccesary
			-- debug
			if debugLevel >= 2 then
				io.write(tostring(pc), ":", string.rep(" ", 7-#tostring(pc)), "HLT/99\n")
			end
			-- end debug
			break
		else
			local lastPc = pc
			local params = {}
			if not instruction then
				-- debug
				if debugLevel >= 1 then
					print("WARNING: Unimplemented instruction: " .. tostring(opcode))
				end
				-- end debug
			else
				for i = 1, instruction.params do -- compute parameter values
					if pMode[i] == 1 then
						params[i] = pc+i
					elseif pMode[i] == 2 then
						params[i] = memory[pc+i]+memory.relative
					else
						params[i] = memory[pc+i]
					end
				end
				local ret, hlt = instruction.call(memory, iStream, oStream, (unpack or table.unpack)(params)) -- run instruction
				if hlt then
					return memory, pc, false -- pause the program in it's current state (no halt)
				end
				pc = pc + instruction.params + 1
				if ret then -- jump returns the new PC
					pc = ret
				end
			end

			-- debug
			if debugLevel >= 2 and instruction then
				io.write(tostring(lastPc), ":", string.rep(" ", 7-#tostring(lastPc)))
				io.write(instruction.name, "/", opcode, string.rep(" ", 4-#tostring(opcode)))
				for i = 1, instruction.params do
					local p = tostring(params[i])
					if pMode[i] == 1 then
						p = "#" .. tostring(memory[params[i]])
					elseif pMode[i] == 2 then
						p = "R+" .. tostring(memory[params[i]])
					end
					io.write(p)
					io.write(string.rep(" ", 17-#p))
				end
				io.write(string.rep(" ", (3-instruction.params)*17))
				local done = {}
				for o = 1, instruction.params do
					if not done[params[o]] then
						printParams(instruction, memory, params[o], 3)
						done[params[o]] = true
					end
				end
				io.write("\n")
			end
		end
		-- end debug

	end
	return memory, pc, true -- current state, should halt
end

function lib.offset(t, by)
	if not by then
		by = -1
	end
	if by == 0 then
		return t
	elseif by < 0 then
		for i, v in ipairs(t) do
			t[i+by] = v
		end
	elseif by > 0 then
		for i, v in ipairs(t) do
			t[i] = t[t+by]
		end
	end
	return t
end

function lib.count_char(str, c)
	local count = 0
	for i = 1, #str do
		if str:sub(i, i) == c then
			count = count + 1
		end
	end
	return count
end

return lib
