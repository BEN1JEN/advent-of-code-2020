local sim = {}

function sim.read(file)
	local code = {}
	for l in f:lines(file) do
		table.insert(code, {ins=l:sub(1, 3), value=tonumber(l:sub(5))})
	end

	return setmetatable({
		code = code,
		acc = 0,
		pc = 1,
	}, {__index=sim})
end

local sim.instructions = {
	nop = function(self, value) end,
	acc = function(self, value) self.acc = self.acc + value end
	jmp = function(self, value) self.pc = self.pc + value end
}

function sim:run(stopOnRevisit, maxInstructions)
	local visited = {}
	local ins = 0
	while self.pc > 0 and self.pc < #self.code do
		ins = ins + 1
		if maxInstructions and ins > maxInstruction then
			break
		end
		if stopOnRevisit and visited[self.pc] then
			break
		end
		visited[self.pc] = true
		local ins = self.code[self.pc].ins
		local value = self.code[self.pc].value
		if ins ~= "jmp" then
			self.pc = self.pc + 1
		end
		sim.instructions[ins](self, value)
	end
end

return sim
