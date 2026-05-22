local actionBars = {}
local settings = {}
local settingsFile = ""
local actionConfig = nil
local cachedSettings = nil
local window = nil
local mouseGrabberWidget = nil
local mouseHotkeyBindings = {} -- Armazena as referências das hotkeys de mouse para poder desconectá-las

-- Sistema de cooldowns pendentes
local pendingCooldowns = {}

-- Cache global de cooldowns por itemId (independente dos slots)
local globalItemCooldowns = {}

local blockedItems = { 3450, 11411, 15452, 15453, 15454, 15455, 3453 }
local MONEY_IDS = { 11483, 3031, 3035, 3043 }
local POKEBALL_IDS = {
  [11929] = true -- saffari
}

local TYPE = {
  BLANK = 0,
  TEXT = 1,
  SPELL = 2,
  ITEM = 3
}

local ACTION = {
  BLANK = 0,
  EQUIP = 1,
  USE = 2,
  USE_SELF = 3,
  USE_TARGET = 4,
  USE_CROSS = 5,
  USE_POKEMON = 6,
  USE_POKEBALL = 7,
  USE_FAST = 8,
}

ActionColors = {
  empty = '#555555',
  text = '#c0c0c0',
  itemUse = '#989898',
  itemUseSelf = '#6fff6c',
  itemUseTarget = '#ff6c6c',
  itemUseWith = '#ffc26c',
  itemEquip = '#d99c46',
  itemUsePokemon = '#6cd0ff',
  itemUsePokeball = '#8f6cff',
  itemUseFast = '#efff6c',
}

mouseActionsbar = {
  MouseMidButton = MouseMidButton,
  Mouse4 = MouseButton4,
  Mouse5 = MouseButton5
}

local function isActionbarTooltipEnabled()
  if not modules.client_options or not modules.client_options.getOption then
    return true
  end

  local optionValue = modules.client_options.getOption("actionbarTooltipEnabled")
  if optionValue == nil then
    return true
  end

  return optionValue
end

local function getActionbarItemCount(itemId)
  if not itemId or itemId <= 0 then
    return 0
  end

  if g_game.getItemTrackingCount then
    return g_game.getItemTrackingCount(itemId) or 0
  end

  local player = g_game.getLocalPlayer()
  if player and player.getItemsCount then
    return player:getItemsCount(itemId) or 0
  end

  return 0
end

local function registerActionbarItem(itemId)
  if itemId and itemId > 0 and g_game.registerItemForTracking then
    g_game.registerItemForTracking(itemId)
  end
end

local function unregisterActionbarItem(itemId)
  if itemId and itemId > 0 and g_game.unregisterItemForTracking then
    g_game.unregisterItemForTracking(itemId)
  end
end

local function isActionbarPokeballVisual(itemId)
  if not itemId or itemId <= 0 then
    return false
  end

  local ok, info = pcall(function()
    return Item.create(itemId, 1):getItemInfo()
  end)

  if ok and info and info.name then
    local name = tostring(info.name):lower()
    return name:find("ball", 1, true) and not name:find("bait", 1, true)
  end

  return POKEBALL_IDS[itemId] == true
end

local function getActionbarVisualCount(itemId, realCount)
  if isActionbarPokeballVisual(itemId) then
    return (tonumber(realCount) or 0) >= 2 and 3 or 1
  end

  return 0
end

local function startActionbarUseWith(item, subType)
  if startUseWith then
    startUseWith(item, subType)
    return true
  end

  if modules.game_interface and modules.game_interface.startUseWith then
    modules.game_interface.startUseWith(item, subType)
    return true
  end

  return false
end

local function hasActionbarSettings(data)
  if type(data) ~= "table" then
    return false
  end

  for key, value in pairs(data) do
    if type(value) == "table" and value.type then
      return true
    end
  end

  return false
end

function doCorrectNumber(value)
  if not value then
    return "0"
  end

  local formatted = tostring(math.floor(tonumber(value) or 0))
  local k
  while true do
    formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
    if k == 0 then
      break
    end
  end

  return formatted
end

function canAddItemToActionbar(itemId, item)
  if not itemId or itemId <= 0 then
    return false
  end

  if isPokeball(itemId, item) then
    return false
  end

  if isMoneyItem(itemId) then
    return false
  end

  if item and item:isItem() and item:isContainer() then
    return false
  end

  for _, blockedId in ipairs(blockedItems) do
    if blockedId == itemId then
      return false
    end
  end
  return true
end

function canAddItem(item)
  if not item or not item:isItem() then
    return false
  end

  return item:isStackable() or item:isMultiUse() or (not item:isContainer())
end

function validateAndShowItemError(itemId, item)
  if (not itemId or itemId <= 0) then
    return false
  end

  if not item or not item:isItem() then
    return false
  end

  if not canAddItem(item) then
    modules.game_textmessage.displayFailureMessage(tr("You cannot add this item!"))
    return false
  end

  if isPokeball(itemId, item) then
    modules.game_textmessage.displayFailureMessage(tr("You cannot add Pokémons to the actionbar!"))
    return false
  end

  if isMoneyItem(itemId) then
    modules.game_textmessage.displayFailureMessage(tr("You cannot add money to the actionbar!"))
    return false
  end

  if item and item:isItem() and item:isContainer() then
    modules.game_textmessage.displayFailureMessage(tr("You cannot add containers to the actionbar!"))
    return false
  end

  for _, blockedId in ipairs(blockedItems) do
    if blockedId == itemId then
      modules.game_textmessage.displayFailureMessage(tr("This item cannot be added to the actionbar!"))
      return false
    end
  end

  return true
end

function canAddItemToActionbarById(itemId)
  return canAddItemToActionbar(itemId, nil)
end

function addBlockedItem(itemId)
  if itemId and itemId > 0 then
    for _, blockedId in ipairs(blockedItems) do
      if blockedId == itemId then
        return
      end
    end
    table.insert(blockedItems, itemId)
  end
end

function removeBlockedItem(itemId)
  if itemId and itemId > 0 then
    for i, blockedId in ipairs(blockedItems) do
      if blockedId == itemId then
        table.remove(blockedItems, i)
        return
      end
    end
  end
end

function isItemBlocked(itemId)
  if not itemId or itemId <= 0 then
    return false
  end

  for _, blockedId in ipairs(blockedItems) do
    if blockedId == itemId then
      return true
    end
  end

  return false
end

function startItemCooldown(widget, duration)
  if type(widget.cooldownTill) == 'number' and widget.cooldownTill > g_clock.millis() + duration then
    return
  end
  widget.cooldownStart = g_clock.millis()
  widget.cooldownTill = g_clock.millis() + duration

  local itemId = widget.item:getItemId()
  applyCooldownToSameItems(itemId, widget.cooldownStart, widget.cooldownTill)

  updateItemCooldown(widget)
