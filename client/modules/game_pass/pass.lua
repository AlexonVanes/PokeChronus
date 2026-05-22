
function Protocol_create(byte)
  local protocol      = {}
        protocol[1]   = {}
        protocol[2]   = 0
        protocol[3]   = byte
 
  return protocol
end

function Protocol_add(protocol, string)
  table.insert(protocol[1], string)
end

function Protocol_read(protocol)
  protocol[2] = protocol[2] + 1
  return protocol[1][protocol[2]]
end

function isInArray(table, value)
  for i = 1, #table do
    if table[i] == value then
      return true
    end
  end

  return false
end

local MainWindow, PassInfo, ItemsVip, ItemsPremium, PassLevels, MainButton, ImageShow, UIBlackWindow, UIBuyLevel, CollectButton, AlertCollect
local MissionWindow, MissionPanel, buyWindow
local Key = "Alt+P"
local Opcode = 20
local imagePath = "images/"
local BuyLevelPrice = 10
local BuyPassPrice = 50

local PassVip = 1
local PassPremium = 2
local PassFirst = PassVip
local ItemsPanel = {}

local HasPremium = false
local PassLevel = 0
local MaxPassLevel = 100
local sendPassOpcode
local updatePassActionButtons
local setupPassActionCallbacks

lastTimeSearch = 0

function init()
  connect(g_game, {
    onGameStart = refresh,
    onGameEnd = refresh,
  })
  MainWindow = g_ui.displayUI('pass')
  PassInfo = MainWindow:getChildById('passInfo')
  ItemsVip = MainWindow:getChildById('itemsVip')
  ItemsPremium = MainWindow:getChildById('itemsPremium')
  -- ImageShow = MainWindow:getChildById('imageShow')
  UIBuyLevel = MainWindow:getChildById('UIBuyLevel')
  UIBlackWindow = MainWindow:getChildById('UIBlackWindow')
  CollectButton = MainWindow:getChildById('collectButton')
  AlertCollect = MainWindow:getChildById('alertCollect')
  PassLevels = MainWindow:getChildById('passLevels')
  
  MissionWindow = MainWindow:getChildById('missionPanel')
  MissionScrollbar = MainWindow:getChildById('missionScrollBar')
  MissionReturn = MainWindow:getChildById('returnMission')
  MissionPanel = MissionWindow
  local buyLevelPriceLabel = UIBuyLevel and UIBuyLevel:getChildById('priceLabel')
  if buyLevelPriceLabel then
    buyLevelPriceLabel:setText(tostring(BuyLevelPrice))
  end
  local buyPassWindow = MainWindow:getChildById('UIBuyPass35')
  local buyPassPriceLabel = buyPassWindow and buyPassWindow:getChildById('priceValue')
  if buyPassPriceLabel then
    buyPassPriceLabel:setText(tostring(BuyPassPrice))
  end
  
  -- MissionWindow:hide()
  
  ItemsPanel = {
    [PassVip] = ItemsVip,
    [PassPremium] = ItemsPremium,
  }
  
  -- g_keyboard.bindKeyDown(Key, toggle)
  
  MainButton = modules.client_topmenu.addRightGameToggleButton('MainButton', tr('Pass') .. ' ('..Key..')', '/images/topbuttons/pass', toggle)
  MainButton:setOn(false)
--   MainButton:setWidth(56)
  ProtocolGame.registerExtendedOpcode(Opcode, getPass)
  setupPassActionCallbacks()
  updatePassActionButtons()
  MainWindow:hide()
end

local function stopEvent(panel)
  if not panel then
    return
  end

  if panel.event then
    removeEvent(panel.event)
    panel.event = nil
  end
end

sendPassOpcode = function(buffer)
  if not g_game.isOnline() then
    return false
  end

  local protocolGame = g_game.getProtocolGame()
  if not protocolGame then
    return false
  end

  protocolGame:sendExtendedOpcode(Opcode, buffer)
  return true
end

updatePassActionButtons = function()
  if not PassInfo then
    return
  end

  local buyPassButton = PassInfo:getChildById('buyPassButton')
  local passLevelUpButton = PassInfo:getChildById('passLeveuUp')

  if buyPassButton then
    buyPassButton:setVisible(not HasPremium)
    buyPassButton:setEnabled(not HasPremium)
  end

  if passLevelUpButton then
    passLevelUpButton:setVisible(HasPremium and PassLevel < MaxPassLevel)
    passLevelUpButton:setEnabled(HasPremium and PassLevel < MaxPassLevel)
  end
