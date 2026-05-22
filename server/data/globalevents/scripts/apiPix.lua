function donateCallback(player, price, accountID)
    if not player or not player:isPlayer() then
      return
    end
    local priceNumber = tonumber(price) or 0
    local diamonds = math.floor(priceNumber * 1.2)
    if diamonds < 1 then
      return
    end
    addPlayerDiamond(player, diamonds)
    if player.sendShopDiamondBalance then
      player:sendShopDiamondBalance()
    end
	
	print(string.format("Entregue %d diamantes, a player: %s accountId: %d", diamonds, player:getName(), accountID))
   return true
end

function onThink(interval, lastExecution, thinkInterval)
   local resultId = db.storeQuery("SELECT * FROM `pix_payment` WHERE `status` = 'CONCLUIDA' AND `paid` = 0;")

   if(resultId ~= false) then
      repeat
         local guid = result.getDataInt(resultId, "player_id")
         local loc = result.getDataInt(resultId, "loc_id")
         local price = result.getDataString(resultId, "price")
         local txid = result.getDataString(resultId, "txid")
         local name = getPlayerNameByGUID(tonumber(guid))
         local player = Creature(name)
         if player then
            if donateCallback(player, tonumber(price), player:getAccountId()) then
               db.query("UPDATE `pix_payment` SET `paid` = 1 WHERE `txid` = " .. db.escapeString(txid))

               local buffer = {
                  ['pix_codes'] = PIX_CODES.PIX_PAID_SUCCESS,
                  ['loc_id'] = loc
               }
               player:sendExtendedOpcode(PIX_OPCODE, json.encode(buffer))
            end
         end
      until(not result.next())
      result.free()
   end
   return true
end