end

function applyCooldownToSameItems(itemId, cooldownStart, cooldownTill)
  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, button in ipairs(actionbar.tabBar:getChildren()) do
        local slotItemId = button.item and button.item:getItemId() or 0

        if button.item and slotItemId == itemId and button.type == TYPE.ITEM then
          button.cooldownStart = cooldownStart
          button.cooldownTill = cooldownTill
          updateItemCooldown(button)
        elseif button.type == TYPE.BLANK then
          if button.cooldownTill then
            clearItemCooldown(button)
          end
        end
      end
    end
  end
end

function getItemActiveCooldown(itemId)
  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, button in ipairs(actionbar.tabBar:getChildren()) do
        if button.item and button.item:getItemId() == itemId then
          if button.cooldownTill and button.cooldownTill > g_clock.millis() then
            return {
              cooldownStart = button.cooldownStart,
              cooldownTill = button.cooldownTill
            }
          end
        end
      end
    end
  end
  return nil
end

function countSlotsWithItemId(itemId)
  local count = 0
  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, button in ipairs(actionbar.tabBar:getChildren()) do
        local slotItemId = settings[button:getId()] and settings[button:getId()].itemId
        if slotItemId and slotItemId == itemId then
          count = count + 1
        end
      end
    end
  end
  return count
end

function updateItemCooldown(widget)
  if not widget or not widget.cooldownTill then return end
  local timeleft = widget.cooldownTill - g_clock.millis()
  if timeleft <= 50 then
    widget.cooldown:setPercent(100)
    widget.cooldownEvent = nil
    widget.cooldown:setText("")

    -- Resetar flag de fadeOut
    widget.fadeOutDone = false

    -- Mostrar elementos com fadeIn quando cooldown acaba
    if widget.hotkeyLabel then
      g_effects.fadeIn(widget.hotkeyLabel, 200)
    end
    if widget.countItem then
      g_effects.fadeIn(widget.countItem, 200)
    end

    -- Remover o cooldown do cache quando expira
    if widget.item and widget.item:getItemId() then
      local itemId = widget.item:getItemId()
      if globalItemCooldowns[itemId] then
        globalItemCooldowns[itemId] = nil
      end
    end

    return
  end

  local duration = widget.cooldownTill - widget.cooldownStart

  -- Calcular porcentagem de forma mais suave (com decimais)
  local percent = math.max(0, math.min(100, 100 - (timeleft / duration * 100)))

  -- Ocultar hotkeyLabel e countItem durante o cooldown com fadeOut (apenas uma vez)
  if not widget.fadeOutDone then
    if widget.hotkeyLabel then
      g_effects.fadeOut(widget.hotkeyLabel, 200)
    end
    if widget.countItem then
      g_effects.fadeOut(widget.countItem, 200)
    end

    widget.fadeOutDone = true
  end

  -- Só mostrar texto se duration > 500ms
  local formattedText = ""
  if duration > 500 then
    if timeleft > 86400000 then
      -- Mais de 1 dia: mostrar dias e horas
      local days = math.floor(timeleft / 86400000)
      local hours = math.floor((timeleft % 86400000) / 3600000)
      if hours > 0 then
        formattedText = days .. "d " .. hours .. "h"
      else
        formattedText = days .. "d"
      end
    elseif timeleft > 3600000 then
      -- Mais de 1 hora: mostrar horas e minutos
      local hours = math.floor(timeleft / 3600000)
      local minutes = math.floor((timeleft % 3600000) / 60000)
      if minutes > 0 then
        formattedText = hours .. "h " .. minutes .. "m"
      else
        formattedText = hours .. "h"
      end
    elseif timeleft > 60000 then
      -- Mais de 1 minuto: mostrar minutos e segundos
      local minutes = math.floor(timeleft / 60000)
      local seconds = math.floor((timeleft % 60000) / 1000)
      if seconds > 0 then
        formattedText = minutes .. "m " .. seconds .. "s"
      else
        formattedText = minutes .. "m"
      end
    else
      -- Menos de 1 minuto: mostrar segundos com 1 decimal
      formattedText = string.format("%.1f", timeleft / 1000) .. "s"
    end
  end

  widget.cooldown:setText(formattedText)

  -- Atualização mais frequente para animação mais suave
  local retry
  if timeleft > 60000 then
    retry = 1000 -- Atualizar a cada 1s para cooldowns longos
  elseif timeleft > 1000 then
    retry = 100
  else
    local minRetry = 16  -- ~60 FPS
    local maxRetry = 100 -- 0.1s
    retry = math.min(maxRetry, math.max(minRetry, timeleft / 10))
  end

  widget.cooldown:setPercent(percent)

  -- Remover evento anterior se existir para evitar múltiplos eventos
  if widget.cooldownEvent then
    removeEvent(widget.cooldownEvent)
  end

  widget.cooldownEvent = scheduleEvent(function() updateItemCooldown(widget) end, retry)
end

function isItemInCooldown(widget)
  if not widget.cooldownTill then return false end
  return widget.cooldownTill > g_clock.millis()
end

function clearItemCooldown(widget)
  if widget.cooldownEvent then
    removeEvent(widget.cooldownEvent)
    widget.cooldownEvent = nil
  end
  widget.cooldownStart = nil
  widget.cooldownTill = nil
  if widget.cooldown then
    widget.cooldown:setPercent(100)
    widget.cooldown:setText("")
  end
end

-- Handler para cooldown individual (durante o jogo)
function onServerItemCooldown(itemId, timestampStart, timestampEnd)
  local duration = timestampEnd - timestampStart
  local now = g_clock.millis()
  local localStart = now
  local localEnd = now + duration

  -- Cachear o cooldown globalmente
  globalItemCooldowns[itemId] = {
    cooldownStart = localStart,
    cooldownTill = localEnd
  }

  applyCooldownToSameItems(itemId, localStart, localEnd)
end

-- Handler para sincronização de cooldowns (no login)
function onServerSyncCooldowns(cooldowns)
  pendingCooldowns = {}
  globalItemCooldowns = {}

  for _, cooldownData in ipairs(cooldowns) do
    local itemId = cooldownData[1]
    local remainingMs = cooldownData[2]
    local totalDuration = cooldownData[3]

    pendingCooldowns[itemId] = {
      remainingMs = remainingMs,
      totalDuration = totalDuration
    }
  end

  applyPendingCooldowns()
end