end

setupPassActionCallbacks = function()
  if not MainWindow then
    return
  end

  local missionsButton = PassInfo and PassInfo:getChildById('missions')
  if missionsButton then
    missionsButton.onClick = function() showMissions() end
  end

  local buyPassButton = PassInfo and PassInfo:getChildById('buyPassButton')
  if buyPassButton then
    buyPassButton.onClick = function() showBuyPassElite() end
  end

  local passLevelButton = PassInfo and PassInfo:getChildById('passLeveuUp')
  if passLevelButton then
    passLevelButton.onClick = function() showUpWindow() end
  end

  local buyPass35Window = MainWindow:getChildById('UIBuyPass35')
  if buyPass35Window then
    local cancelButton = buyPass35Window:getChildById('cancelar')
    local buyButton = buyPass35Window:getChildById('comprar')
    if cancelButton then
      cancelButton.onClick = function() doCloseBuyWindow() end
    end
    if buyButton then
      buyButton.onClick = function() doBuyPass35Server() end
    end
  end

  local buyLevelWindow = MainWindow:getChildById('UIBuyLevel')
  if buyLevelWindow then
    local cancelButton = buyLevelWindow:getChildById('cancelar')
    if cancelButton then
      cancelButton.onClick = function() hideUpWindow() end
    end
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = refresh,
    onGameEnd = refresh,
  })
  -- g_keyboard.unbindKeyDown(Key)

  if waitingEvent then
    removeEvent(waitingEvent)
    waitingEvent = nil
  end
  waitingPass = false
  stopEvent(PassInfo)

  ProtocolGame.unregisterExtendedOpcode(Opcode)
  if MainWindow then
    MainWindow:destroy()
  end
  MainWindow = nil
  MissionWindow = nil
  if MainButton then
    MainButton:destroy()
  end
  MainButton = nil
end

function toggle()
  if MainWindow:isVisible() then
    hide()
	hideMissions()
    stopEvent(PassInfo)
  else
    show()
	hideMissions()
    stopEvent(PassInfo)
  end
  -- if MainButton:isOn() then
    -- hide()
  -- else
    -- show()
  -- end
end

function refresh()
  MainWindow:hide()
  MissionWindow:hide()
  closeBuyWindow()
  stopEvent(PassInfo)
  -- MainButton:setOn(false)
end

function show()
  MainWindow:show()
  MainWindow:raise()
  MainWindow:focus()
  lastTimeSearch = os.time()+2
  stopEvent(PassInfo)
  -- Diagnóstico: aguarde resposta do servidor pelo opcode e avise se nada chegar
  if waitingEvent then
    removeEvent(waitingEvent)
    waitingEvent = nil
  end
  waitingPass = true
  waitingEvent = scheduleEvent(function()
    if waitingPass then
      print("[PASS] Nenhum pacote de ExtendedOpcode "..Opcode.." recebido apos abrir o passe. Verifique o handler do opcode "..Opcode..".")
    end
  end, 3000)
  sendPassOpcode("Open")
  -- MainButton:setOn(true)
end

function hide()
  MainWindow:hide()
  MissionWindow:hide()
  closeBuyWindow()
  stopEvent(PassInfo)
  -- MainButton:setOn(false)
end

--[[
  -- Esconder itens do Pass
  PassInfo:hide()
  ItemsVip:hide()
  ItemsPremium:hide()
  PassLevels:hide()
  MainWindow:getChildById('windowList'):hide()
  MainWindow:getChildById('SeparatorList'):hide()
  MainWindow:getChildById('ItemsPremiumImageText'):hide()
  MainWindow:getChildById('itemsPremium'):hide()
  MainWindow:getChildById('itemsPremiumImage'):hide()
  MainWindow:getChildById('itemsVipImage'):hide()
  MainWindow:getChildById('ItemsVipImageText'):hide()
  MainWindow:getChildById('itemsVip'):hide()
  MainWindow:getChildById('itemsScrollBar'):hide()
  
  -- Mostrar missões
  MissionWindow:show()
  MissionScrollbar:show()
  MissionReturn:show()
  MainWindow:getChildById('backgroundMissions'):show()
  MainWindow:getChildById('tittleMissions'):show()
  
  stopEvent(PassInfo)
]]

