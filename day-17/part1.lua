local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local active = {}
local y = 0
for l in f:lines() do
	for x = 1, #l do
		if l:sub(x, x) == "#" then
			active[tostring(x-1) .. "," .. tostring(y) .. ",0"] = {x=x-1, y=y, z=0}
		end
	end
	y = y + 1
end

local function show()
	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
	for _, a in pairs(active) do
		minX, maxX = math.min(minX, a.x), math.max(maxX, a.x)
		minY, maxY = math.min(minY, a.y), math.max(maxY, a.y)
		minZ, maxZ = math.min(minZ, a.z), math.max(maxZ, a.z)
	end
	io.write("x=", tostring(minX), "-", tostring(maxX), "\n")
	io.write("y=", tostring(minY), "-", tostring(maxY), "\n")
	for z = minZ, maxZ do
		io.write("\nz=", tostring(z), "\n")
		for y = minY, maxY do
			for x = minX, maxX do
				if active[tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)] then
					io.write("#")
				else
					io.write(".")
				end
			end
			io.write("\n")
		end
	end
end

io.write("Before any cycles:\n")
show()

for i = 1, 6 do
	local newActive = {}
	local update = {}
	for _, a in pairs(active) do
		for dx = -1, 1 do
			for dy = -1, 1 do
				for dz = -1, 1 do
					local x, y, z = a.x+dx, a.y+dy, a.z+dz
					local posStr = tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
					update[posStr] = {x=x, y=y, z=z}
				end
			end
		end
	end
	for posStr, u in pairs(update) do
		local cell = active[posStr]
		local n = 0
		for nx = -1, 1 do
			for ny = -1, 1 do
				for nz = -1, 1 do
					if nx ~= 0 or ny ~= 0 or nz ~= 0 then
						if active[tostring(u.x+nx) .. "," .. tostring(u.y+ny) .. "," .. tostring(u.z+nz)] then
							n = n + 1
						end
					end
				end
			end
		end
		if cell then
			if n == 2 or n == 3 then
				newActive[posStr] = {x=u.x, y=u.y, z=u.z}
			end
		else
			if n == 3 then
				newActive[posStr] = {x=u.x, y=u.y, z=u.z}
			end
		end
	end
	active = newActive
	io.write("\nAfter ", tostring(i), " cycles:\n")
	show()
end
local total = 0
for _ in pairs(active) do
	total = total + 1
end
print(total)
