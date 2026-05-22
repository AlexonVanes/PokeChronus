local OPCODE = 104
local MYPOKEID = 0
local ISOUTSIDE = false
-- local updateHealthEvent

local fModes = {"offensive", "balanced", "defensive"}
local PokemonInfoSlots = {
  [InventorySlotAmmo] = "activeBallSlot"
}

InventorySlotStyles = {
  [InventorySlotHead] = "HeadSlot",
  [InventorySlotNeck] = "NeckSlot",
  [InventorySlotBack] = "BackSlot",
  [InventorySlotBody] = "BodySlot",
  [InventorySlotRight] = "RightSlot",
  [InventorySlotLeft] = "LeftSlot",
  [InventorySlotLeg] = "LegSlot",
  [InventorySlotFeet] = "FeetSlot",
  [InventorySlotFinger] = "FingerSlot",
  [InventorySlotAmmo] = "AmmoSlot"
}
local fightMode = 2

local defaultPokeBaseImage = "images/pokebase"
local defaultPokeStatusImage = "images/pokebase"
local registeredOpcode = false
local activeBallFastcall = nil
local autoOpenBallpackEvent = nil
local setPokeLevel = nil

pokemonWindow = nil
ballpackWindow = nil
pokeHealthBar = nil
pokeballs = {}
local ballpackSlots = {}
local ballpackPokemons = {}

fightOffensiveBox = nil
fightBalancedBox = nil
fightDefensiveBox = nil
fightModeRadioGroup = nil
pvpModeRadioGroup = nil

local function isTypingInAnyField()
  return g_keyboard.isTextInputFocused and g_keyboard.isTextInputFocused()
end

local function togglePokemonHotkey()
  if isTypingInAnyField() then
    return true
  end

  toggle()
  return true
end

local function calculatePercent(current, maxValue)
  current = tonumber(current) or 0
  maxValue = tonumber(maxValue) or 0
  if maxValue <= 0 then
    return 0
  end

  return math.max(0, math.min(100, math.floor((current / maxValue) * 100)))
end

local function formatValue(value)
  value = math.floor(tonumber(value) or 0)
  local negative = value < 0
  value = math.abs(value)

  local formatted = tostring(value)
  while true do
    local newFormatted, count = formatted:gsub("^(%d+)(%d%d%d)", "%1.%2")
    formatted = newFormatted
    if count == 0 then
      break
    end
  end

  if negative then
    formatted = "-" .. formatted
  end

  return formatted
end

local function setWidgetImageIfExists(widget, imagePath, fallbackPath)
  if not widget then return end

  if imagePath and g_resources.fileExists(imagePath .. ".png") then
    widget:setImageSource(imagePath)
    return
  end

  if fallbackPath and g_resources.fileExists(fallbackPath .. ".png") then
    widget:setImageSource(fallbackPath)
  end
end

local function setActiveBallVisible(visible)
  if not pokemonWindow then return end

  local activeBallSlot = pokemonWindow:recursiveGetChildById('activeBallSlot')
  if not activeBallSlot then return end

  activeBallSlot:setVisible(true)
end

local function setActiveBallClientId(clientId)
  if not pokemonWindow then return end

  local activeBallSlot = pokemonWindow:recursiveGetChildById('activeBallSlot')
  if not activeBallSlot then return end

  clientId = tonumber(clientId)
  if clientId and clientId > 0 then
    activeBallSlot:setItemId(clientId)
    activeBallSlot:setVisible(true)
  else
    activeBallSlot:setItem(nil)
    activeBallSlot:setVisible(false)
  end
end

local function getPokemonBallpackIndex(pokemon)
  if not pokemon then return nil end

  local index = pokemon.fastcallNumber or pokemon.pokeid
  if type(index) == "string" then
    index = index:gsub("!p%s*", "")
  end

  index = tonumber(index)
  if not index or index < 1 or index > 6 then
    return nil
  end

  return index
end