function hideMissions() -- toggle mission
  MissionWindow:hide()
  MissionScrollbar:hide()
  MissionReturn:hide()

  PassInfo:show()
  ItemsVip:show()
  ItemsPremium:show()
  -- ImageShow:show()
  PassLevels:show()
  MainWindow:getChildById('windowList'):show()
  MainWindow:getChildById('SeparatorList'):show()
  MainWindow:getChildById('ItemsPremiumImageText'):show()
  MainWindow:getChildById('itemsPremium'):show()
  MainWindow:getChildById('itemsPremiumImage'):show()
  MainWindow:getChildById('itemsVipImage'):show()
  MainWindow:getChildById('ItemsVipImageText'):show()
  MainWindow:getChildById('itemsVip'):show()
  MainWindow:getChildById('itemsScrollBar'):show()
  MainWindow:getChildById('backgroundMissions'):hide()
  MainWindow:getChildById('tittleMissions'):hide()
  stopEvent(PassInfo)
end

function showBuyPassElite()
  if HasPremium then
    AtualPass()
    return
  end

  local confirmWindow = MainWindow:getChildById('UIBuyPass35')
  if confirmWindow then
    if UIBlackWindow then
      UIBlackWindow:show()
    end
    confirmWindow:show()
    confirmWindow:raise()
    confirmWindow:focus()
  end
end

function doBuyPass35Server()
  sendPassOpcode("BuyPass35")
  
  local confirmWindow = MainWindow:getChildById('UIBuyPass35')
  if confirmWindow then
    confirmWindow:hide()
  end
  if UIBlackWindow then
    UIBlackWindow:hide()
  end
end

function doCloseBuyWindow()
  local confirmWindow = MainWindow:getChildById('UIBuyPass35')
  if confirmWindow then
    confirmWindow:hide()
  end

  if UIBlackWindow then
    UIBlackWindow:hide()
  end
end

function closeBuyWindow()
  if buyWindow then
    buyWindow:destroy()
    buyWindow = nil
  end
  doCloseBuyWindow()
end

local function createPassPacket(packetType, values)
  return {values or {}, 0, packetType}
end

local function parsePassPacket(buffer)
  local ok, data = pcall(function() return json.decode(buffer) end)
  if ok and type(data) == 'table' and type(data.type) == 'string' then
    return createPassPacket(data.type, data.values or data.data or {})
  end

  print("[PASS] Pacote recusado: formato inseguro ou invalido.")
  return nil
end

