PokeBar = {}

local panelBar, currentSlotBar
local protocol = runinsandbox("protocol")
local pokemonOrder = {}
local slotBarAssociationsHotkeys = {}
local isMinimized = false
local savedPanelState = {} -- ADIÇÃO: Salvar estado antes de minimizar

local abilities = {
	fly = {
		tooltip = "Fly",
		imageClip = { x = 0, y = 0, width = 20, height = 20 },
	},
	teleport = {
		tooltip = "Teleport",
		imageClip = { x = 20, y = 0, width = 20, height = 20 },
	},
	cut = {
		tooltip = "Cut",
		imageClip = { x = 40, y = 0, width = 20, height = 20 },
	},
	surf = {
		tooltip = "Surf",
		imageClip = { x = 60, y = 0, width = 20, height = 20 },
	},
	dig = {
		tooltip = "Dig",
		imageClip = { x = 80, y = 0, width = 20, height = 20 },
		callback = function()
			g_game.talk("!dig")
		end
	},
	strength = {
		tooltip = "Strength",
		imageClip = { x = 0, y = 0, width = 20, height = 20 },
	},
	waterfall = {
		tooltip = "Waterfall",
		imageClip = { x = 20, y = 0, width = 20, height = 20 },
	},
	rocksmash = {
		tooltip = "Rock Smash",
		imageClip = { x = 40, y = 0, width = 20, height = 20 },
	},
	flash = {
		tooltip = "Flash",
		imageClip = { x = 120, y = 0, width = 20, height = 20 },
	}
}

-- FUNÇÃO: Capitalizar primeira letra
local function capitalizeFirstLetter(word)
	return word:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
end

local function doUpdateHotkey(slotBar)
	if not KeybindManager then return end
	local keybind = KeybindManager:getKeybindByName("Chamar " .. panelBar:getChildIndex(slotBar), "Pokemon")

	if keybind then
		slotBar.keyCombo:setText(keybind.keyCombo)

		slotBarAssociationsHotkeys[keybind.name] = slotBar
	end
end

local function doEditOrder()
	panelBar.isEditingMode = not panelBar.isEditingMode

	for i, slotBar in ipairs(panelBar:getChildren()) do
		local opacityEdit = panelBar.isEditingMode and 0.8 or 1

		slotBar:setOpacity(opacityEdit)
	end

	g_mouse.popCursor("target")
end

local function doUpdateOrder()
	local children = panelBar:getChildren()

	table.sort(children, function(a, b)
		if not a.pokemon or not b.pokemon then return false end
		return (pokemonOrder[a.pokemon.name] or 100) < (pokemonOrder[b.pokemon.name] or 100)
	end)
	panelBar:reorderChildren(children)

	for i, slotBar in pairs(panelBar:getChildren()) do
		doUpdateHotkey(slotBar)
	end
end

local function doUpdateResizeBar()
	local height = 20

	for i, slotBar in ipairs(panelBar:getChildren()) do
		height = height + slotBar:getHeight() + slotBar:getMarginTop()
	end

	if isMinimized then
		panelBar:resize(56, height)
	else
		panelBar:resize(176, height)
	end
end

local function doUpdateElementSlotBar(slotBar)
	if not slotBar.elements then return end
	
	slotBar.elements:destroyChildren()

	local width = slotBar.elements:getWidth()
	local pokemon = Pokedex_PokemonsByName[getPokemonName(slotBar.pokemon.name):lower()]

	if pokemon then
		for i, name in pairs(pokemon.Types) do
			local info = Pokedex_Types[name]

			if info then
				local widget = g_ui.createWidget("UIWidget", slotBar.elements)
				widget:setSize({width = width, height = width})
				widget:setImageSource("/modules/game_dex/images/types/" .. name:lower())
				widget:setTooltip(info.Text)
			end
		end
	end

	slotBar.elements:setHeight(slotBar.elements:getChildCount() * width)
end

