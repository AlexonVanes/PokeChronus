function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if not player then
        return true
    end

    -- CONFIG
    local STORAGE_ACTIVE = 128238
    local STORAGE_DELAY  = 128250
    local DELAY_SECONDS  = 5

    local BIKE_ITEM_ID = 41505

    local PLAYERSEX_FEMALE = 0
    local PLAYERSEX_MALE   = 1

    local table_mount = {
        [BIKE_ITEM_ID] = {
            velocidade = 2000,
            female = 2712,
            male   = 2713
        }
    }

    -- Delay
    local now = os.time()
    local nextUse = player:getStorageValue(STORAGE_DELAY)
    if nextUse > now then
        player:sendCancelMessage(
            string.format("Aguarde %d segundos para usar novamente.", nextUse - now)
        )
        return true
    end

    -- Já está usando bike
    if player:getStorageValue(STORAGE_ACTIVE) > 0 then
        player:sendCancelMessage("Você já está usando uma bike. Use !bike para descer.")
        return true
    end

    local mountInfo = table_mount[item:getId()]
    if not mountInfo then
        player:sendCancelMessage("Essa bike não está configurada corretamente.")
        return true
    end

    local originalOutfit = player:getOutfit()

    -- Salva outfit
    player:setStorageValue(128238, originalOutfit.lookType)
    player:setStorageValue(128239, originalOutfit.lookHead)
    player:setStorageValue(128240, originalOutfit.lookBody)
    player:setStorageValue(128241, originalOutfit.lookLegs)
    player:setStorageValue(128242, originalOutfit.lookFeet)
    player:setStorageValue(128243, originalOutfit.lookAddons)

    -- Outfit bike
    local bikeOutfit = player:getSex() == PLAYERSEX_MALE and mountInfo.male or mountInfo.female
    player:setOutfit({
        lookType   = bikeOutfit,
        lookHead   = originalOutfit.lookHead,
        lookBody   = originalOutfit.lookBody,
        lookLegs   = originalOutfit.lookLegs,
        lookFeet   = originalOutfit.lookFeet,
        lookAddons = originalOutfit.lookAddons
    })

    -- Remove item
    item:remove(1)

    -- Velocidade
    local condition = Condition(CONDITION_HASTE)
    condition:setParameter(CONDITION_PARAM_SPEED, mountInfo.velocidade)
    condition:setTicks(-1)
    player:addCondition(condition)

    -- Mensagens
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Bike ON")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use !bike para descer da bike.")

    -- Aplica delay
    player:setStorageValue(STORAGE_DELAY, now + DELAY_SECONDS)

    return true
end
