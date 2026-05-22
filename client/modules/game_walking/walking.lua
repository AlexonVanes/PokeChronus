smartWalkDirs = {}
smartWalkDir = nil
wsadWalking = false
nextWalkDir = nil
lastWalkDir = nil
lastFinishedStep = 0
autoWalkEvent = nil
firstStep = true
walkLock = 0
walkEvent = nil
walkPollEvent = nil
pollWalkDir = nil
lastPollWalk = 0
lastWalk = 0
lastTurn = 0
lastTurnDirection = 0
lastStop = 0
lastManualWalk = 0
autoFinishNextServerWalk = 0
turnKeys = {}
walkKeyCallbacks = {}
turnKeyCallbacks = {}

function init()
  connect(g_game, { onTeleport = onTeleport })
  
  connect(LocalPlayer, {
    onPositionChange = onPositionChange,
    onWalk = onWalk,
    onWalkFinish = onWalkFinish,
    onCancelWalk = onCancelWalk
  })

  modules.game_interface.getRootPanel().onFocusChange = stopSmartWalk
  bindKeys()
  startWalkPolling()
end

function terminate()
  disconnect(g_game, { onTeleport = onTeleport })
  
  disconnect(LocalPlayer, {
    onPositionChange = onPositionChange,
    onWalk = onWalk,
    onWalkFinish = onWalkFinish
  })
  removeEvent(autoWalkEvent)
  removeEvent(walkPollEvent)
  walkPollEvent = nil
  pollWalkDir = nil
  stopSmartWalk()
  unbindKeys()
  disableWSAD()
end

function bindKeys()
  bindWalkKey('Up', North)
  bindWalkKey('Right', East)
  bindWalkKey('Down', South)
  bindWalkKey('Left', West)
  bindWalkKey('Numpad8', North)
  bindWalkKey('Numpad9', NorthEast)
  bindWalkKey('Numpad6', East)
  bindWalkKey('Numpad3', SouthEast)
  bindWalkKey('Numpad2', South)
  bindWalkKey('Numpad1', SouthWest)
  bindWalkKey('Numpad4', West)
  bindWalkKey('Numpad7', NorthWest)

  bindTurnKey('Ctrl+Up', North)
  bindTurnKey('Ctrl+Right', East)
  bindTurnKey('Ctrl+Down', South)
  bindTurnKey('Ctrl+Left', West)
  bindTurnKey('Ctrl+Numpad8', North)
  bindTurnKey('Ctrl+Numpad6', East)
  bindTurnKey('Ctrl+Numpad2', South)
  bindTurnKey('Ctrl+Numpad4', West)
end

function unbindKeys()
  unbindWalkKey('Up', North)
  unbindWalkKey('Right', East)
  unbindWalkKey('Down', South)
  unbindWalkKey('Left', West)
  unbindWalkKey('Numpad8', North)
  unbindWalkKey('Numpad9', NorthEast)
  unbindWalkKey('Numpad6', East)
  unbindWalkKey('Numpad3', SouthEast)
  unbindWalkKey('Numpad2', South)
  unbindWalkKey('Numpad1', SouthWest)
  unbindWalkKey('Numpad4', West)
  unbindWalkKey('Numpad7', NorthWest)

  unbindTurnKey('Ctrl+Up', North)
  unbindTurnKey('Ctrl+Right', East)
  unbindTurnKey('Ctrl+Down', South)
  unbindTurnKey('Ctrl+Left', West)
  unbindTurnKey('Ctrl+Numpad8', North)
  unbindTurnKey('Ctrl+Numpad6', East)
  unbindTurnKey('Ctrl+Numpad2', South)
  unbindTurnKey('Ctrl+Numpad4', West)
end

local function isTyping()
  if g_keyboard.isTextInputFocused and g_keyboard.isTextInputFocused() then
    return true
  end

  return false
end

local function blockWalkingWhileTyping()
  if not isTyping() then
    return false
  end

  nextWalkDir = nil
  removeEvent(walkEvent)
  walkEvent = nil
  stopSmartWalk()
  return true
end

