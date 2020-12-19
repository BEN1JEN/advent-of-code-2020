local lib = require "lib"
local arg = {...}

f = io.open("data-part2.txt", "r")

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
		return str:sub(1, #rule.char) == rule.char and {#rule.char} or {}
	else
		local matches = {}
		for _, sub in ipairs(rule.subs) do
			if #sub > 0 then
				local is = {{sri=1, i=1}}
				while #is > 0 do
					local index = table.remove(is, 1)
					local ms = match(rules[sub[index.sri]], str:sub(index.i))
					if index.sri == #sub then
						for _, m in ipairs(ms) do
							table.insert(matches, index.i+m-1)
						end
					else
						for _, m in ipairs(ms) do
							table.insert(is, {sri=index.sri+1, i=index.i+m})
						end
					end
				end
			end
		end
		return matches
	end
end

local matchCount = 0
local notMatch = 0
for l in f:lines() do
	local matched = match(rules[0], l)
	local doesMatch = false
	for _, m in ipairs(matched) do
		if m == #l then
			doesMatch = true
		end
	end
	if doesMatch then
		matchCount = matchCount + 1
	else
		notMatch = notMatch + 1
	end
	if l == "" then
		break
	end
end

print(matchCount, notMatch)
