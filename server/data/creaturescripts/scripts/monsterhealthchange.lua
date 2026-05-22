local BATTLE_HEALTH_OPCODE = 121

local function sendBattleHealthToSpectators(creatureId)
	local creature = Creature(creatureId)
	if not creature then
		return
	end

	local maxHealth = creature:getMaxHealth()
	local percent = 0
	if maxHealth > 0 then
		percent = math.ceil((creature:getHealth() / maxHealth) * 100)
	end
	percent = math.max(0, math.min(100, percent))

	local spectators = Game.getSpectators(creature:getPosition(), false, true, 8, 8, 6, 6)
	for _, spectator in ipairs(spectators) do
		spectator:sendExtendedOpcode(BATTLE_HEALTH_OPCODE, creature:getId() .. "@" .. percent)
	end
end

local function scheduleBattleHealthUpdate(creature)
	if creature and creature:isMonster() then
		addEvent(sendBattleHealthToSpectators, 50, creature:getId())
	end
end

function calcularReducaoDano(defesa, multiplicador)
	local blocos = defesa / 100 -- a cada 100 de defesa
	local reducao = blocos * 50 * multiplicador -- 50% de redu��o por bloco, ajustado pelo multiplicador
	if reducao > 100 then
		reducao = 100
	end
	return reducao
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, spellName, origin)
	if origin and origin == ORIGIN_RETURN or not attacker then
		return primaryDamage, primaryType, false
	end

	scheduleBattleHealthUpdate(creature)

	local primaryTypeName = getCombatName(primaryType)
	local attackerMaster = attacker:getMaster()

	if creature:isPlayer() and attackerMaster then
		primaryDamage = creature:getMaxHealth() * 0.1
		return primaryDamage, primaryType, false
	end

	if creature:isPlayer() or attacker:isPlayer() then
		if primaryTypeName == "physical" then
			return 0, primaryType
		end
		return primaryDamage, primaryType, false
	end

	local localDamageMultiplier = 1.0

	if attacker:getCondition(CONDITION_CONFUSION) then
		if math.random(100) >= 30 then
			Game.sendAnimatedText(creature:getPosition(), "MISS", TEXTCOLOR_WHITE_EXP, true)
			return 0, primaryType, false
		end
	end

	local isCritical = false;

	local defense = creature:getTotalDefense()
	local chanceCritical = 0
	local criticalDamage = 1.5
	local chanceBlock = 0
	local damageReductionMultiplier = 1.0

	if attackerMaster and attackerMaster:isPlayer() then
		local ball = attackerMaster:getUsingBall()
		if ball then
			local heldType = "critical"
			local ident = ball:getAttribute(ITEM_ATTRIBUTE_HELDY)
			local isCriticalHeld = isHeld(heldType, ident)

			if isCriticalHeld then
				local tier = HELDS_Y_INFO[ident].tier
				chanceCritical = chanceCritical + HELDS_BONUS[heldType][tier]
			end
		end

		local guild = attackerMaster:getGuild()
		if guild then
			local hasCriticalChanceBuff = guild:hasBuff(COLUMN_2, CRITICAL_CHANCE_BUFF)
			if hasCriticalChanceBuff then
				chanceCritical = chanceCritical + GUILD_BUFF_CRITICAL_CHANCE
			end

			local hasCriticalDamageBuff = guild:hasBuff(COLUMN_2, CRITICAL_DAMAGE_BUFF)
			if hasCriticalDamageBuff then
				criticalDamage = criticalDamage + (GUILD_BUFF_CRITICAL_DAMAGE / 100)
			end

			local hasDefenseBuff = guild:hasBuff(COLUMN_3, DEFENSE_BUFF)
			if hasDefenseBuff then
				damageReductionMultiplier = damageReductionMultiplier * (1 + GUILD_BUFF_DEFENSE / 100)
			end
		end
	end

	if chanceCritical > 0 and math.random(1, 100) <= chanceCritical then
		localDamageMultiplier = localDamageMultiplier * criticalDamage
		isCritical = true
	end

	local reducaoDano = calcularReducaoDano(defense, damageReductionMultiplier)
	localDamageMultiplier = localDamageMultiplier * (1 - (reducaoDano / 100))
	if primaryDamage then primaryDamage = primaryDamage * localDamageMultiplier end

	local masterCreature = creature:getMaster()
	if masterCreature and masterCreature:isPlayer() then
        addEvent(function(pid)
            local p = Player(pid)
            if p then doSendPokeTeamByClient(p) end
        end, 100, masterCreature:getId())

		local ball = masterCreature:getUsingBall()
		if ball then
			local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
			local type = "return"
			local isReturnHeld = isHeld(type, heldx)
			if isReturnHeld then
				local tier = HELDS_X_INFO[heldx].tier
				local porcentagemDano = HELDS_BONUS[type][tier]
				local damageToReturn = (primaryDamage * porcentagemDano)
				doTargetCombatHealth(creature.uid, attacker.uid, COMBAT_NORMALDAMAGE, damageToReturn, damageToReturn, 0, ORIGIN_RETURN)
			end
		end
		local guild = masterCreature:getGuild()
		if guild then
			local hasBlockChance = guild:hasBuff(COLUMN_6, BLOCK_CHANCE_BUFF)
			if hasBlockChance then
				chanceBlock = chanceBlock + GUILD_BUFF_BLOCK
			end
		end
	end

	if math.random(100) <= chanceBlock then
		Game.sendAnimatedText(creature:getPosition(), "BLOCK", TEXTCOLOR_WHITE_EXP, true)
		return 0, primaryType, false
	end

	return primaryDamage, primaryType, isCritical
end
