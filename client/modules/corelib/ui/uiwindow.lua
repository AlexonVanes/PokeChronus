-- @docclass
UIWindow = extends(UIWidget, "UIWindow")

function UIWindow.create()
  local window = UIWindow.internalCreate()
  window:setTextAlign(AlignTopCenter)
  window:setDraggable(true)  
  window:setAutoFocusPolicy(AutoFocusFirst)
  
  addEvent(function()
    if window.closeButton then
      window.closeButton.onClick = function() window:close() end
    end
  end)
  
  return window
end
function UIWindow:close()
  self:hide()
  signalcall(self.onClose, self)
end
function UIWindow:onKeyDown(keyCode, keyboardModifiers)
  if keyboardModifiers == KeyboardNoModifier then
    if keyCode == KeyEnter then
      signalcall(self.onEnter, self)
    elseif keyCode == KeyEscape then
      signalcall(self.onEscape, self)
    end
  end
end

function UIWindow:onFocusChange(focused)
  if focused then self:raise() end
end

function UIWindow:onDragEnter(mousePos)
  if self.static then
    return false
  end
  self:breakAnchors()
  self.movingReference = { x = mousePos.x - self:getX(), y = mousePos.y - self:getY() }
  return true
end

function UIWindow:onDragLeave(droppedWidget, mousePos)
  -- TODO: auto detect and reconnect anchors
end

function UIWindow:onDragMove(mousePos, mouseMoved)
  if self.static then
    return
  end
  local pos = { x = mousePos.x - self.movingReference.x, y = mousePos.y - self.movingReference.y }
  self:setPosition(pos)
  self:bindRectToParent()
end

function UIWindow:onVisibilityChange(visible)
  if visible and self.animation then
    self:breakAnchors()
	
	local function popDown()
	  local pos = self:getPosition()
	  pos.y = pos.y + 14
	  self:setPosition(pos)	
	end
	
	local function popUp()
	  local pos = self:getPosition()
	  pos.y = pos.y - 14
	  self:setPosition(pos)
	  scheduleEvent(popDown, 130)
	end
	
    scheduleEvent(popUp, 128) 
  end
end