function enableWSAD()
  if wsadWalking then
    return
  end
  wsadWalking = true  
  local player = g_game.getLocalPlayer()
  if player then
    player:lockWalk(100) -- 100 ms walk lock for all directions    
  end

  bindWalkKey("W", North)
  bindWalkKey("D", East)
  bindWalkKey("S", South)
  bindWalkKey("A", West)

  bindTurnKey("Ctrl+W", North)
  bindTurnKey("Ctrl+D", East)
  bindTurnKey("Ctrl+S", South)
  bindTurnKey("Ctrl+A", West)

  bindWalkKey("E", NorthEast)
  bindWalkKey("Q", NorthWest)
  bindWalkKey("C", SouthEast)
  bindWalkKey("Z", SouthWest)
end

function disableWSAD()
  if not wsadWalking then
    return
  end
  wsadWalking = false

  unbindWalkKey("W")
  unbindWalkKey("D")
  unbindWalkKey("S")
  unbindWalkKey("A")

  unbindTurnKey("Ctrl+W")
  unbindTurnKey("Ctrl+D")
  unbindTurnKey("Ctrl+S")
  unbindTurnKey("Ctrl+A")

  unbindWalkKey("E")
  unbindWalkKey("Q")
  unbindWalkKey("C")
  unbindWalkKey("Z")
end

function bindWalkKey(key, dir)
  if walkKeyCallbacks[key] then
    unbindWalkKey(key)
  end

  local callbacks = {}
  callbacks.down = function()
    if blockWalkingWhileTyping() then return true end
    changeWalkDir(dir)
    return walk(smartWalkDir or dir, 0)
  end
  callbacks.up = function()
    if blockWalkingWhileTyping() then return true end
    return changeWalkDir(dir, true)
  end
  callbacks.press = function(c, k, ticks)
    if blockWalkingWhileTyping() then return true end
    return smartWalk(dir, ticks)
  end

  walkKeyCallbacks[key] = callbacks
  g_keyboard.bindKeyDown(key, callbacks.down, nil, true)
  g_keyboard.bindKeyUp(key, callbacks.up, nil, true)
  g_keyboard.bindKeyPress(key, callbacks.press)
end

function unbindWalkKey(key)
  local callbacks = walkKeyCallbacks[key]
  if not callbacks then
    return
  end

  g_keyboard.unbindKeyDown(key, callbacks.down)
  g_keyboard.unbindKeyUp(key, callbacks.up)
  g_keyboard.unbindKeyPress(key, callbacks.press)
  walkKeyCallbacks[key] = nil
end

function bindTurnKey(key, dir)
  if turnKeyCallbacks[key] then
    unbindTurnKey(key)
  end

  turnKeys[key] = dir
  local callbacks = {}
  callbacks.down = function()
    if blockWalkingWhileTyping() then return true end
    return turn(dir, false)
  end
  callbacks.press = function()
    if blockWalkingWhileTyping() then return true end
    return turn(dir, true)
  end
  callbacks.up = function()
    if blockWalkingWhileTyping() then return true end
    local player = g_game.getLocalPlayer()
    if player then player:lockWalk(200) end
  end

  turnKeyCallbacks[key] = callbacks
  g_keyboard.bindKeyDown(key, callbacks.down)
  g_keyboard.bindKeyPress(key, callbacks.press)
  g_keyboard.bindKeyUp(key, callbacks.up)
end

function unbindTurnKey(key)
  turnKeys[key] = nil
  local callbacks = turnKeyCallbacks[key]
  if not callbacks then
    return
  end

  g_keyboard.unbindKeyDown(key, callbacks.down)
  g_keyboard.unbindKeyPress(key, callbacks.press)
  g_keyboard.unbindKeyUp(key, callbacks.up)
  turnKeyCallbacks[key] = nil
end

function handleWindowKeyDown(keyCode, keyboardModifiers)
  local keyComboDesc = determineKeyComboDesc(keyCode, keyboardModifiers)
  local callbacks = walkKeyCallbacks[keyComboDesc] or turnKeyCallbacks[keyComboDesc]
  if callbacks and callbacks.down then
    callbacks.down()
    return true
  end
  return false