local function getBallpackPokemonTooltip(pokemon)
  local name = pokemon.nickname and pokemon.nickname ~= "" and pokemon.nickname or pokemon.name or "Pokemon"
  local boost = tonumber(pokemon.boost) or 0
  local health = tonumber(pokemon.health) or 0
  local maxHealth = tonumber(pokemon.maxHealth) or 0

  if maxHealth > 0 then
    return string.format("%s +%d\nHP: %d / %d", name, boost, health, maxHealth)
  end

  return string.format("%s +%d", name, boost)
end

local function callBallpackPokemon(index)
  index = tonumber(index)
  if index then
    g_game.talk("!p " .. index)
  end
end

local function clearBallpackSlot(index)
  local slot = ballpackSlots[index]
  if not slot then return end

  slot:setItem(nil)
  slot:setTooltip(tr('Empty'))
  slot.onClick = nil
  slot.onMouseRelease = nil
end

local function updateBallpackSlot(pokemon)
  local index = getPokemonBallpackIndex(pokemon)
  if not index then return end

  local slot = ballpackSlots[index]
  if not slot then return end

  ballpackPokemons[index] = pokemon

  if pokemon.ballClientId and tonumber(pokemon.ballClientId) and tonumber(pokemon.ballClientId) > 0 then
    slot:setItemId(tonumber(pokemon.ballClientId))
  else
    slot:setItem(nil)
  end

  slot:setTooltip(getBallpackPokemonTooltip(pokemon))
  slot.onClick = function()
    callBallpackPokemon(index)
  end
  slot.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == MouseRightButton then
      callBallpackPokemon(index)
      return true
    end
    return false
  end
end

local function refreshBallpackSlots()
  for i = 1, 6 do
    if ballpackPokemons[i] then
      updateBallpackSlot(ballpackPokemons[i])
    else
      clearBallpackSlot(i)
    end
  end
end

function updateBallpackFromPokebar(pokemon)
  updateBallpackSlot(pokemon)
end

function toggleBallpack()
  openBallpackSlot()
end

local function getOpenBallpackContainer()
  for _, container in pairs(g_game.getContainers()) do
    local containerItem = container:getContainerItem()
    local name = container:getName()
    if (name and name:lower() == 'ballpack') or (containerItem and containerItem:getId() == 7343) then
      return container
    end
  end
  return nil
end

function openBallpackSlot()
  local openedContainer = getOpenBallpackContainer()
  if openedContainer then
    g_game.close(openedContainer)
    return
  end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local ballpack = player:getInventoryItem(InventorySlotExt3)
  if ballpack then
    g_game.open(ballpack)
    return
  end

  if displayInfoBox then
    displayInfoBox(tr('Ballpack'), tr('Ballpack nao encontrada.'))
  else
    print('[game_pokemon] Ballpack nao encontrada.')
  end
end

local function autoOpenBallpack(tries)
  removeEvent(autoOpenBallpackEvent)
  autoOpenBallpackEvent = nil

  if not g_game.isOnline() then return end

  local player = g_game.getLocalPlayer()
  local ballpack = player and player:getInventoryItem(InventorySlotExt3)
  if ballpack then
    if not getOpenBallpackContainer() then
      g_game.open(ballpack)
    end
    return
  end

  tries = (tries or 0) + 1
  if tries <= 8 then
    autoOpenBallpackEvent = scheduleEvent(function()
      autoOpenBallpack(tries)
    end, 350)
  end
end

local function onGameStart()
  refresh()
  autoOpenBallpack(0)
end

function updateFromPokebar(pokemon)
  if not pokemon then return end

  updateBallpackFromPokebar(pokemon)

  local isActive = pokemon.use or pokemon.text == tr("USE") or pokemon.text == "USE"
  if not isActive then return end

  if pokemonWindow and pokeOutfit and pokemon.looktype then
    pokeOutfit:setOutfit({ type = tonumber(pokemon.looktype) or 0, lookType = tonumber(pokemon.looktype) or 0 })
    pokeOutfit:setVisible(true)
    pokeOutfit:setAnimate(true)
    if pokeOutfit.setOldScaling then
      pokeOutfit:setOldScaling(true)
    end
    if nilpokemon then
      nilpokemon:setVisible(false)
    end
  end

  activeBallFastcall = pokemon.fastcallNumber or pokemon.pokeid
  if type(activeBallFastcall) == "string" then
    activeBallFastcall = activeBallFastcall:gsub("!p%s*", "")
  end
  setActiveBallVisible(true)