function getPass(protocol, opcode, buffer)
  -- Cancelar diagnóstico de espera quando o pacote chegar
  waitingPass = false
  if waitingEvent then
    removeEvent(waitingEvent)
    waitingEvent = nil
  end
  
  local receive = parsePassPacket(buffer)
  if not receive then
    return
  end
  
  if receive[3] == 'Pass' then
    HasPremium = Protocol_read(receive)
    PassLevel = Protocol_read(receive)
    MaxPassLevel = Protocol_read(receive)
    local passStars = Protocol_read(receive)
    local passDaysLeft = Protocol_read(receive)
    local passTime = Protocol_read(receive)
	
    stopEvent(PassInfo)
    PassInfo:getChildById('level'):setText(PassLevel)
	if passDaysLeft == 1 then
		PassInfo:getChildById('daysLeft'):setText("1 Dia")
	else
		PassInfo:getChildById('daysLeft'):setText(passDaysLeft.." Dias")
	end
    if passTime == 0 then
      PassInfo:getChildById('TimeLeft'):hide()
    else
      PassInfo:getChildById('TimeLeft'):show()
      PassInfo:getChildById('TimeLeft'):setText("  "..convertTime2(passTime))

      seconds = passTime
      local function update()
        seconds = math.max(0, seconds - 1)
        PassInfo:getChildById('TimeLeft'):setText("  "..convertTime2(seconds))
        if seconds > 0 then
          PassInfo.event = scheduleEvent(update, 1000)
        end
      end
      PassInfo.event = scheduleEvent(update, 1000)
    end

    local isMaxLevel = PassLevel >= MaxPassLevel
    for star, child in ipairs(PassInfo:getChildById('stars'):getChildren()) do
      child:setOn(isMaxLevel or star <= passStars)
    end

    if isMaxLevel then
      PassInfo:getChildById('levelLabel'):setText("Full")
    else
      local levelLabel = PassInfo:getChildById('levelLabel')
      levelLabel:setWidth(62)
      levelLabel:setText((passStars * 10).."/100")
    end
    if HasPremium then
      PassInfo:getChildById('atualPass'):setImageSource('images/info/elite')
      if PassLevel < MaxPassLevel then --- caso j� tenha o passe executar isso
	    PassInfo:getChildById('atualPass'):setImageSource('images/info/elite')
		
	  end
    else --- caso n�o tenha o passe, executar isso aqui...
	    PassInfo:getChildById('atualPass'):setImageSource('images/info/basico')
    end
    updatePassActionButtons()
		-- ImageShow:getChildById('separator'):hide()
		-- ImageShow:getChildById('title'):setText("")
		-- ImageShow:getChildById('image'):setImageSource("")
		-- ImageShow:getChildById('desc'):setText("")
  elseif receive[3] == 'Items' then
    local first = Protocol_read(receive)
    local items = Protocol_read(receive)
    local collecteds = Protocol_read(receive)
	if first then
      for passType=PassFirst, PassPremium do
	    ItemsPanel[passType]:destroyChildren()
	  end
	  PassLevels:destroyChildren()
	end
	drawPassItems(items, collecteds)
  elseif receive[3] == 'Missions' then
    local first = Protocol_read(receive)
    local missions = Protocol_read(receive)
	if first then
	  MissionPanel:destroyChildren()
	end
	for num, mission in ipairs(missions) do
	if num ~= 1 then
	  local widget = g_ui.createWidget('MissionWidget', MissionPanel)
	  local missionProgress = tonumber(mission.progress) or 0
	  local missionMax = tonumber(mission.max) or 0
	  local missionXP = (tonumber(mission.stars) or 0) * 10

	  if missionProgress >= missionMax then
	    widget:getChildById('star'):setOn(true)
	    widget:getChildById('star'):setTooltip('Concluido')
	    widget:getChildById('xptext'):setText(missionXP)
	  else
	    widget:getChildById('xptext'):setText(missionXP)
	  end
	  local icon = widget:getChildById('itemIcon')
	  icon:setImageSource((mission.icon and mission.icon ~= "") and mission.icon or "images/mission/icones/task")
	  icon:setSize(mission.size)

    local iconPosition = mission.position or {x = 0, y = 0}
	  icon:setMarginLeft(iconPosition.x or 0)
	  icon:setMarginTop(iconPosition.y or 0)

	  local progressFill = widget:getChildById('progressFill')
	  if progressFill then
	    local percent = 0
	    if missionMax > 0 then
	      percent = math.min(1, math.max(0, missionProgress / missionMax))
	    end
	    progressFill:setWidth(math.max(1, math.floor(116 * percent)))
	  end
	  
	  widget:getChildById('progress'):setText(""..missionProgress.." de "..missionMax.."")
	  widget:getChildById('desc'):setText(mission.desc)
	end
   end
  elseif receive[3] == 'Pass35Buyed' then
    Pass35Buyed()
  elseif receive[3] == 'NoDiamondsBuyPass' then
    NoDiamondsBuyPass()
  elseif receive[3] == 'NoDiamonds' then
    NoDiamonds()
  elseif receive[3] == 'NoPass' then
    NoPass()
  elseif receive[3] == 'ActivePass' then
    AtualPass()
  elseif receive[3] == "PassLevelUp" then
  PassLevelUp()
  elseif receive[3] == 'HassMission' then
    HassPremiumPass()
    PassInfo:getChildById('passLeveuUp'):show()
  elseif receive[3] == 'NoMission' then
    NoPremiumPass()
    PassInfo:getChildById('passLeveuUp'):hide()
  elseif receive[3] == 'NoVipCollect' then
	NoVipCollect()
  elseif receive[3] == 'UpdateReward' then
    local level = Protocol_read(receive)
    local passType = Protocol_read(receive)
    if not ItemsPanel[passType] then
      return
    end

	local widget = ItemsPanel[passType]:getChildById(level)
	if widget then
	  g_ui.createWidget('CollectedMask', widget)
    widget.onClick = nil
	end
  end