end

function handleWindowKeyPress(keyCode, keyboardModifiers, autoRepeatTicks)
  local keyComboDesc = determineKeyComboDesc(keyCode, keyboardModifiers)
  local callbacks = walkKeyCallbacks[keyComboDesc] or turnKeyCallbacks[keyComboDesc]
  if callbacks and callbacks.press then
    callbacks.press(nil, nil, autoRepeatTicks or 0)
    return true
  end
  return false
end

function handleWindowKeyUp(keyCode, keyboardModifiers)
  local keyComboDesc = determineKeyComboDesc(keyCode, keyboardModifiers)
  local callbacks = walkKeyCallbacks[keyComboDesc] or turnKeyCallbacks[keyComboDesc]
  if callbacks and callbacks.up then
    callbacks.up()
    return true
  end
  return false
end

function stopSmartWalk()
  smartWalkDirs = {}
  smartWalkDir = nil
end

local function isWalkKeyPressed(key)
  local ok, pressed = pcall(function() return g_keyboard.isKeyPressed(key) end)
  return ok and pressed
end

local function getPolledWalkDir()
  if blockWalkingWhileTyping() then
    return nil
  end

  if g_keyboard.getModifiers() ~= KeyboardNoModifier then
    return nil
  end

  local north = isWalkKeyPressed('Up') or isWalkKeyPressed('Numpad8')
  local east = isWalkKeyPressed('Right') or isWalkKeyPressed('Numpad6')
  local south = isWalkKeyPressed('Down') or isWalkKeyPressed('Numpad2')
  local west = isWalkKeyPressed('Left') or isWalkKeyPressed('Numpad4')

  if wsadWalking then
    north = north or isWalkKeyPressed('W')
    east = east or isWalkKeyPressed('D')
    south = south or isWalkKeyPressed('S')
    west = west or isWalkKeyPressed('A')
  end

  if isWalkKeyPressed('Numpad9') or (wsadWalking and isWalkKeyPressed('E')) then
    return NorthEast
  elseif isWalkKeyPressed('Numpad3') or (wsadWalking and isWalkKeyPressed('C')) then
    return SouthEast
  elseif isWalkKeyPressed('Numpad1') or (wsadWalking and isWalkKeyPressed('Z')) then
    return SouthWest
  elseif isWalkKeyPressed('Numpad7') or (wsadWalking and isWalkKeyPressed('Q')) then
    return NorthWest
  elseif north and east then
    return NorthEast
  elseif south and east then
    return SouthEast
  elseif south and west then
    return SouthWest
  elseif north and west then
    return NorthWest
  elseif north then
    return North
  elseif east then
    return East
  elseif south then
    return South
  elseif west then
    return West
  end

  return nil
end

function pollWalkKeys()
  walkPollEvent = nil

  if g_game.isOnline and g_game.isOnline() and not g_game.isDead() then
    local dir = getPolledWalkDir()
    if dir then
      if pollWalkDir ~= dir then
        changeWalkDir(dir)
        pollWalkDir = dir
      end

      if lastPollWalk + 35 < g_clock.millis() then
        walk(smartWalkDir or dir, 0)
        lastPollWalk = g_clock.millis()
      end
    elseif pollWalkDir then
      changeWalkDir(pollWalkDir, true)
      pollWalkDir = nil
    end
  elseif pollWalkDir then
    stopSmartWalk()
    pollWalkDir = nil
  end

  walkPollEvent = scheduleEvent(pollWalkKeys, 25)
end

function startWalkPolling()
  if walkPollEvent then
    return
  end

  walkPollEvent = scheduleEvent(pollWalkKeys, 25)
end

