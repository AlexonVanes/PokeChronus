-- @docclass
g_effects = {}

-- Fade In
function g_effects.fadeIn(widget, time, elapsed)
  if not elapsed then elapsed = 0 end
  time = time or 300
  widget:setOpacity(math.min(elapsed/time, 1))
  removeEvent(widget.fadeEvent)
  if elapsed < time then
    widget.fadeEvent = scheduleEvent(function()
      g_effects.fadeIn(widget, time, elapsed + 30)
    end, 30)
  else
    widget.fadeEvent = nil
  end
end

-- Fade Out
function g_effects.fadeOut(widget, time, elapsed)
  if not elapsed then elapsed = 0 end
  time = time or 300
  elapsed = math.max((1 - widget:getOpacity()) * time, elapsed)
  removeEvent(widget.fadeEvent)
  widget:setOpacity(math.max((time - elapsed)/time, 0))
  if elapsed < time then
    widget.fadeEvent = scheduleEvent(function()
      g_effects.fadeOut(widget, time, elapsed + 30)
    end, 30)
  else
    widget.fadeEvent = nil
  end
end

function g_effects.cancelFade(widget)
  removeEvent(widget.fadeEvent)
  widget.fadeEvent = nil
end

-- Blink
function g_effects.startBlink(widget, duration, interval, clickCancel)
  duration = duration or 0
  interval = interval or 500
  clickCancel = clickCancel ~= false -- default true

  removeEvent(widget.blinkEvent)
  removeEvent(widget.blinkStopEvent)

  widget.blinkEvent = cycleEvent(function()
    widget:setOn(not widget:isOn())
  end, interval)

  if duration > 0 then
    widget.blinkStopEvent = scheduleEvent(function()
      g_effects.stopBlink(widget)
    end, duration)
  end

  if clickCancel then
    connect(widget, { onClick = g_effects.stopBlink })
  end
end

function g_effects.stopBlink(widget)
  disconnect(widget, { onClick = g_effects.stopBlink })
  removeEvent(widget.blinkEvent)
  removeEvent(widget.blinkStopEvent)
  widget.blinkEvent = nil
  widget.blinkStopEvent = nil
  widget:setOn(false)
end

-- Scale In
function g_effects.scaleIn(window, steps, delay)
  steps = steps or 10
  delay = delay or 20

  if not window._originalSize then
    window._originalSize = window:getSize()
    window._originalPos = window:getPosition()
  end

  local originalSize = window._originalSize
  local originalPos = window._originalPos

  window:setSize({ width = originalSize.width * 0.5, height = originalSize.height * 0.5 })
  window:setPosition({
    x = originalPos.x + originalSize.width * 0.25,
    y = originalPos.y + originalSize.height * 0.25
  })

  local function scaleStep(currentStep)
    if currentStep > steps then
      window:setSize(originalSize)
      window:setPosition(originalPos)
      return
    end

    local factor = 0.5 + (currentStep / steps) * 0.5

    local newWidth = originalSize.width * factor
    local newHeight = originalSize.height * factor

    window:setSize({ width = newWidth, height = newHeight })
    window:setPosition({
      x = originalPos.x + (originalSize.width - newWidth) / 2,
      y = originalPos.y + (originalSize.height - newHeight) / 2
    })

    scheduleEvent(function()
      scaleStep(currentStep + 1)
    end, delay)
  end

  scaleStep(1)
end

-- Scale Out
function g_effects.scaleOut(window, steps, delay, onComplete)
  steps = steps or 10
  delay = delay or 20

  if not window._originalSize then
    window._originalSize = window:getSize()
    window._originalPos = window:getPosition()
  end

  local originalSize = window._originalSize
  local originalPos = window._originalPos

  local function scaleStep(currentStep)
    if currentStep > steps then
      if onComplete then
        onComplete()
      else
        window:hide()
      end
      window:setSize(originalSize)
      window:setPosition(originalPos)
      return
    end

    local factor = 1 - (currentStep / steps) * 0.5

    local newWidth = originalSize.width * factor
    local newHeight = originalSize.height * factor

    window:setSize({ width = newWidth, height = newHeight })
    window:setPosition({
      x = originalPos.x + (originalSize.width - newWidth) / 2,
      y = originalPos.y + (originalSize.height - newHeight) / 2
    })

    scheduleEvent(function()
      scaleStep(currentStep + 1)
    end, delay)
  end

  scaleStep(1)
end

-- Move In (slide from bottom)
function g_effects.moveIn(window, steps, delay)
  steps = steps or 10
  delay = delay or 20

  if not window._originalPos then
    window._originalPos = window:getPosition()
  end

  local originalPos = window._originalPos
  local startPos = { x = originalPos.x, y = originalPos.y + 50 }

  window:setPosition(startPos)
  window:show()

  local function moveStep(currentStep)
    if currentStep > steps then
      window:setPosition(originalPos)
      return
    end

    local newY = startPos.y - ((currentStep / steps) * 50)
    window:setPosition({ x = originalPos.x, y = newY })

    scheduleEvent(function()
      moveStep(currentStep + 1)
    end, delay)
  end

  moveStep(1)
