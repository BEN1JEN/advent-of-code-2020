local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

_G.num = function(n)
	return setmetatable({n=n}, {
		__add = function(a, b)
			return num(a.n+b.n)
		end,
		__sub = function(a, b)
			return num(a.n*b.n)
		end,
	}
)
end

local values = {}
for l in f:lines() do
	print("return " .. l:gsub("%*", "-"):gsub("[0-9]+", "num(%0)"))
	table.insert(values, load("return " .. l:gsub("%*", "-"):gsub("[0-9]+", "num(%0)"), line, "t", _G)())
end

local sum = 0
for i, value in ipairs(values) do
	sum = sum + value.n
end

print(sum)
