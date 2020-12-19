local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local rules = {}
for l in f:lines() do
	if l == "" then
		break
	end
	local id1, numbers1 = l:match("^([0-9]+):([0-9 ]+)$")
	local id2, numbers2, numbers3 = l:match("^([0-9]+)%:([0-9 ]+)%|([0-9 ]+)$")
	local id3, letter = l:match("^([0-9]+): \"([ab])\"$")
	local id = tonumber(id1 or id2 or id3)
	local subRulesA = {}
	local subRulesB = {}
	if not letter then
		for n in (numbers1 or numbers2):gmatch("[0-9]+") do
			table.insert(subRulesA, tonumber(n))
		end
		if numbers3 then
			for n in numbers3:gmatch("[0-9]+") do
				table.insert(subRulesB, tonumber(n))
			end
		end
	end
	rules[id] = {id=id, type=letter and "char" or "sub", subs={subRulesA, subRulesB}, char=letter}
end

local function match(rule, str)
	if rule.type == "char" then
		return str:sub(1, #rule.char) == rule.char, #rule.char
	else
		local bestMatch = 0
		for _, sub in ipairs(rule.subs) do
			local doesMatch = true
			local i = 1
			for _, sr in ipairs(sub) do
				local m, l = match(rules[sr], str:sub(i))
				if not m then
					doesMatch = false
					break
				end
				i = i + l
			end
			if doesMatch then
				bestMatch = math.max(bestMatch, i-1)
			end
		end
		return bestMatch ~= 0, bestMatch
	end
end

local matches = 0
local notMatch = 0
for l in f:lines() do
	local matched, len = match(rules[0], l)
	if matched and len == #l then
		matches = matches + 1
	else
		notMatch = notMatch + 1
	end
	if l == "" then
		break
	end
end

print(matches, notMatch)
