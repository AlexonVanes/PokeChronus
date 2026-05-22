local config = {
    cooldownTime = 60
}

local playerCooldowns = {}

function onSay(player, words, param)
    local destinations = {
        Npc = {x = 3157, y = 2957, z = 8},
        Boxs = {x = 3170, y = 2978, z = 10},
        Teleports = {x = 3052, y = 2840, z = 15},
        SuperBoxs = {x = 3207, y = 2977, z = 10},
        FarmsFree = {x = 3237, y = 2977, z = 10},
        FarmsVip = {x = 828, y = 2063, z = 9},
        AreaVip = {x = 790, y = 2059, z = 6},
        HuntsLevel = {x = 788, y = 2057, z = 9},
        HuntsReset = {x = 3071, y = 2982, z = 9},
        DimensionZone = {x = 3956, y = 2493, z = 4},
        Pesca = {x = 2958, y = 2903, z = 7},
        Stones = {x = 3085, y = 2946, z = 8},
        Pvp = {x = 3018, y = 2297, z = 14},
        Outfits = {x = 3244, y = 3004, z = 10},
        Minerar = {x = 766, y = 1718, z = 7}
    }

    local playerCooldown = playerCooldowns[player:getId()]
    local currentTime = os.time()

    if playerCooldown and playerCooldown > currentTime then
        local remainingTime = playerCooldown - currentTime
        player:sendCancelMessage("Você precisa aguardar mais " .. remainingTime .. " segundos antes de usar o comando novamente.")
        return true
    end

    if param == "" then
        local warpNames = ""
        for key, _ in pairs(destinations) do
            warpNames = warpNames .. key .. ", "
        end
        warpNames = string.sub(warpNames, 1, -3)

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Warps disponíveis: " .. warpNames)
    else
        local lowerParam = string.lower(param)
        local destination = nil

        for key, value in pairs(destinations) do
            if string.lower(key) == lowerParam then
                destination = value
                break
            end
        end

        if destination then
            if lowerParam == "dimensionzone" and player:getLevel() < 15000 then
                player:sendCancelMessage("Você precisa ser pelo menos level 15000 para ser teleportado para a Dimensão.")
                return true
            elseif lowerParam == "mineracao" and player:getStorageValue(102231) < 10 then
                player:sendCancelMessage("Você precisa ter pelo menos 10 resets para ir para mineração.")
                return true
            else
                player:teleportTo(destination)
                player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Teleportado para: " .. lowerParam)
            end

            playerCooldowns[player:getId()] = currentTime + config.cooldownTime
        else
            player:sendCancelMessage("Essa warp não existe!")
        end
    end
    return false
end