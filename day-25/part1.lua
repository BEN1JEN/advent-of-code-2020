local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local cardPub = assert(tonumber(f:read("*line")))
local doorPub = assert(tonumber(f:read("*line")))

local function findSecrets(subject, public)
	local secrets = {}
	local i, loops = 1, 0
	while #secrets < 5 do
		i = i * subject
		i = i % 20201227
		loops = loops + 1
		if i == public then
			table.insert(secrets, loops)
			print(#secrets .. "/10")
		end
	end
	return secrets
end

print("finding card secrets...")
local cardSecrets = findSecrets(7, cardPub)
print("finding card secrets...")
local doorSecrets = findSecrets(7, doorPub)
print(cardSecrets, doorSecrets)

--[[
print("generating way more secrets...")
for i = #cardSecrets+1, 20 do
	cardSecrets[i] = cardSecrets[i-1] + (cardSecrets[2] - cardSecrets[1])
end
for i = #doorSecrets+1, 20 do
	doorSecrets[i] = doorSecrets[i-1] + (doorSecrets[2] - doorSecrets[1])
end
--]]

for i, doorSecret in ipairs(doorSecrets) do
	for j, cardSecret in ipairs(cardSecrets) do
		print("trying", i, j, doorSecret, cardSecret)
		print("computing encryption key...")
		local value = 1
		for i = 1, cardSecret do
			value = value * doorPub
			value = value % 20201227
		end

		print("computing backup check")
		local value2 = 1
		for i = 1, doorSecret do
			value2 = value2 * cardPub
			value2 = value2 % 20201227
		end

		print("done")
		print(value, value2)
		if value == value2 then
			os.exit()
		else
			print("bad, continuing...")
		end
	end
end

os.exit(1)
