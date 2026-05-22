function onSay(player, words, param)
    local ball = player:getDittoBall()
    if not ball then
        player:sendCancelMessage("You don't have a Ditto active.")
        return true
    end

    local tf = ball:getCustomAttribute("ditto_transform")
    if not tf or tf == "" or tf == 0 then
        player:sendCancelMessage("Ditto is not transformed.")
        return true
    end

    if Ditto and Ditto.revert and Ditto.revert(player) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Ditto] Reverted to original form.")
    end

    return true
end