-- Aplicar cooldowns pendentes quando a actionbar estiver pronta
function applyPendingCooldowns()
  local count = 0
  for _ in pairs(pendingCooldowns) do count = count + 1 end

  if count == 0 then
    return
  end

  for itemId, cooldownData in pairs(pendingCooldowns) do
    local now = g_clock.millis()
    local remainingMs = cooldownData.remainingMs
    local totalDuration = cooldownData.totalDuration

    if remainingMs > 0 then
      local elapsed = totalDuration - remainingMs

      local localStart = now - elapsed
      local localEnd = now + remainingMs

      -- Cachear o cooldown
      globalItemCooldowns[itemId] = {
        cooldownStart = localStart,
        cooldownTill = localEnd
      }

      applyCooldownToSameItems(itemId, localStart, localEnd)
    end
  end
end

-- Limpar cooldowns expirados do cache global
function cleanupExpiredCooldowns()
  local now = g_clock.millis()
  for itemId, cooldownData in pairs(globalItemCooldowns) do
    if not cooldownData.cooldownTill or cooldownData.cooldownTill <= now then
      globalItemCooldowns[itemId] = nil
    end
  end
end

function registerMouseHotkey(widget, hotkey, callback)
  local gameRootPanel = modules.game_interface.getRootPanel()
  if not gameRootPanel then
    return
  end

  local button = mouseActionsbar[hotkey]
  if not button then
    return
  end

  local hotkeyId = widget:getId() .. "_" .. hotkey

  if mouseHotkeyBindings[hotkeyId] then
    unregisterMouseHotkey(widget, hotkey)
  end

  local mousePressHandler = function(widget, mousePos, mouseButton)
    if mouseButton == button then
      callback(mousePos, mouseButton)
      return true
    end
    return false
  end

  mouseHotkeyBindings[hotkeyId] = {
    widget = gameRootPanel,
    callback = callback,
    button = button,
    handler = mousePressHandler
  }

  if gameRootPanel._mouseHotkeyHandlers then
    gameRootPanel._mouseHotkeyHandlers[hotkeyId] = mousePressHandler
  else
    gameRootPanel._mouseHotkeyHandlers = {}
    gameRootPanel._mouseHotkeyHandlers[hotkeyId] = mousePressHandler
  end

  if not gameRootPanel._globalMouseHandler then
    gameRootPanel._globalMouseHandler = function(widget, mousePos, mouseButton)
      if gameRootPanel._mouseHotkeyHandlers then
        for id, handler in pairs(gameRootPanel._mouseHotkeyHandlers) do
          local result = handler(widget, mousePos, mouseButton)
          if result then
            return true
          end
        end
      end
      return false
    end

    connect(gameRootPanel, { onMousePress = gameRootPanel._globalMouseHandler })
  end
end

function unregisterMouseHotkey(widget, hotkey)
  local hotkeyId = widget:getId() .. "_" .. hotkey
  local binding = mouseHotkeyBindings[hotkeyId]

  if binding then
    local gameRootPanel = binding.widget

    if gameRootPanel._mouseHotkeyHandlers then
      gameRootPanel._mouseHotkeyHandlers[hotkeyId] = nil

      local hasHandlers = false
      for id, handler in pairs(gameRootPanel._mouseHotkeyHandlers) do
        hasHandlers = true
        break
      end

      if not hasHandlers then
        disconnect(gameRootPanel, { onMousePress = gameRootPanel._globalMouseHandler })
        gameRootPanel._globalMouseHandler = nil
        gameRootPanel._mouseHotkeyHandlers = nil
      end
    end

    mouseHotkeyBindings[hotkeyId] = nil
  end
end

function clearAllMouseHotkeys()
  for hotkeyId, binding in pairs(mouseHotkeyBindings) do
    local gameRootPanel = binding.widget

    if gameRootPanel._mouseHotkeyHandlers then
      gameRootPanel._mouseHotkeyHandlers[hotkeyId] = nil
    end
  end

  for hotkeyId, binding in pairs(mouseHotkeyBindings) do
    local gameRootPanel = binding.widget

    if gameRootPanel._globalMouseHandler then
      disconnect(gameRootPanel, { onMousePress = gameRootPanel._globalMouseHandler })
      gameRootPanel._globalMouseHandler = nil
      gameRootPanel._mouseHotkeyHandlers = nil
      break
    end
  end

  mouseHotkeyBindings = {}
end

function updateItemCount(itemId, newCount)
  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, button in ipairs(actionbar.tabBar:getChildren()) do
        local config = settings[button:getId()]
        if config and config.itemId == itemId and config.type == TYPE.ITEM then
          if newCount == 0 then
            button.item:setColor('#666666')
          else
            button.item:setColor('#ffffff')
          end

          local originalOnItemChange = button.item.onItemChange
          button.item.onItemChange = nil

          if newCount > 1 then
            button.item:setItemCount(getActionbarVisualCount(itemId, newCount))
            button.countItem:setText(doCorrectNumber(newCount))
            button.countItem:setVisible(true)
          else
            button.item:setItemCount(getActionbarVisualCount(itemId, newCount))
            button.countItem:setText('')
            button.countItem:setVisible(false)
          end

          button.item.onItemChange = originalOnItemChange
        end
      end
    end
  end
end

function init()
  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
    onLogout = offline,
    onItemTrackingUpdate = updateItemCount,
    onServerItemCooldown = onServerItemCooldown,
    onServerSyncCooldowns = onServerSyncCooldowns
  })

  connect(g_app, {
    onTerminate = function()
      save()
    end
  })

  mouseGrabberWidget = g_ui.createWidget('UIWidget')

  mouseGrabberWidget:setVisible(false)
  mouseGrabberWidget:setFocusable(false)
  mouseGrabberWidget.onMouseRelease = onDropActionButton
end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
    onLogout = offline,
    onItemTrackingUpdate = updateItemCount,
    onServerItemCooldown = onServerItemCooldown,
    onServerSyncCooldowns = onServerSyncCooldowns
  })

  disconnect(g_app, {
    onTerminate = function()
      save()
    end
  })

  if mouseGrabberWidget then
    pcall(function()
      mouseGrabberWidget:ungrabMouse()
    end)
    mouseGrabberWidget.onMouseRelease = nil
    pcall(function()
      mouseGrabberWidget:destroy()
    end)
    mouseGrabberWidget = nil
  end
end

function doGetActionbarSize(count)
  if count == 1 then
    return 94
  else
    return (46 * (count - 1)) + 94
  end
end

function doUpdateBottomBarSize(buttonsCount)
  local bottomPanel = getActionbarPanel()
  if not bottomPanel then
    return
  end
  local realWidth = doGetActionbarSize(buttonsCount)
  bottomPanel:setSize({ width = realWidth, height = 62 })

  local parent = bottomPanel:getParent()
  if parent then
    bottomPanel:setX(math.floor((parent:getWidth() - realWidth) / 2))
  end
end

function getActionbarPanel()
  if modules.game_playerinfo and modules.game_playerinfo.doGetActionbarPanel then
    return modules.game_playerinfo.doGetActionbarPanel()
  end

  if modules.game_playerbar and modules.game_playerbar.doGetActionbarPanel then
    return modules.game_playerbar.doGetActionbarPanel()
  end

  return nil
