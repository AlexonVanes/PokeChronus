-- chunkname: @/modules/game_playerbar/playerbar.lua

OPCODE = 113
playerBarWindow = nil
profileWindow = nil
mainPanel = nil
actionbarPanel = nil
returnWindow = nil
panelDescription = nil
panelEditProfile = nil
panelLoadImage = nil
panelConfirmLoadImage = nil
panelUPLOADImage = nil
panelSkills = nil
buttonEditProfile = nil
statusTooltipWindow = nil
profileHotkeyBound = false
pokebarPollingEvent = nil
playerbarPositionUpdateEvent = nil

local function isTypingInAnyField()
	if g_keyboard.isTextInputFocused and g_keyboard.isTextInputFocused() then
		return true
	end

	if modules.game_console and modules.game_console.isChatEnabled then
		local ok, enabled = pcall(modules.game_console.isChatEnabled)
		return ok and enabled == true
	end

	return false
end

healthTooltip = "Your character health is %d out of %d."
manaTooltip = "Your character mana is %d out of %d."
experienceTooltip = "You have %d%% to advance to level %d."
fishingTooltip = "Nivel da pesca: %d\nFaltam %d%% para alcancar o nivel %d."
staminaTooltip = "Sua stamina esta em %02d:%02d (%d%%)."
playerGender = "male"
playerVipDays = 0
vipPlayerDays = 0
profileId = nil
profileImageBy64 = nil
profileLastUpdate = nil
profileUseUploadImg = nil
storagesData = {
	tornament = 0,
	vipPlus = 0,
	fenixReturn = 0
}
profileConfigStatus = {
	image = "1",
	useUpload = false,
	border = "none"
}

imageClipPokeball = {
	[0] = 0,
	14,
	28,
	42,
	56,
	70,
	84
}

local quickSlots = {
	{ id = "quickSlot1", inventorySlot = 7, name = "fishing" },
	{ id = "quickSlot2", inventorySlot = 3, name = "pokedex" },
	{ id = "quickSlot3", inventorySlot = 8, name = "pokebar" },
	{ id = "quickSlot4", inventorySlot = 2, name = "pokebag" }
}

local imageBarPath = "/images/game/playerbar/"
local imageBar = {
	[-1] = "default"
}
local expBarWidth = 132
local expBarHeight = 8
local femaleOutfit = 3116
local maleOutfit = 3119
local lastProfileRequest = 0

genderName = genderName or {
	[0] = { name = "female", subName = "Female", color = "#ff99cc" },
	[1] = { name = "male", subName = "Male", color = "#9dd6ff" }
}
townsName = townsName or setmetatable({}, { __index = function() return tr("Pallet Town") end })
clanNameById = clanNameById or setmetatable({}, { __index = function() return "none" end })
clanColor = clanColor or setmetatable({}, { __index = function() return "#a4a4a4" end })
lookClans = lookClans or setmetatable({}, { __index = function() return setmetatable({}, { __index = function() return tr("Pokemon Trainer") end }) end })
lookClansShe = lookClansShe or lookClans
profileBorders = profileBorders or {
	{ type = "NONE", image = "none", name = "Sem borda" }
}
skillByAbility = skillByAbility or {
	["Mining"] = 1,
	["Woodcutting"] = 2,
	["Construction"] = 3,
	["Smithing"] = 4,
	["Fishing"] = 6,
	["Total Level"] = 7
}

if not doCorrectNumber then
	function doCorrectNumber(value)
		if not value then return "0" end
		local formatted = tostring(math.floor(tonumber(value) or 0))
		local k
		while true do
			formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
			if k == 0 then break end
		end
		return formatted
	end
end

if not calculatePercentage then
	function calculatePercentage(current, max)
		if not max or max == 0 then return 0 end
		return math.floor((current / max) * 100)
	end
end

if not setColoredText then
	function setColoredText(label, text, color)
		if not label then return end
		local colored = tostring(text or "")
		colored = colored:gsub("%[a%](.-)%[a/%]", '<font color="' .. (color or "#ffffff") .. '">%1</font>')
		colored = colored:gsub("%[P%](.-)%[P/%]", '<font color="#32CD32">%1</font>')
		colored = colored:gsub("%[d%](.-)%[d/%]", '<font color="#aaaaaa">%1</font>')
		colored = colored:gsub("%[X%](.-)%[X/%]", '<font color="#FFD700">%1</font>')
		label:setText(colored)
	end
end

if not doUpdateProgresslBar then
	function doUpdateProgresslBar(bar, size, percentage)
		if not bar then return end
		local progress = math.max(0, math.min(100, tonumber(percentage) or 0))
		local width = math.floor((tonumber(size) or bar:getWidth() or 0) * progress / 100)
		bar:setWidth(width)
		if bar.setImageClip then
			bar:setImageClip({ x = 0, y = 0, width = width, height = 6 })
		end
	end
end

if not doSetupRegionCaughtWidget then
	function doSetupRegionCaughtWidget(widget, id)
		if not widget then return end
		local regions = {
			kanto = "KANTO",
			johto = "JOHTO",
			hoenn = "HOENN",
			distortion = "Title"
		}
		local region = regions[id] or "Title"
		if widget.icon then
			widget.icon:setImageSource("images/profile/" .. (id == "distortion" and "kanto" or tostring(id or "kanto")))
		end
		if widget.title then
			widget.title:setText(tr(region))
		end
		if widget.info then
			widget.info:setText("0")
		end
	end
end

if not doSetupClanWidget then
	function doSetupClanWidget(widget, id)
		if not widget then return end
		if widget.icon then
			widget.icon:setImageSource("images/profile/logo")
		end
		if widget.title then
			widget.title:setText(tr("POKEMON TRAINER"))
			widget.title:setColor("#aeaeae")
		end
		if widget.levelLabel then
			if widget.levelLabel.title then widget.levelLabel.title:setText(tr("Level")) end
			if widget.levelLabel.info then widget.levelLabel.info:setText("1") end
		end
		if widget.experienceLabel then
			if widget.experienceLabel.title then widget.experienceLabel.title:setText(tr("Experience")) end
			if widget.experienceLabel.info then widget.experienceLabel.info:setText("0") end
		end
		if widget.progressbar and widget.progressbar.progress then
			doUpdateProgresslBar(widget.progressbar.progress, 195, 1)
		end
	end
end

