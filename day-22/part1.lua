local lib = require "lib"
local arg = {...}

f = io.open("data.txt", "r")

local players = {}
for l in f:lines() do
	if l:sub(1, 7) == "Player " then
		table.insert(players, {})
	elseif l ~= "" then
		table.insert(players[#players], tonumber(l))
	end
end

--[[
	local signalQueue = {startLoc = 1, endLoc = 0}
	function computer.pushSignal(...)
		signalQueue[signalQueue.endLoc] = {...}
		signalQueue.endLoc = signalQueue.endLoc + 1
	end
	function computer.pullSignal(timeout)
		if type(timeout) == "number" then
			love.timer.sleep(timeout)
		else
			input:demand()
		end
		repeat
			local value = input:pop()
			if value then
				computer.pushSignal(value)
			end
		until not value
		signalQueue.startLoc = signalQueue.startLoc + 1
		if signalQueue.startLoc > signalQueue.endLoc then
			signalQueue.startLoc, signalQueue.endLoc = 1, 0
		end
		local value = signalQueue[signalQueue.startLoc-1]
		signalQueue[signalQueue.startLoc-1] = nil
		return value and (table.unpack or unpack)(value)
	end

--]]

local winner = false
while true do
	local bestCard, bestPlayer = -math.huge, 0
	local cards = {}
	for i, player in ipairs(players) do
		local top = table.remove(player, 1)
		if #player == 0 then
			winner = i%2+1
		end
		table.insert(cards, top)
		if top > bestCard then
			bestCard = top
			bestPlayer = player
		elseif top == bestCard then
			error("um...")
		end
	end
	table.insert(bestPlayer, bestCard)
	for _, card in ipairs(cards) do
		if card ~= bestCard then
			table.insert(bestPlayer, card)
		end
	end
	if winner then
		break
	end
end

local score = 0
for i, card in ipairs(players[winner]) do
	score = score + card*(#players[winner]+1-i)
end

print(score)
