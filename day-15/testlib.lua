require "newlib"
local function test(n, f, i, r)
	local result = {xpcall(f, debug.traceback, table.unpack(i))}
	if not result[1] then
		print("--------------")
		print("Test Failed", n)
		print("Input Data:", i)
		print("Lua Error:", result[2])
	else
		for k = 1, #r do
			if not table.compare(result[k+1], r[k]) then
				print("--------------")
				print("Test Failed", n)
				print("Input Data:", i)
				print("Bad Result Index:", k)
				print("Expected Result:", r[k])
				print("Actual Result:", result[k+1])
			end
		end
	end
end

test("compare same", table.compare, {{1, 2, 3, {a=1, b=2}, c={1, false, 2, a=3}}, {1, 2, 3, {a=1, b=2}, c={1, false, 2, a=3}}}, {true})
test("compare different", table.compare, {{1, 2, 3, {a=1, b=2}, c={1, false, 2, a=3}}, {1, 2, 3, {a=1, b=2}, c={1, false, 2.1, a=3}}}, {false})
test("index list", table.indexList, {{3, 2, 1, 4}}, {{1, 2, 3, 4}})
test("table merge", table.merge, {{1, 2, 3, a=true, b=3, c=4}, {4, 5, 6, c=5, d=6}}, {{1, 2, 3, 4, 5, 6, b=3, c=5, d=6, a=true}})
test("table copy", table.copy, {{1, 2, 3, 4, a={b=false, [7]=true}, [true]={1, -2, 3}}}, {{1, 2, 3, 4, a={b=false, [7]=true}, [true]={1, -2, 3}}})
test("table map", table.map, {{1, 2, 3, 4}, function(v)return 5-v;end}, {{4, 3, 2, 1}})
test("list filter", table.filter, {{1, 2, 3, 4}, function(v)return v>1 and v<4 end}, {{2, 3}})
test("table filter", table.filterTable, {{a=1, b=2, c=3, d=4}, function(v)return v>1 and v<4 end}, {{b=2, c=3}})
test("table select many", table.constructFrom, {{4, 3, 2, 1}, function(v, i)return {v, i}end}, {{4, 1, 3, 2, 2, 3, 1, 4}})
test("list aggragate", table.aggragate, {{1, 2, 3}, function(total, v)return total..tostring(v).."," end, ""}, {"1,2,3,"})
test("table aggragate", table.aggragateTable, {{a=4}, function(total, v, k)return total..tostring(k)..":"..tostring(v)..","end, ""}, {"a:4,"})
test("table contains", table.contains, {{1, 2, 3, 4, 5}, 4}, {true})
local tmp test("table from list", table.fromList, {{"a", 1, "b", 2, "c", 3}, function(v,i)if(i%2==1)then;tmp=v;else;return tmp,v;end;end}, {a=1, b=2, c=3})
test("table flip", table.flip, {{4, 3, 2, 1}}, {{1, 2, 3, 4}})
test("table pick", table.pick, {{3, 2, 1}, function(t)return(t[1])end}, {1})
test("table pick list", table.pickList, {{1, 2, 3, 4}, function(ll)return(ll-1)end}, {3})
test("string gmatch list", string.gmatchlist, {"this is a test using thingies", ". ."}, {{"s i", "s a", "t u", "g t"}})
test("string strip", string.strip, {"    g   "}, {"g"})
test("string lower is upper", string.isUpper, {"hELLO"}, {false})
test("string upper is upper", string.isUpper, {"HELLO"}, {true})
test("string empty is upper", string.isUpper, {""}, {true})
test("string lower is lower", string.isLower, {"hello"}, {true})
test("string upper is lower", string.isLower, {"hELLO"}, {false})
test("string empty is lower", string.isLower, {""}, {true})
