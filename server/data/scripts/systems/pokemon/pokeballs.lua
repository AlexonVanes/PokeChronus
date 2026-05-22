CONST_EXHAUST_POKEBALL = 500
local ACTIVE_POKEBALL_SLOT = CONST_SLOT_AMMO

function Player.canSummonPokemon(self, ball)
    local pokeName = ball:getSpecialAttribute("pokeName") or ball:getCustomAttribute("pokeName")
    if pokeName then
        local pokemonType = MonsterType(pokeName)
        if pokemonType then
            local minLevel = pokemonType:minimumLevel()
            local pLevel = self:getLevel()
            if pLevel < minLevel then
                self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need to be at least level " .. minLevel .. " to summon this pokemon.")
                return false
            end
        end
    end
    return true
end

local function getActiveSlotBall(player)
    local ball = player:getSlotItem(ACTIVE_POKEBALL_SLOT)
    if ball and ball:isPokeball() then
        return ball
    end
    return nil
end

local function moveBallToBallpack(player, ball)
    if not ball then
        return true
    end
    if ball:getTopParent() ~= player then
        return true
    end

    local ballpack = player:getOrCreateBallpack()
    if ballpack and ballpack:getEmptySlots() > 0 then
        return ball:moveTo(ballpack)
    end

    return false
end

local function moveBallToActiveSlot(player, ball)
    if not ball then
        return nil
    end

    local activeBall = getActiveSlotBall(player)
    if activeBall == ball then
        return ball
    end

    if activeBall then
        activeBall:setSpecialAttribute("isBeingUsed", 0)
        local activeBallKey = getBallKey(activeBall:getId())
        if activeBall:getId() == balls[activeBallKey].usedOff then
            activeBall:transform(balls[activeBallKey].usedOn)
        end
        if not moveBallToBallpack(player, activeBall) then
            return nil
        end
    end

    if not ball:moveTo(player) then
        return nil
    end

    local movedBall = getActiveSlotBall(player)
    if movedBall == ball then
        return movedBall
    end

    return nil
end

local function getPlayerPokeballsWithActive(player)
    return player:getCarriedPokemonBalls()
end

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local timeNow = os.mtime()
    if timeNow < player:getLastTimePokeballUse() then
        return true
    end
    if player:isSummonBlocked() then return true end

    player:setLastTimePokeballUse(timeNow + CONST_EXHAUST_POKEBALL)
    local ballKey = getBallKey(item:getId())
    if not ballKey or not balls[ballKey] then return true end

    if hasSummons(player) then
        local usingBall = player:getUsingBall()
        if not usingBall or usingBall ~= item then return true end
        doRemoveSummon(player:getId(), balls[ballKey].effectRelease, false, true, balls[ballKey].missile)
        player:setUsingPokeball(false)
        item:transform(balls[ballKey].usedOn)
        item:setSpecialAttribute("isBeingUsed", 0)
    else
        if not player:canSummonPokemon(item) then return true end
        if item:getTopParent() == player then
            local activeBall = moveBallToActiveSlot(player, item)
            if not activeBall then
                player:sendCancelMessage("Put away the active pokeball slot item first.")
                return true
            end

            item = activeBall
            ballKey = getBallKey(item:getId())
            player:setUsingPokeball(item)

            item:transform(balls[ballKey].usedOff)
            item:setSpecialAttribute("isBeingUsed", 1)

            doReleaseSummon(player:getId(), player:getPosition(), balls[ballKey].effectRelease, true, balls[ballKey].missile)
        else
            if item:getSpecialAttribute("isBeingUsed") == 1 then
                item:transform(balls[ballKey].usedOn)
                item:setSpecialAttribute("isBeingUsed", 0)
            end
        end
    end
    return true
end

for _, pokeball in pairs(balls) do
    action:id(pokeball.usedOn)
    action:id(pokeball.usedOff)
end

action:register()

local talkaction = TalkAction("!p")