end

function clearFromPokebar()
  activeBallFastcall = nil
  ballpackPokemons = {}
  refreshBallpackSlots()
  setPokeLevel(nil)
  setActiveBallVisible(false)
  if pokeOutfit then
    pokeOutfit:setVisible(false)
  end
  if nilpokemon then
    nilpokemon:setVisible(true)
  end
end

function openActiveBall()
  if activeBallFastcall then
    g_game.talk("!p " .. activeBallFastcall)
  end
end

local function updatePokemonInfoSlot(slot, item)
  if not pokemonWindow then return end

  local widgetId = PokemonInfoSlots[slot]
  if not widgetId then return end

  local itemWidget = pokemonWindow:recursiveGetChildById(widgetId)
  if not itemWidget then return end

  if item then
    itemWidget:setItem(item)
  else
    itemWidget:setItem(nil)
  end
end

setPokeLevel = function(data)
  if not pokemonWindow then return end

  local label = pokemonWindow:recursiveGetChildById('pokeLevelLabel')
  if not label then return end

  local level = data and (data.level or data.pokeLevel)
  if not level and data and data.healthInfos then
    level = data.healthInfos.level or data.healthInfos.pokeLevel
  end
  if not level and data and data.pokeInfo then
    level = data.pokeInfo.level or data.pokeInfo.pokeLevel
  end

  level = tonumber(level)
  if level and level > 0 then
    label:setText("Lv. " .. level)
    label:setVisible(true)
  else
    label:setText("")
    label:setVisible(false)
  end
end

function toggleMovesPanel()
  if modules.game_pokemonmoves and modules.game_pokemonmoves.toggle then
    modules.game_pokemonmoves.toggle()
    return true
  end

  if modules.game_textmessage and modules.game_textmessage.displayFailureMessage then
    modules.game_textmessage.displayFailureMessage(tr("Movesets indisponiveis."))
  end
  return false
end

function openTmsPanel()
  local moduleCandidates = {"game_tms", "game_tm", "game_pokemontms"}
  for _, moduleName in ipairs(moduleCandidates) do
    local module = modules[moduleName]
    if module and module.toggle then
      module.toggle()
      return true
    end
    if module and module.show then
      module.show()
      return true
    end
  end

  if modules.game_shop and modules.game_shop.setMode then
    if modules.game_shop.showShop then
      modules.game_shop.showShop()
    elseif modules.game_shop.toggleShop then
      modules.game_shop.toggleShop()
    end
    modules.game_shop.setMode("sell")
    if modules.game_shop.generateShopCategory then
      scheduleEvent(function()
        modules.game_shop.generateShopCategory("TMS")
      end, 250)
    end
    return true
  end

  if modules.game_textmessage and modules.game_textmessage.displayFailureMessage then
    modules.game_textmessage.displayFailureMessage(tr("Painel de TMs indisponivel."))
  end
  return false
end

local function resetAuraEffect()
  if not pokemonWindow or not pokemonWindow.contentsPanel then return end

  local auraEffect = pokemonWindow.contentsPanel.effect
  if not auraEffect then return end

  if auraEffect.setEffectId then
    auraEffect:setEffectId(0)
  end
  if auraEffect.setSize then
    auraEffect:setSize("32 32")
  end
  if auraEffect.setMarginTop then
    auraEffect:setMarginTop(0)
  end
  if auraEffect.setMarginLeft then
    auraEffect:setMarginLeft(0)
  end
  auraEffect:setVisible(false)
end