if not doSetupMainWidget then
	function doSetupMainWidget(widget)
		if not widget then return end
		local player = g_game.getLocalPlayer()
		if widget.playerName then
			widget.playerName:setText(player and player:getName() or tr("Trainer"))
		end
		if widget.vipIcon then
			widget.vipIcon:setImageSource("images/profile/vip_emblem_off")
			widget.vipIcon:setTooltip(tr("Conta Free"))
		end
		if widget.levelLabel then
			if widget.levelLabel.title then widget.levelLabel.title:setText(tr("Level")) end
			if widget.levelLabel.info then widget.levelLabel.info:setText(player and doCorrectNumber(player:getLevel()) or "1") end
		end
		if widget.experienceLabel then
			if widget.experienceLabel.title then widget.experienceLabel.title:setText(tr("Experience")) end
			if widget.experienceLabel.info then widget.experienceLabel.info:setText(player and doCorrectNumber(player:getExperience()) or "0") end
		end
		if widget.XPGainRateLabel and widget.XPGainRateLabel.info then
			widget.XPGainRateLabel.info:setText("100%")
		end
		if widget.vipDaysLabel then
			if widget.vipDaysLabel.title then widget.vipDaysLabel.title:setText(tr("VIP")) end
			if widget.vipDaysLabel.info then
				widget.vipDaysLabel.info:setText(tr("Expirado"))
				widget.vipDaysLabel.info:setColor("#ff6b6b")
			end
		end
	end
end

if modules and modules.game_playerbar then
	modules.game_playerbar.doUpdateProgresslBar = doUpdateProgresslBar
	modules.game_playerbar.doSetupRegionCaughtWidget = doSetupRegionCaughtWidget
	modules.game_playerbar.doSetupClanWidget = doSetupClanWidget
	modules.game_playerbar.doSetupMainWidget = doSetupMainWidget
end

local function exportProfileFunctions()
	if not modules or not modules.game_playerbar then
		return
	end

	modules.game_playerbar.doUpdateProgresslBar = doUpdateProgresslBar
	modules.game_playerbar.doSetupRegionCaughtWidget = doSetupRegionCaughtWidget
	modules.game_playerbar.doSetupClanWidget = doSetupClanWidget
	modules.game_playerbar.doSetupMainWidget = doSetupMainWidget
	if doSetupImageDiretory then modules.game_playerbar.doSetupImageDiretory = doSetupImageDiretory end
	if togglePanelLoadImage then modules.game_playerbar.togglePanelLoadImage = togglePanelLoadImage end
	if toggleEditProfileInfos then modules.game_playerbar.toggleEditProfileInfos = toggleEditProfileInfos end
	if doApplyProfileUpdate then modules.game_playerbar.doApplyProfileUpdate = doApplyProfileUpdate end
	if doApplyANewDescription then modules.game_playerbar.doApplyANewDescription = doApplyANewDescription end
	if toggleEditDescWindow then modules.game_playerbar.toggleEditDescWindow = toggleEditDescWindow end
	if doSetupUPLOADProfile then modules.game_playerbar.doSetupUPLOADProfile = doSetupUPLOADProfile end
	if toggleProfile then modules.game_playerbar.toggleProfile = toggleProfile end
end

local profileBar = {
	[0] = {
		image = "girl_player_bar",
		size = { height = 80, width = 80 }
	},
	[1] = {
		image = "boy_player_bar",
		size = { height = 80, width = 80 }
	}
}

local function safeSetTooltip(widget, text)
	if widget then
		widget:setTooltip(text)
	end
end

local function hideStatusTooltip()
	if statusTooltipWindow then
		statusTooltipWindow:hide()
	end
end

local function showStatusTooltip(widget)
	if not widget or not widget.statusTooltip then
		return
	end

	if not statusTooltipWindow then
		statusTooltipWindow = g_ui.createWidget("StatusIconTooltip", rootWidget)
		statusTooltipWindow:hide()
	end

	statusTooltipWindow.icon:setImageSource(widget.statusTooltip.icon)
	statusTooltipWindow.title:setText(widget.statusTooltip.title)
	statusTooltipWindow.desc:setText(widget.statusTooltip.desc)
	statusTooltipWindow:show()
	statusTooltipWindow:raise()

	local pos = g_window.getMousePosition()
	pos.x = g_window.getSize().width / 2 < pos.x and pos.x - statusTooltipWindow:getWidth() - 5 or pos.x + 5
	pos.y = g_window.getSize().height / 2 < pos.y and pos.y - statusTooltipWindow:getHeight() - 5 or pos.y + 5
	statusTooltipWindow:setPosition(pos)
end

local function setStatusTooltip(widget, icon, title, desc)
	if not widget then
		return
	end

	widget:setTooltip("")
	widget.tooltip = nil
	widget.statusTooltip = {
		icon = icon,
		title = title,
		desc = desc
	}
	widget.onHoverChange = function(self, hovered)
		if hovered then
			showStatusTooltip(self)
		else
			hideStatusTooltip()
		end
	end
	widget.onMouseMove = function(self)
		showStatusTooltip(self)
	end
end

local function setIconActive(widget, active)
	if widget then
		widget:setOpacity(active and 1 or 0.45)
	end
end

local updateProfileRuntimeStats
local getGenderData
local getPlayerSex

local function formatVipDays(days)
	days = math.max(0, math.floor(tonumber(days) or 0))
	return days == 1 and "1 dia" or days .. " dias"
end

