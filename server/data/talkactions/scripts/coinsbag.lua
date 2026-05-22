local COINS_BAG_CONTAINER_ID = 15

function onSay(player, words, param)
    if player.removeInventoryShortcutItems then
        player:removeInventoryShortcutItems()
    end

    local coinsBag = player:getOrCreateCoinsBag()
    if not coinsBag then
        player:sendCancelMessage("Coins Bag nao encontrada.")
        return false
    end

    if not player.openContainer or not player.closeContainer then
        return false
    end

    local openedId = player:getContainerId(coinsBag)
    if openedId and openedId >= 0 then
        player:closeContainer(openedId)
        return false
    end

    player:openContainer(coinsBag, COINS_BAG_CONTAINER_ID, false)
    return false
end
