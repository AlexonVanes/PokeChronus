function onSay(player, words, param)


if not player:getGroup():getAccess() then
    return true
end

if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return true
end

	local players = Game.getPlayers()
	for _, pid in ipairs(players) do
	    pid:sendExtendedOpcode(70, param)

      
     local condition = Condition(CONDITION_OUTFIT)
		local outfitpoke = pid:getOutfit()
		condition:setOutfit(outfitpoke.lookTypeEx, outfitpoke.lookType, outfitpoke.lookHead, outfitpoke.lookBody, outfitpoke.lookLegs, outfitpoke.lookFeet, 0, 0, 0 , 4635, 3)
		condition:setTicks(-1)
		pid:addCondition(condition)
	end




-- player


end