local function updateBlessAndVip(db)
	if not playerBarWindow then
		return
	end

	local player = g_game.getLocalPlayer()
	local blessCount = tonumber(db and db.blessCount)
	if not blessCount and player and player.getBlessings then
		blessCount = tonumber(player:getBlessings()) or 0
	end
	blessCount = blessCount or 0
	local premiumDays = tonumber(db and db.premiumDay) or tonumber(playerVipDays) or 0
	local isVip = premiumDays >= 1 or (player and player.isPremium and player:isPremium())

	local blessIcon = playerBarWindow:recursiveGetChildById("blessIcon")
	local vipIcon = playerBarWindow:recursiveGetChildById("vipIcon")
	local profileBlessIcon = mainPanel and mainPanel:recursiveGetChildById("blessIcon")
	local profileVipIcon = mainPanel and mainPanel:recursiveGetChildById("vipIcon")
	local profileVipDaysLabel = mainPanel and mainPanel:recursiveGetChildById("vipDaysLabel")

	if profileVipDaysLabel then
		if profileVipDaysLabel.title then profileVipDaysLabel.title:setText(tr("VIP")) end
		if profileVipDaysLabel.info then
			profileVipDaysLabel.info:setText(premiumDays >= 1 and formatVipDays(premiumDays) or tr("Expirado"))
			profileVipDaysLabel.info:setColor(premiumDays >= 1 and "#30ff00" or "#ff6b6b")
		end
	end

	if blessCount >= 1 then
		if blessIcon then blessIcon:setImageSource("/modules/game_playerbar/images/icons/bless") end
		if profileBlessIcon then profileBlessIcon:setImageSource("/modules/game_playerbar/images/icons/bless") end
		setIconActive(blessIcon, true)
		setIconActive(profileBlessIcon, true)
		setStatusTooltip(blessIcon, "/modules/game_playerbar/images/icons/bless", tr("BLESS"), tr("Bless Remaining") .. ": " .. blessCount .. "\n" .. tr("Voce esta abencoado pela graca de Arceus!"))
		setStatusTooltip(profileBlessIcon, "/modules/game_playerbar/images/icons/bless", tr("BLESS"), tr("Bless Remaining") .. ": " .. blessCount .. "\n" .. tr("Voce esta abencoado pela graca de Arceus!"))
	else
		if blessIcon then blessIcon:setImageSource("/modules/game_playerbar/images/icons/bless_off") end
		if profileBlessIcon then profileBlessIcon:setImageSource("/modules/game_playerbar/images/icons/bless_off") end
		setIconActive(blessIcon, false)
		setIconActive(profileBlessIcon, false)
		setStatusTooltip(blessIcon, "/modules/game_playerbar/images/icons/bless_off", tr("BLESS"), tr("Voce nao possui bless ativa."))
		setStatusTooltip(profileBlessIcon, "/modules/game_playerbar/images/icons/bless_off", tr("BLESS"), tr("Voce nao possui bless ativa."))
	end

	if isVip then
		if vipIcon then vipIcon:setImageSource("/modules/game_playerbar/images/icons/vip") end
		if profileVipIcon then profileVipIcon:setImageSource("/modules/game_playerbar/images/profile/vip_emblem") end
		setIconActive(vipIcon, true)
		setIconActive(profileVipIcon, true)
		if premiumDays >= 1 then
			setStatusTooltip(vipIcon, "/modules/game_playerbar/images/icons/vip", tr("CONTA VIP"), tr("Dias restantes") .. ": " .. premiumDays .. "\n" .. tr("Todos os beneficios VIPs ativos para o seu personagem!"))
			setStatusTooltip(profileVipIcon, "/modules/game_playerbar/images/icons/vip", tr("CONTA VIP"), tr("Dias restantes") .. ": " .. premiumDays .. "\n" .. tr("Todos os beneficios VIPs ativos para o seu personagem!"))
		else
			setStatusTooltip(vipIcon, "/modules/game_playerbar/images/icons/vip", tr("CONTA VIP"), tr("Todos os beneficios VIPs ativos para o seu personagem!"))
			setStatusTooltip(profileVipIcon, "/modules/game_playerbar/images/icons/vip", tr("CONTA VIP"), tr("Todos os beneficios VIPs ativos para o seu personagem!"))
		end
	else
		if vipIcon then vipIcon:setImageSource("/modules/game_playerbar/images/icons/vip") end
		if profileVipIcon then profileVipIcon:setImageSource("/modules/game_playerbar/images/profile/vip_emblem_off") end
		setIconActive(vipIcon, false)
		setIconActive(profileVipIcon, false)
		setStatusTooltip(vipIcon, "/modules/game_playerbar/images/icons/vip", tr("Conta Free"), tr("Voce nao possui VIP ativo."))
		setStatusTooltip(profileVipIcon, "/modules/game_playerbar/images/icons/vip", tr("Conta Free"), tr("Voce nao possui VIP ativo."))
	end

	if db and db.gainRateXP and mainPanel and mainPanel.xpGainRateLabel and mainPanel.xpGainRateLabel.info then
		mainPanel.xpGainRateLabel.info:setText(tostring(db.gainRateXP) .. "%")
	end
end

local function applyPlayerbarProfileData(data)
	if not data then
		return false
	end

	local vipDays = tonumber(data.premiumDay) or tonumber(data.vipDays) or tonumber(data.vipPlus) or tonumber(data.premiumDays) or 0
	if data.storagesData then
		vipDays = math.max(vipDays, tonumber(data.storagesData.vipPlus) or tonumber(data.storagesData.vipplus) or 0)
	end
	if vipDays >= 65000 then
		vipDays = data.storagesData and (tonumber(data.storagesData.vipPlus) or tonumber(data.storagesData.vipplus) or 0) or 0
	end
	data.premiumDay = vipDays

	playerGender = getGenderData(getPlayerSex(g_game.getLocalPlayer()) or data.sex).name
	playerVipDays = vipDays
	vipPlayerDays = vipDays
	storagesData = data.storagesData or storagesData
	updateBlessAndVip(data)
	updateProfileRuntimeStats(g_game.getLocalPlayer())

	if doSetupSkills and data.skills and profileWindow then
		doSetupSkills(data.skills)
	end
	return true
end

function getOpCode(protocol, opcode, jsonData)
	local action = jsonData and jsonData.action
	local data = jsonData and jsonData.data
	if action ~= "RefreshAvatar" or not data then
		return false
	end

	return applyPlayerbarProfileData(data)
end

function getRawOpCode(protocol, opcode, buffer)
	local ok, jsonData = pcall(function()
		return json.decode(buffer)
	end)
	if not ok or not jsonData then
		return false
	end

	local data = jsonData.data or jsonData
	if jsonData.action and jsonData.action ~= "RefreshAvatar" then
		return false
	end
	return applyPlayerbarProfileData(data)
end

getPlayerSex = function(player)
    if not player then
        return 0
    end

    if player.getSex then
        local sex = tonumber(player:getSex())
		if sex == 0 or sex == 1 then
			return sex
		end
    end

	if player.getOutfit then
		local outfit = player:getOutfit()
		local lookType = outfit and (outfit.type or outfit.lookType)
		if lookType == femaleOutfit then
			return 0
		elseif lookType == maleOutfit then
			return 1
		end
	end

    return 1
end

getGenderData = function(value)
	if value == nil or value == "" then
		local player = g_game.getLocalPlayer()
		if player and player.getSex then
			value = player:getSex()
