Icons = {}
Icons[PlayerStates.Poison] = { tooltip = tr('You are poisoned'), path = '/images/game/states/poisoned', id = 'condition_poisoned' }
Icons[PlayerStates.Burn] = { tooltip = tr('You are burning'), path = '/images/game/states/burning', id = 'condition_burning' }
Icons[PlayerStates.Energy] = { tooltip = tr('You are electrified'), path = '/images/game/states/electrified', id = 'condition_electrified' }
Icons[PlayerStates.Drunk] = { tooltip = tr('You are drunk'), path = '/images/game/states/drunk', id = 'condition_drunk' }
Icons[PlayerStates.ManaShield] = { tooltip = tr('You are protected by a magic shield'), path = '/images/game/states/magic_shield', id = 'condition_magic_shield' }
Icons[PlayerStates.Paralyze] = { tooltip = tr('You are paralysed'), path = '/images/game/states/slowed', id = 'condition_slowed' }
Icons[PlayerStates.Haste] = { tooltip = tr('You are hasted'), path = '/images/game/states/haste', id = 'condition_haste' }
Icons[PlayerStates.Swords] = { tooltip = tr('You may not logout during a fight'), path = '/images/game/states/logout_block', id = 'condition_logout_block' }
Icons[PlayerStates.Drowning] = { tooltip = tr('You are drowning'), path = '/images/game/states/drowning', id = 'condition_drowning' }
Icons[PlayerStates.Freezing] = { tooltip = tr('You are freezing'), path = '/images/game/states/freezing', id = 'condition_freezing' }
Icons[PlayerStates.Dazzled] = { tooltip = tr('You are dazzled'), path = '/images/game/states/dazzled', id = 'condition_dazzled' }
Icons[PlayerStates.Cursed] = { tooltip = tr('You are cursed'), path = '/images/game/states/cursed', id = 'condition_cursed' }
Icons[PlayerStates.PartyBuff] = { tooltip = tr('You are strengthened'), path = '/images/game/states/strengthened', id = 'condition_strengthened' }
Icons[PlayerStates.PzBlock] = { tooltip = tr('You may not logout or enter a protection zone'), path = '/images/game/states/protection_zone_block', id = 'condition_protection_zone_block' }
Icons[PlayerStates.Pz] = { tooltip = tr('You are within a protection zone'), path = '/images/game/states/protection_zone', id = 'condition_protection_zone' }
Icons[PlayerStates.Bleeding] = { tooltip = tr('You are bleeding'), path = '/images/game/states/bleeding', id = 'condition_bleeding' }
Icons[PlayerStates.Hungry] = { tooltip = tr('You are hungry'), path = '/images/game/states/hungry', id = 'condition_hungry' }

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
  [InventorySlotAmmo] = "AmmoSlot",
  [InventorySlotExt2] = "OrderSlot",
  [InventorySlotExt3] = "InfoSlot",
  [InventorySlotPurse] = "PurseSlot"
}

inventoryWindow = nil
inventoryPanel = nil
inventoryButton = nil
purseButton = nil
local updateHealthEvent
local pokemon = nil
local OUTFIT_REPOSITION = {
	[2106] = {top = -30, left = -10},
}

conditionPanel = nil

local COINS_BAG_ITEM_ID = 1997
local BIKE_ITEM_IDS = {
  [27634] = true,
  [41505] = true,
  [13218] = true
}

local function displayInventoryMessage(message)
  if modules.game_textmessage and modules.game_textmessage.displayFailureMessage then
    modules.game_textmessage.displayFailureMessage(message)
  elseif displayInfoBox then
    displayInfoBox(tr("Inventory"), message)
  else
    print("[game_inventory] " .. tostring(message))
  end
end

local function keepInventoryMenuOpen()
  if inventoryButton then
    inventoryButton:setOn(true)
  end
end