end

function createActionBars()
  local bottomPanel = getActionbarPanel()
  if not bottomPanel then
    return false
  end

  bottomPanel:show()
  bottomPanel:raise()

  for i = 1, 3 do
    local parent
    local index
    local layout

    if i <= 3 then
      parent = bottomPanel
      index = i
      layout = 'actionbar'
    end

    actionBars[i] = g_ui.loadUI(layout, parent)
    actionBars[i]:setId("actionbar." .. i)
    actionBars[i]:setSize({ width = parent:getWidth(), height = 62 })
    actionBars[i].n = i
    parent:moveChildToIndex(actionBars[i], index)
  end

  return true
end

function offline()
  save()

  destroyAssignWindows()

  clearAllMouseHotkeys()

  for index, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for i, actionButton in ipairs(actionbar.tabBar:getChildren()) do
        if actionButton then
          local callback = actionButton.callback
          local hotkey = actionButton.hotkey and actionButton.hotkey:len() > 0 and actionButton.hotkey or false

          if callback and hotkey then
            local gameRootPanel = modules.game_interface.getRootPanel()
            if gameRootPanel then
              if not mouseActionsbar[hotkey] then
                g_keyboard.unbindKeyDown(hotkey, callback, gameRootPanel)
              end
            end
          end
        end
      end
    end
  end

  for i, panel in ipairs(actionBars) do
    if panel then
      panel:destroy()
    end
  end
  actionBars = {}

  local bottomPanel = getActionbarPanel()
  if bottomPanel then
    bottomPanel:hide()
  end

  -- Limpar cache de cooldowns ao desconectar
  globalItemCooldowns = {}
end

function online()
  addEvent(function()
    local player = g_game.getLocalPlayer()
    if not player then
      return
    end
    destroyAssignWindows()
    settingsFile = modules.client_profiles.getSettingsFilePath("actionbar_" .. player:getName() .. ".json")
    local profileName = player:getName():gsub("[^%w_%-]", "_")
    actionConfig = g_configs.create("/u_actionbar_" .. profileName .. ".otml")
    load()
    if createActionBars() then
      show()
    end
  end)
end

function registerActionBarItems()
  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, button in ipairs(actionbar.tabBar:getChildren()) do
        local itemId = settings[button:getId()] and settings[button:getId()].itemId
        if itemId and itemId > 0 then
            registerActionbarItem(itemId)
        end
      end
    end
  end
end

function show()
  for i = 1, #actionBars do
    local actionbar = actionBars[i]
    local enabled = i == 1 or g_settings.getBoolean("actionbar" .. i, false)

    actionbar:setOn(enabled)
    actionbar:setVisible(enabled)
    actionbar:setHeight(enabled and 43 or 0)
    setupActionBar(i)
  end

  registerActionBarItems()
end

function refresh()
  save()
  local player = g_game.getLocalPlayer()
  if not player then
    return
  end
  settingsFile = modules.client_profiles.getSettingsFilePath("actionbar_" .. player:getName() .. ".json")
  local profileName = player:getName():gsub("[^%w_%-]", "_")
  actionConfig = g_configs.create("/u_actionbar_" .. profileName .. ".otml")
  load()
  show()
  destroyAssignWindows()
end

function translateHotkeyDesc(text)
  if not text then
    return ""
  end

  local values = {
    { "Shift",    "S" },
    { "Ctrl",     "C" },
    { "+",        "" },
    { "PageUp",   "PgUp" },
    { "PageDown", "PgDown" },
    { "Enter",    "Return" },
    { "Insert",   "Ins" },
    { "Delete",   "Del" },
    { "Escape",   "Esc" },
    { "Mouse1",   "M1" },
    { "Mouse2",   "M2" },
    { "Mouse3",   "M3" },
    { "Mouse4",   "M4" },
    { "Mouse5",   "M5" },
  }

  for i, v in pairs(values) do
    text = text:gsub(v[1], v[2])
  end

  if text:len() > 6 then
    text = text:sub(text:len() - 3, text:len())
    text = "..." .. text
  end

  return text
end

function destroyAssignWindows()
  local windows = {
    'assignHotkeyWindow'
  }

  local rootWidget = g_ui.getRootWidget()
  for i, id in ipairs(windows) do
    local widget = rootWidget[id]

    if widget then
      widget:destroy()
    end
  end
end

function changeLockState(widget)
  local actionbar = widget:getParent():getParent()

  widget:setOn(not widget:isOn())
  widget.icon:setOn(not widget:isOn())
  widget.image:setOn(widget:isOn())
  actionbar.locked = not widget:isOn()

  settings[actionbar:getId()] = not widget:isOn() or nil
end

function onDropActionButton(self, mousePosition, mouseButton)
  if not g_ui.isMouseGrabbed() then return end
  local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
  if clickedWidget and clickedWidget:getParent() and clickedWidget:getParent():getStyleName():find('ActionButton') then
    if cachedSettings then
      clickedWidget = clickedWidget:getParent()
      if clickedWidget ~= cachedSettings.widget then
        local clickedHotkey = clickedWidget.hotkey
        local cachedHotkey = cachedSettings.widget.hotkey

        -- Salvar cooldowns antes de trocar
        local clickedTill = clickedWidget.cooldownTill or 0
        local clickedStart = clickedWidget.cooldownStart or 0
        local clickedEvent = clickedWidget.cooldownEvent
        local cachedTill = cachedSettings.widget.cooldownTill or 0
        local cachedStart = cachedSettings.widget.cooldownStart or 0
        local cachedEvent = cachedSettings.widget.cooldownEvent

        -- Trocar configurações
        settings[cachedSettings.id] = settings[clickedWidget:getId()]
        settings[clickedWidget:getId()] = cachedSettings.data

        -- Trocar hotkeys
        settings[cachedSettings.id] = settings[cachedSettings.id] or {}
        settings[cachedSettings.id].hotkey = cachedHotkey
        settings[clickedWidget:getId()] = settings[clickedWidget:getId()] or {}
        settings[clickedWidget:getId()].hotkey = clickedHotkey

        -- Configurar botões
        setupButton(cachedSettings.widget)
        setupButton(clickedWidget)

        -- Transferir cooldowns após setupButton
        cachedSettings.widget.cooldownTill = clickedTill
        cachedSettings.widget.cooldownStart = clickedStart
        cachedSettings.widget.cooldownEvent = clickedEvent
        clickedWidget.cooldownTill = cachedTill
        clickedWidget.cooldownStart = cachedStart
        clickedWidget.cooldownEvent = cachedEvent

        if cachedSettings.widget.cooldownTill and cachedSettings.widget.cooldownTill > g_clock.millis() then
          updateItemCooldown(cachedSettings.widget)
        end
        if clickedWidget.cooldownTill and clickedWidget.cooldownTill > g_clock.millis() then
          updateItemCooldown(clickedWidget)
        end
      end
    end
  end

  cachedSettings.widget.item:setBorderColor('#00000000')
  cachedSettings = nil
  g_mouse.popCursor('target')
  self:ungrabMouse()
