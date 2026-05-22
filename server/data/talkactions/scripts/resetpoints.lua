function onSay(player, words, param)
    local resetPoints = player:getStorageValue(32070)

    if resetPoints ~= -1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você tem " .. resetPoints .. " Reset Points.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você não tem Reset Points.")
    end

    return false
end
