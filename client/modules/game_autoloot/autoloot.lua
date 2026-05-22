-- Criado por Thalles Vitor --
-- Sistema de Auto Loot --
-- Refatorado para melhor estabilidade --

local autoloot = nil
local combobox = nil
local panel = nil
local panel_items = nil
local power = nil
local pesquisar = nil

local autolootbtn = nil
local optionss = {}
local itemlist = {}
local availableItems = {}
local addedItems = {}
local addedItemWidgets = {}
local initialized = false
local onReceiveOptions
local onReceiveAutoLootList
local onDestroyChildren
local onChangeAutoLootCategory
local onReceivePlayerItemsAdded

function init()
  if initialized then return end

  -- Aguardar que os módulos necessários sejam carregados
  scheduleEvent(function()
    if not modules.game_interface or not modules.client_topmenu then
      scheduleEvent(init, 100)
      return
    end

    g_ui.importStyle('autoloot')
    autoloot = g_ui.createWidget("AutolootWindow", modules.game_interface.getRootPanel())
    autoloot:hide()

    combobox = autoloot:getChildById("options")
    panel = autoloot:getChildById("panel_loots")
    panel_items = autoloot:getChildById("panel_loots_added")
    power = autoloot:getChildById("power_on")
    pesquisar = autoloot:getChildById("pesquisar")
    local closeButton = autoloot:getChildById("closeButton")
    if closeButton then
      closeButton.onClick = exibir
    end

    connect(g_game, {
      onGameStart = onGameStart,
      onGameEnd = naoexibir,
    })

    autolootbtn = modules.client_topmenu.addRightGameToggleButton('autoloot', tr('Auto-Loot'), '/modules/game_autoloot/aloot.png', exibir)
    autolootbtn:setOn(false)

    power.onClick = function() 
      if not g_game.isOnline() then return end
      if power:getText() == "OFF" then
        g_game.getProtocolGame():sendExtendedOpcode(57, "ligar")
      else
        g_game.getProtocolGame():sendExtendedOpcode(57, "desligar")
      end
    end

    pesquisar.onTextChange = function(self, value)
      if not g_game.isOnline() then return end
      g_game.getProtocolGame():sendExtendedOpcode(65, (value == "" and "none" or value) .. "@" .. combobox:getText() .. "@")
    end

    combobox.onTextChange = function(self, value) 
      if not g_game.isOnline() then return end
      g_game.getProtocolGame():sendExtendedOpcode(54, tostring(value)) 
    end

    ProtocolGame.registerExtendedOpcode(170, onReceiveOptions)
    ProtocolGame.registerExtendedOpcode(106, onReceiveAutoLootList)
    ProtocolGame.registerExtendedOpcode(107, onDestroyChildren)
    ProtocolGame.registerExtendedOpcode(108, onChangeAutoLootCategory)
    ProtocolGame.registerExtendedOpcode(109, onReceivePlayerItemsAdded)

    initialized = true
  end, 100)
end

function onGameStart()
  naoexibir()
end

function terminate()
  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = naoexibir,
  })

  ProtocolGame.unregisterExtendedOpcode(170, onReceiveOptions)
  ProtocolGame.unregisterExtendedOpcode(106, onReceiveAutoLootList)
  ProtocolGame.unregisterExtendedOpcode(107, onDestroyChildren)
  ProtocolGame.unregisterExtendedOpcode(108, onChangeAutoLootCategory)
  ProtocolGame.unregisterExtendedOpcode(109, onReceivePlayerItemsAdded)

  if autolootbtn then
    autolootbtn:destroy()
    autolootbtn = nil
  end

  if autoloot then
    autoloot:destroy()
    autoloot = nil
  end
  
  optionss = {}
  itemlist = {}
  availableItems = {}
  addedItems = {}
  addedItemWidgets = {}
  initialized = false
end

function exibir()
  if not g_game.isOnline() then return end
  if not autoloot then return end

  if autoloot:isVisible() then
    autoloot:hide()
    autolootbtn:setOn(false)
  else
    autoloot:show()
    autoloot:raise()
    autoloot:focus()
    autolootbtn:setOn(true)
    
    if combobox:getOptionsCount() == 0 then
        g_game.getProtocolGame():sendExtendedOpcode(53, "Items")
    end
  end
end

function naoexibir()
  if autoloot then
    autoloot:hide()
  end
  if autolootbtn then
    autolootbtn:setOn(false)
  end
  
  if panel then panel:destroyChildren() end
  if panel_items then panel_items:destroyChildren() end
  
  optionss = {}
  itemlist = {}
  availableItems = {}
  addedItems = {}
  addedItemWidgets = {}
  if combobox then combobox:clear() end
