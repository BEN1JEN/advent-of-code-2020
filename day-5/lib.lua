local lib = {}

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

function lib.xor(a, b)
	return (a or b) and not (a and b)
end

require "newlib"

return lib
