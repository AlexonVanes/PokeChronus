function onSay(player, words, param)
	local summon = player:getSummon()
	if not summon then
		player:sendCancelMessage("Sorry, not possible. You need a summon to conjure spells.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local playerTile = Tile(player:getPosition())
	local summonTile = Tile(summon:getPosition())
	if (playerTile and (playerTile:hasFlag(TILESTATE_PROTECTIONZONE) or playerTile:getHouse()))
		or (summonTile and (summonTile:hasFlag(TILESTATE_PROTECTIONZONE) or summonTile:getHouse())) then
		player:sendCancelMessage("Sorry, not possible in protection zone or house.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local summonName = summon:getName()

	-- Ditto Memory: if the ball has ditto_transform, cast the copied pokemon's
	-- moves instead of Ditto's (which has none). summonName stays as Ditto for
	-- the say message and other checks.
	local moveSourceName = summonName
	local ball = player:getUsingBall()
	if ball then
		local dittoTF = ball:getCustomAttribute("ditto_transform")
		if dittoTF and dittoTF ~= "" and dittoTF ~= 0 then
			local tfName = string.split(tostring(dittoTF), "|")[1]
			if tfName and tfName ~= "" then
				moveSourceName = tfName
			end
		end
	end

	local monsterType = MonsterType(moveSourceName)
	local move = monsterType:getMoveList()
	local target = summon:getTarget()

	local stunned = (summon:getCondition(CONDITION_STUN) or player:getCondition(CONDITION_STUN))
	local silence = (summon:getCondition(CONDITION_SILENCE) or player:getCondition(CONDITION_SILENCE))
	local feared = (summon:getCondition(CONDITION_FEAR) or player:getCondition(CONDITION_FEAR))

	if stunned then
		player:sendCancelMessage("Sorry, not possible. you are stunned.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if silence then
		player:sendCancelMessage("Sorry, not possible. you are silenced.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if feared then
		player:sendCancelMessage("Sorry, not possible. you are feared.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	for i = 1, #moveWords do
		if words == moveWords[i] then
			if move[i] then
				if move[i].passive == 1 then return false end
				if move[i].isTarget == 1 and not target then
					player:sendCancelMessage("Sorry, not possible. You need a target.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end
				if target and move[i].isTarget == 1 and move[i].range ~= 0 and summon:getPosition():getDistance(target:getPosition()) > move[i].range then
					player:sendCancelMessage("Sorry, not possible. You are too far.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end
				if getCreatureCondition(summon, CONDITION_SLEEP) then
					player:sendCancelMessage("Sorry, not possible. Your pokemon is sleeping.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end
				local exhausted = player:checkMoveExhaustion(i, move[i].speed / 1000)
				if not exhausted or player:getAccountType() == ACCOUNT_TYPE_GOD then
					local moveName = move[i].name
					doCreatureCastSpell(summon, moveName)
					player:say(summonName .. ", use " .. moveName .. "!", TALKTYPE_MONSTER_SAY)
				end
			else
				player:sendCancelMessage("Sorry, not possible.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				break
			end
		end
	end
	return false
end