local function setAuraEffect(auraName)
  if not pokemonWindow or not pokemonWindow.contentsPanel then return end

  local auraEffect = pokemonWindow.contentsPanel.effect
  if not auraEffect then return end

  if not auraEffect.setEffectId then
    auraEffect:setVisible(false)
    return
  end

  if not auraName or auraName == "" then
    resetAuraEffect()
    return
  end

  local effectInfos = getAuraByName(auraName)
  local effectId = effectInfos and effectInfos.effectId or 0
  auraEffect:setEffectId(effectId)
  auraEffect:setVisible(effectId > 0)

  if effectInfos and effectInfos.rect then
    auraEffect:setSize(effectInfos.rect.size .. ' ' .. effectInfos.rect.size)
    auraEffect:setMarginTop(effectInfos.rect.top)
    auraEffect:setMarginLeft(effectInfos.rect.left)
  else
    auraEffect:setSize("32 32")
    auraEffect:setMarginTop(0)
    auraEffect:setMarginLeft(0)
  end
end

local function getInventorySlotItem(slot)
  local player = g_game.getLocalPlayer()
  if not player then return nil end

  return player:getInventoryItem(slot)
end

function openInventorySlot(slot)
  local item = getInventorySlotItem(slot)
  if item then
    g_game.open(item)
  end
end

function useInventorySlot(slot)
  local item = getInventorySlotItem(slot)
  if item then
    g_game.use(item)
  end
end

function getOpCode(protocol, opcode, json_data)
  if not json_data then
    return false
  end

  local action = json_data['action']
  local data = json_data['data']

  if not action or not data then
    return false
  end

  if action == 'RefreshPokeLife' then
	  -- onPokeHealthChange(tonumber(data.health), tonumber(data.maxHealth))
	  -- doSetupPokemonPreview(tonumber(data.atualAddon), data.dittoStatus)
  elseif action == 'LivePokemonInfos' then
    doSetupMyPokemonInfos(data)
  end
end

function init()
  connect(LocalPlayer, { 
	  onHealthChange = onHealthChange,
    onStatesChange = onStatesChange,
    onInventoryChange = onInventoryChange 
  })

  connect(Creature, {
    onCreatureHealthChange = onCreatureHealthChange
  })

  connect(g_game, { 
	  onGameStart = onGameStart,
    onGameEnd = offline,
    onFightModeChange = update
  })

  if PokeBar then
    connect(PokeBar, {
      onAddSlotBar = updateFromPokebar,
      onUpdateSlotBar = updateFromPokebar,
      onRemoveAllSlotBars = clearFromPokebar
    })
  end

  pcall(function() ProtocolGame.unregisterExtendedJSONOpcode(OPCODE) end)
  ProtocolGame.registerExtendedJSONOpcode(OPCODE, getOpCode)
  registeredOpcode = true

  g_keyboard.bindKeyDown('Ctrl+P', togglePokemonHotkey)

  pokemonWindow = g_ui.loadUI('pokemon', modules.game_interface.getRightPanel())
  pokemonWindow:disableResize()

  pokeOutfit = pokemonWindow.contentsPanel.outfitCreatureBox
  pokeBase = pokemonWindow.contentsPanel.pokeBase
  nilpokemon = pokemonWindow.contentsPanel.nilpokemon
  pokeStatus = pokemonWindow.contentsPanel.pokeStatus

  pokemonWindow.icon:setImageSource('images/icon')
  pokemonWindow.icon:setSize('18 21')
  pokemonWindow.icon:setMarginLeft(1)
  pokemonWindow.icon:setMarginTop(2)
  pokemonWindow.text:setText(tr('Pokemon'))

  pokemonWindow:setContentMinimumHeight(195)
  pokemonWindow.miniwindowScrollBar:setVisible(false)

  pokemonWindow.minimizeButton:setVisible(false)
  pokemonWindow.lockButton:setVisible(false)
  pokemonWindow.closeButton.onClick = toggle

  fightOffensiveBox = pokemonWindow:recursiveGetChildById('fightOffensiveBox')
  fightBalancedBox = pokemonWindow:recursiveGetChildById('fightBalancedBox')
  fightDefensiveBox = pokemonWindow:recursiveGetChildById('fightDefensiveBox')

  fightModeRadioGroup = UIRadioGroup.create()
  fightModeRadioGroup:addWidget(fightOffensiveBox)
  fightModeRadioGroup:addWidget(fightBalancedBox)
  fightModeRadioGroup:addWidget(fightDefensiveBox)
  fightModeRadioGroup.onSelectionChange = onSetFightMode

  fightOffensiveBox.tooltip = tr("Offensive")
  fightBalancedBox.tooltip = tr("Balanced")
  fightDefensiveBox.tooltip = tr("Defensive")

  refresh()
  if g_game.isOnline() then
    autoOpenBallpack(0)
  end
  fightMode = g_game.getFightMode()

  update(fightMode)
