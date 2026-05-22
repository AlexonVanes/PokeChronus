function onSay(player, words, param)


if not player:getGroup():getAccess() then
    return true
end

if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return true
end


local ball = player:getUsingBall()
if not ball then return false end
ball:setSpecialAttribute("ownerPokemon", param)  
    return false
end