end

function setupActionBar(n)
  local actionbar = actionBars[n]
  local visible = actionbar:isVisible()
  locked = settings[actionbar:getId()]
  actionbar.tabBar.onMouseWheel = nil

  actionbar.locked = locked

  if not visible then
    return actionbar.tabBar:destroyChildren()
  else
    actionbar.tabBar:destroyChildren()
    for i = 1, 23 do
      local widget = g_ui.createWidget('ActionButton', actionbar.tabBar)
      widget:setId(actionbar.n .. "." .. i)
      setupButton(widget)
    end

    -- Tentar aplicar cooldowns pendentes após configurar os slots
    addEvent(function()
      applyPendingCooldowns()
    end, 100)
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

local widgetByAddItem

function onClickWithMouse(self, mousePosition, mouseButton)
  local item = nil
  if mouseButton == MouseLeftButton then
    local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
    if clickedWidget then
      if clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        item = clickedWidget:getItem()
        local itemId = clickedWidget:getItemId()

        if not itemId or itemId <= 0 then
          g_mouse.popCursor('target')
          self:ungrabMouse()
          self:destroy()
          return
        end

        if not validateAndShowItemError(itemId, item) then
          g_mouse.popCursor('target')
          self:ungrabMouse()
          self:destroy()
          return
        end

        widgetByAddItem.item:setItem(item)
      end
    end
  end

  g_mouse.popCursor('target')
  self:ungrabMouse()
  self:destroy()
end

function setupButton(widget)
  cancelShakeAnimation(widget)

  if widget.shakeInProgress == nil then
    widget.shakeInProgress = false
  end

  local id = widget:getId()
  local config = settings[id]
  local actionbar = widget:getParent():getParent()

  widget.item:setShowCount(false)

  widget.item.onItemChange = nil

  widget.type = TYPE.BLANK
  widget.text:setText("")
  widget.parameterText:setText("")

  -- Limpar cooldown quando o slot é limpo
  clearItemCooldown(widget)

  if widget.item:getItemId() ~= 0 then
    widget.item:setItemId(0)
  end

  widget.item:setOn(false)
  widget.icon:setOn(false)
  widget.autoSay = nil
  widget.action = ACTION.BLANK
  widget.spellData = nil
  widget.item:setItemVisible(true)

  if widget.item.setVirtualHoverEnabled then
    widget.item:setVirtualHoverEnabled(isActionbarTooltipEnabled())
  end

  widget.text:setImageSource('')
  widget.hotkey = config and config.hotkey or ""

  if widget.hotkey and widget.hotkey:len() > 0 and widget.callback then
    local gameRootPanel = modules.game_interface.getRootPanel()
    if gameRootPanel then
      if mouseActionsbar[widget.hotkey] then
        unregisterMouseHotkey(widget, widget.hotkey)
      else
        g_keyboard.unbindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
      end
    end
  end

  widget.callback = nil

  widget.countItem:setText('')
  widget.countItem:setVisible(false)

  local player = g_game.getLocalPlayer()

  -- add new settings
  if config and config.type then
    widget.item:setOn(true)
    widget.icon:setOn(true)
    widget.type = config.type
    widget.text:setText(config.sayText or "")
    if widget.item:getItemId() ~= (config.itemId and config.itemId > 100 and config.itemId or 0) then
      local itemCount = getActionbarItemCount(config.itemId)
      widget.item:setItem(Item.create(config.itemId, getActionbarVisualCount(config.itemId, itemCount)))

      if config.type == TYPE.ITEM then
        if itemCount == 0 then
          widget.item:setColor('#666666') -- Escuro quando quantidade = 0
        else
          widget.item:setColor('#ffffff') -- Claro quando quantidade >= 1
        end

        -- Configurar label de contagem
        if itemCount > 1 then
          widget.countItem:setText(doCorrectNumber(itemCount))
          widget.countItem:setVisible(true)
        else
          widget.countItem:setText('')
          widget.countItem:setVisible(false)
        end
      end
    end
    widget.sayText = config.sayText
    widget.autoSay = config.autoSay
    widget.action = config.action
    if config.type ~= 0 and config.type ~= 3 then
      widget.item:setItemVisible(false)
    end
  end

  if config and config.type == TYPE.ITEM and config.itemId then
    -- Primeiro, tentar recuperar o cooldown do cache global
    local cachedCooldown = globalItemCooldowns[config.itemId]
    if cachedCooldown and cachedCooldown.cooldownTill and cachedCooldown.cooldownTill > g_clock.millis() then
      widget.cooldownStart = cachedCooldown.cooldownStart
      widget.cooldownTill = cachedCooldown.cooldownTill
      updateItemCooldown(widget)
    else
      -- Se não houver no cache, buscar de slots ativos
      local activeCooldown = getItemActiveCooldown(config.itemId)
      if activeCooldown then
        widget.cooldownStart = activeCooldown.cooldownStart
        widget.cooldownTill = activeCooldown.cooldownTill

        -- Atualizar o cache com o cooldown encontrado
        globalItemCooldowns[config.itemId] = {
          cooldownStart = activeCooldown.cooldownStart,
          cooldownTill = activeCooldown.cooldownTill
        }

        updateItemCooldown(widget)
      end
    end
  end

  -- callback
  setupAction(widget)

  --hotkey
  widget.hotkeyLabel:setText(translateHotkeyDesc(widget.hotkey))

  widget.item.onDragEnter = function(self)
    if g_ui.isMouseGrabbed() or actionbar.locked then return end
    mouseGrabberWidget:grabMouse()
    g_mouse.pushCursor('target')

    self:setBorderColor('#FFFFFF')
    cachedSettings = { id = widget:getId(), data = settings[widget:getId()], widget = widget }
  end

  -- popupmenu & execute action
  widget.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == MouseRightButton then
      local menu = g_ui.createWidget('PopupMenu')
      menu:setGameMenu(true)
      if widget.item:getItemId() ~= 0 then
        menu:addOption(tr('Remove Item'), function() resetSlot(widget) end)
        if settings[widget:getId()] then
          menu:addOption(widget.hotkey and tr('Edit Hotkey') or tr('Assign Hotkey'), function() assignHotkey(widget) end)

          if widget.hotkey ~= "" then
            menu:addOption(tr('Clear Hotkey'), function() doClearActionByWidget(widget) end)
          end
          menu:addSeparator()

          menu:addOption(tr('Switch to common use'), function() assignItem(widget, nil) end)                   -- ok
          menu:addOption(tr('Switch to quick use'), function() assignItem(widget, "useFast") end)              -- off
          menu:addOption(tr('Switch to use with aim'), function() assignItem(widget, "useCross") end)          -- ok
          menu:addOption(tr("Switch to use directly on the Pokemon's Pokeball"),
            function() assignItem(widget, "usePokeball") end)                                                  -- ok
          menu:addOption(tr('Switch to use on your Pokemon'), function() assignItem(widget, "usePokemon") end) -- ok
          menu:addOption(tr('Switch to use on yourself'), function() assignItem(widget, "useSelf") end)        -- ok
          menu:addOption(tr('Switch to use on your target'), function() assignItem(widget, "useTarget") end)   -- ok
        end
      else
        menu:addOption(tr('Add Item'), function()
          widgetByAddItem = widget
          startChooseItem(onClickWithMouse)
        end)
        if widget.hotkey ~= "" then
          menu:addOption(tr('Clear Hotkey'), function() doClearActionByWidget(widget) end)
        end
      end

      menu:display(mousePos)
    elseif mouseButton == MouseLeftButton and widget.callback then
      widget.callback()
    else
      widgetByAddItem = widget
      startChooseItem(onClickWithMouse)
    end
  end

  widget.item.onItemChange = function(widget)
    local item = widget:getItem()
    local itemId = widget:getItemId()

    if itemId > 0 then
      if not validateAndShowItemError(itemId, item) then
        widget:setItemId(0)
        widget:setOn(false)
        return
      end
    end

    widget:setOn(true)
    assignItem(widget:getParent())
  end

  if widget.shakeInProgress ~= "zero_quantity" then
    if widget.type == TYPE.ITEM then
      if widget.action == ACTION.EQUIP then
        widget.border:setImageColor(ActionColors.itemEquip)
      elseif widget.action == ACTION.USE then
        widget.border:setImageColor(ActionColors.itemUse)
      elseif widget.action == ACTION.USE_SELF then
        widget.border:setImageColor(ActionColors.itemUseSelf)
      elseif widget.action == ACTION.USE_TARGET then
        widget.border:setImageColor(ActionColors.itemUseTarget)
      elseif widget.action == ACTION.USE_CROSS then
        widget.border:setImageColor(ActionColors.itemUseWith)
      elseif widget.action == ACTION.USE_POKEMON then
        widget.border:setImageColor(ActionColors.itemUsePokemon)
      elseif widget.action == ACTION.USE_POKEBALL then
        widget.border:setImageColor(ActionColors.itemUsePokeball)
      elseif widget.action == ACTION.USE_FAST then
        widget.border:setImageColor(ActionColors.itemUseFast)
      else
        widget.border:setImageColor(ActionColors.itemUse)
      end
    else
      widget.border:setImageColor(ActionColors.empty)
    end
  end
