local spells = {}
local OPCODE_SKILLBAR = 52
local side = "vertical"
local mainWindow, spellWindow

local function hideMainWindow()
	if mainWindow then
		mainWindow:hide()
	end
end

function show()
	if mainWindow then
		mainWindow:show()
	end
end

function toggle()
	if not mainWindow then
		return false
	end

	if mainWindow:isVisible() then
		mainWindow:hide()
	else
		mainWindow:show()
	end
	return true
end

function init()
	mainWindow = g_ui.displayUI('pokemonmoves')
	g_mouse.bindPress(mainWindow, function() createMenu() end, MouseRightButton)
	spellWindow = mainWindow.spellWindow
	mainWindow:hide()
	local pos = g_settings.getString("movebar_position")
	local sideConfig = g_settings.getString("movebar_side")
	if pos and #pos > 1 then
		mainWindow:setPosition(json.decode(pos))
	end
	if sideConfig then
		side = sideConfig
	end
	connect(g_game, 'onTalk', messageSentCallback)
	connect(g_game, { onGameEnd = hideMainWindow })
	connect(g_game, { onGameStart = hideMainWindow })
	connect(LocalPlayer, {
		onLevelChange = onLevelChange
	})
	ProtocolGame.registerExtendedOpcode(OPCODE_SKILLBAR, getOpCode)
end

function getOpCode(protocol, opcode, buffer)
	local ok, moveset = pcall(function() return json.decode(buffer) end)
	if not ok or type(moveset) ~= 'table' then
		return
	end

	spells = {}
	for moveNumber, moveInfo in ipairs(moveset) do
		spells[moveNumber] = moveInfo
	end
	createUIMoves()
end

function onLevelChange(player, level, oldLevel)
	createUIMoves()
end

function messageSentCallback(name, level, mode, text, channelId, pos)
	if not g_game.isOnline() then return end
	if g_game.getLocalPlayer():getName() ~= name then return end
	if mode ~= 34 then return end
	if string.find(string.lower(text), "use") then
		text = string.gsub(text, "use ", "")
		text = string.gsub(text, "!", "")
		text = text:split(", ")[2]
		for i = 1, #spells do
			if spells[i].name:lower() == text:lower() then
				startCooldownById(i)
				break
			end
		end
	elseif string.find(string.lower(text), "thanks") then
		if mainWindow then
			mainWindow:hide()
		end
	end
end

function terminate()
	g_settings.set("movebar_position", json.encode(mainWindow:getPosition()))
	g_settings.set("movebar_side", side)
	ProtocolGame.unregisterExtendedOpcode(OPCODE_SKILLBAR)
	mainWindow:destroy()
	disconnect(g_game, { onGameEnd = hideMainWindow })
	disconnect(g_game, { onGameStart = hideMainWindow })
	disconnect(g_game, 'onTalk', messageSentCallback)
	disconnect(LocalPlayer, {
		onLevelChange = onLevelChange
	})
end

function createMenu()
	local menu = g_ui.createWidget('PopupMenu')
	if side == 'horizontal' then
		menu:addOption('Set Vertical', function()
			side = 'vertical'
			createUIMoves()
		end)
	else
		menu:addOption('Set Horizontal', function()
			side = 'horizontal'
			createUIMoves()
		end)
	end
	menu:display()
end

function doUseSkill(moveId)
	moveId = tonumber(moveId)
	if not moveId or not g_game.isOnline() then
		return false
	end

	local moveInfo = spells[moveId]
	if not moveInfo or tonumber(moveInfo.passive) ~= 0 then
		return false
	end

	local player = g_game.getLocalPlayer()
	if not player then
		return false
	end

	local requiredLevel = tonumber(moveInfo.level) or 0
	if player:getLevel() < requiredLevel then
		return false
	end

	local cooldown = tonumber(moveInfo.cooldownReal) or 0
	if cooldown > 0 then
		return false
	end

	g_game.talk('m' .. moveId)
	return true
end

function finishCooldown(widget)
	if widget then
		widget:destroy()
	end
end

function updateCooldown(widget, cooldown)
	if not widget then
		return
	end
	if cooldown <= 0 then return finishCooldown(widget) end
	if not widget:getParent() then
		return
	end
	local id = tonumber(widget:getParent():getId())
	widget:setText(string.format("%.f", (cooldown/1000)))
	local percentage = math.floor((cooldown * 100) / spells[id].speed)
	local invertedPercentage = 100 - percentage
	widget:setPercent(invertedPercentage)

	cooldown = cooldown - 100
	spells[id].cooldownReal = cooldown
	widget.event = scheduleEvent(function() updateCooldown(widget, cooldown) end, 100)