end

local function isInArray(array, element)
    for _, value in ipairs(array) do
        if value == element then
            return true
        end
    end
    return false
end

function drawPassItems(items, collecteds)
  if not items then
    return
  end

  collecteds = collecteds or {}

  for num, reward in ipairs(items) do
    local level = reward[PassPremium+1]
    for passType=PassFirst, PassPremium do
	  local widget = g_ui.createWidget(reward[passType].style , ItemsPanel[passType])
	  widget:setId(level)
	  if reward[passType].style == "UIPassItem" then
	    widget:getChildById('item'):setItemId(reward[passType].item.clientId)
	    widget:getChildById('item'):setItemCount(reward[passType].item.count)
	  elseif reward[passType].style == "UIPassSkin" then
	    widget:setOutfit({type = reward[passType].skin.lookType, head = 0, body = 0, legs = 0, feet = 0})
	  elseif reward[passType].style == "UIPassExperience" then
	    widget:setText(reward[passType].experience)
	  elseif reward[passType].style == "UIPassPremiumPoints" then
	    widget:setText(reward[passType].premiumPoints)
	  end
	  if collecteds[passType] and isInArray(collecteds[passType], level) then
	    g_ui.createWidget('CollectedMask', widget)
	  end
	  widget:setTooltip(reward[passType].name)
	  if (passType == PassPremium and not HasPremium) or PassLevel < level then
	    g_ui.createWidget("UIPassMask" , widget)
	  end
      widget.onClick = function()
			-- ImageShow:getChildById('separator'):hide()
			-- ImageShow:getChildById('title'):setText("")
			-- ImageShow:getChildById('image'):setImageSource("")
			-- ImageShow:getChildById('desc'):setText("")

	    if reward[passType].style == "UIPassItem" and reward[passType].item.id == 1 then
		  widget:getChildById('item'):setItemId(reward[passType].item.clientId)
		  return
		end
        if passType == PassPremium and not HasPremium then
          NoPass()
          return
        end
        if level <= PassLevel and not (collecteds[passType] and isInArray(collecteds[passType], level)) then
          sendPassOpcode(level..'#Collect#'..passType)
        end
      end
    end
	local widget = g_ui.createWidget('PassWidgetLevel', PassLevels)
	widget:setText(level)
  end
end

function showMissions()
  MissionWindow:show()
  MissionWindow:raise()
  MissionWindow:focus()
  MissionScrollbar:show()
  MissionReturn:show()

  PassInfo:hide()
  ItemsVip:hide()
  ItemsPremium:hide()
  -- ImageShow:hide()
  UIBuyLevel:hide()
  UIBlackWindow:hide()
  CollectButton:hide()
  AlertCollect:hide()
  PassLevels:hide()
  MainWindow:getChildById('windowList'):hide()
  MainWindow:getChildById('SeparatorList'):hide()
  MainWindow:getChildById('ItemsPremiumImageText'):hide()
  MainWindow:getChildById('itemsPremium'):hide()
  MainWindow:getChildById('itemsPremiumImage'):hide()
  MainWindow:getChildById('itemsVipImage'):hide()
  MainWindow:getChildById('ItemsVipImageText'):hide()
  MainWindow:getChildById('itemsVip'):hide()
  MainWindow:getChildById('itemsScrollBar'):hide()
  MainWindow:getChildById('backgroundMissions'):show()
  MainWindow:getChildById('tittleMissions'):show()
  stopEvent(PassInfo)
end

function hideUpWindow()
  UIBuyLevel:hide()
  UIBlackWindow:hide()
  stopEvent(PassInfo)
end

function showUpWindow()
  if not HasPremium then
    NoPass()
    return
  end

  if PassLevel >= MaxPassLevel then
    AtualPass()
    return
  end

  UIBlackWindow:show()
  UIBuyLevel:show()
  UIBuyLevel:getChildById('comprar').onClick = function()
	sendPassOpcode("BuyLevel")
	UIBuyLevel:hide()
	UIBlackWindow:hide()
  end
end

