local lib = require "lib"
local arg = {...}

f = io.open("data-jason.txt", "r")

local gplayers = {}
for l in f:lines() do
	if l:sub(1, 7) == "Player " then
		table.insert(gplayers, {})
	elseif l ~= "" then
		table.insert(gplayers[#gplayers], tonumber(l))
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

local gameid, maxLev = 1, 0
local function recursiveCombat(players, lvl)
	local lid = gameid
	gameid = gameid + 1
	maxLev = math.max(maxLev, lvl)
	local function log(...)
		print("game " .. tostring(lid) .. " rec " .. tostring(lvl) .. ":")
		print(...)
	end
	local prevConfigurations = {}
	local winner = false
	while true do
		local confId = table.concat(players[1], ",") .. "\n" .. table.concat(players[2], ",")
		--log(confId)
		if prevConfigurations[confId] then
			winner = 1
			--log("game redid")
			break
		end
		prevConfigurations[confId] = true
		local bestCard, bestPlayer = -math.huge, 0
		local canRecurse = true
		local cards = {}
		for i, player in ipairs(players) do
			local top = table.remove(player, 1)
			if top > #player then
				canRecurse = false
			end
			table.insert(cards, top)
			if top > bestCard then
				bestCard = top
				bestPlayer = player
			elseif top == bestCard then
				error("um...")
			end
		end
		if canRecurse then
			local newCards1, newCards2 = {}, {}
			for i = 1, cards[1] do
				newCards1[i] = players[1][i]
			end
			for i = 1, cards[2] do
				newCards2[i] = players[2][i]
			end
			local p2 = {newCards1, newCards2}
			local w = recursiveCombat(p2, lvl+1)
			bestPlayer = players[w]
			bestCard = cards[w]
		end
		table.insert(bestPlayer, bestCard)
		for _, card in ipairs(cards) do
			if card ~= bestCard then
				table.insert(bestPlayer, card)
			end
		end
		for i, player in ipairs(players) do
			if #player == 0 then
				winner = i%2+1
			end
		end
		if winner then
			break
		end
	end
	return winner
end

local winner = recursiveCombat(gplayers, 1)

local score = 0
for i, card in ipairs(gplayers[winner]) do
	score = score + card*(#gplayers[winner]+1-i)
end

print(score, winner, gameid, maxLev)