end
	end

	local sex = tonumber(value)
	if sex and genderName[sex] then
		return genderName[sex]
	end

	local text = tostring(value or playerGender or ""):lower()
	if text == "0" or text == "female" or text == "feminino" or text == "woman" or text == "mulher" then
		return genderName[0] or { name = "female" }
	end
	return genderName[1] or { name = "male" }
end

local function getProfileGenderName(player)
	local sex = getPlayerSex(player or g_game.getLocalPlayer())
	if sex == 0 or sex == 1 then
		local gender = getGenderData(sex)
		if gender and gender.name then
			playerGender = gender.name
			return gender.name
		end
	end

	if playerGender and (playerGender == "male" or playerGender == "female") then
		return playerGender
	end

	return getGenderData(nil).name
end

local function updateProfileImage(player)
    if not playerBarWindow then
        return
    end

    local profileWidget = playerBarWindow:recursiveGetChildById("perfilImage")
    if not profileWidget then
        return
    end

    local imageId = profileConfigStatus and profileConfigStatus.image or nil
	if (not imageId or imageId == "") and player and player.getSkillLevel and Skill and Skill.Profile then
		imageId = player:getSkillLevel(Skill.Profile)
	end
	imageId = imageId or 32

	if profileConfigStatus and profileConfigStatus.useUpload and profileImageBy64 then
		profileWidget:setImageSourceBase64(profileImageBy64)
	else
		profileWidget:setImageSource("/perfil/circle/" .. getProfileGenderName(player) .. "/" .. tostring(imageId))
	end

    local profileBase = playerBarWindow:recursiveGetChildById("perfilBase")
    if profileBase then
        profileBase:setImageSource("/perfil/circle/base")
    end

    local profileBorder = playerBarWindow:recursiveGetChildById("perfilBorder")
    if profileBorder then
        profileBorder:setImageSource("/perfil/border/" .. tostring(profileConfigStatus and profileConfigStatus.border or "none"))
    end
end

function updateProfileRuntimeStats(player)
	if not mainPanel then
		return
	end

	player = player or g_game.getLocalPlayer()
	if not player then
		return
	end

	if mainPanel.playerName then
		mainPanel.playerName:setText(player:getName())
	end
	if mainPanel.levelLabel and mainPanel.levelLabel.info then
		mainPanel.levelLabel.info:setText(doCorrectNumber(player:getLevel()))
	end
	if mainPanel.experienceLabel and mainPanel.experienceLabel.info then
		mainPanel.experienceLabel.info:setText(doCorrectNumber(player:getExperience()))
	end
	if mainPanel.speedLabel and mainPanel.speedLabel.info and player.getSpeed then
		mainPanel.speedLabel.info:setText(doCorrectNumber(player:getSpeed()))
	end
	if mainPanel.vigorLabel and mainPanel.vigorLabel.info and player.getStamina then
		local stamina = player:getStamina()
		local hours = math.floor(stamina / 60)
		local minutes = stamina % 60
		if minutes < 10 then
			minutes = "0" .. minutes
		end
		mainPanel.vigorLabel.info:setText(hours .. ":" .. minutes)
	end
end

local updateSideStatBars

local function onPlayerbarExperienceChange(player)
	updateProfileRuntimeStats(player)
	if player and player.getLevel and player.getLevelPercent then
		onLevelChange(player, player:getLevel(), player:getLevelPercent())
	end
end

local function onPlayerbarSpeedChange(player)
	updateProfileRuntimeStats(player)
end

local function onPlayerbarBaseSpeedChange(player)
	updateProfileRuntimeStats(player)
end

local function onPlayerbarStaminaChange(player)
	updateProfileRuntimeStats(player)
	updateSideStatBars(player)
end

local function onPlayerbarSkillChange(player, id, level, percent)
	if Skill and Skill.Fishing and id == Skill.Fishing then
		updateSideStatBars(player, level, percent)
	end
end

function init()
	pcall(function() ProtocolGame.unregisterExtendedOpcode(OPCODE) end)
	pcall(function() ProtocolGame.unregisterExtendedJSONOpcode(OPCODE) end)
	ProtocolGame.registerExtendedOpcode(OPCODE, getRawOpCode)
	ProtocolGame.registerExtendedJSONOpcode(OPCODE, getOpCode)
	connect(g_game, {
		onGameEnd = offline,
		onLogout = offline,
		onGameStart = onGameStart,
		onPlayerProfilesChange = updatePlayerProfiles
	})
	disconnect(LocalPlayer, {
		onHealthChange = onHealthChange,
		onLevelChange = onLevelChange,
		onBlessingsChange = onBlessingsChange,
		onPremiumChange = onPremiumChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onExperienceChange = onPlayerbarExperienceChange,
		onSpeedChange = onPlayerbarSpeedChange,
		onBaseSpeedChange = onPlayerbarBaseSpeedChange,
		onStaminaChange = onPlayerbarStaminaChange,
		onSkillChange = onPlayerbarSkillChange,
		onExtraSkillChange = onExtraSkillChange,
		onInventoryChange = onInventoryChange,
		onOutfitChange = updateProfileImage
	})
	connect(LocalPlayer, {
		onHealthChange = onHealthChange,
		onLevelChange = onLevelChange,
		onBlessingsChange = onBlessingsChange,
		onPremiumChange = onPremiumChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onExperienceChange = onPlayerbarExperienceChange,
		onSpeedChange = onPlayerbarSpeedChange,
		onBaseSpeedChange = onPlayerbarBaseSpeedChange,
		onStaminaChange = onPlayerbarStaminaChange,
		onSkillChange = onPlayerbarSkillChange,
		onExtraSkillChange = onExtraSkillChange,
		onInventoryChange = onInventoryChange,
		onOutfitChange = updateProfileImage
	})

	playerBarWindow = g_ui.displayUI("playerbar.otui")
	if not playerBarWindow then
		return
	end
	playerInfo = playerBarWindow
	playerBarWindow:setDraggable(true)
	playerBarWindow.onDragLeave = function(widget, droppedWidget, mousePos)
		g_settings.setNode("playerBar", {
			position = pointtostring(widget:getPosition()),
			visible = widget:isVisible()
		})
	end
	
	actionbarPanel = nil
	exportPlayerbarFunctions()
	setupProfileWindow()
	refresh()
	requestProfileData()
	
	-- Inicia o polling para atualizar pokébolas
	startPokebarPolling()
	
end

