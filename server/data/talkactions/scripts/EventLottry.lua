dofile('data/lib/systems/EventLottry.lua')

function onSay(player, words, param)
    if param == 'start' then
        if not verifyPermissions(player) then 
            return true
        end
        
        if Lottery:isStarted() then
            player:sendCancelMessage(Lottery:getMsg(LOTTERY_MESSAGE_ERROR_ACTIVE))
        else	
            Lottery:start()
            Game.broadcastMessage("A loteria foi ativada! !loteria info.", MESSAGE_EVENT_ADVANCE)
        end
    elseif param == 'forcestop' then
        if not verifyPermissions(player) then 
            return true 
        end
        Game.broadcastMessage("A loteria foi desativada!.", MESSAGE_EVENT_ADVANCE)
        Lottery:turnOff()
    elseif param == 'info' then
        local message = string.format(Lottery:getMsg(LOTTERY_MESSAGE_INFO), Lottery:getBetPrice(), Lottery:getRewardsName())
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message)
    else
        if Lottery:isStarted() then
            Lottery:bet(player, param)
        else
            player:sendCancelMessage(Lottery:getMsg(LOTTERY_MESSAGE_ERROR_NO_ACTIVE))
        end
    end
    
    return false
end


function verifyPermissions(player)
    if not player:getGroup():getAccess() then
        return false
    end
    
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end
    
    return true
end