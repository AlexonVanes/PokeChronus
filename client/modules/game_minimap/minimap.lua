minimapWidget = nil
minimapButton = nil
minimapWindow = nil
minimapOpen = true

otmm = true
preloaded = false
fullmapView = false

oldZoom = nil
oldPos = nil

fullmapCloseButton = nil

local function configureMinimapWidget()
  if not minimapWidget then
    return
  end

  minimapWidget.disableDrag = true
  if minimapWidget.setDraggable then
    minimapWidget:setDraggable(false)
  end
  if minimapWidget.setChangeCursorImage then
    minimapWidget:setChangeCursorImage(false)
  end
  if minimapWidget.setColor then
    pcall(function()
      minimapWidget:setColor('alpha')
    end)
  end

  local controls = minimapWidget:recursiveGetChildById('panelControls')
  if controls then
    if controls.setPhantom then
      controls:setPhantom(false)
    end
    controls:raise()
  end
end

function init()
  local function toggleMinimapButton()
    toggleMap()
  end

  minimapButton = modules.client_topmenu.addRightGameToggleButton(
    'minimapButton',
    tr('Minimap'),
    '/images/TOPBUTTONS_REWORK/ICON_MINIMAP',
    toggleMinimapButton
  )

  minimapButton:setOn(true)

  minimapWindow = g_ui.loadUI('minimap', modules.game_interface.getRightPanel())
  minimapWindow:setContentMinimumHeight(64)

  minimapWidget = minimapWindow:recursiveGetChildById('minimap')
  if not minimapWidget then
    print('[game_minimap] minimap widget nao encontrado.')
    return
  end
  configureMinimapWidget()

  minimapWindow:setup()

  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
  })

  connect(LocalPlayer, {
    onPositionChange = updateCameraPosition
  })

  if g_game.isOnline() then
    online()
  end

  scheduleEvent(function()
    showMap()
  end, 100)
end

function terminate()
  if g_game.isOnline() then
    saveMap()
  end

  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
  })

  disconnect(LocalPlayer, {
    onPositionChange = updateCameraPosition
  })

  if fullmapView then
    exitFullMap()
  end

  if fullmapCloseButton then
    fullmapCloseButton:destroy()
    fullmapCloseButton = nil
  end

  if minimapWindow then
    minimapWindow:destroy()
    minimapWindow = nil
  end

  if minimapButton then
    minimapButton:destroy()
    minimapButton = nil
  end
end

function showMap()
  if not minimapWindow then
    return
  end

  local rightPanel = modules.game_interface.getRightPanel()
  if rightPanel and minimapWindow:getParent() ~= rightPanel then
    minimapWindow:setParent(rightPanel)
  end

  if minimapWindow.open then
    minimapWindow:open()
  else
    minimapWindow:show()
  end
  minimapWindow:raise()
  minimapWindow:focus()
  minimapWindow:setVisible(true)
  minimapOpen = true

  if minimapButton then
    minimapButton:setOn(true)
  end
end

function hideMap()
  if not minimapWindow then
    return
  end

  if fullmapView then
    exitFullMap()
    return
  end

  if minimapWindow.close then
    minimapWindow:close()
  else
    minimapWindow:hide()
  end

  minimapOpen = false

  if minimapButton then
    minimapButton:setOn(false)
  end
end

function toggle()
  return toggleMap()
end

function onMiniWindowClose()
  minimapOpen = false
  if minimapButton then
    minimapButton:setOn(false)
  end
end

function toggleMap()
  if not minimapWindow then
    return
  end

  if fullmapView then
    exitFullMap()
    return
  end

  if minimapOpen and minimapWindow:isVisible() then
    hideMap()
  else
    showMap()
  end
end

function preload()
  loadMap(false)
  preloaded = true
end

function online()
  loadMap(not preloaded)
  updateCameraPosition()
  scheduleEvent(function()
    showMap()
  end, 100)
end

function offline()
  saveMap()
end

