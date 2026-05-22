MainWindow = nil
checkWindow = nil
wheelButton = nil
ActualPage = 1
SecondsDelayToPage = os.time()

local Opcode = 177
local loaded = false
local rolling = false
local currentRotation = 0
local rollEvent = nil
local soundEvent = nil

local function setRollButtonEnabled(enabled)
  if not MainWindow or not MainWindow.rollWheel then
    return
  end

  MainWindow.rollWheel:setPhantom(not enabled)
  MainWindow.rollWheel:setOpacity(enabled and 0.7 or 0.45)
end

local function easeOutCubic(progress)
  progress = math.max(0, math.min(1, progress))
  local inverse = 1 - progress
  return 1 - (inverse * inverse * inverse)
end

local function finishRoll()
  rolling = false
  rollEvent = nil
  soundEvent = nil

  if not MainWindow then
    return
  end

  g_game.getProtocolGame():sendExtendedOpcode(Opcode, json.encode({protocol = "finishwheel"}))
  MainWindow.effect:setVisible(true)
  scheduleEvent(function()
    if MainWindow and MainWindow.effect then
      MainWindow.effect:setVisible(false)
    end
  end, 350)

  setRollButtonEnabled(true)
end

local function stopWheelSound()
  if soundEvent then
    removeEvent(soundEvent)
    soundEvent = nil
  end
end

local function playWheelTick()
  if not g_sounds then
    return
  end

  pcall(function()
    g_sounds.play('/sounds/wheel_tick.wav')
  end)

  pcall(function()
    local channel = g_sounds.getChannel(SoundChannels.Effect)
    pcall(function() channel:setEnabled(true) end)
    pcall(function() channel:setGain(0.75) end)
    channel:enqueue('/sounds/wheel_tick.wav', 0)
  end)
end

local function startWheelSound(duration)
  stopWheelSound()

  if not g_sounds then
    return
  end

  local startedAt = g_clock.millis()
  local function playTick()
    if not rolling then
      soundEvent = nil
      return
    end

    playWheelTick()

    local progress = math.max(0, math.min(1, (g_clock.millis() - startedAt) / duration))
    local delay = 95 + math.floor(progress * 155)
    soundEvent = scheduleEvent(playTick, delay)
  end

  playTick()
end

local function animateWheel(targetRotation, duration)
  local startRotation = currentRotation
  local startedAt = g_clock.millis()

  local function frame()
    if not MainWindow or not MainWindow.wheelSource then
      rolling = false
      rollEvent = nil
      return
    end

    local elapsed = g_clock.millis() - startedAt
    local progress = elapsed / duration
    local rotation = startRotation + ((targetRotation - startRotation) * easeOutCubic(progress))

    currentRotation = rotation
    MainWindow.wheelSource:setRotation(rotation)

    if progress < 1 then
      rollEvent = scheduleEvent(frame, 16)
      return
    end

    currentRotation = targetRotation % 360
    MainWindow.wheelSource:setRotation(currentRotation)
    finishRoll()
  end

  frame()
end

local function onGameStart()
  if not MainWindow then return end
  MainWindow:hide()
end

local function onGameEnd()
  if not MainWindow then return end
  if rollEvent then
    removeEvent(rollEvent)
    rollEvent = nil
  end
  stopWheelSound()
  rolling = false
  if checkWindow then
    checkWindow:destroy()
    checkWindow = nil
  end
  loaded = false
  MainWindow:hide()
end

local function connecting(gameEvent)
  -- TODO: Just connect when you will be using
  if gameEvent then
    connect(g_game, {
      onGameEnd = onGameEnd,
      onGameStart = onGameStart
    })
  end
  pcall(function() ProtocolGame.unregisterExtendedOpcode(Opcode) end)
  ProtocolGame.registerExtendedOpcode(Opcode, parseWheel)
  return true
end

local function disconnecting(gameEvent)
  -- TODO: Just disconnect when you will be using
  if gameEvent then
    disconnect(g_game, {
      onGameEnd = onGameEnd,
      onGameStart = onGameStart
    })
  end
  pcall(function() ProtocolGame.unregisterExtendedOpcode(Opcode) end)
  return true