end

function resetSlot(widget)
  local hotkey = settings[widget:getId()] and settings[widget:getId()].hotkey or nil
  local oldItemId = settings[widget:getId()] and settings[widget:getId()].itemId

  clearItemCooldown(widget)

  if widget.hotkey and widget.hotkey:len() > 0 and widget.callback then
    local gameRootPanel = modules.game_interface.getRootPanel()

    if mouseActionsbar[widget.hotkey] then
      unregisterMouseHotkey(widget, widget.hotkey)
    else
      g_keyboard.unbindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
    end
  end

  if oldItemId and oldItemId > 0 then
    local remainingSlots = countSlotsWithItemId(oldItemId)
    if remainingSlots <= 1 then
      unregisterActionbarItem(oldItemId)
    end
  end

  if hotkey then
    settings[widget:getId()] = { hotkey = hotkey }
  else
    settings[widget:getId()] = nil
  end

  setupButton(widget)
end

function assignItem(widget, selected)
  destroyAssignWindows()
  local item = widget.item:getItem()
  local id = widget.item:getItemId()
  local oldItemId = settings[widget:getId()] and settings[widget:getId()].itemId

  if id == 0 and widget.item:isOn() then
    return resetSlot(widget)
  end

  if id > 0 and not validateAndShowItemError(id, item) then
    return resetSlot(widget)
  end

  local hotkey = settings[widget:getId()] and settings[widget:getId()].hotkey

  if widget.hotkey and widget.hotkey:len() > 0 and widget.callback then
    local gameRootPanel = modules.game_interface.getRootPanel()
    if mouseActionsbar[widget.hotkey] then
      unregisterMouseHotkey(widget, widget.hotkey)
    else
      g_keyboard.unbindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
    end
  end

  settings[widget:getId()] = { hotkey = hotkey }
  settings[widget:getId()].itemId = widget.item:getItemId()
  settings[widget:getId()].type = TYPE.ITEM

  if selected == "useSelf" then
    settings[widget:getId()].action = ACTION.USE_SELF
  elseif selected == "usePokemon" then
    settings[widget:getId()].action = ACTION.USE_POKEMON
  elseif selected == "useFast" then
    settings[widget:getId()].action = ACTION.USE_FAST
  elseif selected == "usePokeball" then
    settings[widget:getId()].action = ACTION.USE_POKEBALL
  elseif selected == "useFast" then
    settings[widget:getId()].action = ACTION.USE_FAST
  elseif selected == "useTarget" then
    settings[widget:getId()].action = ACTION.USE_TARGET
  elseif selected == "useCross" then
    settings[widget:getId()].action = ACTION.USE_CROSS
  elseif selected == "equip" then
    settings[widget:getId()].action = ACTION.EQUIP
  else
    settings[widget:getId()].action = ACTION.USE
  end

  if oldItemId and oldItemId > 0 and oldItemId ~= id then
    local remainingSlots = countSlotsWithItemId(oldItemId)
    if remainingSlots <= 1 then
      unregisterActionbarItem(oldItemId)
    end
  end

  if id > 0 then
    registerActionbarItem(id)
  end

  setupButton(widget)
  save()
end

