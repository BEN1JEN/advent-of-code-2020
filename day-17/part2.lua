local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local function strPos(x, y, z, w)
	return tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "," .. tostring(w)
end

local active = {}
local y = 0
for l in f:lines() do
	for x = 1, #l do
		if l:sub(x, x) == "#" then
			active[strPos(x-1, y, 0, 0)] = {x=x-1, y=y, z=0, w=0}
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
	for w = minZ, maxZ do
		for z = minZ, maxZ do
		io.write("\nz=", tostring(z), ", w=", tostring(w), "\n")
			for y = minY, maxY do
				for x = minX, maxX do
					if active[strPos(x, y, z, w)] then
						io.write("#")
					else
						io.write(".")
					end
				end
				io.write("\n")
			end
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
					for dw = -1, 1 do
						local x, y, z, w = a.x+dx, a.y+dy, a.z+dz, a.w+dw
						local posStr = strPos(x, y, z, w)
						update[posStr] = {x=x, y=y, z=z, w=w}
					end
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
					for nw = -1, 1 do
						if nx ~= 0 or ny ~= 0 or nz ~= 0 or nw ~= 0 then
							if active[strPos(u.x+nx, u.y+ny, u.z+nz, u.w+nw)] then
								n = n + 1
							end
						end
					end
				end
			end
		end
		if cell then
			if n == 2 or n == 3 then
				newActive[posStr] = {x=u.x, y=u.y, z=u.z, w=u.w}
			end
		else
			if n == 3 then
				newActive[posStr] = {x=u.x, y=u.y, z=u.z, w=u.w}
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