function hideAlertWindow()
  MainWindow:getChildById('AlertWindow'):hide()
  UIBlackWindow:hide()
  stopEvent(PassInfo)
end

local AlertMessages = {
  activePass = { title = "PASSE ATIVO", message = "Voce ja possui o Passe de Elite." },
  novip_collect = { title = "PASSE NECESSARIO", message = "Compre o Passe de Elite para liberar esta acao." },
  nopass = { title = "PASSE NECESSARIO", message = "Voce precisa do Passe de Elite." },
  novip_colect = { title = "RECOMPENSA BLOQUEADA", message = "Esta recompensa pertence ao Passe de Elite." },
  nodiamonds = { title = "DIAMONDS INSUFICIENTES", message = "Voce nao possui diamonds suficientes." },
  no_diamonds_passbuy = { title = "DIAMONDS INSUFICIENTES", message = "Voce precisa de 50 diamonds para comprar o Passe de Elite." },
  Pass_buyed = { title = "PASSE ATIVADO", message = "Passe de Elite comprado com sucesso." },
  pass_levelup = { title = "NIVEL COMPRADO", message = "Voce comprou 1 nivel do Passe." }
}

local function showPassAlert(icone, color, textKey)
  local alertWindow = MainWindow:getChildById('AlertWindow')
  local alertData = AlertMessages[textKey] or { title = "AVISO", message = "" }

  UIBlackWindow:show()
  alertWindow:show()
  alertWindow:raise()
  alertWindow:focus()
  alertWindow:getChildById('icon'):setImageSource("images/AlertWindow/icon/"..icone)
  alertWindow:getChildById('icon'):setImageColor(color)
  alertWindow:getChildById('alertTitle'):setText(alertData.title)
  alertWindow:getChildById('alertMessage'):setText(alertData.message)
  stopEvent(PassInfo)
end

function NoPremiumPass()
  HasPremium = false
  updatePassActionButtons()
  PassInfo:getChildById('missions').onClick = function() NoRequesits() end
  PassInfo:getChildById('passLeveuUp'):hide()
end
function HassPremiumPass()
  HasPremium = true
  updatePassActionButtons()
  PassInfo:getChildById('missions').onClick = function() showMissions() end
end
function AtualPass()
  local icone = "pass"
  local color = "#ffffff"
  local text = "activePass"

  showPassAlert(icone, color, text)
end
function NoRequesits()
  local icone = "exclaming"
  local color = "#ffe400"
  local text = "novip_collect"

  showPassAlert(icone, color, text)
end
function NoPass()
  local icone = "pass"
  local color = "#ffffff"
  local text = "nopass"

  showPassAlert(icone, color, text)
end
function NoVipCollect()
  local icone = "vip"
  local color = "#ffffff"
  local text = "novip_colect"

  showPassAlert(icone, color, text)
end
function NoDiamonds()
  local icone = "diamond"
  local color = "#ffffff"
  local text = "nodiamonds"

  UIBuyLevel:hide()
  showPassAlert(icone, color, text)
end
function NoDiamondsBuyPass()
  local icone = "diamond"
  local color = "#ffffff"
  local text = "no_diamonds_passbuy"

  UIBuyLevel:hide()
  showPassAlert(icone, color, text)
end
function Pass35Buyed()
  HasPremium = true
  local icone = "pass"
  local color = "#ffffff"
  local text = "Pass_buyed"

  UIBuyLevel:hide()
  showPassAlert(icone, color, text)
  PassInfo:getChildById('missions').onClick = function() showMissions() end
  updatePassActionButtons()
end
function PassLevelUp()
  PassLevel = math.min(MaxPassLevel, PassLevel + 1)
  updatePassActionButtons()
  local icone = "pass"
  local color = "#ffffff"
  local text = "pass_levelup"

  UIBuyLevel:hide()
  showPassAlert(icone, color, text)
end


function convertTime2(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function convertOsTime(seconds)
  local hours = 0
  local minutes = 0
  repeat
    if seconds >= 60 then
      minutes = minutes + 1; seconds = seconds - 60
    elseif minutes >= 60 then
      hours = hours + 1; minutes = minutes - 60
    end
  until seconds < 60 and minutes < 60
  return {hours = hours, seconds = seconds, minutes = minutes}
end
