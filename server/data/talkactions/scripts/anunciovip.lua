local config = {
    storage = 19400, -- storage onde o tempo será salvo
    cor = "green", -- de acordo com o constant.lua da biblioteca
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
    
    if player:isPremium() then
        local storageValue = player:getStorageValue(config.storage)
        local currentTime = os.time()
        
        if storageValue - currentTime <= 0 then
            player:setStorageValue(config.storage, currentTime + (config.tempo * 60)) 
            local message = "[ANÚNCIO]: " .. player:getName() .. ": " .. param
            Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE, false, config.cor)
            return true
        else
            player:sendCancelMessage("Aguarde " .. (storageValue - currentTime) .. " segundos para falar novamente.")
            return true
        end
    else
        player:sendCancelMessage("Este comando só pode ser usado por jogadores VIP.")
        return true
    end
end