local function findOpenContainerByItemId(itemId)
  if not itemId then
    return nil
  end

  for _, container in pairs(g_game.getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and containerItem:getId() == itemId then
      return container
    end
  end

  return nil
end

local function findOpenContainerForItem(item)
  if not item then
    return nil
  end

  return findOpenContainerByItemId(item:getId())
end

local function getInventoryItemFromSlots(slots)
  local player = g_game.getLocalPlayer()
  if not player then
    return nil
  end

  if type(slots) ~= "table" then
    slots = {slots}
  end

  for _, slot in ipairs(slots) do
    local item = player:getInventoryItem(slot)
    if item then
      return item
    end
  end

  return nil
end

local function getInventorySlotWidget(slot)
  if not inventoryPanel then
    return nil
  end

  local slotId = 'slot' .. slot
  local itemWidget = inventoryPanel:getChildById(slotId)
  if itemWidget then
    return itemWidget
  end

  if inventoryWindow then
    return inventoryWindow:recursiveGetChildById(slotId)
  end

  return nil
end

local function useItemWithTarget(item)
  if modules.game_interface and modules.game_interface.startUseWith then
    modules.game_interface.startUseWith(item, item:getCountOrSubType() or -1)
  else
    g_game.use(item)
  end
end

local function startVirtualUseWith(itemId)
  local item = Item.create(itemId, 1)
  useItemWithTarget(item)
  keepInventoryMenuOpen()
  return true
end

local function openInventorySlotItem(slots, mode, missingMessage)
  local item = getInventoryItemFromSlots(slots)
  if not item then
    displayInventoryMessage(missingMessage or tr("Item nao encontrado."))
    return false
  end

  if mode == "useWith" then
    useItemWithTarget(item)
  elseif mode == "use" then
    g_game.use(item)
  elseif mode == "toggleOpen" then
    local openedContainer = findOpenContainerForItem(item)
    if openedContainer then
      g_game.close(openedContainer)
    else
      g_game.open(item)
    end
  else
    g_game.open(item)
  end

  keepInventoryMenuOpen()
  return true
end

local function useBikeItem()
  local item = getInventoryItemFromSlots(InventorySlotFinger)
  if not item then
    displayInventoryMessage(tr("Equipe uma bike no slot de bike."))
    return false
  end

  if g_game.isOnline() then
    g_game.talk("!bike")
  end

  keepInventoryMenuOpen()
  return true
end

local function getDraggedItem(widget)
  if not widget then
    return nil
  end

  if widget.currentDragThing and widget.currentDragThing:isItem() then
    return widget.currentDragThing
  end

  if widget.getItem then
    local item = widget:getItem()
    if item and item:isItem() then
      return item
    end
  end

  return nil
end

local function moveBikeItemToSlot(widget)
  local item = getDraggedItem(widget) or getDraggedItem(g_ui.getDraggingWidget())
  if not item then
    displayInventoryMessage(tr("Arraste um item para este slot."))
    return false
  end

  g_game.move(item, {x = 65535, y = InventorySlotFinger, z = 0}, 1)
  keepInventoryMenuOpen()
  return true
end

local function getEquippedBikeItem()
  local item = getInventoryItemFromSlots(InventorySlotFinger)
  if item and BIKE_ITEM_IDS[item:getId()] then
    return item
  end

  return nil
end

local function setupBikeDropTarget()
  if not inventoryWindow then
    return
  end

  local bikeButton = inventoryWindow:recursiveGetChildById("bikeButton")
  if not bikeButton then
    return
  end

  for _, child in ipairs(bikeButton:getChildren()) do
    child:setPhantom(true)
  end

  local bikeSlot = getInventorySlotWidget(InventorySlotFinger)
  if bikeSlot then
    bikeSlot:breakAnchors()
    bikeSlot:setParent(bikeButton)
    bikeSlot:setId("slot" .. InventorySlotFinger)
    bikeSlot:setSize({width = 44, height = 40})
    bikeSlot:addAnchor(AnchorTop, "parent", AnchorTop)
    bikeSlot:addAnchor(AnchorLeft, "parent", AnchorLeft)
    bikeSlot:setMarginTop(0)
    bikeSlot:setMarginLeft(0)
    bikeSlot:setPhantom(false)
    bikeSlot:setDraggable(true)
    bikeSlot:setFocusable(false)
    bikeSlot:setOpacity(getEquippedBikeItem() and 1 or 0)

    local bordered = bikeSlot:getChildById("bordered")
    if bordered then
      bordered:setPhantom(true)
    end

    local moveborder = bikeSlot:getChildById("moveborder")
    if moveborder then
      moveborder:setPhantom(true)
    end
  end

  bikeButton:setDraggable(true)

  bikeButton.onDragEnter = function(widget, mousePos)
    local draggingWidget = g_ui.getDraggingWidget()

    if draggingWidget == widget or not draggingWidget then
      local equippedBike = getEquippedBikeItem()
      if not equippedBike then
        return false
      end

      widget.currentDragThing = equippedBike
      widget:setBorderColor("#6ee7b7")
      widget:setBorderWidth(1)
      g_mouse.pushCursor("target")
      return true
    end

    local item = getDraggedItem(draggingWidget)
    if not item then
      return false
    end

    widget:setBorderColor("#6ee7b7")
    widget:setBorderWidth(1)
    g_mouse.pushCursor("target")
    return true
  end

  bikeButton.onDragLeave = function(widget, droppedWidget, mousePos)
    widget:setBorderColor("#2f3c5a")
    widget:setBorderWidth(1)
    if g_ui.getDraggingWidget() == widget then
      widget.currentDragThing = nil
    end
    g_mouse.popCursor("target")
    return true
  end

  bikeButton.onDrop = function(widget, droppedWidget, mousePos)
    widget:setBorderColor("#2f3c5a")
    widget:setBorderWidth(1)
    g_mouse.popCursor("target")
    return moveBikeItemToSlot(droppedWidget)
  end
end

local function toggleCoinsBag()
  local item = getInventoryItemFromSlots(InventorySlotLeg)
  if item then
    return openInventorySlotItem(InventorySlotLeg, "toggleOpen")
  end

  if g_game.isOnline() then
    g_game.talk("!coinsbag")
    scheduleEvent(function()
      if g_game.isOnline() and not findOpenContainerByItemId(COINS_BAG_ITEM_ID) then
        local item = getInventoryItemFromSlots(InventorySlotLeg)
        if item then
          openInventorySlotItem(InventorySlotLeg, "toggleOpen")
        end
      end
    end, 300)
    keepInventoryMenuOpen()
    return true
  end

  return openInventorySlotItem(InventorySlotLeg, "toggleOpen", tr("Coins Bag nao encontrada. Relogue para o servidor preparar ela no inventario."))
end

local function toggleCatchBag()
  if getInventoryItemFromSlots(InventorySlotFeet) then
    return openInventorySlotItem(InventorySlotFeet, "toggleOpen")
  end

  if not g_game.isOnline() then
    displayInventoryMessage(tr("Catch Bag nao encontrada. Relogue para o servidor preparar ela no inventario."))
    return false
  end

  g_game.talk("!catchbag")
  scheduleEvent(function()
    if g_game.isOnline() then
      openInventorySlotItem(InventorySlotFeet, "toggleOpen", tr("Catch Bag preparada. Clique novamente no botao CATCH para abrir."))
    end
  end, 300)
  keepInventoryMenuOpen()
  return true
end

local function toggleInventoryModule(moduleName, functionName, missingMessage)
  local module = modules[moduleName]
  local callback = module and module[functionName or "toggle"]
  if not callback then
    displayInventoryMessage(missingMessage or tr("Modulo indisponivel."))
    return false
  end

  callback()
  keepInventoryMenuOpen()
  return true
end

function openInventoryAction(action)
  if action == "bag" then
    return openInventorySlotItem(InventorySlotBack, "toggleOpen", tr("Mochila nao encontrada."))
  elseif action == "ballpack" then
    if modules.game_pokemon and modules.game_pokemon.openBallpackSlot then
      modules.game_pokemon.openBallpackSlot()
      keepInventoryMenuOpen()
      return true
    end
    return openInventorySlotItem(InventorySlotExt3, "open", tr("Ballpack nao encontrada."))
  elseif action == "pokedex" then
    return openInventorySlotItem(InventorySlotBody, "useWith", tr("Pokedex nao encontrada. Relogue para o servidor preparar ela no inventario."))
  elseif action == "catch" then
    return toggleCatchBag()
  elseif action == "pokemon" then
    return toggleInventoryModule("game_pokemon", "toggle", tr("Painel de Pokemon indisponivel."))
  elseif action == "order" then
    return openInventorySlotItem(InventorySlotExt2, "useWith", tr("Order nao encontrado. Relogue para o servidor preparar ele no inventario."))
  elseif action == "rod" then
    return openInventorySlotItem(InventorySlotNeck, "useWith", tr("Rod nao encontrada. Relogue para o servidor preparar ela no inventario."))
  elseif action == "rope" then
    return startVirtualUseWith(38682)
  elseif action == "bike" then
    return useBikeItem()
  elseif action == "badges" then
    if modules.game_playerbar and modules.game_playerbar.toggleProfile then
      return toggleInventoryModule("game_playerbar", "toggleProfile", tr("Perfil indisponivel."))
    end
    displayInventoryMessage(tr("Painel de badges indisponivel."))
    keepInventoryMenuOpen()
    return false
  elseif action == "coins" then
    return toggleCoinsBag()
  elseif action == "shop" then
    return toggleInventoryModule("game_shop", "toggleShop", tr("Loja indisponivel."))
  end

  return false
end

function init()
  connect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    onBlessingsChange = onBlessingsChange,
    onStatesChange = onStatesChange,
  })
  connect(g_game, { onGameStart = refresh })

  g_keyboard.bindKeyDown('Ctrl+I', toggle)

  inventoryButton = modules.client_topmenu.addRightButton('inventoryButton', tr('Inventory') .. ' (Ctrl+I)', '/images/TOPBUTTONS_REWORK/ICON_INVENTARIO', toggle)
  inventoryButton:setOn(true)

  inventoryWindow = g_ui.loadUI('inventory', modules.game_interface.getRightPanel())
  inventoryWindow:disableResize()
  inventoryPanel = inventoryWindow:getChildById('contentsPanel')
  setupBikeDropTarget()
  
  local icon = inventoryWindow:getChildById('icon')
  if icon then
    icon:setImageSource('/images/ui/inventory/icon')
  end
  -- inventoryWindow:getChildById('text'):setText('Inventory')
  conditionPanel = inventoryWindow:recursiveGetChildById('conditionPanel')
  


  --purseButton = inventoryPanel:getChildById('purseButton')
  local function purseFunction()
    local purse = g_game.getLocalPlayer():getInventoryItem(InventorySlotPurse)
    if purse then
      g_game.use(purse)
    end
  end
  
  ProtocolGame.registerExtendedOpcode(17, getOpCode)

  refresh()
  inventoryWindow:setup()
  local scrollBar = inventoryWindow:getChildById('miniwindowScrollBar')
  if scrollBar then
    scrollBar:hide()
  end
  updateHealthEvent = cycleEvent(checkCreaturesAround, 100)
