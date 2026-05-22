local memoryTimerCode = 0
local memoryTimerTable = {d=0, h=0, m=0, s=0}
local transformationTimeLeft = nil
local arrowEventCode = 0
local unlockSlotEventCode = 0
local memorySlotPrices = {25, 40, 60, 75, 75, 75}
local isDittoClient = false
local DITTO_MEMORY_OPCODE = 90

function isDittoCached()
    return isDittoClient
end

local randomToShinyNames = {"Shiny Venusaur", "Shiny Blastoise", "Shiny Charizard", "Shiny Pidgeot", "Shiny Butterfree", 
	"Shiny Beedrill", "Shiny Raichu", "Shiny Nidoking", "Shiny Ninetales", "Shiny Crobat", 
	"Shiny Vileplume", "Shiny Parasect", "Shiny Venomoth", "Shiny Arcanine", "Shiny Alakazam", 
	"Shiny Machamp", "Shiny Tentacruel", "Shiny Golem", "Shiny Magneton", "Shiny Farfetch'd", 
	"Shiny Dodrio", "Shiny Muk", "Shiny Gengar", "Shiny Hypno", 
	"Shiny Kingler", "Shiny Electrode", "Shiny Marowak", "Shiny Weezing", "Shiny Rhydon", "Shiny Tangela", "Shiny Seadra", 
	"Shiny Mr. Mime", "Shiny Scyther", "Shiny Jynx", "Shiny Electabuzz", "Shiny Magmar", 
	"Shiny Pinsir", "Shiny Tauros", "Shiny Gyarados", "Shiny Vaporeon", "Shiny Jolteon", 
	"Shiny Flareon", "Aerodactyl", "Shiny Snorlax", "Shiny Kabutops", "Shiny Dragonair", 
	"Shiny Dragonite", "Shiny Meganium", "Shiny Typhlosion", "Shiny Feraligatr", "Shiny Ariados", 
	"Shiny Lanturn", "Shiny Xatu", "Shiny Ampharos", "Shiny Espeon", "Shiny Umbreon", 
	"Shiny Politoed", "Shiny Magcargo", "Shiny Stantler", "Shiny Pupitar", "Shiny Tyranitar"}

local function removeShinyAndMega(name)
	if not name or name == "" then
		return "", false, false
	end

	local result = name
	local isShiny = false
	local isMega = false

	if string.find(result, "^Shiny%s+") then
		result = string.gsub(result, "^Shiny%s+", "")
		isShiny = true
	end

	if string.find(result, "^Mega%s+") then
		result = string.gsub(result, "^Mega%s+", "")
		isMega = true
	end

	return result, isShiny, isMega
end

local function getMemorySlotPrice(slot)
	return memorySlotPrices[slot] or 75
end

local function formatTransformationTime(t)
	local totalHours = (t.d * 24) + t.h
	return string.format("%02d:%02d:%02d", totalHours, t.m, t.s)
end

local function onDittoMemoryOpcode(protocol, opcode, buffer)
    local actions = string.explode(tostring(buffer or ""), '@')
    for a = 1,#actions do
        local action = string.explode(actions[a], '=')
        if action[1] == "memorySlots" then
            updateMemorySlots(action[2])
        elseif action[1] == "openBuyWindow" then
            showUnlockWindow(action[2])
        elseif action[1] == "refreshSlot" then
            updateMemorySlot(action[2])
        elseif action[1] == "showDittoMemoryWindow" then
            show()
        elseif action[1] == "transformation" then
            updateTransformationThings(action[2])
        elseif action[1] == "close" then
            hide()
        end
        if action[1] == "isDitto" then
            isDittoClient = tonumber(action[2]) == 1
            print("[DITTO DEBUG CLIENT] isDitto:", isDittoClient)
        end
    end
end

function init()
    print("[DITTO MEMORY] Module starting...")
    
    connect(g_game, { onGameEnd = onGameEnd })
    ProtocolGame.registerExtendedOpcode(DITTO_MEMORY_OPCODE, onDittoMemoryOpcode)

    dittoMemoryWindow = g_ui.displayUI('dittoMemory')
    dittoMemoryWindow:hide()
    dittoMemoryMemoriesPanel = dittoMemoryWindow:getChildById("memoriesPanel")
    dittoMemoryTransformationPanel = dittoMemoryWindow:getChildById("transformationPanel")
    transformationTimeLeft = dittoMemoryTransformationPanel:getChildById("transformationTimeLeft")
    
    unlockMemoryWindow = g_ui.displayUI('unlockMemory')
    unlockMemoryWindow:hide()
    
    print("[DITTO MEMORY] Module initialized successfully!")