function loadMap(clean)
  if not minimapWidget then
    return
  end

  local protocolVersion = g_game.getProtocolVersion()

  if clean then
    g_minimap.clean()
  end

  if otmm then
    local minimapFile = '/minimap.otmm'

    if g_resources.fileExists(minimapFile) then
      g_minimap.loadOtmm(minimapFile)
    end
  else
    local minimapFile = '/minimap_' .. protocolVersion .. '.otcm'

    if g_resources.fileExists(minimapFile) then
      g_map.loadOtcm(minimapFile)
    end
  end

  minimapWidget:load()
  configureMinimapWidget()
end

function saveMap()
  if not minimapWidget then
    return
  end

  local protocolVersion = g_game.getProtocolVersion()

  if otmm then
    local minimapFile = '/minimap.otmm'
    g_minimap.saveOtmm(minimapFile)
  else
    local minimapFile = '/minimap_' .. protocolVersion .. '.otcm'
    g_map.saveOtcm(minimapFile)
  end

  minimapWidget:save()
end

function updateCameraPosition()
  if not minimapWidget then
    return
  end

  local player = g_game.getLocalPlayer()

  if not player then
    return
  end

  local pos = player:getPosition()

  if not pos then
    return
  end

  if not minimapWidget:isDragging() then
    if not fullmapView then
      minimapWidget:setCameraPosition(pos)
    end

    minimapWidget:setCrossPosition(pos)
  end
end

function toggleFullMap()
  if fullmapView then
    exitFullMap()
  else
    enterFullMap()
  end
end

function enterFullMap()
  if fullmapView then
    return
  end

  if not minimapWindow or not minimapWidget then
    return
  end

  local rootPanel = modules.game_interface.getRootPanel()

  oldZoom = minimapWidget:getZoom()
  oldPos = minimapWidget:getCameraPosition()

  fullmapView = true

  minimapWidget:setColor('#000000AA')

  minimapWindow:hide()

  minimapWidget:setParent(rootPanel)
  minimapWidget:fill('parent')
  minimapWidget:setAlternativeWidgetsVisible(true)

  if not fullmapCloseButton then
    fullmapCloseButton = g_ui.createWidget('Button', rootPanel)
    fullmapCloseButton:setId('fullmapCloseButton')
    fullmapCloseButton:setText('X')
    fullmapCloseButton:setWidth(32)
    fullmapCloseButton:setHeight(32)

    fullmapCloseButton:addAnchor(AnchorTop, 'parent', AnchorTop)
    fullmapCloseButton:addAnchor(AnchorRight, 'parent', AnchorRight)

    fullmapCloseButton:setMarginTop(10)
    fullmapCloseButton:setMarginRight(10)

    fullmapCloseButton.onClick = function()
      exitFullMap()
    end
  else
    fullmapCloseButton:setParent(rootPanel)
  end

  fullmapCloseButton:show()
  fullmapCloseButton:raise()
  fullmapCloseButton:focus()

  local zoom = oldZoom or 0
  local pos = oldPos or minimapWidget:getCameraPosition()

  minimapWidget:setZoom(zoom)
  minimapWidget:setCameraPosition(pos)
end

function exitFullMap()
  if not fullmapView then
    return
  end

  if not minimapWindow or not minimapWidget then
    return
  end

  fullmapView = false

  if fullmapCloseButton then
    fullmapCloseButton:hide()
  end

  minimapWidget:setColor('#1F007A')

  local contentsPanel = minimapWindow:getChildById('contentsPanel')

  if contentsPanel then
    minimapWidget:setParent(contentsPanel)
    minimapWidget:fill('parent')
  end

  minimapWidget:setAlternativeWidgetsVisible(false)

  minimapWindow:show()
  minimapWindow:raise()
  minimapWindow:focus()

  local zoom = oldZoom or 0
  local pos = oldPos or minimapWidget:getCameraPosition()

  oldZoom = minimapWidget:getZoom()
  oldPos = minimapWidget:getCameraPosition()

  minimapWidget:setZoom(zoom)
  minimapWidget:setCameraPosition(pos)

  if minimapButton then
    minimapButton:setOn(true)
  end
end
