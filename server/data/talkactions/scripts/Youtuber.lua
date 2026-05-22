function onSay(player, words, param)
    -- Lista de nomes permitidos
    local allowedNames = {"Koiakudo", "Loces", "Maaster"}

    -- Verifica se o nome do jogador está na lista de nomes permitidos
    if isInArray(allowedNames, player:getName()) then
        -- Verifica se já passou uma semana desde a última vez
        if player:getStorageValue(76547) <= os.time() then
            -- Atualiza o storage para a próxima semana
            player:setStorageValue(76547, os.time() + 7 * 24 * 60 * 60)

            -- Lista de itens para dar ao jogador
            local itemsToGive = {
                {17313, 5},
                {17312, 5},
                {17311, 5},
                {17314, 5},
                {22664, 1},
                {20651, 3},
                {20699, 5},
                {20700, 5},
                {20701, 5}
            }

            -- Dá os itens ao jogador
            for i = 1, #itemsToGive do
                player:addItem(itemsToGive[i][1], itemsToGive[i][2])
            end

            player:sendTextMessage(MESSAGE_INFO_DESCR, "Você recebeu seus itens semanais.")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Você já pegou seus itens esta semana.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você não tem permissão para pegar esses itens.")
    end

    return false
end
