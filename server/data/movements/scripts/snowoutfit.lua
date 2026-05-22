-- Storages outfit
local STORAGE = {
    lookType = 50000,
    head     = 50001,
    body     = 50002,
    legs     = 50003,
    feet     = 50004
}

-- Storages de estado
local STATE = {
    ride = 5000,
    fly  = 5001,
    surf = 5002
}

-- Outfit do piso
local OUTFIT = {
    male   = 2697,
    female = 2698
}

-- 🔹 Verifica se player está em algum estado especial
local function isBusy(player)
    return player:getStorageValue(STATE.ride) > 0 or
           player:getStorageValue(STATE.fly)  > 0 or
           player:getStorageValue(STATE.surf) > 0
end

-- 🔹 Salva outfit atual
local function saveOutfit(player)
    local outfit = player:getOutfit()
    player:setStorageValue(STORAGE.lookType, outfit.lookType)
    player:setStorageValue(STORAGE.head, outfit.lookHead)
    player:setStorageValue(STORAGE.body, outfit.lookBody)
    player:setStorageValue(STORAGE.legs, outfit.lookLegs)
    player:setStorageValue(STORAGE.feet, outfit.lookFeet)
end

-- 🔹 Recupera outfit salvo
local function getSavedOutfit(player)
    local lookType = player:getStorageValue(STORAGE.lookType)
    if lookType <= 0 then
        return nil
    end

    return {
        lookType = lookType,
        lookHead = player:getStorageValue(STORAGE.head),
        lookBody = player:getStorageValue(STORAGE.body),
        lookLegs = player:getStorageValue(STORAGE.legs),
        lookFeet = player:getStorageValue(STORAGE.feet)
    }
end

-- 🔹 Limpa storages
local function clearOutfit(player)
    for _, v in pairs(STORAGE) do
        player:setStorageValue(v, -1)
    end
end

function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end

    local player = creature

    -- 🚫 Não faz nada se estiver em Ride/Fly/Surf
    if isBusy(player) then
        return true
    end

    -- Salva outfit se necessário
    if player:getStorageValue(STORAGE.lookType) <= 0 then
        saveOutfit(player)
    end

    local current = player:getOutfit()
    local desired = player:getSex() == PLAYERSEX_FEMALE and OUTFIT.female or OUTFIT.male

    if current.lookType ~= desired then
        player:setOutfit({
            lookType = desired,
            lookHead = current.lookHead,
            lookBody = current.lookBody,
            lookLegs = current.lookLegs,
            lookFeet = current.lookFeet
        })
    end

    return true
end

function onStepOut(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end

    local player = creature

    -- 🚫 Não restaura se estiver em Ride/Fly/Surf
    if isBusy(player) then
        return true
    end

    local oldOutfit = getSavedOutfit(player)
    if not oldOutfit then
        return true
    end

    if player:getOutfit().lookType ~= oldOutfit.lookType then
        player:setOutfit(oldOutfit)
    end

    clearOutfit(player)
    return true
end