end

function doSetupMyPokemonInfos(data)
  if not pokemonWindow then return end

  MYPOKEID = data.myPokeId
  setPokeLevel(data)

  if data.pokeOutfit then
    pokeOutfit:setOutfit(data.pokeOutfit)
    pokeOutfit:setVisible(true)
    nilpokemon:setVisible(false)

    setAuraEffect(data.currentAura)

    if data.currentParticle and data.currentParticle ~= "" and pokeOutfit:getCreature() then
      pokeOutfit:getCreature():setOutfitShader(data.currentParticle)
    else
      if pokeOutfit:getCreature() then
        pokeOutfit:getCreature():setOutfitShader("outfit_default")
      end
    end

    local isAnimate = pokeOutfit:hasAutoAnimationTag()
    pokeOutfit:setAnimate(isAnimate)

    if data.healthInfos then
      onPokeHealthChange(math.floor(data.healthInfos.health), math.floor(data.healthInfos.healthMax))
    end
  end

  if data.pokeBase then
    setWidgetImageIfExists(pokeBase, "/images/ui/tooltip/bases/" .. data.pokeBase, defaultPokeBaseImage)
  end
end

function terminate()
  disconnect(LocalPlayer, { 
	  onHealthChange = onHealthChange,
    onStatesChange = onStatesChange,
    onInventoryChange = onInventoryChange
  })

  disconnect(Creature, {
    onCreatureHealthChange = onCreatureHealthChange
  })

  disconnect(g_game, { 
	  onGameStart = onGameStart,
    onGameEnd = offline,
    onFightModeChange = update
  })

  if PokeBar then
    disconnect(PokeBar, {
      onAddSlotBar = updateFromPokebar,
      onUpdateSlotBar = updateFromPokebar,
      onRemoveAllSlotBars = clearFromPokebar
    })
  end

  if registeredOpcode then
    pcall(function() ProtocolGame.unregisterExtendedJSONOpcode(OPCODE) end)
    registeredOpcode = false
  end

  removeEvent(autoOpenBallpackEvent)
  autoOpenBallpackEvent = nil

  offline()
  g_keyboard.unbindKeyDown('Ctrl+P', togglePokemonHotkey)
  if pokemonWindow then
    pokemonWindow:destroy()
    pokemonWindow = nil
  end
  ballpackSlots = {}
  ballpackPokemons = {}
  if fightModeRadioGroup then
    fightModeRadioGroup:destroy()
    fightModeRadioGroup = nil
  end
end

function refresh()
  if not pokemonWindow then return end

  local player = g_game.getLocalPlayer()
  if g_game.isOnline() then
    onHealthChange(player, player:getHealth(), player:getMaxHealth())
    local protocol = g_game.getProtocolGame()
    if protocol then
      protocol:sendExtendedOpcode(104, 'refresh')
    end
    onStatesChange(player, player:getStates(), 0)

    pokemonWindow:setup()
    pokemonWindow:open()
  end

  for i = InventorySlotFirst, InventorySlotLast do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
  end

  if g_game.isOnline() then
    onInventoryChange(player, InventorySlotExt3, player:getInventoryItem(InventorySlotExt3))
  end

  if player then
    local char = g_game.getCharacterName()

    local lastCombatControls = g_settings.getNode('LastCombatControls')

    if not table.empty(lastCombatControls) then
      if lastCombatControls[char] then
        g_game.setFightMode(lastCombatControls[char].fightMode)
      end
    end
  end
end

function update(opcode)
  if not fightModeRadioGroup then return end

  if opcode then
	if opcode == 1 then
		fightModeRadioGroup:selectWidget(fightOffensiveBox)
	elseif opcode == 2 or opcode <= 0 then
		fightModeRadioGroup:selectWidget(fightBalancedBox)
	elseif opcode == 3 then
		fightModeRadioGroup:selectWidget(fightDefensiveBox)
	end
  end