function onGameStart()
	refresh()
	bindProfileHotkey()
	requestProfileData()
end

function terminate()
	pcall(function() ProtocolGame.unregisterExtendedOpcode(OPCODE) end)
	pcall(function() ProtocolGame.unregisterExtendedJSONOpcode(OPCODE) end)
	disconnect(g_game, {
		onGameEnd = offline,
		onLogout = offline,
		onGameStart = onGameStart,
		onPlayerProfilesChange = updatePlayerProfiles
	})
	disconnect(LocalPlayer, {
		onHealthChange = onHealthChange,
		onLevelChange = onLevelChange,
		onBlessingsChange = onBlessingsChange,
		onPremiumChange = onPremiumChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onExperienceChange = onPlayerbarExperienceChange,
		onSpeedChange = onPlayerbarSpeedChange,
		onBaseSpeedChange = onPlayerbarBaseSpeedChange,
		onStaminaChange = onPlayerbarStaminaChange,
		onSkillChange = onPlayerbarSkillChange,
		onExtraSkillChange = onExtraSkillChange,
		onInventoryChange = onInventoryChange,
		onOutfitChange = updateProfileImage
	})

	-- Para o polling
	stopPokebarPolling()
	unbindProfileHotkey()
	
	if profileWindow then
		profileWindow:destroy()
	end
	if playerBarWindow then
		playerBarWindow:destroy()
	end
	if actionbarPanel then
		actionbarPanel:destroy()
	end
	if statusTooltipWindow then
		statusTooltipWindow:destroy()
	end

	playerBarWindow = nil
	profileWindow = nil
	actionbarPanel = nil
	statusTooltipWindow = nil
end

function doGetActionbarPanel()
	if actionbarPanel then
		return actionbarPanel
	end

	local rootPanel = modules.game_interface.getRootPanel()
	if rootPanel then
		actionbarPanel = g_ui.createWidget("UIWidget", rootPanel)
		actionbarPanel:setId("playerbarActionbarPanel")
		actionbarPanel:setSize({ width = 980, height = 62 })
		actionbarPanel:setFocusable(false)
		actionbarPanel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		actionbarPanel:addAnchor(AnchorBottom, "parent", AnchorBottom)
		actionbarPanel:setMarginBottom(0)
		actionbarPanel:setLayout(UIVerticalLayout.create(actionbarPanel))
		actionbarPanel:hide()
	end

	return actionbarPanel
end

function exportPlayerbarFunctions()
	if not modules or not modules.game_playerbar then
		return
	end

	modules.game_playerbar.doGetActionbarPanel = doGetActionbarPanel
end

function toggle()
	playerBarWindow:setVisible(not playerBarWindow:isVisible())
end

local function destroyOrphanProfileWindows()
	local rootPanel = modules.game_interface.getRootPanel()
	if not rootPanel then
		return
	end

	for _, child in ipairs(rootPanel:getChildren()) do
		if child:getId() == "profileWindow" and child ~= profileWindow then
			child:destroy()
		end
	end
end

function toggleEditWindow(status)
	if not mainPanel or not mainPanel.buttonEditDesc then
		return
	end

	if not status then
		g_effects.fadeOut(mainPanel.buttonEditDesc, 150)
	else
		g_effects.fadeIn(mainPanel.buttonEditDesc, 150)
	end
end

function toggleEditProfileWindow(status)
	if not buttonEditProfile then
		return
	end

	if not status then
		g_effects.fadeOut(buttonEditProfile, 150)
	else
		g_effects.fadeIn(buttonEditProfile, 150)
	end
end

function toggleEditDescWindow()
	if not panelDescription or not returnWindow then
		return
	end

	if panelDescription:isVisible() then
		g_effects.fadeOut(panelDescription, 150)
		g_effects.fadeOut(returnWindow, 150)
		scheduleEvent(function()
			panelDescription:hide()
			returnWindow:hide()
			if profileWindow then profileWindow:setWidth(500) end
			if profileWindow and profileWindow.topbar then profileWindow.topbar:setWidth(500) end
		end, 200)
	else
		if profileWindow then profileWindow:setWidth(734) end
		if profileWindow and profileWindow.topbar then profileWindow.topbar:setWidth(734) end
		panelDescription:show()
		panelDescription:raise()
		returnWindow:show()
		returnWindow:raise()
		if profileWindow.topbar then profileWindow.topbar:raise() end
		if profileWindow.closeWindow then profileWindow.closeWindow:raise() end
		if updateTimeRemaining then
			updateTimeRemaining()
		end
		if panelDescription.textEdit then
			panelDescription.textEdit:focus()
		end
		returnWindow.onClick = function() toggleEditDescWindow() end
		g_effects.fadeIn(panelDescription, 150)
		g_effects.fadeIn(returnWindow, 150)
	end
end

function toggleEditProfileInfos()
	if not panelEditProfile or not returnWindow then
		return
	end

	if panelEditProfile:isVisible() then
		g_effects.fadeOut(panelEditProfile, 150)
		g_effects.fadeOut(returnWindow, 150)
		scheduleEvent(function()
			panelEditProfile:hide()
			returnWindow:hide()
			if profileWindow then profileWindow:setWidth(500) end
			if profileWindow and profileWindow.topbar then profileWindow.topbar:setWidth(500) end
		end, 200)
	else
		if profileWindow then profileWindow:setWidth(734) end
		if profileWindow and profileWindow.topbar then profileWindow.topbar:setWidth(734) end
		panelEditProfile:show()
		panelEditProfile:raise()
		returnWindow:show()
		returnWindow:raise()
		if profileWindow.topbar then profileWindow.topbar:raise() end
		if profileWindow.closeWindow then profileWindow.closeWindow:raise() end
		returnWindow.onClick = function() toggleEditProfileInfos() end
		if doSetupImagesProfile then
			doSetupImagesProfile()
		end
		if doSetupSelectionEdit then
			doSetupSelectionEdit()
		end
		if doShowPanelEditProfile then
			doShowPanelEditProfile("images")
		end
		if panelEditProfile.panelSelection then
			panelEditProfile.panelSelection:raise()
			for _, child in ipairs(panelEditProfile.panelSelection:getChildren()) do
				child:raise()
				if child.icon then child.icon:raise() end
				if child.name then child.name:raise() end
				if child.arrow then child.arrow:raise() end
			end
		end
		if panelEditProfile.div then panelEditProfile.div:raise() end
		if panelEditProfile.applyButton then panelEditProfile.applyButton:raise() end
		if panelEditProfile.backgroundPanel then panelEditProfile.backgroundPanel:raise() end
		if panelEditProfile.editPanelOverlay then panelEditProfile.editPanelOverlay:raise() end
		if panelEditProfile.panelList then panelEditProfile.panelList:raise() end
		if panelEditProfile.panelListBorder then panelEditProfile.panelListBorder:raise() end
		if panelEditProfile.scrollBar then panelEditProfile.scrollBar:show(); panelEditProfile.scrollBar:raise() end
		if panelEditProfile.scrollBar2 then panelEditProfile.scrollBar2:raise() end
		if panelEditProfile.titlePanel then panelEditProfile.titlePanel:raise() end
		if panelEditProfile.iconPanel then panelEditProfile.iconPanel:raise() end
		if panelEditProfile.labelPanel then panelEditProfile.labelPanel:raise() end
		if profileWindow.topbar then profileWindow.topbar:raise() end
		if returnWindow then returnWindow:raise() end
		if profileWindow.closeWindow then profileWindow.closeWindow:raise() end
		g_effects.fadeIn(panelEditProfile, 150)
		g_effects.fadeIn(returnWindow, 150)
	end
