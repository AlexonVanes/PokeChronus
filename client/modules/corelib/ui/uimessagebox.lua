if not UIWindow then dofile 'uiwindow' end

-- @docclass
UIMessageBox = extends(UIWindow, "UIMessageBox")

-- messagebox cannot be created from otui files
UIMessageBox.create = nil

function UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
  local messageBox = UIMessageBox.internalCreate()
  rootWidget:addChild(messageBox)

  messageBox:setStyle('WindowBox')
  messageBox:setText(title)

  local messageLabel = g_ui.createWidget('MessageBoxLabel', messageBox)
  messageLabel:setText(message)

  local buttonsWidth = 0
  local buttonsHeight = 0

  local anchor = AnchorRight
  if buttons.anchor then anchor = buttons.anchor end

  local buttonHolder = g_ui.createWidget('MessageBoxButtonHolder', messageBox)
  buttonHolder:addAnchor(anchor, 'parent', anchor)

  for i=1,#buttons do
    local button = messageBox:addButton(buttons[i].text, buttons[i].callback)
    if i == 1 then
      button:setMarginLeft(0)
      button:addAnchor(AnchorBottom, 'parent', AnchorBottom)
      button:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      buttonsHeight = button:getHeight()
    else
      button:addAnchor(AnchorBottom, 'prev', AnchorBottom)
      button:addAnchor(AnchorLeft, 'prev', AnchorRight)
    end
    buttonsWidth = buttonsWidth + button:getWidth() + button:getMarginLeft()
  end

  buttonHolder:setWidth(buttonsWidth)
  buttonHolder:setHeight(buttonsHeight)

  if onEnterCallback then connect(messageBox, { onEnter = onEnterCallback }) end
  if onEscapeCallback then connect(messageBox, { onEscape = onEscapeCallback }) end

  messageBox:setWidth(math.max(messageLabel:getWidth(), messageBox:getTextSize().width, buttonHolder:getWidth()) + messageBox:getPaddingLeft() + messageBox:getPaddingRight())
  messageBox:setHeight(messageLabel:getHeight() + messageBox:getPaddingTop() + messageBox:getPaddingBottom() + buttonHolder:getHeight() + buttonHolder:getMarginTop())
   
  messageBox:setMarginTop(0)
  scheduleEvent(function() messageBox:setMarginTop(-15) end, 30)
  
  return messageBox
end

function displayInfoBox(title, message)
  local messageBox
  local defaultCallback = function() messageBox:ok() end
  messageBox = UIMessageBox.display(title, message, {{text='Ok', callback=defaultCallback}}, defaultCallback, defaultCallback)
  return messageBox
end

function displayErrorBox(title, message)
  local messageBox
  local defaultCallback = function() messageBox:ok() end
  messageBox = UIMessageBox.display(title, message, {{text='Ok', callback=defaultCallback}}, defaultCallback, defaultCallback)
  return messageBox
end

function displayCancelBox(title, message)
  local messageBox
  local defaultCallback = function() messageBox:cancel() end
  messageBox = UIMessageBox.display(title, message, {{text='Cancel', callback=defaultCallback}}, defaultCallback, defaultCallback)
  return messageBox
end

function displayGeneralBox(title, message, buttons, onEnterCallback, onEscapeCallback)
  return UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
end

function displayConfirmBox(title, message, onConfirm, onCancel)
	local confirmBox

	local function onDestroy()
		if confirmBox then
			confirmBox:destroy()
			confirmBox = nil
		end
	end

	local function onCancelCallback()
		onDestroy()
		if onCancel then
			onCancel()
		end
	end

	local function onEnterCallback()
		onDestroy()
		if onConfirm then
			onConfirm()
		end
	end

	local buttons = {
		{
			text = tr("Yes"),
			callback = onEnterCallback
		},
		{
			text = tr("No"),
			callback = onCancelCallback
		}
	}

	confirmBox = displayGeneralBox(title, message, buttons, onEnterCallback, onCancelCallback)

	confirmBox:raise()
	confirmBox:focus()

	return confirmBox
end

function UIMessageBox:addButton(text, callback)
  local buttonHolder = self:getChildById('buttonHolder')
  local button
  local isCancel = false

  if text:lower() == "no" or text:lower() == "não" or text:lower() == "nao" or text:lower() == "cancel" or text:lower() == "cancelar" then
    button = g_ui.createWidget('MessageBoxButtonRed', buttonHolder)
    isCancel = true
  else
    button = g_ui.createWidget('MessageBoxButton', buttonHolder)
  end

  button:setImageBorder(10)
  button:setText(text)
  connect(button, { onClick = callback })

  -- Ajuste de tamanho baseado no texto
  local minWidth = 100
  local padding = 20
  local textLength = text:len()
  local calculatedWidth = textLength * 10 + padding
  local finalWidth = math.max(minWidth, calculatedWidth)

  button:setWidth(finalWidth)
  button:setHeight(50)

  -- Conta quantos botões já existem
  local children = buttonHolder:getChildren()
  local count = #children

  if count == 1 then
    -- Só um botão: centraliza
    local holderWidth = buttonHolder:getWidth()
    local buttonWidth = button:getWidth()
    button:setX((holderWidth - buttonWidth) / 2)
  elseif count == 2 then
    -- Dois botões: um à esquerda e outro à direita
    local holderWidth = buttonHolder:getWidth()
    local spacing = 10

    local totalWidth = (children[1]:getWidth() + children[2]:getWidth() + spacing)

    -- Posição do primeiro botão
    children[1]:setX((holderWidth - totalWidth) / 2)
    -- Segundo botão à direita do primeiro
    children[2]:setX(children[1]:getX() + children[1]:getWidth() + spacing)
  end

  return button
end





function UIMessageBox:ok()
  signalcall(self.onOk, self)
  self.onOk = nil
  self:destroy()
end

function UIMessageBox:cancel()
  signalcall(self.onCancel, self)
  self.onCancel = nil
  self:destroy()
end