end

function toggle()
  if not pokemonWindow then return end

  if pokemonWindow:isVisible() then
    pokemonWindow:close()
  else
    pokemonWindow:open()
  end
end

function offline()
  if not pokemonWindow then return end

  removeEvent(autoOpenBallpackEvent)
  autoOpenBallpackEvent = nil

  pokemonWindow:recursiveGetChildById('conditionPanel'):destroyChildren()
  setPokeLevel(nil)

  local lastCombatControls = g_settings.getNode('LastCombatControls')
  if not lastCombatControls then
    lastCombatControls = {}
  end

  local player = g_game.getLocalPlayer()
  if player then
    local char = g_game.getCharacterName()
    lastCombatControls[char] = {
      fightMode = g_game.getFightMode(),
      chaseMode = g_game.getChaseMode(),
      safeFight = g_game.isSafeFight()
    }

    if g_game.getFeature(GamePVPMode) then
      lastCombatControls[char].pvpMode = g_game.getPVPMode()
    end

    -- save last combat control settings
    g_settings.setNode('LastCombatControls', lastCombatControls)
  end
end

function onSkillButtonClick(button)
  local percentBar = button:getChildById('percent')
  if percentBar then
    percentBar:setVisible(not percentBar:isVisible())
    if percentBar:isVisible() then
      button:setHeight(21)
      pokemonWindow:setHeight(pokemonWindow:getHeight() + 6)
    else
      button:setHeight(21 - 6)
      pokemonWindow:setHeight(pokemonWindow:getHeight() - 6)
    end
  end
end

function startChooseItem(releaseCallback)
  if g_ui.isMouseGrabbed() then return end
  if not releaseCallback then
    error("No mouse release callback parameter set.")
  end
  local mouseGrabberWidget = g_ui.createWidget('UIWidget')
  mouseGrabberWidget:setVisible(false)
  mouseGrabberWidget:setFocusable(false)

  connect(mouseGrabberWidget, { onMouseRelease = releaseCallback })
  
  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
end

local codeH = 1

function onHealthChange(player, health, maxHealth, oldHealth, oldMaxHealth)
  if not pokemonWindow then return end

  local function updateBar(bar, percentage)
      local Yhppc = math.floor(88 * (1 - (percentage / 100)))
      local rect = { x = 0, y = 0, width = 88 - Yhppc + 1, height = 16 }
      bar:setImageClip(rect)
      bar:setImageRect(rect)
  end
	
  local percent = calculatePercent(health, maxHealth)
  local oldPercent = calculatePercent(oldHealth, oldMaxHealth)
  local healthBar = pokemonWindow.contentsPanel.healthBar.progress
  local healthText = pokemonWindow.contentsPanel.healthBar.text
  local healthUnderBar = pokemonWindow.contentsPanel.healthBar.under
  
  healthText:setText(formatValue(health) .. ' / ' .. formatValue(maxHealth))
  
  updateBar(healthBar, percent)
  
  if oldHealth and oldMaxHealth and oldHealth > health and oldPercent > percent then
  	decreaseHealthEvent = scheduleEvent(function() 
  		doDecreaseHealthBar(healthUnderBar, oldPercent, percent) 
  	end, 1000)
  else
  	codeH = 1
  	removeEvent(decreaseHealthEvent)
  	updateBar(healthUnderBar, percent)
  end
end

function doDecreaseHealthBar(bar, old, to)
	codeH = math.random(1000,9999)
	for a = 1, old - to do 
		local checkCode = codeH
		scheduleEvent(function() 
			if checkCode == codeH then
				local percent = old-a
                local Yhppc = math.floor(88 * (1 - (percent / 100)))
                local rect = { x = 0, y = 0, width = 88 - Yhppc + 1, height = 16 }
                bar:setImageClip(rect)
                bar:setImageRect(rect)
			else
				return true
			end
		end, 30 * a)
	end
end

local pokeLifeOld = 0
local pokeMaxLifeOld = 0