end

function startCooldownById(id)
	if not spellWindow then return end
	local spellWidget = spellWindow:getChildById(id)
	if not spellWidget or not spells[id] then return end
	spellWidget:destroyChildren()
	local progress = g_ui.createWidget('SpellProgressSpell', spellWidget)
	local moveText = g_ui.createWidget('SpellText', spellWidget)
	moveText:setText(id)
	local moveInfo = spells[id]
	progress:setTooltip(string.format("Name: %s\nLevel: %s\nCooldown: %ss", moveInfo.name, moveInfo.level,
	(moveInfo.speed / 1000)))
	progress:setId("progress")
	progress.event = updateCooldown(progress, moveInfo.speed)
end

function stopAllEvents()
	if not spellWindow then return end
	for i = 1, #spells do
		local spellWidget = spellWindow:getChildById(i)
		if spellWidget then
			local progress = spellWidget:getChildById("progress")
			if progress then
				progress.event = nil
				progress:destroy()
			end
		end
	end
end

function createUIMoves()
	local width = side == 'horizontal' and ((38 * #spells) + 60) or 58
	local height = side == 'horizontal' and 58 or ((38 * #spells) + 60)
	local player = g_game.getLocalPlayer()
	if not player then return end
	local level = player:getLevel()

	if not spellWindow or not mainWindow then return end

	if side == 'horizontal' then
		mainWindow:setImageSource("background_horizontal")
	else
		mainWindow:setImageSource("background_vertical")
	end

	mainWindow:show()

	stopAllEvents()
	spellWindow:destroyChildren()
	for moveId, moveInfo in ipairs(spells) do
		local spellWidget = g_ui.createWidget('SpellButton', spellWindow)
		spellWidget:setId(moveId)
		local pathImage = "moves_icon/" .. moveInfo.name .. "_on.png"
		if not g_resources.fileExists(pathImage) then
			pathImage = "moves_icon/Base.png"
		end
		spellWidget:setImageSource(pathImage)

		if moveInfo.passive == 0 then
			spellWidget:setTooltip(string.format("Name: %s\nLevel: %s\nCooldown: %ss", moveInfo.name, moveInfo.level,
				(moveInfo.speed / 1000)))

			if level >= moveInfo.level then
				spellWidget.onClick = function() doUseSkill(moveId) end
			else
				local progress = g_ui.createWidget('SpellProgressSpell', spellWidget)
				progress:setText('L' .. moveInfo.level)
				progress:setColor('red')
				progress:setPercent(0)
			end

			local cooldownReal = tonumber(moveInfo.cooldownReal) or 0
			local isReady = cooldownReal == 0
			if not isReady then
				local progress = g_ui.createWidget('SpellProgressSpell', spellWidget)
				progress:setTooltip(string.format("Name: %s\nLevel: %s\nCooldown: %ss", moveInfo.name, moveInfo.level,
				(moveInfo.speed / 1000)))
				progress:setId("progress")
				progress.event = updateCooldown(progress, cooldownReal)
			end
			local moveText = g_ui.createWidget('SpellText', spellWidget)
			moveText:setText(moveId)
		else
			spellWidget:setTooltip(string.format("Name: %s", moveInfo.name))
		end

		if side == 'horizontal' then
			spellWidget:setMarginLeft(((moveId - 1) * 38) + 20)
			spellWidget:setMarginTop(13)
		else
			spellWidget:setMarginTop(((moveId - 1) * 38) + 20)
			spellWidget:setMarginLeft(13)
		end
	end

	local orderButton = g_ui.createWidget('OrderButton', spellWindow)
	orderButton.onClick = function()
		if side == 'horizontal' then
			side = 'vertical'
			createUIMoves()
		else
			side = 'horizontal'
			createUIMoves()
		end
	end

	if side == 'horizontal' then
		orderButton:setMarginLeft((#spells * 38) + 20)
		orderButton:setMarginTop(16)
	else
		orderButton:setMarginTop((#spells * 38) + 20)
		orderButton:setMarginLeft(19)
	end


	spellWindow:setHeight(height)
	spellWindow:setWidth(width)
	mainWindow:setSize(spellWindow:getSize())
end
