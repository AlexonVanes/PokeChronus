HealthCircleInfo = nil
healthCircleFront = nil
pokeCircleFront = nil
extraPokeCircleFront = nil
invulnerablePokeCircleFront = nil
healthCircle = nil
pokeCircle = nil
pokeManaCircleFront = nil
pokeManaCircle = nil

local widgetSecondEvents = {}
local widgetSecondState = {}

local function setWidgetPercent(widget, percent, width, height)
  if not widget then
    return
  end

  percent = math.max(0, math.min(100, percent))

  local y = math.floor(height * (1 - (percent / 100)))
  local rect = {
    x = 0,
    y = y,
    width = width,
    height = height - y + 1
  }

  widget:setImageClip(rect)
  widget:setImageRect(rect)
end

local function getLiveWidgetPercent(widget)
  local state = widgetSecondState[widget]
  if not state then
    return 0
  end

  local elapsed = g_clock.millis() - state.startTime
  local progress = math.min(1, elapsed / state.duration)
  local percent = state.startPercent * (1 - progress)

  return math.max(0, percent)
end

local function getRemainingSeconds(widget)
  local state = widgetSecondState[widget]
  if not state then
    return 0
  end

  local elapsed = g_clock.millis() - state.startTime
  local remaining = math.max(0, state.duration - elapsed)
  return remaining / 800 -- 800 pra dar mais chance de subir
end

local function stopWidgetSeconds(widget)
  if not widget then
    return
  end

  if widgetSecondEvents[widget] then
    removeEvent(widgetSecondEvents[widget])
    widgetSecondEvents[widget] = nil
  end

  widgetSecondState[widget] = nil
  widget:setVisible(false)
  setWidgetPercent(widget, 0, 90, 208)
end

function setWidgetHealthSeconds(widget, seconds)
  if not widget or seconds <= 0 then
    if widget then
      stopWidgetSeconds(widget)
    end
    return
  end

  local width = 90
  local height = 208
  local now = g_clock.millis()
  local duration = seconds * 700

  local currentPercent = getLiveWidgetPercent(widget)
  local remainingSeconds = getRemainingSeconds(widget)

  local startPercent = currentPercent

  -- se não havia barra ativa, começa cheia
  if startPercent <= 0 then
    startPercent = 100
  end

  -- se o novo valor for maior que o restante atual, reseta para 100%
  if seconds > remainingSeconds or remainingSeconds < 1 then -- +1 qualquer coisa  // (seconds-1)
    startPercent = 100
  end

  if widgetSecondEvents[widget] then
    removeEvent(widgetSecondEvents[widget])
    widgetSecondEvents[widget] = nil
  end

  widgetSecondState[widget] = {
    startTime = now,
    duration = duration,
    startPercent = startPercent,
    currentPercent = startPercent
  }

  widget:setVisible(true)
  setWidgetPercent(widget, startPercent, width, height)

  local function updateBar()
    if not widget or not widgetSecondState[widget] then
      return
    end

    local state = widgetSecondState[widget]
    local elapsed = g_clock.millis() - state.startTime
    local progress = math.min(1, elapsed / state.duration)

    local percent = state.startPercent * (1 - progress)
    state.currentPercent = percent

    setWidgetPercent(widget, percent, width, height)

    if progress >= 1 or percent <= 0 then
      widgetSecondEvents[widget] = nil
      widgetSecondState[widget] = nil
      widget:setVisible(false)
      setWidgetPercent(widget, 0, width, height)
      return
    end

    widgetSecondEvents[widget] = scheduleEvent(updateBar, 50)
  end

  widgetSecondEvents[widget] = scheduleEvent(updateBar, 50)
end