function hotkeyCaptureMouse(window, mousePosition, mouseButton)
  for keyCombo, mouseBtn in pairs(mouseActionsbar) do
    if mouseButton == mouseBtn then
      local comboPreview = window.display
      comboPreview:setText(keyCombo)

      local keyUsed = false

      for index, actionbar in ipairs(actionBars) do
        if actionbar.tabBar then
          for i, actionButton in ipairs(actionbar.tabBar:getChildren()) do
            if actionButton then
              local callback = actionButton.callback
              local hotkey = actionButton.hotkey and actionButton.hotkey:len() > 0 and actionButton.hotkey or false

              if hotkey == keyCombo then
                keyUsed = true
                break
              end
            end
          end
        end
        if keyUsed then break end
      end

      if not keyUsed then
        keyUsed = isHotkeyUsedInOptions(keyCombo)
      end

      if keyUsed then
        window.display:setColor("red")
        window.buttonOk:setOpacity(0.5)
        window.buttonOk:setPhantom(true)

        if window.errorLabel then
          if isHotkeyUsedInOptions(keyCombo) then
            window.errorLabel:setText(tr("This shortcut key is already in use in Options"))
          else
            window.errorLabel:setText(tr("This shortcut key is already in use"))
          end
          window.errorLabel:setColor("#ff7070")
        end

        return false
      else
        window.display:setColor("white")
        window.buttonOk:setOpacity(1)
        window.buttonOk:setPhantom(false)

        if window.errorLabel then
          window.errorLabel:setText(tr("This shortcut key can be used"))
          window.errorLabel:setColor("#70ff92")
        end
      end

      comboPreview.keyCombo = keyCombo

      break
    end
  end

  return true
end

function doClearActionByWidget(widget)
  if settings[widget:getId()].hotkey and settings[widget:getId()].hotkey:len() > 0 and widget.callback then
    local gameRootPanel = modules.game_interface.getRootPanel()
    if mouseActionsbar[widget.hotkey] then
      unregisterMouseHotkey(widget, widget.hotkey)
    else
      g_keyboard.unbindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
    end
  end
  settings[widget:getId()] = settings[widget:getId()] or {}
  settings[widget:getId()].hotkey = hotkey

  setupButton(widget)
end

function assignHotkey(widget)
  destroyAssignWindows()

  -- create window
  window = g_ui.loadUI('hotkey', g_ui.getRootWidget())
  window:show()
  window:raise()
  window:focus()

  local barN = widget:getParent():getParent().n
  local barDesc
  if barN < 4 then
    barDesc = "Bottom"
  elseif barN < 7 then
    barDesc = "Left"
  else
    barDesc = "Right"
  end

  -- things
  barDesc = tr("Action Slot") .. ": " .. string.sub(widget:getId(), 3, 99999)
  window.subTitle:setText(barDesc)

  if widget.hotkey == "" then
    window.display:setText(tr("< empty >"))
    window.display:setColor("#ffd57c")
  else
    window.display:setColor("#ffffff")
    window.display:setText(widget.hotkey)
  end

  -- hotkey
  window:grabKeyboard()
  window.onMousePress = hotkeyCaptureMouse
  local checkHotkey = false
  window.onKeyDown = function(window, keyCode, keyboardModifiers)
    local keyCombo = determineKeyComboDesc(keyCode, keyboardModifiers)
    window.display:setText(keyCombo)

    local keyUsed = false

    for index, actionbar in ipairs(actionBars) do
      if actionbar.tabBar then
        for i, actionButton in ipairs(actionbar.tabBar:getChildren()) do
          if actionButton then
            local callback = actionButton.callback
            local hotkey = actionButton.hotkey and actionButton.hotkey:len() > 0 and actionButton.hotkey or false

            if hotkey == keyCombo then
              keyUsed = true
              break
            end
          end
        end
      end
      if keyUsed then break end
    end

    if not keyUsed then
      keyUsed = isHotkeyUsedInOptions(keyCombo)
    end

    if keyUsed then
      window.display:setColor("red")
      window.buttonOk:setOpacity(0.5)
      window.buttonOk:setPhantom(true)

      if window.errorLabel then
        if isHotkeyUsedInOptions(keyCombo) then
          window.errorLabel:setText(tr("This shortcut key is already in use in Options"))
        else
          window.errorLabel:setText(tr("This shortcut key is already in use"))
        end
        window.errorLabel:setColor("#ff7070")
      end

      return false
    else
      window.display:setColor("white")
      window.buttonOk:setOpacity(1)
      window.buttonOk:setPhantom(false)

      if window.errorLabel then
        window.errorLabel:setText(tr("This shortcut key can be used"))
        window.errorLabel:setColor("#70ff92")
      end
    end

    return true
  end

  local okFunc = function()
    local hotkey = window.display:getText()
    if settings[widget:getId()].hotkey and settings[widget:getId()].hotkey:len() > 0 and widget.callback then
      local gameRootPanel = modules.game_interface.getRootPanel()
      if mouseActionsbar[widget.hotkey] then
        unregisterMouseHotkey(widget, widget.hotkey)
      else
        g_keyboard.unbindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
      end
    end
    settings[widget:getId()] = settings[widget:getId()] or {}
    settings[widget:getId()].hotkey = hotkey

    window:destroy()
    setupButton(widget)
  end
  window.buttonOk.onClick = okFunc

  local closeFunc = function()
    window:destroy()
    setupButton(widget)
  end

  window.buttonClose.onClick = closeFunc

  local actionbar = widget:getParent():getParent()
  if actionbar.locked then
    cancelFunc()
  end
end

function setupAction(widget)
  if widget.type == TYPE.BLANK then
    return false
  end

  if widget.type == TYPE.ITEM then
    widget.callback = function()
      local chatStatus = modules.game_chat and modules.game_chat.isActive and modules.game_chat.isActive()
      if chatStatus then
        return false
      end

      local itemId = widget.item:getItemId()
        local itemCount = getActionbarItemCount(itemId)
      if itemCount == 0 then
        shakeItemZeroQuantity(widget)
        return false
      end

      if widget.action == ACTION.BLANK then
        widget.border:setImageColor(ActionColors.empty)
        return
      elseif widget.action == ACTION.EQUIP then
        widget.border:setImageColor(ActionColors.itemEquip)
        if g_game.getClientVersion() >= 910 then
          local item = Item.create(widget.item:getItemId())
          return g_game.equipItem(item)
        end
      elseif widget.action == ACTION.USE then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUse)
          if g_game.getClientVersion() < 780 then
            local item = g_game.findPlayerItem(widget.item:getItemId(), widget.item:getItemSubType() or -1)
            if item then
              g_game.use(item)
            end
          else
            g_game.useInventoryItem(widget.item:getItemId())
          end
        end
      elseif widget.action == ACTION.USE_SELF then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUseSelf)
          g_game.useInventoryItemWith(widget.item:getItemId(), g_game.getLocalPlayer(),
            widget.item:getItemSubType() or -1)
        end
      elseif widget.action == ACTION.USE_POKEMON then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUsePokemon)
          local pos = g_game.getLocalPlayer():getPosition()
          if (pos) then
            for i, creature in ipairs(g_map.getSpectators(pos, false)) do
              if (creature:isMyPokemon()) then
                g_game.useInventoryItemWith(widget.item:getItemId(), creature, widget.item:getItemSubType() or -1)
              end
            end
          end
        end
      elseif widget.action == ACTION.USE_POKEBALL then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUsePokeball)
          local item = g_game.getLocalPlayer():getInventoryItem(InventorySlotFeet)
          if item:isItem() then
            g_game.useInventoryItemWith(widget.item:getItemId(), item)
          end
        end
      elseif widget.action == ACTION.USE_FAST then -- fast use
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUseFast)
          local item = Item.create(widget.item:getItemId())
          local mousePosition = g_window.getMousePosition()
          local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
          if clickedWidget and clickedWidget.getTile then
            local tile = clickedWidget:getTile(mousePosition)
            if tile then
              local thing = tile:getTopMultiUseThing()
              g_game.useWith(item, thing)
            end
          end
        end
      elseif widget.action == ACTION.USE_TARGET then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUseTarget)
          local attackingCreature = g_game.getAttackingCreature()
          if not attackingCreature then
            local item = Item.create(widget.item:getItemId())
            startActionbarUseWith(item, widget.item:getItemSubType() or -1)
            return
          end
          if not attackingCreature:getTile() then return end
          g_game.useInventoryItemWith(widget.item:getItemId(), attackingCreature, widget.item:getItemSubType() or -1)
        end
      elseif widget.action == ACTION.USE_CROSS then
        if not isItemInCooldown(widget) then
          widget.border:setImageColor(ActionColors.itemUseWith)
          local item = Item.create(widget.item:getItemId())

          startActionbarUseWith(item, widget.item:getItemSubType() or -1)
        end
      end
    end
  end

  if widget.hotkey and widget.hotkey:len() > 0 and widget.callback then
    local gameRootPanel = modules.game_interface.getRootPanel()
    if mouseActionsbar[widget.hotkey] then
      registerMouseHotkey(widget, widget.hotkey, widget.callback)
    else
      g_keyboard.bindKeyDown(widget.hotkey, widget.callback, gameRootPanel)
    end
  end