function changeWalkDir(dir, pop)
  while table.removevalue(smartWalkDirs, dir) do end
  if pop then
    if #smartWalkDirs == 0 then
      stopSmartWalk()
      return
    end
  else
    table.insert(smartWalkDirs, 1, dir)
  end

  smartWalkDir = smartWalkDirs[1]
  if modules.client_options.getOption('smartWalk') and #smartWalkDirs > 1 then
    for _,d in pairs(smartWalkDirs) do
      if (smartWalkDir == North and d == West) or (smartWalkDir == West and d == North) then
        smartWalkDir = NorthWest
        break
      elseif (smartWalkDir == North and d == East) or (smartWalkDir == East and d == North) then
        smartWalkDir = NorthEast
        break
      elseif (smartWalkDir == South and d == West) or (smartWalkDir == West and d == South) then
        smartWalkDir = SouthWest
        break
      elseif (smartWalkDir == South and d == East) or (smartWalkDir == East and d == South) then
        smartWalkDir = SouthEast
        break
      end
    end
  end
end

function smartWalk(dir, ticks)
  if blockWalkingWhileTyping() then
    return false
  end

  walkEvent = scheduleEvent(function() 
    if not blockWalkingWhileTyping() and g_keyboard.getModifiers() == KeyboardNoModifier then
      local direction = smartWalkDir or dir
      walk(direction, ticks)
      return true
    end
    return false
  end, 20)
end

function canChangeFloorDown(pos)
  pos.z = pos.z + 1
  toTile = g_map.getTile(pos)
  return toTile and toTile:hasElevation(3)
end

function canChangeFloorUp(pos)
  pos.z = pos.z - 1
  toTile = g_map.getTile(pos)
  return toTile and toTile:isWalkable()
end

function onPositionChange(player, newPos, oldPos)
end

function onWalk(player, newPos, oldPos)
  if autoFinishNextServerWalk + 200 > g_clock.millis() then
    player:finishServerWalking()
  end
end

function onTeleport(player, newPos, oldPos)
  if not newPos or not oldPos then
    return
  end
  -- floor change is also teleport
  if math.abs(newPos.x - oldPos.x) >= 3 or math.abs(newPos.y - oldPos.y) >= 3 or math.abs(newPos.z - oldPos.z) >= 2 then  
    -- far teleport, lock walk for 100ms
    walkLock = g_clock.millis() + g_settings.getNumber('walkTeleportDelay')
  else
    walkLock = g_clock.millis() + g_settings.getNumber('walkStairsDelay')
  end
  nextWalkDir = nil -- cancel autowalk
end

function onWalkFinish(player)
  lastFinishedStep = g_clock.millis()
  if nextWalkDir ~= nil then
    removeEvent(autoWalkEvent)
    autoWalkEvent = addEvent(function() if nextWalkDir ~= nil then walk(nextWalkDir, 0) end end, false)
  end
end

function onCancelWalk(player)
  player:lockWalk(50)
end

