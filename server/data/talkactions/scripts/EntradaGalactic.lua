function onSay(cid, words, param) 
  
  local second = 10   -- Tempo para a estátua aparecer denovo, em segundos.

  local trapPos = {x = 4125, y = 2195, z = 5, stackpos = 1}  -- posição da estátua
  local trap = getThingFromPos(trapPos)
  local trapId = 1551     -- id da estátua .

  local player = {x = 4126, y = 2195, z = 5}  -- posição que o player deve estar.
     function create()
      doCreateItem(trapId, 1, trapPos)
      doSendMagicEffect(trapPos, 6)
    return true
   end  
   
    if getThingPos(cid).x ~= player.x or getThingPos(cid).y ~= player.y or getThingPos(cid).z ~= player.z then
        return doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Você não pode utilizar este comando fora do SQM correto.")
    end
        if trap.itemid == trapId then
            doRemoveItem(trap.uid, 1)
            doSendMagicEffect(trapPos, 2)
            addEvent(create, second*1000)         
        end

return true
end