function talkaction.onSay(player, words, param)
    local timeNow = os.mtime()
    if timeNow < player:getLastTimePokeballUse() then
        return false
    end
    if player:isSummonBlocked() then return false end
    player:setLastTimePokeballUse(timeNow + CONST_EXHAUST_POKEBALL)

    local index = tonumber(param)
    if not index then return false end

    local pokeballs = getPlayerPokeballsWithActive(player)
    local ball = pokeballs[index]
    if not ball then
        doSendPokeTeamByClient(player)
        return false
    end

    local usingBall = player:getUsingBall()
    if hasSummons(player) then
        if not usingBall then
            doSendPokeTeamByClient(player)
            return false
        end
        local usingBallKey = getBallKey(usingBall:getId())
        if not usingBallKey or not balls[usingBallKey] then
            usingBall:setSpecialAttribute("isBeingUsed", 0)
            player:setUsingPokeball(false)
            doSendPokeTeamByClient(player)
            return false
        end
        doRemoveSummon(player:getId(), balls[usingBallKey].effectRelease, false, true, balls[usingBallKey].missile)
        player:setUsingPokeball(false)
        usingBall:transform(balls[usingBallKey].usedOn)
        usingBall:setSpecialAttribute("isBeingUsed", 0)
    end
    local position = player:getPosition()
    if ball ~= usingBall then
        if not player:canSummonPokemon(ball) then return false end
        local ballKey = getBallKey(ball:getId())
        if not ballKey or not balls[ballKey] then return false end
        local activeBall = moveBallToActiveSlot(player, ball)
        if not activeBall then
            player:sendCancelMessage("Put away the active pokeball slot item first.")
            doSendPokeTeamByClient(player)
            return false
        end

        ball = activeBall
        ballKey = getBallKey(ball:getId())
        if not ballKey or not balls[ballKey] then return false end
        ball:transform(balls[ballKey].usedOff)
        ball:setSpecialAttribute("isBeingUsed", 1)

        player:setUsingPokeball(ball)
        doReleaseSummon(player:getId(), position, balls[ballKey].effectRelease, true, balls[ballKey].missile)
    end
    doSendPokeTeamByClient(player)
    return false
end

talkaction:separator(" ")
talkaction:register()

local creatureevent = CreatureEvent("testeBallLogin")

function creatureevent.onLogin(player)
    player:migratePokeballsToBallpack()
    player:updateStoredPokemonList()
    doSendPokeTeamByClient(player)
	return true
end

creatureevent:register()


function Player.handlePokebar(self, buffer)
    local ok, payload = pcall(function() return json.decode(buffer) end)
    if not ok or type(payload) ~= "table" then
        return
    end

    if payload.type == "revive" then
        if not (self:revivePokemon(payload.info)) then
            self:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
	elseif payload.type == "update" then
		doSendPokeTeamByClient(self:getId())
    end
    return true
end

function Item:resetMoves()
	for i = 1, 12 do
		self:setSpecialAttribute("cd" .. i, 0)
	end
end

function isReviveClient(itemId)
    local revives = {25228}
    if isInArray(revives, itemId) then
        return true
    end
    return false
end