end

function getOpCode(protocol, opcode, buffer)
    local status, json_data =
        pcall(
            function()
                return json.decode(buffer)
            end
        )
    if not status then
        return false
    end
	
	if json_data.action == "release" then
	    local creature = g_map.getCreatureById(json_data.creature)
      if not creature then
        return false
      end
		local creatureOutfit = creature:getOutfit().type
		pokemon = creature
		if inventoryWindow.name then inventoryWindow.name:setText(creature:getName()) end
		if inventoryWindow.pokeOutfit then
      inventoryWindow.pokeOutfit:setVisible(false)
      inventoryWindow.pokeOutfit:setAnimate(false)
    end
		if OUTFIT_REPOSITION[creatureOutfit] then
			local pos = OUTFIT_REPOSITION[creatureOutfit]
			if inventoryWindow.pokeOutfit then
        inventoryWindow.pokeOutfit:setVisible(false)
      end
		end
		
		if inventoryWindow.progressBar then inventoryWindow.progressBar:setVisible(true) end
		if inventoryWindow.removeOutfit then inventoryWindow.removeOutfit:setVisible(false) end
    if inventoryWindow.progressBar then
        inventoryWindow.progressBar:setImageClip({ x = 0, y = 0, width = 112, height = 7 })
        inventoryWindow.progressBar:setImageRect({ x = 0, y = 0, width = 112, height = 7 })
    end
	elseif json_data.action == "remove" then
		pokemon = nil
		if inventoryWindow.name then inventoryWindow.name:setText("") end
		if inventoryWindow.progressBar then inventoryWindow.progressBar:setVisible(false) end
		if inventoryWindow.pokeOutfit then inventoryWindow.pokeOutfit:setVisible(false) end
		if inventoryWindow.removeOutfit then inventoryWindow.removeOutfit:setVisible(true) end
	end