end

-- Move Out (slide to bottom)
function g_effects.moveOut(window, steps, delay, onComplete)
  steps = steps or 10
  delay = delay or 20

  if not window._originalPos then
    window._originalPos = window:getPosition()
  end

  local originalPos = window._originalPos
  local endPos = { x = originalPos.x, y = originalPos.y + 50 }

  local function moveStep(currentStep)
    if currentStep > steps then
      if onComplete then onComplete() else window:hide() end
      window:setPosition(originalPos)
      return
    end

    local newY = originalPos.y + ((currentStep / steps) * 50)
    window:setPosition({ x = originalPos.x, y = newY })

    scheduleEvent(function()
      moveStep(currentStep + 1)
    end, delay)
  end

  moveStep(1)
end

-- Pop Up (jump up and back)
function g_effects.popUp(window, offset, delay)
  offset = offset or 14
  delay = delay or 130

  if not window._originalPos then
    window._originalPos = window:getPosition()
  end

  local originalPos = window._originalPos

  local function popDown()
    window:setPosition({ x = originalPos.x, y = originalPos.y + offset })
  end

  local function popUp()
    window:setPosition({ x = originalPos.x, y = originalPos.y - offset })
    scheduleEvent(popDown, delay)
  end

  scheduleEvent(popUp, delay)
end

-- Pop Down (jump down and back)
function g_effects.popDown(window, offset, delay)
  offset = offset or 14
  delay = delay or 130

  if not window._originalPos then
    window._originalPos = window:getPosition()
  end

  local originalPos = window._originalPos

  local function popUp()
    window:setPosition({ x = originalPos.x, y = originalPos.y - offset })
  end

  local function popDown()
    window:setPosition({ x = originalPos.x, y = originalPos.y + offset })
    scheduleEvent(popUp, delay)
  end

  scheduleEvent(popDown, delay)
end

-- Shake (tremer janela)
function g_effects.shake(window, intensity, steps, delay)
  intensity = intensity or 10
  steps = steps or 10
  delay = delay or 20

  if not window._originalPos then
    window._originalPos = window:getPosition()
  end

  local originalPos = window._originalPos
  local stepCount = 0

  local function doShake()
    if stepCount >= steps then
      window:setPosition(originalPos)
      return
    end

    local offsetX = math.random(-intensity, intensity)
    local offsetY = math.random(-intensity, intensity)

    window:setPosition({ x = originalPos.x + offsetX, y = originalPos.y + offsetY })

    stepCount = stepCount + 1
    scheduleEvent(doShake, delay)
  end

  doShake()
end

function g_effects.collapse(widget, steps, delay, onComplete)
  steps = steps or 10
  delay = delay or 20

  if not widget._originalSize then
    widget._originalSize = widget:getSize()
  end

  local originalSize = widget._originalSize

  local function collapseStep(currentStep)
    if currentStep > steps then
      widget:setHeight(0)
      widget._isCollapsed = true
      if onComplete then onComplete() end
      return
    end

    local newHeight = originalSize.height * (1 - (currentStep / steps))
    widget:setHeight(newHeight)

    scheduleEvent(function()
      collapseStep(currentStep + 1)
    end, delay)
  end

  collapseStep(1)
end

function g_effects.expand(widget, steps, delay, onComplete)
  steps = steps or 10
  delay = delay or 20

  if not widget._originalSize then return end

  local originalSize = widget._originalSize

  local function expandStep(currentStep)
    if currentStep > steps then
      widget:setHeight(originalSize.height)
      widget._isCollapsed = false
      if onComplete then onComplete() end
      return
    end

    local newHeight = originalSize.height * (currentStep / steps)
    widget:setHeight(newHeight)

    scheduleEvent(function()
      expandStep(currentStep + 1)
    end, delay)
  end

  expandStep(1)
end

function g_effects.toggleCollapse(widget)
  if widget._isCollapsed then
    g_effects.expand(widget)
  else
    g_effects.collapse(widget)
  end
end

-- Slide Height (anima altura do widget)
function g_effects.slideHeight(widget, from, to, steps, delay, onComplete)
  steps = steps or 10
  delay = delay or 20
  local diff = to - from

  local function animate(step)
    if step > steps then
      widget:setHeight(to)
      if onComplete then onComplete() end
      return
    end

    local newHeight = from + math.floor((diff * step) / steps)
    widget:setHeight(newHeight)

    scheduleEvent(function()
      animate(step + 1)
    end, delay)
  end

  animate(1)
end