end

function setupProfileWindow()
	destroyOrphanProfileWindows()
	if profileWindow then
		return
	end
	exportProfileFunctions()

	local rootPanel = modules.game_interface.getRootPanel()
	if rootPanel then
		for _, child in ipairs(rootPanel:getChildren()) do
			if child:getId() == "profileWindow" then
				child:destroy()
			end
		end
	end

	local ok, loadedProfileWindow = pcall(g_ui.loadUI, "profile", rootPanel)
	if not ok then
		profileWindow = nil
		return
	end
	profileWindow = loadedProfileWindow
	if not profileWindow then
		return
	end
	exportProfileFunctions()

	mainPanel = profileWindow.mainPanel
	returnWindow = profileWindow.returnWindow
	buttonEditProfile = profileWindow.buttonEditProfile
	panelDescription = profileWindow.panelDescriptionEdit
	panelEditProfile = profileWindow.panelEditProfile
	panelLoadImage = profileWindow.panelLoadImage
	panelConfirmLoadImage = profileWindow.panelConfirmLoadImage
	panelUPLOADImage = profileWindow.panelUPLOADImage
	panelSkills = profileWindow.panelSkillsInfo

	if mainPanel and mainPanel.buttonEditDesc then
		mainPanel.buttonEditDesc.onHoverChange = function(self, hovered)
			toggleEditWindow(hovered)
		end
	end

	if buttonEditProfile then
		buttonEditProfile.onHoverChange = function(self, hovered)
			toggleEditProfileWindow(hovered)
		end
	end

	if panelDescription then panelDescription:hide() end
	if panelEditProfile then panelEditProfile:hide() end
	if panelLoadImage then panelLoadImage:hide() end
	if panelConfirmLoadImage then panelConfirmLoadImage:hide() end
	if panelUPLOADImage then panelUPLOADImage:hide() end
	if returnWindow then returnWindow:hide() end
	if doSetupSelectionEdit and panelEditProfile then
		doSetupSelectionEdit()
	end
	toggleEditWindow(false)
	toggleEditProfileWindow(false)

	profileWindow:hide()
end

function toggleProfile()
	destroyOrphanProfileWindows()
	if not profileWindow then
		setupProfileWindow()
	end
	if not profileWindow then
		return
	end

	if profileWindow:isVisible() then
		profileWindow:hide()
		profileWindow:setWidth(500)
		if profileWindow.topbar then profileWindow.topbar:setWidth(500) end
		if panelDescription then panelDescription:hide() end
		if panelEditProfile then panelEditProfile:hide() end
		if panelLoadImage then panelLoadImage:hide() end
		if panelConfirmLoadImage then panelConfirmLoadImage:hide() end
		if panelUPLOADImage then panelUPLOADImage:hide() end
		if panelSkills then panelSkills:hide() end
		if returnWindow then returnWindow:hide() end
		return
	else
		local player = g_game.getLocalPlayer()
		if player and mainPanel then
			local playerName = mainPanel:recursiveGetChildById("playerName")
			local levelLabel = mainPanel:recursiveGetChildById("levelLabel")
			local experienceLabel = mainPanel:recursiveGetChildById("experienceLabel")
			if playerName then
				playerName:setText(player:getName())
			end
			if levelLabel and levelLabel.info then
				levelLabel.info:setText(doCorrectNumber(player:getLevel()))
			end
			if experienceLabel and experienceLabel.info then
				experienceLabel.info:setText(doCorrectNumber(player:getExperience()))
			end
		end

		profileWindow:show()
		profileWindow:raise()
		profileWindow:focus()
		requestProfileData()
	end
end

function bindProfileHotkey()
	exportProfileFunctions()
	if profileHotkeyBound then
		return
	end
	local rootPanel = modules.game_interface.getRootPanel()
	g_keyboard.unbindKeyDown("P", rootPanel)
	g_keyboard.bindKeyDown("P", function()
		if isTypingInAnyField() then
			return true
		end
		toggleProfile()
		return true
	end, rootPanel)
	profileHotkeyBound = true
end

function unbindProfileHotkey()
	local rootPanel = modules.game_interface.getRootPanel()
	g_keyboard.unbindKeyDown("P", rootPanel)
	profileHotkeyBound = false
end

function requestProfileData()
	updateBlessAndVip()

	local now = os.time()
	if now - lastProfileRequest < 3 then
		return
	end
	lastProfileRequest = now

	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedOpcode(OPCODE, json.encode({
			protocol = nil,
			data = "ShowProfile"
		}))
	end
end

function onBlessingsChange(player, blessings)
	updateBlessAndVip({ blessCount = blessings, premiumDay = playerVipDays })
end

function onPremiumChange(player, premium)
	updateBlessAndVip({ blessCount = player and player.getBlessings and player:getBlessings() or 0, premiumDay = playerVipDays })
end