function onPokeHealthChange(health, maxHealth)
  if not pokemonWindow then return end

  local function updateBar(bar, percentage)
      local Yhppc = math.floor(88 * (1 - (percentage / 100)))
      local rect = { x = 0, y = 0, width = 88 - Yhppc + 1, height = 16 }
      bar:setImageClip(rect)
      bar:setImageRect(rect)
  end

  local percent = calculatePercent(health, maxHealth)
  local oldPercent = calculatePercent(pokeLifeOld, pokeMaxLifeOld)
  local healthBar = pokemonWindow.contentsPanel.pokeHealthBar.progress
  local healthText = pokemonWindow.contentsPanel.pokeHealthBar.text
  local healthUnderBar = pokemonWindow.contentsPanel.pokeHealthBar.under

  if health == 0 and maxHealth == 0 then
	  healthText:setText("")
	  updateBar(healthBar, percent)
	  return
  end

  healthText:setText(formatValue(health) .. ' ('..percent..'%)')

  updateBar(healthBar, percent)

  if pokeLifeOld > health and oldPercent > percent then
  	decreaseHealthEvent = scheduleEvent(function() 
  		doDecreaseHealthBar(healthUnderBar, oldPercent, percent) 
  	end, 1000)
  else
  	codeH = 1
  	removeEvent(decreaseHealthEvent)
  	updateBar(healthUnderBar, percent)
  end

  pokeLifeOld = health
  pokeMaxLifeOld = maxHealth
end

Icons = {}
Icons[128] = { path = '/images/ui/tooltip/bases/duel_zone', id = 'condition_logout_block' }
Icons[16384] = { path = '/images/ui/tooltip/bases/pz_zone', id = 'condition_protection_zone' }

function onStatesChange(localPlayer, now, old)
  if not pokeStatus then return end

  if now == old or not Icons[now] then
    pokeStatus:setVisible(false)
    return
  end
  if now == 0 then
    pokeStatus:setVisible(false)
  else
    pokeStatus:setVisible(true)
    setWidgetImageIfExists(pokeStatus, Icons[now].path, defaultPokeStatusImage)
  end
end

function onCreatureHealthChange(pokemon, health, maxHealth)
	if pokemon:getId() == MYPOKEID then
		onPokeHealthChange(health, maxHealth)
	end
end

function onInventoryChange(player, slot, item, oldItem)
  if not pokemonWindow then return end
  if slot > InventorySlotPurse then return end

  updatePokemonInfoSlot(slot, item)

  local reloadTooltip = false
  local tId = g_tooltip.getHoveredWidget() and g_tooltip.getHoveredWidget():getId() or -1

  local itemWidget = pokemonWindow:recursiveGetChildById('slot' .. slot)
  if not itemWidget or not itemWidget:getId() then return end

  if tId == itemWidget:getId() then
    g_tooltip.hide()
    reloadTooltip = true
  end

  if item then
    itemWidget:setItem(item)

    if reloadTooltip then
      g_tooltip.display()
    end

    if slot == 8 then
      pokeOutfit:setVisible(true)
      nilpokemon:setVisible(false)
    end
  else
    if slot == 8 then
      MYPOKEID = 0
      onPokeHealthChange(0, 0)
      setPokeLevel(nil)
      pokeOutfit:setVisible(false)
      nilpokemon:setVisible(true)
      setWidgetImageIfExists(pokeBase, "/images/ui/tooltip/bases/normal", defaultPokeBaseImage)

      resetAuraEffect()
    end
    itemWidget:setItem(nil)
  end
end

function onSetFightMode(self, selectedWidget, previousWidget)
  if not selectedWidget then
    return true
  end

  local buttonId = selectedWidget:getId()
  if buttonId == 'fightOffensiveBox' then
    fightMode = 1
  elseif buttonId == 'fightBalancedBox' then
    fightMode = 2
  else
    fightMode = 3
  end

	g_game.setFightMode(fightMode)
  local protocol = g_game.getProtocolGame()
  if protocol then
	  protocol:sendExtendedOpcode(73, fightMode)
  end
  return true
end

function getWindow()
	return pokemonWindow
end