function Player:revivePokemon(info)
    -- dump(info)
    local pokeballs = getPlayerPokeballsWithActive(self)
    if not pokeballs or #pokeballs == 0 then
        return false
    end

	if not isReviveClient(info.clientId) then
		return false
	end

    local reviveItem = info.position and self:getItemByPos(info.position, info.stackpos, info.clientId) or Game.getItemIdByClientID(info.clientId)
    if not reviveItem then
       return
    end

    if type(reviveItem) ~= "userdata" then
        if self:getItemCount(reviveItem) < 1 then
            return false
        end
    end

    local pokeball = pokeballs[tonumber(info.index)]
    if not pokeball then
        return false
    end

	local ball = self:getUsingBall()
	if ball then
        if (pokeball == ball and #self:getSummons() > 0 and not self:isOnFly()) or (pokeball == ball and self:isOnFly() and #self:getSummons() == 0)then
	    	return false
	    end
    end

	local summonName = pokeball:getSpecialAttribute("pokeName")

	pokeball:resetMoves()

	pokeball:setSpecialAttribute("pokeHealth", MonsterType(summonName):getHealth() * 10000)
	local ballKey = getBallKey(pokeball:getId())
	if not ballKey or not balls[ballKey] then
		return false
	end
	pokeball:transform(balls[ballKey].usedOn)
	self:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	if type(reviveItem) == "userdata" and reviveItem:remove(1) or self:removeItem(reviveItem, 1) then
		doUpdatePokebarOnRevive(self, info.index)
	end
    return true
end

function doUpdatePokebarOnRevive(player, index)
	local player = type(player) == "userdata" and player or type(player) == "number" and Player(player)
	doSendPokeTeamByClient(player)
end

function doSendPokeTeamByClient(player)
    player = Player(player)
    local pokeballs = getPlayerPokeballsWithActive(player)
    local pokemons = {}

    local pokesHost = {}
    local isHosting = player:isHosting()
    for i, ball in ipairs(pokeballs) do
        local pokeName = ball:getSpecialAttribute("pokeName") or ""
        local monsterType = MonsterType(pokeName)
        
        if monsterType then
            local maxHealth = monsterType:getTotalHealth(ball, player)
            local curHealth = ball:getSpecialAttribute("pokeHealth") or 0
            local lookType = monsterType:getOutfit().lookType

            if Ditto and Ditto.isDittoBall and Ditto.isDittoBall(ball) and Ditto.getTransform then
                local tf = Ditto.getTransform(ball)
                if tf and tf.name then
                    local transformedType = MonsterType(tf.name)
                    if transformedType then
                        maxHealth = tonumber(ball:getCustomAttribute("ditto_max_health")) or maxHealth
                        lookType = tf.lookType or transformedType:getOutfit().lookType
                    end
                end
            end

            -- Se o pokemon estiver fora, pega a vida real da criatura
            if ball:getSpecialAttribute("isBeingUsed") == 1 then
                local summons = player:getSummons()
                if summons and summons[1] then
                    local summon = Creature(summons[1])
                    curHealth = summon:getHealth()
                    maxHealth = summon:getMaxHealth()
                end
            end

            -- Forçar a escala correta se necessário (muitos servidores usam escala de 10000x)
            if curHealth > maxHealth then
                if curHealth / 10000 <= maxHealth then
                    curHealth = curHealth / 10000
                elseif curHealth / 100 <= maxHealth then
                    curHealth = curHealth / 100
                end
            end

            local healthPercent = maxHealth > 0 and math.floor((curHealth / maxHealth) * 100) or 0
            healthPercent = math.max(0, math.min(100, healthPercent))

            local ballItemType = ItemType(ball:getId())
            local ballClientId = ballItemType and ballItemType:getClientId() or 0

            local pokemon = {
                type = "PokeBar",
                pokeid = "!p " .. i,
                name = pokeName,
                nickname = ball:getSpecialAttribute("nickname"),
                use = ball:getSpecialAttribute("isBeingUsed") == 1 or false,
                text = (ball:getSpecialAttribute("isBeingUsed") == 1) and "USE" or "",
                cooldown = -1,
                ball = getBallKey(ball:getId()),
                ballClientId = ballClientId,
                health = curHealth,
                maxHealth = maxHealth,
                looktype = lookType,
                boost = ball:getSpecialAttribute("pokeBoost") or 0,
                fastcallNumber = i,
            }
            table.insert(pokemons, pokemon)
            if isHosting then
                pokesHost[i] = {name = pokemon.name, lookType = pokemon.looktype}
            end
        end
    end
    if isHosting then
        Hosts[player:getId()].pokeballs = pokesHost
        local spectators = player:getSpectators()
        for i, spectator in ipairs(spectators) do
            spectator:sendHostData()
        end
    end
	player:sendExtendedOpcode(53, json.encode(pokemons))
end
