function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end
	local parts = param:split(",")

	local position = player:getPosition()
	local monsterName = parts[1] and parts[1]:gsub("^%s*(.-)%s*$", "%1")
	if not monsterName or monsterName == "" then
		player:sendCancelMessage("Use: /m monster name[,count,head,body,legs,feet,addons]")
		return false
	end

	local qtd = tonumber(parts[2]) or 1
	for i = 1, qtd do
		local monster = Game.createMonster(monsterName, position, false, true)
		if not monster then
			player:sendCancelMessage("Monster not found or cannot be placed: " .. monsterName)
			return false
		end

		local outfit = monster:getOutfit()
		local newOutfit = {
			lookType = outfit.lookType,
			lookHead = tonumber(parts[3]) or 0,
			lookBody = tonumber(parts[4]) or 0,
			lookLegs = tonumber(parts[5]) or 0,
			lookFeet = tonumber(parts[6]) or 0,
			lookAddons = tonumber(parts[7]) or 0
		}

		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		monster:setOutfit(newOutfit)
	end
	return false
end
