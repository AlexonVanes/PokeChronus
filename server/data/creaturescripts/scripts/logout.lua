function onLogout(player)

	if not playerLoginStatus[player:getName()] then
		player:normalizeActivePokeballSlot()
		player:migratePokeballsToBallpack()
		player:updateStoredPokemonList()
		return true
	end

	if nextUseStaminaTime then
		nextUseStaminaTime[player.uid] = nil
	end

	if hasSummons(player) then
		local ball = player:getUsingBall()
		if ball then
			local ballId = ball:getId()
			local ballKey = getBallKey(ballId)
			if ballKey and balls[ballKey] and ballId == balls[ballKey].usedOff then
				local summons = player:getSummons()
				local summon = summons[1]
				ball:transform(balls[ballKey].usedOn)
				ball:setSpecialAttribute("isBeingUsed", 0)
				if summon then
					ball:setSpecialAttribute("pokeHealth", summon:getHealth())
				end
			end
		end
		doRemoveSummon(player:getId())
	end
	player:normalizeActivePokeballSlot()
	player:migratePokeballsToBallpack()


	if player:getStorageValue(storageBike) > 0 then
		player:removeCondition(CONDITION_OUTFIT)
		player:changeSpeed(-player:getStorageValue(storageBike))
		player:setStorageValue(storageBike, -1)
	end

	if player:getStorageValue(storageArenaEvent) == 2 then
		local town = player:getTown()
		player:teleportTo(town:getTemplePosition())
		player:unregisterEvent("PrepareDeathArena")
		player:setStorageValue(storageArenaEvent, -1)
	end
	player:updateStoredPokemonList()
	playerLoginStatus[player:getName()] = nil
	return true
end