updateSideStatBars = function(player, fishingLevelOverride, fishPercentOverride)
	if not playerBarWindow then
		return
	end

	player = player or g_game.getLocalPlayer()
	local fishTextLabel = playerBarWindow:recursiveGetChildById("fishTextLabel")
	local fishLabel = playerBarWindow:recursiveGetChildById("fishPercentLabel")
	local fishBar = playerBarWindow:recursiveGetChildById("fishBar")
	local fishFill = playerBarWindow:recursiveGetChildById("fishFill")
	local staminaTextLabel = playerBarWindow:recursiveGetChildById("staminaTextLabel")
	local staminaBar = playerBarWindow:recursiveGetChildById("staminaBar")
	local staminaFill = playerBarWindow:recursiveGetChildById("staminaFill")

	local fishingLevel = tonumber(fishingLevelOverride)
	local fishPercent = tonumber(fishPercentOverride)
	if player and player.getSkillLevel and Skill and Skill.Fishing then
		fishingLevel = fishingLevel or tonumber(player:getSkillLevel(Skill.Fishing))
		if not fishPercent and player.getSkillLevelPercent then
			fishPercent = tonumber(player:getSkillLevelPercent(Skill.Fishing)) or fishPercent
		end
	end
	fishingLevel = math.max(0, math.floor(fishingLevel or 0))
	fishPercent = math.max(0, math.min(100, tonumber(fishPercent) or 0))
	local fishDisplayPercent = math.floor(fishPercent)
	local fishRemainingPercent = math.max(0, 100 - fishDisplayPercent)
	local fishTooltipText = tr(fishingTooltip, fishingLevel, fishRemainingPercent, fishingLevel + 1)
	if fishLabel then
		fishLabel:setText(fishDisplayPercent .. "%")
	end
	if fishFill then
		local width = fishBar and fishBar:getWidth() or 120
		fishFill:setWidth(math.floor(width * fishPercent / 100))
	end
	safeSetTooltip(fishTextLabel, fishTooltipText)
	safeSetTooltip(fishLabel, fishTooltipText)
	safeSetTooltip(fishBar, fishTooltipText)
	safeSetTooltip(fishFill, fishTooltipText)

	local staminaMinutes = 1890
	local staminaPercent = 75
	if player and player.getStamina then
		staminaMinutes = tonumber(player:getStamina()) or 0
		staminaPercent = math.max(0, math.min(100, math.floor(staminaMinutes * 100 / 2520)))
	end
	local staminaHours = math.floor(staminaMinutes / 60)
	local staminaRemainder = staminaMinutes % 60
	local staminaTooltipText = tr(staminaTooltip, staminaHours, staminaRemainder, staminaPercent)
	if staminaFill then
		local width = staminaBar and staminaBar:getWidth() or 120
		staminaFill:setWidth(math.floor(width * staminaPercent / 100))
	end
	safeSetTooltip(staminaTextLabel, staminaTooltipText)
	safeSetTooltip(staminaBar, staminaTooltipText)
	safeSetTooltip(staminaFill, staminaTooltipText)
end
local function setupPlayerBarPosition()
	if not playerBarWindow then
		return
	end

	playerBarWindow:breakAnchors()
	playerBarWindow:setSize({ width = 260, height = 104 })

	local settings = g_settings.getNode("playerBar")
	if settings and settings.position then
		playerBarWindow:setPosition(topoint(settings.position))
	else
		playerBarWindow:setPosition({ x = 28, y = 74 })
	end
end
function refresh()
	if not g_game.isOnline() then
		return
	end

	local settings = g_settings.getNode("playerBar")
	local visible = true

	setupPlayerBarPosition()

	playerBarWindow:setVisible(visible)

	local player = g_game.getLocalPlayer()
	if player then
		if doLoadLocalProfileForCharacter then
			if not doLoadLocalProfileForCharacter() and doUseDefaultProfileForCharacter then
				doUseDefaultProfileForCharacter()
			end
		end
		local nameLabel = playerBarWindow:recursiveGetChildById("playerNameLabel")
		if nameLabel then
			nameLabel:setText(player:getName())
		end
		onFreeCapacityChange(player, player:getFreeCapacity())
		onHealthChange(player, player:getHealth(), player:getMaxHealth())
		onLevelChange(player, player:getLevel(), player:getLevelPercent())
		updateProfileRuntimeStats(player)
		updateSideStatBars(player)
		updateProfileImage(player)
		updateBlessAndVip()
		loadQuickSlotsItems()
		bindProfileHotkey()
	end
end

function offline()
	if not playerBarWindow then
		return
	end

	local settings = {
		position = pointtostring(playerBarWindow:getPosition()),
		visible = playerBarWindow:isVisible()
	}

	g_settings.setNode("playerBar", settings)
	playerBarWindow:hide()
	if actionbarPanel then
		actionbarPanel:hide()
	end
	if profileWindow then
		profileWindow:hide()
	end
	unbindProfileHotkey()
	
	-- Para os eventos de atualização
	stopPlayerbarPositionUpdate()
	stopPokebarPolling()
end

function onMiniWindowClose()
	return
end

function onHealthChange(localPlayer, health, maxHealth)
	if maxHealth < health then
		maxHealth = health
	end

	local healthBar = playerBarWindow and playerBarWindow:recursiveGetChildById("healthBar")
	if not healthBar then
		return
	end

	local healthPercent = maxHealth > 0 and math.floor(health / maxHealth * 100) or 0
	local healthPercentLabel = playerBarWindow:recursiveGetChildById("healthPercentLabel")
	healthBar:setValue(health, 0, maxHealth)
	healthBar:setTooltip(tr(healthTooltip, health, maxHealth))
	healthBar:setText("")
	if healthPercentLabel then
		healthPercentLabel:setText(healthPercent .. "%")
		healthPercentLabel:setTooltip(tr(healthTooltip, health, maxHealth))
		healthPercentLabel:raise()
	else
		healthBar:setText(healthPercent .. "%")
	end
end

function onLevelChange(localPlayer, value, percent)
	local lvlLabel = playerBarWindow:recursiveGetChildById("lvlLabel")
	local expBar = playerBarWindow:recursiveGetChildById("expBar")
	local expPercentLabel = playerBarWindow:recursiveGetChildById("expPercentLabel")
	if lvlLabel then
		lvlLabel:setText(tr("Lv. %d", value))
	end
	local barWidth = expBar and expBar:getWidth() or expBarWidth
	local fillWidth = math.floor(barWidth * math.max(0, math.min(percent, 100)) / 100)
	local xpFill = playerBarWindow:recursiveGetChildById("xpFill")
	if xpFill then
		xpFill:setWidth(fillWidth)
		xpFill:setImageClip({ x = 0, y = 0, width = fillWidth, height = expBarHeight })
		xpFill:setVisible(fillWidth > 0)
	end
	if expPercentLabel then
		local progress = math.max(0, math.min(100, tonumber(percent) or 0))
		expPercentLabel:setText(math.floor(progress) .. " XP")
	end
	if expBar then
		expBar:setTooltip(tr(experienceTooltip, percent, value + 1))
	end
	if expPercentLabel then
		expPercentLabel:setTooltip(tr(experienceTooltip, percent, value + 1))
	end
