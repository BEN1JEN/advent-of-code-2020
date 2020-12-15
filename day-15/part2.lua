local lib = require "lib"
local arg = {...}

local nums = {2,20,0,4,1,17}
local spoken = {[2]=1, [20]=2, [0]=3, [4]=4, [1]=5}
--local nums = {0,3,6}
--local spoken = {[0]=1, [3]=2}
for i = 7, 30000000 do
	local n = spoken[nums[#nums]] and i-1-spoken[nums[#nums]] or 0
	spoken[nums[#nums]] = i-1
	table.insert(nums, n)
	if i%100000 == 0 then
		print(i)
	end
end

print(nums[30000000])
