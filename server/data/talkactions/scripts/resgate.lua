-- Função para adicionar pontos ao jogador
function doPlayerAddPoint(player)
    local accountId = player:getAccountId()
    local points = db.storeQuery("SELECT `pontos` FROM `accounts` WHERE `id` = " .. accountId)

    if points ~= nil then
        local currentPoints = result.getDataInt(points, "pontos")
        result.free(points)

        -- Atualiza os pontos do jogador no banco de dados
        local newPoints = currentPoints + 1
        db.query("UPDATE `accounts` SET `pontos` = " .. newPoints .. " WHERE `id` = " .. accountId)

        -- Entrega um item (ID 2145) ao jogador por ponto adicionado
        player:addItem(2145, 1)

        return newPoints
    end

    return 0
end

-- Talkaction para resgatar todos os pontos
function onSay(player, words, param)
    if param == "" then
        local accountId = player:getAccountId()
        local currentPoints = 0

        local points = db.storeQuery("SELECT `pontos` FROM `accounts` WHERE `id` = " .. accountId)

        if points ~= nil then
            currentPoints = result.getDataInt(points, "pontos")
            result.free(points)

            if currentPoints > 0 then
                -- Entrega itens (ID 2145) ao jogador com base na quantidade de pontos
                player:addItem(2145, currentPoints)

                -- Define os pontos no banco de dados como zero
                db.query("UPDATE `accounts` SET `pontos` = 0 WHERE `id` = " .. accountId)

                player:sendTextMessage(MESSAGE_INFO_DESCR, "Você resgatou todos os pontos do site. Total de pontos resgatados: " .. currentPoints)
            else
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você não possui pontos para resgatar.")
            end
        else
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "Erro ao obter pontos da conta.")
        end
    end
    return false
end
