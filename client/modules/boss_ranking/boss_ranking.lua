mainWindow, boss, bossId  = nil
bosses = {}
local opcode_ = 69
local bossCreature = nil

function init()
  mainWindow = g_ui.loadUI("boss_ranking", modules.game_interface.getRootPanel())
  ProtocolGame.registerExtendedJSONOpcode(opcode_, receiveOpcode)
  connect(Creature, {onDisappear = onDisappear})
end

function terminate()
    mainWindow:destroy()
	ProtocolGame.unregisterExtendedJSONOpcode(opcode_, receiveOpcode)
	disconnect(Creature, {onDisappear = onDisappear, })
end

function onDisappear(creature)
	if bossId and creature:getId() == bossId then
		boss, bossId  = nil
		mainWindow:hide()
	end
end

function receiveOpcode(protocol, opcode, data)
	if type(data) ~= 'table' then
		return
	end

	local packetType = data.type
	if packetType == "update" then
		bossId = tonumber(data.bossId)
		bossCreature = getCreatureById(bossId)
		if not bossCreature or type(data.rank) ~= 'table' then
			return
		end
		
		mainWindow:show()
		local totalDamage = 0 
		for _, playerData in ipairs(data.rank) do
			totalDamage = totalDamage + (tonumber(playerData.damage) or 0)
		end
		if totalDamage <= 0 then
			return
		end
		mainWindow.bossOutfit:setOutfit(bossCreature:getOutfit())
		mainWindow.bossOutfit:setOldScaling(true)
		
		mainWindow.panelDamage:destroyChildren()
		for rank, playerData in ipairs(data.rank) do
			if rank >= 5 then break end
			local widget = g_ui.createWidget("playerLabel", mainWindow.panelDamage)
			widget.nome:setText(tostring(playerData.name or ""))
			widget.rank:setText(convertRank(rank))
			local percent = (tonumber(playerData.damage) or 0)/totalDamage * 100
			local numeroFormatado = string.format("%.2f", percent)
			widget.damage:setText(tostring(numeroFormatado .. "%"))
		end
		
		local personalRank = 0
		local selfName =  g_game.getLocalPlayer():getName()
		
		for rank, playerData in ipairs(data.rank) do
			if playerData.name == selfName then
				personalRank = rank
				break 
			end
		end
		if personalRank <= 0 or not data.rank[personalRank] then
			return
		end

		local percent = ((tonumber(data.rank[personalRank].damage) or 0)/totalDamage * 100)
	    local numeroFormatado = string.format("%.2f", percent)
		
		mainWindow.personalRank:setText(string.format("Rank Pessoal: %s", convertRank(personalRank)))
		mainWindow.personalDamage:setText(string.format("Damage: %d%%", numeroFormatado))
	end
end

function convertRank(num)
	if num == 1 then
		return "1st"
	elseif num == 2 then
		return "2nd"
	elseif num == 3 then
		return "3rd"
	else
		return num .. "th"
	end
end

function getCreatureById(id)
  if type(id) ~= 'number' then return nil end
  for i, spec in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition())) do
     if spec:getId() == id then
        return spec
     end
  end
  return nil
end
