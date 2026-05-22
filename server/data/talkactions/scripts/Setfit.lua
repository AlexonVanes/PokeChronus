function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local params = {param:match("([^,]+),%s*(%d+)")}

    if #params < 2 then
        player:sendCancelMessage("Uso: //setfit <nome_do_player> <outfit_id>")
        return true
    end

    local playerName = params[1]
    local outfitId = tonumber(params[2])

    if not outfitId or not Outfits.isOutfit(outfitId) then
        player:sendCancelMessage("O ID do outfit é inválido.")
        return true
    end

    local targetPlayer = Player(playerName)

    if not targetPlayer then
        player:sendCancelMessage("Jogador não encontrado.")
        return true
    end

    targetPlayer:addOutfit(outfitId)
    targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Seu outfit foi definido por um membro da equipe.")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Outfit definido com sucesso para " .. targetPlayer:getName() .. ".")
    return true
end