local function doUpdateTimerBall(slotBar)
	if not slotBar.pokemon.cooldown then
		slotBar.pokemon.cooldown = -1
	end

	if slotBar.pokemon.cooldown > -1 then
		if slotBar.timer then
			slotBar.timer:setOn(true)
			removeEvent(slotBar.eventId)

			slotBar.eventId = scheduleEvent(function()
				slotBar.timer:setOn(false)
			end, slotBar.pokemon.cooldown * 1000)
		end
	end
end

local function doUpdateAbilities(slotBar)
	if not slotBar.abilities then return end
	
	slotBar.abilities:setVisible(true)
	if slotBar.timer then
		slotBar.timer:setVisible(slotBar.pokemon.cooldown and slotBar.pokemon.cooldown > -1)
	end

	slotBar.abilities:destroyChildren()

	local pokemon = Pokedex_PokemonsByName[getPokemonName(slotBar.pokemon.name):lower()]
	local abilitiesToShow = {}

	if pokemon and #pokemon.Abilities > 0 then
		abilitiesToShow = pokemon.Abilities
	else
		abilitiesToShow = {"fly", "teleport", "cut", "surf"}
	end

	local width = 0

	for i, name in ipairs(abilitiesToShow) do
		local value = abilities[name]

		if value then
			local icon = g_ui.createWidget("SlotBarAbilitiesIcon", slotBar.abilities)

			icon:setImageClip(value.imageClip)
			icon:setTooltip(value.tooltip)

			icon.onClick = value.callback
			width = width + 12
		end
	end

	slotBar.abilities:setWidth(width)
end

local function doUpdateStateSlotBar(slotBar, state)
	slotBar:setChecked(state)

	for i, child in pairs(slotBar:getChildren()) do
		child:setChecked(state)
	end

	doUpdateElementSlotBar(slotBar, slotBar.pokemon)
end

local function doRemoveSlotBar(slotBar)
	if slotBar == currentSlotBar then
		currentSlotBar = nil
	end

	slotBarAssociationsHotkeys[slotBar.keyCombo:getText()] = nil
	pokemonOrder[slotBar.pokemon.name] = nil
	panelBar[slotBar:getId()] = nil

	removeEvent(slotBar.eventId)
	slotBar:destroy()
	doUpdateResizeBar()
end

local function doUpdateSlotBar(slotBar, pokemon)
	local isAlive = pokemon.health > 0

	slotBar.pokemon = pokemon

	slotBar:setOn(not isAlive)
	slotBar.image:setEnabled(isAlive)
	
	if slotBar.keyCombo then
		slotBar.keyCombo:setOn(not isAlive)
	end
	
	if slotBar.pokemonName then
		local nickname = pokemon.nickname or ""
		local realName = string.lower(pokemon.name)
		
		if #nickname > 0 then
			slotBar.pokemonName:setText(nickname)
		else
			slotBar.pokemonName:setText(capitalizeFirstLetter(realName))
		end
		if slotBar.pokemonName then
		if slotBar:isChecked() then
			slotBar.pokemonName:setMarginTop(14)
			doUpdateStateSlotBar(slotBar, true)
		else
			slotBar.pokemonName:setMarginTop(14)
		end
		end
	end
	
	if slotBar.progress then
		local percent = pokemon.health
		if pokemon.maxHealth and pokemon.maxHealth > 100 then
			percent = math.floor((pokemon.health / pokemon.maxHealth) * 100)
		end
		percent = math.min(100, math.max(0, percent))

		slotBar.progress:setPercent(percent)
		slotBar.progress:setText(("%d%%"):format(percent))
		slotBar.progress:setBackgroundColor(getHealthColor(percent))
	end
	
	slotBar.image:setImageSource(getPokemonPortrait(pokemon.name))
	doUpdateTimerBall(slotBar)
	doUpdateAbilities(slotBar)
	doUpdateElementSlotBar(slotBar)

	if pokemon.text == tr("USE") or pokemon.use then
		currentSlotBar = slotBar

		doUpdateStateSlotBar(slotBar, true)
		if modules.game_pokemon and modules.game_pokemon.updateFromPokebar then
			modules.game_pokemon.updateFromPokebar(pokemon)
		end
	elseif slotBar == currentSlotBar then
		currentSlotBar = nil

		doUpdateStateSlotBar(slotBar, false)
	end
end

