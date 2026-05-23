function doPlayerSendEffect(cid, effect)
    local player = Player(cid)
    if player then
        player:getPosition():sendMagicEffect(effect)
    end
    return true
end

function doPlayerAddExperience(cid, exp)
    local player = Player(cid)
    if player then
        player:addExperience(exp, true)
    end
    return true
end

function isPokemonNormal(name)
    name = name:lower()
    return not name:find("shiny ") and not name:find("mega ")
end

function isPokemonShiny(name)
    name = name:lower()
    return name:find("shiny ")
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tile = Tile(toPosition)
    if not tile or not tile:getTopDownItem() then
        return false
    end

    local corpse = tile:getTopDownItem()
    local itype = ItemType(corpse:getId())
    if not itype:isCorpse() and not itype:getName():lower():find("fainted") then
        return false
    end

    local owner = corpse:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
    if owner ~= 0 and owner ~= player:getId() then
        player:sendCancelMessage("Sorry, not possible. You are not the owner.")
        return true
    end

    local ballKey = getBallKey(item:getId())
    if not ballKey then
        return true
    end

    local playerPos = player:getPosition()
    local distance = getDistanceBetween(playerPos, toPosition)

    local delay = distance * 80
    local delayMessage = delay + 2800
    local finalDelay = delayMessage + 1000

    local name = corpse:getName()
    name = name:gsub(" a ", "")
               :gsub(" an ", "")
               :gsub("fainted ", "")
    name = capitalizeFirstLetter(name)

    local monsterType = MonsterType(name)
    if not monsterType then
        player:sendCancelMessage("Sorry, not possible. This problem was reported.")
        playerPos:sendMagicEffect(CONST_ME_POFF)
        corpse:remove()
        return true
    end

    local type1 = monsterType:getRaceName() or "none"
    local type2 = monsterType:getRace2Name() or "none"

    if isInArray(LOWER_PALWORLD_MONSTERS, name:lower()) then
        type1, type2 = "palworld", "palworld"
        if not isInArray(ALLOWED_POKEBALLS_PALWORLD, item.itemid) then
            player:sendCancelMessage("Voce so pode capturar pals com esferas.")
            return true
        end
    end

    if isInArray(LOWER_MASTERBALL_BLOCKED, name:lower()) and item.itemid == 13228 then
        player:sendCancelMessage("Esse Pokemon e bloqueado para uso de masterball.")
        return true
    end

    local chanceBase = monsterType:catchChance()
    if chanceBase <= 0 then
        playerPos:sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("Sorry, it is impossible to catch this monster.")
        return true
    end

    local pontos = math.max(
        TYPES_POINTS[type1][item.itemid] or 0,
        TYPES_POINTS[type2][item.itemid] or 0
    )

    local guild = player:getGuild()
    if guild and guild:hasBuff(COLUMN_4, CRITICAL_CATCH_BUFF) then
        if math.random(0, 100) <= GUILD_BUFF_LUCKY then
            chanceBase = chanceBase * 2
            local criticalEffectPosition = toPosition + Position(1, 1, 0)
            criticalEffectPosition:sendMagicEffect(2511)
            criticalEffectPosition:sendMagicEffect(2512)
        end
    end

    local chance = chanceBase * balls[ballKey].chanceMultiplier

    -- ATRIBUTOS DO CORPSE
    local gender = corpse:getCustomAttribute("newgender") or 2
    local level  = corpse:getCustomAttribute("level") or 1
    local stars  = corpse:getCustomAttribute("pokestars") or 1
    local rank   = corpse:getCustomAttribute("pokerank") or 1

    doSendDistanceShoot(playerPos, toPosition, balls[ballKey].missile)
    item:remove(1)
    corpse:remove()

    local playerId = player:getId()
    local lowerName = name:lower()

    -- ================= SUCESSO =================
    if math.random(0, 10000) <= chance
        or (INFOS_CATCH[lowerName]
        and (pontos + player:getCatchPoints(name)) >= INFOS_CATCH[lowerName].pontos)
    then
        addEvent(function()
            local p = Player(playerId)
            if not p then return end

            local pokeball, destination = p:addCaughtPokemon(name, item.itemid, gender, level, stars, rank)
            if not pokeball then
                p:sendCancelMessage("Erro ao entregar o Pokemon capturado.")
                return
            end

            p:resetCatchTry(name)

            -- mensagem SEM acentos e APOS adicionar o pokemon
            local destinationMessage = destination == "depot" and " Seu Pokemon foi enviado ao depot porque a Catch Bag estava cheia." or " Ele foi enviado para sua Catch Bag."
            p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Parabens! Voce capturou um " .. name .. "!" .. destinationMessage)
        end, finalDelay)

        addEvent(doSendMagicEffect, delay, toPosition, balls[ballKey].effectSucceed)
        addEvent(doPlayerSendEffect, delayMessage + 1000, playerId, 179)

        addEvent(function()
            local p = Player(playerId)
            if p then
                p:updatePassMission("capture", 1)
            end
        end, finalDelay + 100)

        local dex = monsterType:getNumber()
        local storageDexId = baseStorageDex + dex
        if player:getStorageValue(storageDexId) < 1 then
            player:setStorageValue(storageDexId, 1)
            if player.updatePassMission then
                player:updatePassMission("capture_unique", 1)
            end
            local expReward = (FIRST_CAPTURE_XP and FIRST_CAPTURE_XP[lowerName]) or (FIRST_CAPTURE_XP_DEFAULT) or 5000
            if expReward > 0 then
                doPlayerAddExperience(playerId, expReward)
            end
            doPlayerSendTextMessage(
                playerId,
                MESSAGE_EVENT_ADVANCE,
                "Primeira captura de " .. name .. "! +" .. expReward .. " EXP."
            )
        end

    -- ================= FALHA =================
    else
        addEvent(doSendMagicEffect, delay, toPosition, balls[ballKey].effectFail)
        addEvent(doPlayerSendEffect, delayMessage + 1000, playerId, 167)

        addEvent(function()
            local p = Player(playerId)
            if p then
                p:addCatchTry(name, ballKey, pontos)
            end
        end, delay)
    end

    return true
end