end

function isShinyDittoItem(item, callback)
    -- 🔥 SEMPRE pergunta pro server primeiro
    local protocolGame = g_game.getProtocolGame()
    if not protocolGame then
        return false
    end

    -- envia pedido de verificação
    protocolGame:sendExtendedOpcode(90, "requestShow")

    -- espera resposta e executa callback
    scheduleEvent(function()
        if callback then
            callback(isDittoClient)
        end
    end, 50)

    return false
end

function terminate()
	disconnect(g_game, { onGameEnd = onGameEnd })
	ProtocolGame.unregisterExtendedOpcode(DITTO_MEMORY_OPCODE, onDittoMemoryOpcode)

	dittoMemoryWindow:destroy()
	unlockMemoryWindow:destroy()
	
	print("[DITTO MEMORY MODULE] Terminated.")
end

function onGameEnd()
	if dittoMemoryWindow:isVisible() then
		dittoMemoryWindow:hide()
	end
	if unlockMemoryWindow:isVisible() then
		unlockMemoryWindow:hide()
	end
end

function doAnimateArrow(arrow, frame, maxFrames, backing, code, slot, lastShinyName)
	if not unlockMemoryWindow:isVisible() or code ~= arrowEventCode then return true end
	local shinyName = lastShinyName
	if frame <= 0 or frame >= maxFrames then
		for a = 1,255 do
			local newShinyName = randomToShinyNames[math.random(1,#randomToShinyNames)]
			if not lastShinyName or lastShinyName ~= newShinyName then
				shinyName = newShinyName
				break
			end
		end
		local realpokename, isShiny, isMega = removeShinyAndMega(shinyName)
		
		if shinyName ~= "" and pokemonThingsTable[shinyName] and pokemonThingsTable[shinyName].portraitId then
			slot:setImageSource("/pokemon/shiny/"..string.lower(realpokename))
		end
	end
	if backing then
		frame = frame-1
		if frame <= 0 then backing = false end
	else
		frame = frame+1
		if frame >= maxFrames then backing = true end
	end
	arrow:setMarginLeft(10+frame)
	scheduleEvent(function() doAnimateArrow(arrow, frame, maxFrames, backing, code, slot, shinyName) end, 20)
end

function timerStart(widget, code)
	if widget == transformationTimeLeft then
		if memoryTimerCode ~= code then return end
		local t = memoryTimerTable
		if t.d > 0 or t.h > 0 or t.m > 0 or t.s > 0 then
			if t.s == 0 then
				t.s = 59
				if t.m == 0 then
					t.m = 59
					if t.h == 0 then
						t.h = 23
						if t.d == 0 then
							--END
						else
							t.d = t.d-1
						end
					else
						t.h = t.h-1
					end
				else
					t.m = t.m-1
				end
			else
				t.s = t.s-1
			end
		else
			transformationTimeLeft:setText(tr('Time')..': '..formatTransformationTime(t))
			memoryTimerCode = 0
			g_game.talk('!revert')
			return
		end
		transformationTimeLeft:setText(tr('Time')..': '..formatTransformationTime(t))
		scheduleEvent(function() timerStart(widget, code) end, 1000)	
	end
end

function getMemoryTimerTable(s)
	local d = 0
	local h = 0
	local m = 0
	if s >= 86400 then
		while s >= 86400 do
			s = s - 86400
			d = d+1
		end
	end
	if s >= 3600 then
		while s >= 3600 do
			s = s - 3600
			h = h+1
		end
	end
	if s >= 60 then
		while s >= 60 do
			s = s - 60
			m = m+1
		end
	end
	return {d=d, h=h, m=m, s=s}
end

function updateTransformationThings(transformationThings)
	local t = string.explode(transformationThings, ",")
	local pokeName = t[1]
	local timeLeft = tonumber(t[2])
	local lookType = tonumber(t[3]) or 0
	local realpokename, isShiny, isMega = removeShinyAndMega(pokeName)
	local transformationName = dittoMemoryTransformationPanel:getChildById("transformationName")
	local detransformButton = dittoMemoryTransformationPanel:getChildById("detransformButton")
	local pokemonICON = dittoMemoryWindow.transformationIcon
	local outfit = {
		type = lookType,
		body = 0,
		legs = 0,
		feet = 0,
		head = 0
	}

	pokemonICON:setOutfit(outfit)
	pokemonICON:setAnimate(false)
	pokemonICON:setWidth(56)
	pokemonICON:setHeight(56)
	pokemonICON:setDirection(2)
	pokemonICON:setMarginTop(58)
	pokemonICON:setMarginLeft(95)

	if pokeName ~= "none" then
		transformationName:setText(pokeName)
		if isShiny then
			transformationName:setColor("#ffe400")
		else
			transformationName:setColor("#ffffff")
		end
		transformationTimeLeft:setVisible(true)
		detransformButton:setVisible(true)
		
		memoryTimerCode = math.random(1,999999)
		memoryTimerTable = getMemoryTimerTable(timeLeft)
		timerStart(transformationTimeLeft, memoryTimerCode)
		transformationTimeLeft:setText(tr('Time')..': '..formatTransformationTime(memoryTimerTable))
		transformationTimeLeft:setTextVerticalAutoResize(false)
	else
		transformationName:setColor("#ffe400")
		transformationName:setText("Shiny Ditto")
		memoryTimerTable = {d=0, h=0, m=0, s=0}
		transformationTimeLeft:setVisible(true)
		transformationTimeLeft:setText(tr('Time')..': '..formatTransformationTime(memoryTimerTable))
		detransformButton:setVisible(false)
	end
end


function tryBuyMemorySlot(slotNumber, onWindow)
	g_game.getProtocolGame():sendExtendedOpcode(90, "tryBuy;"..slotNumber..(onWindow and ";onWindow" or ""))
end

function updateMemorySlot(memorySlot)
	local s = string.explode(memorySlot, ",")
	local a = tonumber(s[1])
	local action = s[2]
	local slot = dittoMemoryMemoriesPanel:getChildById(a)
	slot.buttonLocked:setVisible(false)
	slot.buttonAdd:setVisible(false)
	slot.buttonBuy:setVisible(false)
	slot.uncopy:setVisible(false)
	slot.icon:setVisible(false)
	slot.Itemicon:setVisible(false)
	local realpokename, isShiny, isMega = removeShinyAndMega(action)

	if action == "canBuy" then
		slot.buttonBuy:setVisible(true)
		slot.buttonBuy.tooltip = "Liberar memory "..a.." por "..getMemorySlotPrice(a).." Diamonds"
		slot.buttonBuy.onClick = function() tryBuyMemorySlot(a) end
		
	elseif action == "locked" then
		slot.buttonLocked:setVisible(true)
		slot.buttonLocked.tooltip = "Compre os slots em sequencia"
		slot.onClick = nil
		slot.buttonLocked.onClick = nil
		
	elseif action == "none" then
		slot.buttonAdd.tooltip = tr("Copy transformation")
		slot.buttonAdd:setVisible(true)
		slot.buttonAdd.onClick = function() g_game.talk('!memory '..a) end
	
	else
		slot.uncopy:setVisible(true)
		slot.uncopy.tooltip = tr("Erase Memory")
		slot.uncopy.onClick = function() 
			g_game.getProtocolGame():sendExtendedOpcode(90, "eraseMemory;"..a)
		end
		
		slot.icon:setVisible(true)
		slot.icon.tooltip = "Transformar Shiny Ditto em "..action
		if isShiny then
			slot.icon:setImageSource("/pokemon/shiny/"..string.lower(realpokename))
		else
			slot.icon:setImageSource("/pokemon/regular/"..string.lower(realpokename))
		end
		slot.icon.onClick = function() g_game.talk('!memory '..a) end
	end
end

function updateMemorySlots(memorySlots)
	local t = string.explode(memorySlots, ";")
	for a = 1,#t do
		local slot = dittoMemoryMemoriesPanel:getChildById(a)
		local s = string.explode(t[a], ",")
		local action = s[2]
		slot.buttonLocked:setVisible(false)
		slot.buttonAdd:setVisible(false)
		slot.buttonBuy:setVisible(false)
		slot.uncopy:setVisible(false)
		slot.icon:setVisible(false)
		slot.Itemicon:setVisible(false)
		local realpokename, isShiny, isMega = removeShinyAndMega(action)
	
		if action == "canBuy" then
			slot.buttonBuy:setVisible(true)
			slot.buttonBuy.tooltip = "Liberar memory "..a.." por "..getMemorySlotPrice(a).." Diamonds"
			slot.buttonBuy.onClick = function() tryBuyMemorySlot(a) end
			
		elseif action == "locked" then
			slot.buttonLocked:setVisible(true)
			slot.buttonLocked.tooltip = "Compre os slots em sequencia"
			slot.onClick = nil
			slot.buttonLocked.onClick = nil
			
		elseif action == "none" then
			slot.buttonAdd.tooltip = tr("Copy transformation")
			slot.buttonAdd:setVisible(true)
			slot.buttonAdd.onClick = function() g_game.talk('!memory '..a) end
		
		else
			slot.uncopy:setVisible(true)
			slot.uncopy.tooltip = tr("Erase Memory")
			slot.uncopy.onClick = function() 
				g_game.getProtocolGame():sendExtendedOpcode(90, "eraseMemory;"..a)
			end
			
			slot.icon:setVisible(true)
			slot.icon.tooltip = "Transformar Shiny Ditto em "..action
			if isShiny then
				slot.icon:setImageSource("/pokemon/shiny/"..string.lower(realpokename))
			else
				slot.icon:setImageSource("/pokemon/regular/"..string.lower(realpokename))
			end
			slot.icon.onClick = function() g_game.talk('!memory '..a) end
		end
	end
	local pokeName = t[1]
	local timeLeft = t[2]

end

function sendRequestShow(thing)
	local pos = thing:getPosition()
	local stackPos = thing:getStackPos()
	--opcode: thingPos.x,thingPos.y,thingPos.z,thingPos.stackpos
	local opcodeMsg = pos.x ..",".. pos.y ..",".. pos.z ..",".. stackPos
	g_game.getProtocolGame():sendExtendedOpcode(90, "requestShow;"..opcodeMsg)
end

function openDittoWindow()
	local protocolGame = g_game.getProtocolGame()
	if not protocolGame then
		print("[DITTO MEMORY] Unable to open window: protocol unavailable.")
		return false
	end

	print("[DITTO MEMORY] Sending opcode 90 with action 'show'.")
	if dittoMemoryWindow then
		show()
	end

	protocolGame:sendExtendedOpcode(90, "show")
	return true
end

function showUnlockWindow(things)
	if not unlockMemoryWindow:isVisible() then
		addEvent(function() g_effects.fadeIn(unlockMemoryWindow, 250) end)
	end
	unlockMemoryWindow:show()
	unlockMemoryWindow:raise()
	unlockMemoryWindow:focus()
	
	local t = string.explode(things, ",")
	local slot = tonumber(t[1])
	local price = tonumber(t[2])
	unlockMemoryWindow:getChildById("windowName"):setText(tr("Release Memory").." "..slot)
	local buyedThingPanel = unlockMemoryWindow:getChildById('buyedThingPanel')
	buyedThingPanel.tooltip = tr("You can permanently memorize a pokémon\nin the memory slot and use it with Ditto\nwhenever you want.")
	local arrow = buyedThingPanel:getChildById('arrow')
	local s1 = buyedThingPanel:getChildById('1')
	local s2 = buyedThingPanel:getChildById('2')
	arrowEventCode = math.random(10000,99999)
	arrow:setMarginLeft(10)
	doAnimateArrow(arrow, 0, 50, false, arrowEventCode, s2.icon)
	s1.buttonBuy:setVisible(true)
	
	s2.buttonBuy:setVisible(false)
	s2.icon:setVisible(true)
	
	local textDesc = tr("You are about to unlock the").." ".."[O]Memory "..slot.."[O/] "..tr("for").." [3]"..price.." Diamonds[3/] "..tr("are you sure about that ?")
	setColoredText(unlockMemoryWindow.desc, textDesc, "#ffffff")
	
	-- buyedThingPanel.desc:setText()
	
	-- local priceThingPanel = unlockMemoryWindow:getChildById('priceThingPanel')
	-- local diamondItem = priceThingPanel:getChildById('diamonds')
	-- local priceWidget = priceThingPanel:getChildById('price')
	-- diamondItem:setItemId(3028)
	-- priceWidget:setText(price)
	
	local unlockButton = unlockMemoryWindow:getChildById('unlockButton')
	unlockButton.onClick = function() hideUnlockWindow() tryBuyMemorySlot(slot, true) end
end

function show()
  if not dittoMemoryWindow:isVisible() then
    addEvent(function() g_effects.fadeIn(dittoMemoryWindow, 250) end)
  end
  dittoMemoryWindow:show()
  dittoMemoryWindow:raise()
  dittoMemoryWindow:focus()
  dittoMemoryWindow:getChildById("tip").tooltip = tr("You can use the command '!memory Memory Number'\nto use memory even with that window closed.\nExample: !memory 1")
end


function hide()
  hideUnlockWindow()
  addEvent(function() g_effects.fadeOut(dittoMemoryWindow, 250) end)
  scheduleEvent(function() dittoMemoryWindow:hide() end, 250)
end

function hideUnlockWindow()
  addEvent(function() g_effects.fadeOut(unlockMemoryWindow, 250) end)
  scheduleEvent(function() unlockMemoryWindow:hide() end, 250)
end

function getPokemonThingsPosition()
	return pokemonThingsPosition
end