local function onDragEnter(slotBar, mousePosition)
	if panelBar.isEditingMode then
		slotBar.drag = true

		g_mouse.pushCursor("target")
	else
		panelBar:breakAnchors()

		slotBar.movingReference = {
			x = mousePosition.x - panelBar:getX(),
			y = mousePosition.y - panelBar:getY()
		}
	end

	return not panelBar:isOn()
end

local function onDragMove(slotBar, mousePosition, mouseMoved)
	if not panelBar.isEditingMode then
		local pos = {
			x = mousePosition.x - slotBar.movingReference.x,
			y = mousePosition.y - slotBar.movingReference.y
		}

		panelBar:setPosition(pos)
		panelBar:bindRectToParent()
	end

	return not panelBar:isOn()
end

local function onDragLeave(slotBar, droppedWidget, mousePosition)
	if panelBar.isEditingMode then
		local move = panelBar:getChildByPos(mousePosition)

		if move and move ~= slotBar and move.moveSlot then
			local moveIndex = panelBar:getChildIndex(move)
			local selfIndex = panelBar:getChildIndex(slotBar)

			pokemonOrder[move.pokemon.name] = selfIndex
			pokemonOrder[slotBar.pokemon.name] = moveIndex

			panelBar:moveChildToIndex(move, selfIndex)
			panelBar:moveChildToIndex(slotBar, moveIndex)
			doUpdateHotkey(move)
			doUpdateHotkey(slotBar)
		end

		slotBar.drag = false

		slotBar:setOpacity(0.8)
		g_mouse.popCursor("target")
	else
		slotBar.dragLeave = g_clock.millis() + 2
	end
end

-- Move o slot clicado para o topo e persiste a ordem
local function moveSlotToTop(slotBar)
	if not slotBar or not slotBar.pokemon then return end
	
	-- Obter lista atual de nomes em ordem
	local children = panelBar:getChildren()
	local namesInOrder = {}
	for i, child in ipairs(children) do
		if child.pokemon then
			table.insert(namesInOrder, child.pokemon.name)
		end
	end
	
	-- Encontrar índice atual
	local currentIndex = nil
	for i, name in ipairs(namesInOrder) do
		if name == slotBar.pokemon.name then
			currentIndex = i
			break
		end
	end
	if not currentIndex or currentIndex == 1 then return end
	
	-- Remover da posição atual e inserir no início
	table.remove(namesInOrder, currentIndex)
	table.insert(namesInOrder, 1, slotBar.pokemon.name)
	
	-- Atualizar pokemonOrder
	for i, name in ipairs(namesInOrder) do
		pokemonOrder[name] = i
	end
	
	-- Reordenar a UI
	doUpdateOrder()
	doUpdateResizeBar()
	
	-- Salvar imediatamente nas configurações para persistir
	local settings = g_settings.getNode("pokebarConfig") or {}
	settings.orders = pokemonOrder
	g_settings.setNode("pokebarConfig", settings)
end

local function onMouseRelease(slotBar, mousePosition, mouseButton)
	if mouseButton == MouseLeftButton and g_clock.millis() > slotBar.dragLeave and not panelBar.isEditingMode then
		g_game.talk("!p " .. slotBar.pokemon.fastcallNumber)
		-- Move o Pokémon para o topo da barra
		moveSlotToTop(slotBar)
	end
	return true
end

local function onHoverChange(slotBar, hovered)
	if panelBar.isEditingMode then
		if hovered then
			slotBar:setOpacity(1)
		elseif not slotBar.drag then
			slotBar:setOpacity(0.8)
		end
	end
end

local function onClick(widget)
	if not KeybindManager then return end
	local slotBar = widget:getParent()
	local keybind = KeybindManager:getKeybindByName("Chamar " .. panelBar:getChildIndex(slotBar), "Pokemon")

	if keybind then
		keybind:capture(KEYCOMBO_PRIMARY)
	end
end

local function onRemoveAllSlotBars()
	panelBar:destroyChildren()
	if modules.game_pokemon and modules.game_pokemon.clearFromPokebar then
		modules.game_pokemon.clearFromPokebar()
	end
	doUpdateResizeBar()
