function onSay(player, words, param)
    local targetPlayerName, amount = param:match("([^,]+),%s*(%d+)")
    
    if not targetPlayerName or not amount then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use: !sellhalloween <playerName>, <amount>")
        return false
    end
    
    local targetPlayer = Player(targetPlayerName)
    
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "O jogador alvo não está online.")
        return false
    end
	
    if targetPlayer == player then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você Não Pode Enviar Halloween Points Para Si Mesmo.")
        return false
    end
    
    amount = tonumber(amount)
    
    if amount <= 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "A quantidade deve ser maior que zero.")
        return false
    end
    
    local playerStorage = player:getStorageValue(624499) or 0
    
    if playerStorage < amount then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você Não Possui Halloween Points Suficiente.")
        return false
    end
    
    player:setStorageValue(624499, playerStorage - amount)
    targetPlayer:setStorageValue(624499, (targetPlayer:getStorageValue(624499) or 0) + amount)
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você Enviou " .. amount .. " Halloween Points Para " .. targetPlayerName)
    targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você Recebeu " .. amount .. " Halloween Points De " .. player:getName())
    
    return false
end