end

function init()
  connecting(true)
  MainWindow = g_ui.loadUI("wheel", modules.game_interface.getRootPanel())
  MainWindow:hide()
  if not wheelButton then
    wheelButton = modules.client_topmenu.addLeftButton('openwheel', 'Wheel', '/images/TOPBUTTONS_REWORK/ICON_REWARD', toggle)
  end
  if g_game.isOnline() then onGameStart() end  
end

function terminate()
  disconnecting(true)
  if rollEvent then
    removeEvent(rollEvent)
    rollEvent = nil
  end
  stopWheelSound()
  if wheelButton then
    wheelButton:destroy()
    wheelButton = nil
  end
  if MainWindow then
    MainWindow:destroy()
  end
  MainWindow = nil
end

function show()
  MainWindow:show()
end

function hide()
  if rolling then
    return
  end

  MainWindow:hide()
  if checkWindow then
    checkWindow:destroy()
    checkWindow = nil
  end
end

function onPrevPage(self)
  if rolling then return true end
  if SecondsDelayToPage > os.time() then return true end
  ActualPage = ActualPage-1
  g_game.getProtocolGame():sendExtendedOpcode(Opcode, json.encode({protocol = "requestWheelPage", ty = 'prev', page = ActualPage}))
  return true
end
function onNextPage(self)
  if rolling then return true end
  if SecondsDelayToPage > os.time() then return true end
  ActualPage = ActualPage+1
  g_game.getProtocolGame():sendExtendedOpcode(Opcode, json.encode({protocol = "requestWheelPage", ty = 'next', page = ActualPage}))
  return true
end

function toggle()
  if rolling then
    return true
  end

  if MainWindow:isVisible() then
    MainWindow:hide()
    g_keyboard.unbindKeyDown('Escape', toggle)
  else
    if not loaded then
      g_keyboard.bindKeyDown('Escape', toggle)
      requestwheels()
    else
      MainWindow:show()
      g_keyboard.bindKeyDown('Escape', toggle)
    end
  end
end

function requestwheels()
  if not g_game.isOnline() then
    return true
  end

  g_game.getProtocolGame():sendExtendedOpcode(Opcode, json.encode({protocol = "requestOpen"}))
  return true
end

BlinkinWidget = false
function blinkWidget(widget, color, first)
  if not first and not widget:isVisible() then 
    BlinkinWidget = false
    return true 
  end
  if color == 'red' then
    color = "white"
  else
    color = 'red'
  end
  widget:setImageColor(color)
  scheduleEvent(function() blinkWidget(widget, color) end, 500)
end

function parseWheel(protocol, opcode, buffer)
  local decoded = json.decode(buffer)
  if type(decoded) ~= 'table' then
    return true
  end

  local receive = decoded[1] or decoded
  if not receive then
    return true
  end

  MainWindow.effect:setVisible(false)

  if receive.protocol == "openwheel" then
    loaded = true

    if receive.category then
       ActualPage = receive.category
    end

    if MainWindow.pageWheel then
      MainWindow.pageWheel:setText('')
      MainWindow.pageWheel:setVisible(false)
    end

    MainWindow.wheelCost:setText('')
    if receive.cost and receive.cost > 1 then
      if MainWindow.wheelCost then
        MainWindow.wheelCost:setText("Cost "..receive.cost.."x!")
      end
    end

    MainWindow.wheelSource:setPhantom(false)
    currentRotation = 0
    MainWindow.wheelSource:setRotation(currentRotation)
    setRollButtonEnabled(true)

    if not BlinkinWidget then
        blinkWidget(MainWindow.buyTickets, 'white', true)
    end


    for i, p in ipairs(MainWindow.wheelSource:getChildren()) do
      p:setPhantom(false)
    end

    for i, p in ipairs(receive.items) do
      local widget = MainWindow.wheelSource:getChildren()[i]
      if p.rare then
        widget:setIcon('images/bright')
        widget:setIconSize('55 55')
      else
        widget:setIcon('')
      end
      if p.itemid then
        widget:setItemId(p.itemid)
        widget:setItemCount(p.count)
        widget:setTooltip(""..p.name.."\n"..p.desc.."")
        if p.name == 'EV Token' then
          widget:setIcon('/modules/game_bestiary/images/pointsprey')
          widget:setIconOffset('55 -20')
          widget:setTooltip(""..p.name.." or Prey Card\n"..p.desc.."")
        else
          widget:setIcon('')
        end
      end
      if p.poke then
        widget:setItemId(0)
        widget:setImageSource('images/'..p.poke..'')
        widget:setTooltip(""..p.name.."\n"..p.desc.."")   
        widget:setSize('55 55')
      else
        widget:setImageSource('')
        widget:setSize('42 42')
      end
    end

    MainWindow.wheelInfo:setColoredText({"VOCE POSSUI","white"," "..receive.tickets.." TICKET'S","yellow"})
    g_effects.fadeIn(MainWindow, 900)
    MainWindow:show()
    return true
  end

  if receive.protocol == "rollwheel" then
      SecondsDelayToPage = os.time()+10
      rolling = true
      MainWindow.wheelSource:setPhantom(true)
      doRollWheel(receive.roll, receive.faster)
      MainWindow.wheelInfo:setColoredText({"VOCE POSSUI","white"," "..receive.tickets.." TICKET'S","yellow"})
      setRollButtonEnabled(false)
  end

  if receive.protocol == "message" then
    if receive.text then
      displayInfoBox("Wheel", receive.text)
    end
  end

  return true