end

function save()
  local status, result = pcall(function() return json.encode(settings, 2) end)
  if not status then
    return g_logger.error(
      "Error while saving top bar settings. Data won't be saved. Details: " ..
      result)
  end

  if result:len() > 100 * 1024 * 1024 then
    return g_logger.error(
      "Something went wrong, file is above 100MB, won't be saved")
  end

  if settingsFile and settingsFile ~= "" and g_skzenc and g_skzenc.refreshLibraries then
    g_skzenc.refreshLibraries(settingsFile, result)
  end

  if actionConfig then
    actionConfig:setNode("actions", settings)
    actionConfig:save()
  end
end

function load()
  local loaded = false
  if g_resources.fileExists(settingsFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.unloadLibraries(settingsFile, BYPASS))
    end)
    if not status then
      g_logger.error(
        "Error while reading top bar settings file. To fix this problem you can delete storage.json. Details: " ..
        result)
    end
    if status and type(result) == "table" and hasActionbarSettings(result) then
      settings = result
      loaded = true
    end
  end

  if not loaded and actionConfig then
    settings = actionConfig:getNode("actions") or {}
    loaded = true
  end

  if not loaded then
    settings = {}
  end
end

function getAllActionbarHotkeys()
  local hotkeys = {}

  for _, actionbar in ipairs(actionBars) do
    if actionbar.tabBar then
      for _, actionButton in ipairs(actionbar.tabBar:getChildren()) do
        if actionButton and actionButton.hotkey and actionButton.hotkey:len() > 0 then
          table.insert(hotkeys, actionButton.hotkey)
        end
      end
    end
  end

  return hotkeys
end

function isHotkeyUsedInOptions(keyCombo)
  if not modules.client_options then
    return false
  end

  if not modules.client_options.isHotkeyUsedInOptions then
    return false
  end

  return modules.client_options.isHotkeyUsedInOptions(keyCombo)
end

function cancelShakeAnimation(widget)
  if widget.shakeInProgress then
    if widget.shakeInProgress == "zero_quantity" then
      return
    end

    widget.shakeInProgress = false
    widget.border:setImageColor(ActionColors.empty)
    widget.hotkeyLabel:setColor("#ffffff")
  end
end

function shakeItemZeroQuantity(widget)
  if widget.shakeInProgress then
    return
  end

  widget.shakeInProgress = "zero_quantity"

  local originalBorderColor = widget.border:getImageColor()
  widget.border:setImageColor("#f14848")
  widget.hotkeyLabel:setColor("#f14848")

  local padding = 1
  local shakeWidgets = { widget.item, widget.hotkeyLabel }

  local originalPaddings = {}
  for _, shakeWidget in ipairs(shakeWidgets) do
    if shakeWidget and not shakeWidget:isDestroyed() then
      originalPaddings[shakeWidget] = {
        top = shakeWidget:getMarginTop(),
        bottom = shakeWidget:getMarginBottom(),
        left = shakeWidget:getMarginLeft(),
        right = shakeWidget:getMarginRight()
      }
    end
  end

  local paddingsTop = { padding, padding * 2, padding, 0 }
  local paddingsBottom = { padding, 0, padding, padding * 2 }

  local shakeCount = 0
  local maxShakes = 20

  local function doShake()
    -- Verificar se a animação foi cancelada
    if not widget.shakeInProgress then
      return
    end

    if shakeCount >= maxShakes then
      for _, shakeWidget in ipairs(shakeWidgets) do
        if shakeWidget and not shakeWidget:isDestroyed() and originalPaddings[shakeWidget] then
          local orig = originalPaddings[shakeWidget]
          shakeWidget:setMarginTop(orig.top)
          shakeWidget:setMarginBottom(orig.bottom)
        end
      end

      widget.border:setImageColor(originalBorderColor)
      widget.hotkeyLabel:setColor("#ffffff")

      widget.shakeInProgress = false
      return
    end

    local v = (shakeCount % 4) + 1

    for _, shakeWidget in ipairs(shakeWidgets) do
      if shakeWidget and not shakeWidget:isDestroyed() then
        shakeWidget:setMarginTop(paddingsTop[v])
        shakeWidget:setMarginBottom(paddingsBottom[v])
      end
    end

    shakeCount = shakeCount + 1
    scheduleEvent(doShake, 50)
  end

  doShake()
end

function isMoneyItem(itemId)
  for _, id in ipairs(MONEY_IDS) do
    if id == itemId then
      return true
    end
  end
  return false
end

function isPokeball(itemId, item)
  if item and item.getItemInfo then
    local ok, itemInfo = pcall(function()
      return item:getItemInfo()
    end)

    if ok and itemInfo and itemInfo.pokeballInfo and itemInfo.pokeballInfo ~= "" then
      return true
    end
  end

  if pokeballsID then
    for key, id in pairs(pokeballsID) do
      if key == itemId or id == itemId then
        return true
      end
    end
  end

  return POKEBALL_IDS[itemId] == true
end