end

local pokeballCountCache = 0
local pokebarUpdateEvent = nil
local pokebarPollingEvent = nil

function updatePokeballCount()
	if not playerBarWindow or not playerBarWindow.pokeballs then
		return
	end
	
	local rootPanel = modules.game_interface.getRootPanel()
	local pokebar = rootPanel:recursiveGetChildById("panelBar")
	local pokeballCount = 0
	
	if pokebar then
		pokeballCount = pokebar:getChildCount()
	end
	
	-- Limita a 6 pokébolas para a exibição
	if pokeballCount > 6 then
		pokeballCount = 6
	end
	
	-- Só atualiza se o valor mudou
	if pokeballCountCache ~= pokeballCount then
		pokeballCountCache = pokeballCount
		playerBarWindow.pokeballs:setImageClip("0 " .. (imageClipPokeball[pokeballCount] or 0) .. " 82 12")
	end
end

function startPokebarPolling()
	-- Para o polling anterior se existir
	if pokebarPollingEvent then
		removeEvent(pokebarPollingEvent)
	end
	
	-- Inicia polling a cada 500ms para verificar mudanças na pokebar
	pokebarPollingEvent = scheduleEvent(function()
		updatePokeballCount()
		startPokebarPolling()
	end, 500)
end

function stopPokebarPolling()
	if pokebarPollingEvent then
		removeEvent(pokebarPollingEvent)
		pokebarPollingEvent = nil
	end
end

function updatePlayerbarPosition()
	return
end

function startPlayerbarPositionUpdate()
	if playerbarPositionUpdateEvent then
		removeEvent(playerbarPositionUpdateEvent)
	end
	
	playerbarPositionUpdateEvent = scheduleEvent(function()
		updatePlayerbarPosition()
		startPlayerbarPositionUpdate()
	end, 50)
end

function stopPlayerbarPositionUpdate()
	if playerbarPositionUpdateEvent then
		removeEvent(playerbarPositionUpdateEvent)
		playerbarPositionUpdateEvent = nil
	end
end

function onFreeCapacityChange(player, freeCapacity)
	if not playerBarWindow or not playerBarWindow.pokeballs then
		return
	end
	
	-- O polling vai cuidar de atualizar as pokébolas
end

function onExtraSkillChange(player, id, value)
	if id == Skill.Clan then
		playerBarWindow:setImageSource(imageBarPath .. (imageBar[value] or "default"))
	elseif id == Skill.Profile then
		if profileConfigStatus then
			profileConfigStatus.image = tostring(value or profileConfigStatus.image or 32)
			profileConfigStatus.useUpload = false
		end
		updateProfileImage(player or g_game.getLocalPlayer())
	end
	if Skill and Skill.Fishing and id == Skill.Fishing then
		updateSideStatBars(player)
	end
end

local function setupQuickSlotCallbacks(slot, slotConfig)
	local slotId = slotConfig.id
	local inventorySlot = slotConfig.inventorySlot

	function slot.onMouseRelease(widget, mousePosition, mouseButton)
		local player = g_game.getLocalPlayer()
		if not player then
			return false
		end

		if slotId == "quickSlot2" and mouseButton == MouseRightButton then
			local backItem = player:getInventoryItem(InventorySlotBack)
			if backItem then
				g_game.use(backItem)
				return true
			end
		end

		local item = player:getInventoryItem(inventorySlot)
		if item then
			if item:isMultiUse() then
				modules.game_interface.startUseWith(item, item:getCountOrSubType() or -1)
			else
				g_game.use(item)
			end
			return true
		end

		return false
	end

	slot.onTouchRelease = slot.onMouseRelease
end

local function getOrderItem()
	local player = g_game.getLocalPlayer()
	if player then
		local orderItem = player:getInventoryItem(InventorySlotExt2)
		if orderItem then
			return orderItem
		end
	end

	local inventoryPanel = nil
	if modules.game_inventory and modules.game_inventory.inventoryWindow then
		inventoryPanel = modules.game_inventory.inventoryWindow:getChildById('contentsPanel')
	end
	if inventoryPanel then
		local inventoryOrderSlot = inventoryPanel:getChildById('slot9')
		if inventoryOrderSlot then
			return inventoryOrderSlot:getItem()
		end
	end

	return nil
end

local function updateOrderSlot()
	if not playerBarWindow then
		return
	end

	local orderSlot = playerBarWindow:recursiveGetChildById("slot11")
	if not orderSlot then
		return
	end

	local orderItem = getOrderItem()
	if orderItem then
		orderSlot:setItem(Item.create(orderItem:getId(), orderItem:getCountOrSubType()))
	else
		orderSlot:setItem(nil)
	end
end

function loadQuickSlotsItems()
	local player = g_game.getLocalPlayer()
	if not player or not playerBarWindow then
		return
	end

	for _, slotConfig in ipairs(quickSlots) do
		local slot = playerBarWindow:recursiveGetChildById(slotConfig.id)
		if slot then
			local item = player:getInventoryItem(slotConfig.inventorySlot)
			if item then
				slot:setItem(Item.create(item:getId(), item:getCountOrSubType()))
			else
				slot:setItem(nil)
			end

			setupQuickSlotCallbacks(slot, slotConfig)
		end
	end

	updateOrderSlot()
end

function onInventoryChange(player, slot, item)
	if not playerBarWindow then
		return
	end

	-- Atualiza as pokébolas quando o inventário muda
	updatePokeballCount()

	if slot == 9 or slot == InventorySlotExt2 then
		updateOrderSlot()
	end

	local slotMapping = {
		[7] = "quickSlot1",
		[3] = "quickSlot2",
		[8] = "quickSlot3",
		[2] = "quickSlot4"
	}

	if slotMapping[slot] then
		local quickSlot = playerBarWindow:recursiveGetChildById(slotMapping[slot])
		if quickSlot then
			if item then
				quickSlot:setItem(Item.create(item:getId(), item:getCountOrSubType()))
			else
				quickSlot:setItem(nil)
			end
		end
	end
end
