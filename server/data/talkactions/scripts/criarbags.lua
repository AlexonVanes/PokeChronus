function onSay(player, words, param)
    -- Verifique se o jogador tem permissão para usar o comando
    if not player:getGroup():getAccess() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem permissão para usar este comando.")
        return false
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem privilégios suficientes para usar este comando.")
        return false
    end
    
    local itemID = 17336 -- ID do item que você quer colocar
    
    local startPos = {x = 3229, y = 2821, z = 9}
    local endPos = {x = 3233, y = 2827, z = 9}
    
    for x = startPos.x, endPos.x do
        for y = startPos.y, endPos.y do
            local pos = {x = x, y = y, z = startPos.z}
            local item = Game.createItem(itemID, 1, pos)
            if item then
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end
        end
    end
    
    return false
end
