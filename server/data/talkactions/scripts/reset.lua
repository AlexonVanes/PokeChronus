function onSay(player, words, param)
    local resetPoints = player:getStorageValue(102231)

    if resetPoints ~= -1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você tem " .. resetPoints .. " Resets.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você não tem Resets.")
    end

    return false
end