end

function checkCreaturesAround()
    if not g_game.isOnline() then
        return
    end
    if hasPokemonActive == 0 then
        return
    end

    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

	if pokemon ~= nil then
      local progressPercent = math.floor(100 * pokemon:getHealthPercent() / 100)
      local Yhppc = math.floor(112 * (1 - (progressPercent / 100)))
      local rect = { x = 0, y = 0, width = 112 - Yhppc + 1, height = 7 }
      if inventoryWindow.progressBar then
        inventoryWindow.progressBar:setImageClip(rect)
        inventoryWindow.progressBar:setImageRect(rect)
      end
    else
      if inventoryWindow.progressBar then
        inventoryWindow.progressBar:setImageClip({ x = 0, y = 0, width = 112, height = 7 })
        inventoryWindow.progressBar:setImageRect({ x = 0, y = 0, width = 112, height = 7 })
      end
	end
end

function terminate()
  disconnect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    onBlessingsChange = onBlessingsChange,
    onStatesChange = onStatesChange
  })
  disconnect(g_game, { onGameStart = refresh })

  if g_game.isOnline() then
    offline()
  end

  g_keyboard.unbindKeyDown('Ctrl+I')

  ProtocolGame.unregisterExtendedOpcode(17)

  if inventoryWindow then inventoryWindow:destroy() end
  if inventoryButton then inventoryButton:destroy() end
  if updateHealthEvent then removeEvent(updateHealthEvent) end