function walk(dir, ticks) 
  if blockWalkingWhileTyping() then
    return false
  end

  lastManualWalk = g_clock.millis()
  local player = g_game.getLocalPlayer()
  if not player or g_game.isDead() or player:isDead() then
    return
  end

  if player:isWalkLocked() then
    nextWalkDir = nil
    return
  end

  if g_game.isFollowing() then
    g_game.cancelFollow()
  end

  if player:isAutoWalking() then
    if lastStop + 100 < g_clock.millis() then
      lastStop = g_clock.millis()
      player:stopAutoWalk()
      g_game.stop()
    end
  end
     
  local dash = false
  local ignoredCanWalk = false
  if not g_game.getFeature(GameNewWalking) then
    dash = g_settings.getBoolean("dash", false)
  end

  local ticksToNextWalk = player:getStepTicksLeft()
  if not player:canWalk(dir) then -- canWalk return false when previous walk is not finished or not confirmed by server
    if dash then 
      ignoredCanWalk = true
    else
      if ticksToNextWalk < 500 and (lastWalkDir ~= dir or ticks == 0) then
        nextWalkDir = dir
      end
      if ticksToNextWalk < 30 and lastFinishedStep + 400 > g_clock.millis() and nextWalkDir == nil then -- clicked walk 20 ms too early, try to execute again as soon possible to keep smooth walking
        nextWalkDir = dir
      end
      return
    end
  end
  
  --if nextWalkDir ~= nil and lastFinishedStep + 200 < g_clock.millis() then
  --  print("Cancel " .. nextWalkDir)
  --  nextWalkDir = nil
  --end
  if nextWalkDir ~= nil and nextWalkDir ~= lastWalkDir then 
    dir = nextWalkDir
  end

  local toPos = player:getPrewalkingPosition(true)
  if dir == North then
    toPos.y = toPos.y - 1
  elseif dir == East then
    toPos.x = toPos.x + 1
  elseif dir == South then
    toPos.y = toPos.y + 1
  elseif dir == West then
    toPos.x = toPos.x - 1
  elseif dir == NorthEast then
    toPos.x = toPos.x + 1
    toPos.y = toPos.y - 1
  elseif dir == SouthEast then
    toPos.x = toPos.x + 1
    toPos.y = toPos.y + 1
  elseif dir == SouthWest then
    toPos.x = toPos.x - 1
    toPos.y = toPos.y + 1
  elseif dir == NorthWest then
    toPos.x = toPos.x - 1
    toPos.y = toPos.y - 1
  end
  local toTile = g_map.getTile(toPos)

  if walkLock >= g_clock.millis() and lastWalkDir == dir then
    nextWalkDir = nil
    return
  end

  if firstStep and lastWalkDir == dir and lastWalk + g_settings.getNumber('walkFirstStepDelay') > g_clock.millis() then
    firstStep = false
    walkLock = lastWalk + g_settings.getNumber('walkFirstStepDelay')
    return
  end
  
  if dash and lastWalkDir == dir and lastWalk + 50 > g_clock.millis() then
    return
  end  
  
  firstStep = (not player:isWalking() and lastFinishedStep + 100 < g_clock.millis() and walkLock + 100 < g_clock.millis())
  if player:isServerWalking() and not dash then
    walkLock = walkLock + math.max(g_settings.getNumber('walkFirstStepDelay'), 100)
  end
  
  nextWalkDir = nil
  removeEvent(autoWalkEvent)
  autoWalkEvent = nil
  local preWalked = false
  if toTile and toTile:isWalkable() then
    if not player:isServerWalking() and not ignoredCanWalk then
      player:preWalk(dir)
      preWalked = true
    end
  else
    local playerTile = player:getTile()
    if (playerTile and playerTile:hasElevation(3) and canChangeFloorUp(toPos)) or canChangeFloorDown(toPos) or (toTile and toTile:isEmpty() and not toTile:isBlocking()) then
      player:lockWalk(100)
    elseif player:isServerWalking() then
      g_game.stop()
      return
    elseif not toTile then
      player:lockWalk(100) -- bug fix for missing stairs down on map
    else
      if g_app.isMobile() and dir <= Directions.West then 
        turn(dir, ticks > 0)
      end
      return -- not walkable tile
    end
  end

  if player:isServerWalking() and not dash then
    g_game.stop()
    player:finishServerWalking()
    autoFinishNextServerWalk = g_clock.millis() + 200
  end
  g_game.walk(dir, preWalked)  
  
  if not firstStep and lastWalkDir ~= dir then
    walkLock = g_clock.millis() + g_settings.getNumber('walkTurnDelay')    
  end
  
  lastWalkDir = dir
  lastWalk = g_clock.millis()
  return true
end

function turn(dir, repeated)
  if blockWalkingWhileTyping() then
    return false
  end

  local player = g_game.getLocalPlayer()
  if player:isWalking() and player:getWalkDirection() == dir and not player:isServerWalking() then
    return
  end
  
  removeEvent(walkEvent)
  
  if not repeated or (lastTurn + 100 < g_clock.millis()) then
    g_game.turn(dir)
    changeWalkDir(dir)
    lastTurn = g_clock.millis()
    if not repeated then
      lastTurn = g_clock.millis() + 50
    end
    lastTurnDirection = dir
    nextWalkDir = nil
    player:lockWalk(g_settings.getNumber('walkCtrlTurnDelay'))
  end
end

function checkTurn()
  for keys, direction in pairs(turnKeys) do
    if g_keyboard.areKeysPressed(keys) then
      turn(direction, false)
    end
  end
end