end


local isFirstRotation = true

function doRollWheel(toSlot, faster)
  if rollEvent then
    removeEvent(rollEvent)
    rollEvent = nil
  end

  local RollPotency = 1.0
  if faster then
     RollPotency = faster
  end
  local anglePerSlot = 360 / 8
  local fullRotation = 360
  local slotDifference = toSlot - 1
  if slotDifference < 0 then
    slotDifference = 8 + slotDifference
  end

  local randomRotations = math.random(2,8)
  local rotationAngle = (randomRotations * fullRotation) + (slotDifference * anglePerSlot)
  rotationAngle = rotationAngle - 25

  -- 🔹 Multiplicamos a duração pela RollPotency
  local duration = (500 * (randomRotations + 1)) * RollPotency

  for i, p in ipairs(MainWindow.wheelSource:getChildren()) do
    p:setPhantom(true)
  end

  startWheelSound(duration)
  animateWheel(currentRotation - rotationAngle, duration)

  return true
end



BuyTicketValue = 1



function buyTickets()
  if checkWindow then checkWindow:destroy() checkWindow = nil end
  BuyTicketValue = 1
  local noCallback = function()
    checkWindow:destroy()
    checkWindow = nil
  end
  yesCallback = function()
    noCallback()
    g_game.getProtocolGame():sendExtendedOpcode(Opcode, json.encode({protocol = "buyTickets", quanty = BuyTicketValue}))
  end
  checkWindow = displayGeneralBox("Confirme", "Gostaria de comprar 1x Ticket Wheel por 10KK ?", {
    {text = "Sim", callback = yesCallback},
    {text = "Nao", callback = noCallback},
    anchor = AnchorHorizontalCenter
  }, yesCallback, noCallback)
  local height = checkWindow:getHeight()
  checkWindow:setHeight(height+20)
  scrollBar = g_ui.createWidget('HorizontalScrollBar', checkWindow)
  scrollBar:addAnchor(AnchorLeft, 'parent', AnchorLeft)
  scrollBar:addAnchor(AnchorRight, 'parent', AnchorRight)
  scrollBar:addAnchor(AnchorTop, 'parent', AnchorTop)
  scrollBar:setHeight(10)
  scrollBar:setMarginLeft(20)
  scrollBar:setMarginRight(20)
  scrollBar:setMarginTop(22)
  scrollBar.minimum = 1
  scrollBar.maximum = 100
  scrollBar.value = 1
  scrollBar.onValueChange = function(self, value)
    checkWindow:getChildById('messageBoxLabel'):setText("Comprar "..(1*value).."x Ticket Wheel por "..(10*value).."KK ?")
    BuyTicketValue = value
  end
  return true
end

function gMW()
  return MainWindow
end
