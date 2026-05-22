local firstItems = {1987}
local freeVipStorage = 1650001
local freeVipDays = 3

function onLogin(player)
    local isFirstLogin = player:getLastLoginSaved() == 0

    if isFirstLogin then
        player:teleportTo(Position(2276, 2700, 5)) -- Teleporta o jogador para a posicao desejada

        for i = 1, #firstItems do
            player:addItem(firstItems[i], 1)
        end
    end

    if player:getStorageValue(freeVipStorage) ~= 1 and (isFirstLogin or player:getLevel() <= 8) then
        player:setStorageValue(freeVipStorage, 1)
        player:addVipPlus(freeVipDays)
        pcall(function() player:sendPlayerbarVipData() end)
    end

    return true
end