end

local function onAddSlotBar(pokemon)
	if not pokemon.fastcallNumber then
		pokemon.fastcallNumber = pokemon.pokeid:gsub("!p ", "")
	end
	
	-- ADIÇÃO: Escolher qual widget criar baseado no modo
	local widgetName = isMinimized and "SlotBarMini" or "SlotBar"
	local slotBar = g_ui.createWidget(widgetName, panelBar)
	
	if not slotBar then return end

	slotBar.onDragEnter = onDragEnter
	slotBar.onDragMove = onDragMove
	slotBar.onDragLeave = onDragLeave
	slotBar.onMouseRelease = onMouseRelease
	slotBar.onHoverChange = onHoverChange
	
	if slotBar.keyCombo then
		slotBar.keyCombo.onClick = onClick
	end

	-- Inicializar ordem se não existir
	if not pokemonOrder[pokemon.name] then
		pokemonOrder[pokemon.name] = panelBar:getChildCount()
	end

	g_mouse.bindPress(slotBar, createMenu, MouseRightButton)
	slotBar:setId(pokemon.fastcallNumber)
	doUpdateSlotBar(slotBar, pokemon)

	-- Mover para a posição correta baseada na ordem salva
	local desiredIndex = pokemonOrder[pokemon.name]
	if desiredIndex and desiredIndex <= panelBar:getChildCount() then
		panelBar:moveChildToIndex(slotBar, desiredIndex)
	end

	doUpdateHotkey(slotBar)
	doUpdateResizeBar()
end

local function onRemoveSlotBar(fastcallNumber)
	local slotBar = panelBar[fastcallNumber]

	if slotBar then
		doRemoveSlotBar(slotBar)
	end
end

local function onUpdateSlotBar(pokemon)
	local slotBar = panelBar[pokemon.fastcallNumber]

	if slotBar then
		doUpdateSlotBar(slotBar, pokemon)
	end
end

-- FUNÇÃO ADICIONADA: Alternar modo minimizado com troca de OTUI
local function toggleMinimizeMode()
	isMinimized = not isMinimized
	
	-- Salvar estado do painel antes de destruir
	savedPanelState = {
		position = panelBar:getPosition(),
		locked = panelBar:isOn(),
		pokemonsData = {}
	}
	
	-- Guardar dados de cada pokémon
	for i, slotBar in ipairs(panelBar:getChildren()) do
		if slotBar.pokemon then
			table.insert(savedPanelState.pokemonsData, slotBar.pokemon)
		end
	end
	
	-- Destruir painel antigo
	panelBar:destroy()
	
	-- Recriar painel com novo OTUI
	if isMinimized then
		panelBar = g_ui.loadUI("poketeam_mini", modules.game_interface.getRootPanel())
	else
		panelBar = g_ui.loadUI("poketeam", modules.game_interface.getRootPanel())
	end
	
	-- Restaurar posição e lock
	panelBar:setPosition(savedPanelState.position)
	panelBar:setOn(savedPanelState.locked)
	
	-- Recriar os slots com os dados salvos
	for i, pokemonData in ipairs(savedPanelState.pokemonsData) do
		onAddSlotBar(pokemonData)
	end
	
	-- Re-registrar o bind do mouse
	g_mouse.bindPress(panelBar, createMenu, MouseRightButton)
	
	doUpdateResizeBar()
	
	-- Salvar estado de minimização
	local settings = g_settings.getNode("pokebarConfig") or {}
	settings.minimized = isMinimized
	g_settings.setNode("pokebarConfig", settings)
end

-- FUNÇÃO ADICIONADA: Detectar se está em modo mini
local function isMiniMode()
	if not panelBar or not panelBar:getFirstChild() then
		return false
	end
	local firstChild = panelBar:getFirstChild()
	return firstChild and firstChild:getChild('isMini') ~= nil
end

