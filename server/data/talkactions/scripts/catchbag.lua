local CATCH_BAG_CONTAINER_ID = 14

function onSay(player, words, param)
    local catchBag = player:getOrCreateCatchBag()
    if not catchBag then
        player:sendCancelMessage("Catch Bag nao encontrada.")
        return false
    end

    if not player.openContainer or not player.closeContainer then
        player:sendCancelMessage("Catch Bag preparada. Clique novamente no botao CATCH para abrir.")
        return false
    end

    local openedId = player:getContainerId(catchBag)
    if openedId and openedId >= 0 then
        player:closeContainer(openedId)
        return false
    end

    player:openContainer(catchBag, CATCH_BAG_CONTAINER_ID, false)
    return false
end