end

function getAutolootItems()
  local items = {}
  if not panel_items then return items end
  
  local children = panel_items:getChildren()
  for _, child in ipairs(children) do
    local itemWidget = child:getChildById("item")
    if itemWidget then
      table.insert(items, {id = itemWidget:getItemId(), name = itemWidget:getTooltip() or "Item"})
    end
  end
  return items
end

-- Opcodes
function onReceiveOptions(protocol, opcode, buffer) -- receive auto loot options
  local param = buffer:split("@")
  if not combobox then return end
  
  combobox:clear()
  optionss = {}
  
  for _, option in ipairs(param) do
    if not optionss[option] then
        combobox:addOption(option)
        optionss[option] = true
    end
  end
end

local function destroyAvailableLootEntry(name)
    name = tostring(name)
    local data = availableItems[name]
    if data and data.widget then
        data.widget:destroy()
        data.widget = nil
    end
    itemlist[name] = nil
end

local createAddedLootEntry

local function createLootEntry(id, name)
    if not panel then return end
    name = tostring(name)
    id = tonumber(id)

    availableItems[name] = availableItems[name] or { id = id, name = name }
    availableItems[name].id = id
    availableItems[name].name = name

    if addedItems[name] or itemlist[name] then return end

    local widget = g_ui.createWidget("LootListEntry", panel)
    widget:getChildById("item"):setItemId(id)
    widget:getChildById("nameItem"):setText(name)
    widget:getChildById("itemOption").onClick = function()
        if g_game.isOnline() then
            g_game.getProtocolGame():sendExtendedOpcode(55, tostring(name))
        end
        createAddedLootEntry(id, name)
    end
    availableItems[name].widget = widget
    itemlist[name] = true
    return widget
end

local function restoreAvailableLootEntry(name)
    name = tostring(name)
    if addedItems[name] then return end

    local data = availableItems[name]
    if data then
      createLootEntry(data.id, data.name)
    end
end

createAddedLootEntry = function(id, name)
  if not panel_items then return end
  name = tostring(name)
  id = tonumber(id)

  addedItems[name] = true
  destroyAvailableLootEntry(name)

  if addedItemWidgets[name] then return end

  local widget = g_ui.createWidget("AddedLootEntry", panel_items)
  widget:getChildById("item"):setItemId(id)
  widget:getChildById("item"):setTooltip(name)
  addedItemWidgets[name] = widget
  
  widget:getChildById("removeBtn").onClick = function()
    if g_game.isOnline() then
      g_game.getProtocolGame():sendExtendedOpcode(56, tostring(name))
    end

    if addedItemWidgets[name] then
      addedItemWidgets[name]:destroy()
      addedItemWidgets[name] = nil
    end

    addedItems[name] = nil
    restoreAvailableLootEntry(name)
  end
end

function onReceiveAutoLootList(protocol, opcode, buffer) -- receive auto loot list / state
  local param = buffer:split("@")
  local item_id = tonumber(param[1])
  local item_name = tostring(param[2])
  local power_state = tostring(param[3])

  if item_name == "state" then
    if power then
        power:setText(power_state == "true" and "ON" or "OFF")
    end
    return
  end

  createLootEntry(item_id, item_name)
  
  if power then
    power:setText(power_state == "true" and "ON" or "OFF")
  end
end

function onDestroyChildren(protocol, opcode, buffer) -- destroy children
  if buffer == "destroy" then
    if panel then panel:destroyChildren() end
    itemlist = {}
    availableItems = {}
  elseif buffer == "destroyAddedItem" then
    if panel_items then panel_items:destroyChildren() end
    addedItems = {}
    addedItemWidgets = {}
  end
end

function onChangeAutoLootCategory(protocol, opcode, buffer) -- change auto loot category
  local param = buffer:split("@")
  local item_id = tonumber(param[1])
  local item_name = tostring(param[2])
  local power_state = tostring(param[3])

  createLootEntry(item_id, item_name)
  if power then
    power:setText(power_state == "true" and "ON" or "OFF")
  end
end

function onReceivePlayerItemsAdded(protocol, opcode, buffer) -- receive player items added
  local param = buffer:split("@")
  local item_id = tonumber(param[1])
  local item_name = tostring(param[2])

  createAddedLootEntry(item_id, item_name)
end
