function onSay(player, words, param)


if not player:getGroup():getAccess() then
    return true
end

if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return true
end
	
if type(tonumber(param)) ~= "number" then doPlayerSendTextMessage(player, 19, "você precisa colocar um numero valido") return false end 



param = tonumber(param)

if param == 0 then

setGlobalStorageValue(1, 0)
broadcastMessage("[DOUBLE-EXP]: OFF", MESSAGE_EVENT_ADVANCE)
	return false
else 
param = param * 3600
setGlobalStorageValue(1, os.time() + param)
broadcastMessage("[DOUBLE-EXP]: Ativado por: "..(param/3600).."h", MESSAGE_EVENT_ADVANCE)
	return false
end

end