-- FUNÇÃO MODIFICADA: Ajustar setOn/setChecked baseado no modo
local function doUpdateSlotBarState(slotBar, pokemon)
	local isAlive = pokemon.health > 0
	local isMini = slotBar:getChild('isMini') ~= nil
	
	if isMini then
		-- No modo mini, inverte a lógica: morto = estado normal, vivo = estado on
		slotBar:setOn(isAlive)
	else
		-- No modo normal, mantém a lógica original
		slotBar:setOn(not isAlive)
	end
	
	slotBar:setChecked(pokemon.text == tr("USE") or pokemon.use)
end

function init()
	print(">>> game_poketeam init")
	protocol.initProtocol()
	connect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd
	})
	connect(PokeBar, {
		onAddSlotBar = onAddSlotBar,
		onRemoveSlotBar = onRemoveSlotBar,
		onUpdateSlotBar = onUpdateSlotBar,
		onRemoveAllSlotBars = onRemoveAllSlotBars
	})
	connect(Creature, {
		onHealthPercentChange = onCreatureHealthPercentChange
	})
	if KeybindManager then
		connect(KeybindManager, {
			onUpdateHotkey = onUpdateHotkey
		})
	end

	panelBar = g_ui.loadUI("poketeam", modules.game_interface.getRootPanel())
	g_mouse.bindPress(panelBar, createMenu, MouseRightButton)
end

function terminate()
	protocol.terminateProtocol()
	disconnect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd
	})
	disconnect(Creature, {
		onHealthPercentChange = onCreatureHealthPercentChange
	})
	if KeybindManager then
		disconnect(KeybindManager, {
			onUpdateHotkey = onUpdateHotkey
		})
	end
	panelBar:destroy()
end

function onGameStart()
	local settings = g_settings.getNode("pokebarConfig")

	if settings then
		if settings.orders then
			pokemonOrder = settings.orders
			-- Aplica a ordem após todos os slots serem adicionados
			scheduleEvent(doUpdateOrder, 100)
		end

		panelBar:breakAnchors()
		panelBar:setOn(settings.locked)
		panelBar:setPosition(settings.position)
		
		-- ADIÇÃO: Restaurar estado de minimização
		if settings.minimized then
			isMinimized = false -- Precisa estar false para toggle funcionar
			scheduleEvent(toggleMinimizeMode, 50)
		end
	end

	panelBar:setVisible(modules.client_options.getOption("pokebar"))
	
	-- Request pokebar from server
	if g_game.isOnline() then
		g_game.getProtocolGame():sendExtendedOpcode(1, "pokebar")
	end
end

function onGameEnd()
	local settings = {
		position = pointtostring(panelBar:getPosition()),
		locked = panelBar:isOn(),
		orders = pokemonOrder,
		minimized = isMinimized
	}

	currentSlotBar = nil

	panelBar:destroyChildren()
	g_settings.setNode("pokebarConfig", settings)
end

function onCreatureHealthPercentChange(creature, health)
	if currentSlotBar and creature:isLocalSummon() then
		if currentSlotBar.progress then
			local percent = math.min(100, math.max(0, creature:getHealthPercent()))
			currentSlotBar.progress:setPercent(percent)
			currentSlotBar.progress:setText(("%d%%"):format(percent))
			currentSlotBar.progress:setBackgroundColor(getHealthColor(percent))
		end
	end
end

function onUpdateHotkey(category, name, keyCombo, altKeyCombo)
	if category == "Pokemon" and slotBarAssociationsHotkeys[name] then
		slotBarAssociationsHotkeys[name].keyCombo:setText(keyCombo)
	end
end

function createMenu()
	local menu = g_ui.createWidget("PopupMenu")

	menu:addOption(panelBar:isOn() and tr("Unlocked") or tr("Locked"), function()
		panelBar:setOn(not panelBar:isOn())
	end)
	
	menu:addOption(isMinimized and tr("Maximize") or tr("Minimize"), function()
		toggleMinimizeMode()
	end)
	
	menu:display()
end

function getPokemonBar()
	return panelBar
end

function doCallPokemon(index)
	if not panelBar or not g_game.isOnline() then
		return false
	end

	local slotBar = panelBar:getChildByIndex(index)

	if slotBar and slotBar.pokemon and slotBar.pokemon.fastcallNumber then
		g_game.talk("!p " .. slotBar.pokemon.fastcallNumber)
		return true
	end
	return false
end
