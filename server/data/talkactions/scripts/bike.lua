local STORAGE_ACTIVE = 128238

local BIKE_MOUNTS = {
    [41505] = {velocidade = 2000, female = 2712, male = 2713},
    [27634] = {velocidade = 2000, female = 2712, male = 2713},
    [13218] = {velocidade = 2000, female = 1993, male = 1993}
}

local function restoreOutfit(player, originalLookType)
    player:setOutfit({
        lookType = originalLookType,
        lookHead = player:getStorageValue(128239),
        lookBody = player:getStorageValue(128240),
        lookLegs = player:getStorageValue(128241),
        lookFeet = player:getStorageValue(128242),
        lookAddons = player:getStorageValue(128243)
    })

    player:setStorageValue(128238, 0)
    player:setStorageValue(128239, 0)
    player:setStorageValue(128240, 0)
    player:setStorageValue(128241, 0)
    player:setStorageValue(128242, 0)
    player:setStorageValue(128243, 0)
    player:removeCondition(CONDITION_HASTE)
end

function onSay(player, words, param)
    local bike = player:getSlotItem(CONST_SLOT_RING)
    local mountInfo = bike and BIKE_MOUNTS[bike:getId()]
    if not mountInfo then
        player:sendCancelMessage("Equipe uma bike no slot de bike.")
        return false
    end

    local originalLookType = player:getStorageValue(STORAGE_ACTIVE)
    if originalLookType > 0 then
        restoreOutfit(player, originalLookType)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Bike OFF")
        player:setStorageValue(storageBike, -1)
        return false
    end

    if player:isOnFly() or player:isOnRide() or player:isOnDive() or player:isOnSurf() or player:isOnEvent() or player:isOnLeague() then
        player:sendCancelMessage("Voce esta ocupado.")
        return false
    end

    local outfit = player:getOutfit()
    player:setStorageValue(128238, outfit.lookType)
    player:setStorageValue(128239, outfit.lookHead)
    player:setStorageValue(128240, outfit.lookBody)
    player:setStorageValue(128241, outfit.lookLegs)
    player:setStorageValue(128242, outfit.lookFeet)
    player:setStorageValue(128243, outfit.lookAddons)

    local bikeOutfit = player:getSex() == 1 and mountInfo.male or mountInfo.female
    player:setOutfit({
        lookType = bikeOutfit,
        lookHead = outfit.lookHead,
        lookBody = outfit.lookBody,
        lookLegs = outfit.lookLegs,
        lookFeet = outfit.lookFeet,
        lookAddons = outfit.lookAddons
    })

    local condition = Condition(CONDITION_HASTE)
    condition:setParameter(CONDITION_PARAM_SPEED, mountInfo.velocidade)
    condition:setTicks(-1)
    player:addCondition(condition)
    player:setStorageValue(storageBike, mountInfo.velocidade)

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Bike ON")
    return false
end
