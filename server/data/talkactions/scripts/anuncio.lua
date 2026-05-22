local config = {
    storage = 19415, -- storage onde o tempo será salvo
    tempo = 5, -- em minutos
    itemid = 2161,
    price = 20, -- quantidade de dinheiro que irá custar
}

function onSay(cid, words, param, channel)
    local player = Player(cid) -- Cria um objeto Player
    
    if param == '' then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parâmetro do comando é necessário.")
        return true
    end
    
    local playerName = player:getName()
    local formattedMessage = "[ANÚNCIO]: " .. playerName .. ": " .. param
    
    if player:getStorageValue(config.storage) - os.time() <= 0 then
        if player:removeMoney(config.price) then
            player:setStorageValue(config.storage, os.time() + (config.tempo * 60)) 
            Game.broadcastMessage(formattedMessage, COLOR_LIGHTSTEELBLUE) -- Envia a mensagem de anúncio com a cor COLOR_LIGHTSTEELBLUE
            return true
        else
            player:sendCancelMessage("Você não tem " .. config.price .. " " .. ItemType(config.itemid):getName() .. " para fazer um anúncio.")
            return true
        end
    else
        player:sendCancelMessage("Você precisa esperar " .. (player:getStorageValue(config.storage) - os.time()) .. " segundos para falar novamente.")
        return true
    end
end