function init()
  print('[PKMD HealthInfo Test] init')
  HealthCircleInfo = g_ui.loadUI('healthinfo', modules.game_interface.getMapPanel())
  if HealthCircleInfo then
    healthCircleFront = HealthCircleInfo:getChildById('healthCircleFront')
    pokeCircleFront = HealthCircleInfo:getChildById('pokeCircleFront')
    healthCircle = HealthCircleInfo:getChildById('healthCircle')
    pokeCircle = HealthCircleInfo:getChildById('pokeCircle')

    pokeManaCircleFront = HealthCircleInfo:getChildById('pokeManaCircleFront')
    pokeManaCircle = HealthCircleInfo:getChildById('pokeManaCircle')

    extraPokeCircleFront = HealthCircleInfo:getChildById('extraPokeCircleFront')
    invulnerablePokeCircleFront = HealthCircleInfo:getChildById('invulnerablePokeCircleFront')

    HealthCircleInfo:hide()

    -- connect(LocalPlayer, { onHealthChange = onHealthChangeCircle})
    
    if g_game.isOnline() then
      local localPlayer = g_game.getLocalPlayer()
      onHealthChangeCircle(localPlayer, localPlayer:getHealth(), localPlayer:getMaxHealth())
    end
    if g_game.isOnline() then
      local localPlayer = g_game.getLocalPlayer()
      onPokemonManaChange(localPlayer)
    end

    if g_app.isMobile() then
      HealthCircleInfo:hide()
    end
  end
  return true
end

function terminate()
  -- disconnect(LocalPlayer, { onHealthChange = onHealthChangeCircle})
  HealthCircleInfo:destroy()
  HealthCircleInfo = nil
end

function onHealthChangeCircle(localPlayer, health, maxHealth)
  if health > maxHealth then
    maxHealth = health
  end
  local healthPercent = math.floor(g_game.getLocalPlayer():getHealthPercent())
  local Yhppc = math.floor(208 * (1 - (healthPercent / 100)))
  local rect = { x = 0, y = Yhppc, width = 90, height = 208 - Yhppc + 1 }
  healthCircleFront:setImageClip(rect)
  healthCircleFront:setImageRect(rect)

  if healthPercent > 92 then
    healthCircleFront:setImageColor("#00BC00FF")
  elseif healthPercent > 60 then
    healthCircleFront:setImageColor("#50A150FF")
  elseif healthPercent > 30 then
    healthCircleFront:setImageColor("#A1A100FF")
  elseif healthPercent > 8 then
    healthCircleFront:setImageColor("#BF0A0AFF")
  elseif healthPercent > 3 then
    healthCircleFront:setImageColor("#910F0FFF")
  else
    healthCircleFront:setImageColor("#850C0CFF")
  end
end

function onPokemonManaChange(player)
  local percent = (player:getMana() / player:getMaxMana()) * 100
  local Ymppc = math.floor(162 * (1 - (percent / 100)))
  local rect = { x = 0, y = Ymppc, width = 72, height = 162 - Ymppc + 1 }
  local manaWidget = pokeManaCircleFront
  manaWidget:setImageClip(rect)
  manaWidget:setImageRect(rect)
end

InvUnt = 0
function onPokemonHealthChange(percent, ivulnerability, substitute, invisible, invulnerableUntil)
  local Ymppc = math.floor(208 * (1 - (percent / 100)))
  local rect = { x = 0, y = Ymppc, width = 90, height = 208 - Ymppc + 1 }
  local healthWidget = pokeCircleFront
  local healthColor = invisible and '#8636ff' or '#ff0d5d'

  if substitute then
   extraPokeCircleFront:setVisible(true)
   healthWidget = extraPokeCircleFront
  else
   extraPokeCircleFront:setVisible(false)
  end

  invulnerablePokeCircleFront:show()

  if ivulnerability and ivulnerability > 0 then
    if invulnerableUntil ~= InvUnt then
      InvUnt = invulnerableUntil
      setWidgetHealthSeconds(invulnerablePokeCircleFront, ivulnerability)
    end
  else
    stopWidgetSeconds(invulnerablePokeCircleFront)
  end

  healthWidget:setImageClip(rect)
  healthWidget:setImageRect(rect)
  pokeCircleFront:setImageColor(healthColor)
end