end

function toggleAdventurerStyle(hasBlessing)
  for slot = InventorySlotFirst, InventorySlotLast do
    local itemWidget = inventoryPanel:getChildById('slot' .. slot)
    if not itemWidget then
      itemWidget = inventoryWindow and inventoryWindow:recursiveGetChildById('slot' .. slot)
    end
    if itemWidget then
      itemWidget:setOn(hasBlessing)
    end
  end
end

function refresh()
  local player = g_game.getLocalPlayer()
  for i = InventorySlotFirst, InventorySlotLast do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
    toggleAdventurerStyle(player and Bit.hasBit(player:getBlessings(), Blessings.Adventurer) or false)
  end

  if inventoryWindow.name then inventoryWindow.name:setText("") end
  if inventoryWindow.progressBar then
    inventoryWindow.progressBar:setVisible(false)
    inventoryWindow.progressBar:setImageClip({ x = 0, y = 0, width = 112, height = 7 })
    inventoryWindow.progressBar:setImageRect({ x = 0, y = 0, width = 112, height = 7 })
  end
  if inventoryWindow.pokeOutfit then inventoryWindow.pokeOutfit:setVisible(false) end
  if inventoryWindow.removeOutfit then inventoryWindow.removeOutfit:setVisible(true) end
--  purseButton:setVisible(g_game.getFeature(GamePurseSlot))
  if player then
    onStatesChange(player, player:getStates(), 0)
  end
end

function toggle()
  if inventoryButton:isOn() then
    inventoryWindow:close()
    inventoryButton:setOn(false)
  else
    inventoryWindow:open()
    inventoryButton:setOn(true)
  end
end

function onMiniWindowClose()
  inventoryButton:setOn(false)
end

-- hooked events
function onInventoryChange(player, slot, item, oldItem)
  if slot > InventorySlotLast then return end

  if slot == InventorySlotPurse then
    if g_game.getFeature(GamePurseSlot) then
--      purseButton:setEnabled(item and true or false)
    end
    return
  end
  
 -- local itemx = g_game.getLocalPlayer():getInventoryItem(item)
-- local data = itemx:getItemInfo()
  
  -- if data.pokeballInfo ~= "" then
	-- itemx:setShader("outfit_red")
  -- end

  local itemWidget = getInventorySlotWidget(slot)
  if not itemWidget then
    return
  end
  if item then
    itemWidget:setStyle('InventoryItem')
    if slot == InventorySlotFinger then
      itemWidget:setSize({width = 44, height = 40})
      itemWidget:setOpacity(1)
    end
    itemWidget:setItem(item)
	-- local itemX = itemWidget:getItem()
	 -- local data = itemX:getItemInfo()

		-- itemX:setShader("outfit_red")

  else
    itemWidget:setStyle(InventorySlotStyles[slot])
    if slot == InventorySlotFinger then
      itemWidget:setSize({width = 44, height = 40})
      itemWidget:setOpacity(0)
    end
    itemWidget:setItem(nil)
  end
end

function onBlessingsChange(player, blessings, oldBlessings)
  local hasAdventurerBlessing = Bit.hasBit(blessings, Blessings.Adventurer)
  if hasAdventurerBlessing ~= Bit.hasBit(oldBlessings, Blessings.Adventurer) then
    toggleAdventurerStyle(hasAdventurerBlessing)
  end
end

-- status
function toggleIcon(bitChanged)
  if not conditionPanel or not Icons[bitChanged] then
    return
  end
  local icon = conditionPanel:getChildById(Icons[bitChanged].id)
  if icon then
    icon:destroy()
  else
    icon = loadIcon(bitChanged)
    icon:setParent(conditionPanel)
  end
end

function loadIcon(bitChanged)
  local icon = g_ui.createWidget('ConditionWidget', conditionPanel)
  icon:setId(Icons[bitChanged].id)
  icon:setImageSource(Icons[bitChanged].path)
  icon:setTooltip(Icons[bitChanged].tooltip)
  return icon
end


function onStatesChange(localPlayer, now, old)
  if now == old then return end
  local bitsChanged = bit32.bxor(now, old)
  for i = 1, 32 do
    local pow = math.pow(2, i-1)
    if pow > bitsChanged then break end
    local bitChanged = bit32.band(bitsChanged, pow)
    if bitChanged ~= 0 then
      toggleIcon(bitChanged)
    end
  end
end

function offline()
  local lastCombatControls = g_settings.getNode('LastCombatControls')
  if not lastCombatControls then
    lastCombatControls = {}
  end

  if conditionPanel then
    conditionPanel:destroyChildren()
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
