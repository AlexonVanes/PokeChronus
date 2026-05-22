function onSay(player, words, param)
    local group = player:getGroup()
    if group and group:getId() >= 6 then
        -- Verifique o valor de 'param'
        local outfitId = tonumber(param)
        if outfitId and outfitId > 0 then
            local outfit = {lookType = outfitId}
            player:setOutfit(outfit)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Seu outfit foi alterado para " .. outfitId .. ".")
        else
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Por favor, forneça um ID de outfit válido.")
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você não tem permissão para usar este comando.")
    end
    return false
end