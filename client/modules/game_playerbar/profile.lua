function doUpdateProgresslBar(bar, size, percentage)
    local Yhppc = math.floor(size * (1 - (percentage / 100)))
    local rect = { x = 0, y = 0, width = size - Yhppc + 1, height = 6 }
    bar:setImageClip(rect)
    bar:setImageRect(rect)
end

function doSetupSkillWidget(widget, id)
	local skills = {
		fish = {title = tr("Pesca"), icon = "images/profile/skills/fish", progress = "images/profile/skills/blue"},
		mining = {title = tr("Mineracao"), icon = "images/profile/skills/pick", progress = "images/profile/skills/alpha"},
		woodcutting = {title = tr("Lenhador"), icon = "images/profile/skills/tree", progress = "images/profile/skills/green"},
		construction = {title = tr("Construcao"), icon = "images/profile/skills/house", progress = "images/profile/skills/orange"},
		smithing = {title = tr("Ferreiro"), icon = "images/profile/skills/bigorn", progress = "images/profile/skills/alpha"}
	}

	if skills[id] then
		widget.title:setText(skills[id].title)
		widget.icon:setImageSource(skills[id].icon)
		widget.progress:setImageSource(skills[id].progress)
		doUpdateProgresslBar(widget.progress, 160, 1)
	end
end

function doSetupRegionCaughtWidget(widget, id)
	local regions = {
		kanto = {title = tr("KANTO")},
		johto = {title = tr("JOHTO")},
		hoenn = {title = tr("HOENN")}
	}

	if regions[id] then
		widget.title:setText(regions[id].title)
		widget.icon:setImageSource("images/profile/"..id)
	end
end

function doSetupClanWidget(widget, id)
	local attributes = {
		icon = {imageSource = "/images/ui/clans/icon_big/none"},
		title = {text = tr("TREINADOR POKEMON"), color = "#aeaeae"},
		levelLabel = {title = tr("Nivel"), info = "1"},
		experienceLabel = {title = tr("Experiencia")}
	}

	for attribute, values in pairs(attributes) do
		if widget[attribute].setImageSource and values.imageSource then
			widget[attribute]:setImageSource(values.imageSource)
		end
		if widget[attribute].setText and values.text then
			widget[attribute]:setText(values.text)
		end
		if widget[attribute].setColor and values.color then
			widget[attribute]:setColor(values.color)
		end
		if widget[attribute].title and values.title then
			widget[attribute].title:setText(values.title)
		end
		if widget[attribute].info and values.info then
			widget[attribute].info:setText(values.info)
		end
	end

	doUpdateProgresslBar(widget.progressbar.progress, 195, 1)
end

function getData(str)
    local ano, mes, dia = string.match(str, "(%d+)-(%d+)-(%d+)")
    return dia .. "/" .. mes .. "/" .. ano
end

function doSetupMainWidget(widget)
	local attributes = {
		playerName = {text = tr("Treinador")},
		vipIcon = {imageSource = "images/profile/vip_emblem_off", tooltip = tr("Conta Free")},
		levelLabel = {title = tr("Nivel"), info = "1"},
		experienceLabel = {title = tr("Experiencia")},
		vigorLabel = {title = tr("Vigor"), info = "42:00"},
		xpGainRateLabel = {title = tr("Bonus de XP"), info = "100%", color = "#30ff00"},
		vipDaysLabel = {title = tr("VIP"), info = (tonumber(playerVipDays) or 0) > 0 and ((tonumber(playerVipDays) == 1 and "1 dia") or (tostring(playerVipDays) .. " dias")) or tr("Expirado"), color = (tonumber(playerVipDays) or 0) > 0 and "#30ff00" or "#ff6b6b"},
		genderLabel = {title = tr("Genero"), info = tr("Indefinido"), color = "#ffe99d"},
		cityLabel = {title = tr("Cidade"), info = tr("Pallet Town")},
		speedLabel = {title = tr("Velocidade"), info = "300"},
		totalCatchesLabel = {title = tr("Capturas totais")},
		createDate = {title = tr("Data de criacao"), info = getData("2024-04-01 13:50:06")}
	}

	for attribute, values in pairs(attributes) do
		if widget[attribute].setText and values.text then
			widget[attribute]:setText(values.text)
		end
		if widget[attribute].setImageSource and values.imageSource then
			widget[attribute]:setImageSource(values.imageSource)
		end
		if widget[attribute].setTooltip and values.tooltip then
			widget[attribute]:setTooltip(values.tooltip)
		end
		if widget[attribute].title and values.title then
			widget[attribute].title:setText(values.title)
		end
		if widget[attribute].info and values.info then
			widget[attribute].info:setText(values.info)
		end
		if widget[attribute].info and values.color then
			widget[attribute].info:setColor(values.color)
		end
	end

	doUpdateProgresslBar(widget.progressExp.progress, 195, 1)
	doUpdateProgresslBar(widget.progressVigor.progress, 195, 1)
end

local function getProfileSexData(value)
	local sex
	local player = g_game.getLocalPlayer()
	if player then
		if player.getSex then
			sex = tonumber(player:getSex())
		end
		if (sex ~= 0 and sex ~= 1) and player.getOutfit then
			local outfit = player:getOutfit()
			local lookType = outfit and (outfit.type or outfit.lookType)
			if lookType == 3116 then
				sex = 0
			elseif lookType == 3119 then
				sex = 1
			end
		end
	end

	if sex == nil then
		sex = tonumber(value)
	end
	if sex ~= 0 and sex ~= 1 then
		sex = 1
	end

	local gender = genderName and genderName[sex]
	if not gender then
		gender = sex == 0 and { name = "female", subName = "Female", color = "#ff99cc" } or { name = "male", subName = "Male", color = "#9dd6ff" }
	end

	playerGender = gender.name
	return sex, gender
end

local profileStorageKey = "playerbarProfileByCharacter"

local function getProfileCharacterKey()
	local player = g_game.getLocalPlayer()
	if not player then
		return nil
	end

	local world = g_game.getWorldName and g_game.getWorldName() or ""
	return string.lower(tostring(world) .. ":" .. player:getName())
end

local function getProfileStorage()
	return g_settings.getNode(profileStorageKey) or {}
end

local function saveProfileStorage(storage)
	g_settings.setNode(profileStorageKey, storage or {})
end

local function setProfileDescriptionText(text)
	text = text or ""
	if panelDescription and panelDescription.textEdit then
		panelDescription.textEdit:setText(text)
	end
	if mainPanel and mainPanel.desc then
		if text ~= "" then
			if #text > 75 then
				mainPanel.desc:setText(string.sub(text, 1, 75) .. "...")
				if mainPanel.buttonEditDesc then mainPanel.buttonEditDesc:setTooltip(text) end
			else
				mainPanel.desc:setText(text)
				if mainPanel.buttonEditDesc then mainPanel.buttonEditDesc:setTooltip(nil) end
			end
			mainPanel.desc:setColor("#e9e9e9")
		else
			mainPanel.desc:setText(tr("Sem descricao"))
			mainPanel.desc:setColor("#8a8a8a")
			if mainPanel.buttonEditDesc then mainPanel.buttonEditDesc:setTooltip(nil) end
		end
	end
end

function doApplyCurrentProfileVisuals()
	local _, gender = getProfileSexData(nil)
	local image = tostring(profileConfigStatus and profileConfigStatus.image or "1")
	local border = tostring(profileConfigStatus and profileConfigStatus.border or "none")
	local useUpload = profileConfigStatus and profileConfigStatus.useUpload and profileImageBy64

	local function applyImage(widget)
		if not widget then return end
		if useUpload then
			widget:setImageSourceBase64(profileImageBy64)
		else
			widget:setImageSource("/perfil/circle/" .. gender.name .. "/" .. image)
		end
	end

	local function applyBorder(widget)
		if widget then
			widget:setImageSource("/perfil/border/" .. border)
		end
	end

	if profileWindow then
		applyImage(profileWindow.perfilImage)
		applyBorder(profileWindow.perfilBorder)
	end
	if panelEditProfile then
		applyImage(panelEditProfile.perfilImage)
		applyBorder(panelEditProfile.perfilBorder)
	end
	if playerInfo then
		applyImage(playerInfo.perfilImage)
		applyBorder(playerInfo.perfilBorder)
	end
end

function doSaveLocalProfileForCharacter()
	local key = getProfileCharacterKey()
	if not key then return end

	local storage = getProfileStorage()
	storage[key] = storage[key] or {}
	storage[key].image = tostring(profileConfigStatus and profileConfigStatus.image or "1")
	storage[key].border = tostring(profileConfigStatus and profileConfigStatus.border or "none")
	storage[key].useUpload = profileConfigStatus and profileConfigStatus.useUpload or false
	storage[key].description = panelDescription and panelDescription.textEdit and panelDescription.textEdit:getText() or storage[key].description or ""
	saveProfileStorage(storage)
end

function doLoadLocalProfileForCharacter()
	local key = getProfileCharacterKey()
	if not key then return false end

	local config = getProfileStorage()[key]
	if not config then return false end

	profileConfigStatus.image = tostring(config.image or profileConfigStatus.image or "1")
	profileConfigStatus.border = tostring(config.border or profileConfigStatus.border or "none")
	profileConfigStatus.useUpload = config.useUpload == true
	setProfileDescriptionText(config.description or "")
	doApplyCurrentProfileVisuals()
	return true
end

function doUseDefaultProfileForCharacter()
	local player = g_game.getLocalPlayer()
	local image = "1"
	if player and player.getSkillLevel and Skill and Skill.Profile then
		image = tostring(player:getSkillLevel(Skill.Profile) or image)
	end

	profileConfigStatus.image = image
	profileConfigStatus.border = "none"
	profileConfigStatus.useUpload = false
	setProfileDescriptionText("")
	doApplyCurrentProfileVisuals()
end

local function selectProfileBorderWidget(widget)
	if not widget or widget.slotIMG == nil then return end
	if widget.unlocked == false then
		return
	end
	if panelEditProfile and panelEditProfile.perfilBorder then
		panelEditProfile.perfilBorder:setImageSource("/perfil/border/" .. tostring(widget.slotIMG))
	end
	profileConfigStatus.border = tostring(widget.slotIMG)
	if widget.focus then
		widget:focus()
	end
end

local function selectProfileImageWidget(widget)
	if not widget or widget.uploaded == nil then return end
	if widget.unlocked == false then
		return
	end
	if widget.uploaded then
		if panelEditProfile and panelEditProfile.perfilImage then
			panelEditProfile.perfilImage:setImageSourceBase64(widget.image)
		end
		profileConfigStatus.image = "1"
	else
		if panelEditProfile and panelEditProfile.perfilImage then
			panelEditProfile.perfilImage:setImageSource(widget.image)
		end
		profileConfigStatus.image = tostring(widget.slotIMG)
	end
	profileConfigStatus.useUpload = widget.uploaded
	if widget.focus then
		widget:focus()
	end
end

function updatePlayerProfiles(id, townId, kantoCaughts, johtoCaughts, hoennCaughts, totalCaughts, pokeTeam, profileImage, profileEdge, profileEffect, profileBackground, profileDescription, youtube, twitch, createDate, sex, clan, clanRank, profileUploaded, profileLastUpload, useUploadImg)
    local function updateInfo(info, text)
        if text ~= "" then
            info:setText(text)
        end
    end
	local sexId, gender = getProfileSexData(sex)
	
	if id ~= "" then
		profileId = id
	else
		profileId = nil
	end
	
	if profileUploaded ~= "" then
		profileImageBy64 = profileUploaded
	else
		profileImageBy64 = nil
	end
	
	if profileLastUpload ~= "" then
		profileLastUpdate = profileLastUpload
	else
		profileLastUpdate = nil
	end
	
	if useUploadImg ~= "" then
		profileUseUploadImg = useUploadImg
	else
		profileUseUploadImg = nil
	end
	profileConfigStatus.image = tostring((profileImage ~= "" and profileImage) or profileConfigStatus.image or "1")
	profileConfigStatus.border = tostring((profileEdge ~= "" and profileEdge) or profileConfigStatus.border or "none")
	profileConfigStatus.useUpload = not (useUploadImg == "" or useUploadImg == "-1" or profileImageBy64 == nil)

    local function updateImage(image, source, sex, img)
        if source ~= "" then
			if sex then
				if useUploadImg == "-1" or profileImageBy64 == nil then
					image:setImageSource(source..gender.name.."/"..img)
				else
					image:setImageSourceBase64(profileImageBy64)
				end
			else
				image:setImageSource(source.."/"..img)
			end
		end
    end

    updateInfo(mainPanel.cityLabel.info, townsName[tonumber(townId)])
    updateInfo(profileWindow.caughtPanel.kanto.info, kantoCaughts)
    updateInfo(profileWindow.caughtPanel.johto.info, johtoCaughts)
    updateInfo(profileWindow.caughtPanel.hoenn.info, hoennCaughts)
    updateInfo(mainPanel.totalCatchesLabel.info, totalCaughts)
	
    updateImage(profileWindow.perfilImage, '/perfil/circle/', sexId, profileImage)
    updateImage(profileWindow.perfilBorder, '/perfil/border/', nil, profileEdge)
	
    updateImage(playerInfo.perfilImage, '/perfil/circle/', sexId, profileImage)
    updateImage(playerInfo.perfilBorder, '/perfil/border/', nil, profileEdge)
	
    updateInfo(mainPanel.createDate.info, getData(createDate))
	
	local clanName
	local clanDesc

    if gender then
        updateInfo(mainPanel.genderLabel.info, tr(gender.subName))
        mainPanel.genderLabel.info:setColor(gender.color)
    end
    if clan ~= "" and clanRank ~= "" and clan ~= "-1" and clanRank ~= "-1"  then
		local clanImage = clanNameById[tonumber(clan)]
		local clanTooltip
		if sexId == 1 then
			clanTooltip = lookClans[tonumber(clan)][tonumber(clanRank)]
		else
			clanTooltip = lookClansShe[tonumber(clan)][tonumber(clanRank)]
		end
		profileWindow.clanPanel.icon:setImageSource("/images/ui/clans/icon_big/"..clanImage)
		clanName = clanImage
		clanDesc = clanTooltip
		
		profileWindow.clanPanel.icon:setTooltip(clanTooltip)
		
		if #clanTooltip > 18 then
			profileWindow.clanPanel.title:setFont('sono bold 14')
		else
			profileWindow.clanPanel.title:setFont('sono bold 16')
		end
		
		profileWindow.clanPanel.title:setText(string.upper(clanTooltip))
		profileWindow.clanPanel.title:setColor(clanColor[tonumber(clan)])
	else
		profileWindow.clanPanel.icon:setImageSource("/images/ui/clans/icon_big/none")
		profileWindow.clanPanel.icon:setTooltip(tr("Treinador Pokemon"))
		profileWindow.clanPanel.title:setText(string.upper(tr("Treinador Pokemon")))
		profileWindow.clanPanel.title:setColor("#a4a4a4")
		
		clanName = "none"
		clanDesc = "Treinador Pokemon"
	end
	
	setProfileDescriptionText(profileDescription)

	local player = g_game.getLocalPlayer()
	if clanName == "seavell" then
		clanName = "seavel"
	end

	g_game.setDiscordRPC(player:getName(), player:getLevel(), gender.name.."_"..profileImage, player:getName(), clanName, clanDesc, "World: "..g_game.getWorldName())

	--SETUP PANEL
	if not doLoadLocalProfileForCharacter() then
		doUseDefaultProfileForCharacter()
	end
	doSetupImagesProfile()
	doSetupBordersProfile()
	doShowPanelEditProfile("images")
	if not doLoadLocalProfileForCharacter() then
		doUseDefaultProfileForCharacter()
	end
end

-- DESCRIPTION EDIT
local lastExecutionDescTime = os.time()
-- local blockTime = 60 * 2
local blockTime = 5

function getTimeRemaining()
    local currentTime = os.time()
    if currentTime - lastExecutionDescTime < blockTime then
        return blockTime - (currentTime - lastExecutionDescTime)
    else
        return 0
    end
end

function updateTimeRemaining()
    local timeRemaining = getTimeRemaining()
    local minutes = math.floor(timeRemaining / 60)
    local seconds = timeRemaining % 60
    
    if timeRemaining > 0 then
		panelDescription.descTime:setText(minutes.." "..tr("minutos").." "..tr("e").." "..seconds.." "..tr("segundos")..".")
        panelDescription.applyButton:setPhantom(true)
        panelDescription.applyButton:setOpacity(0.5)
		panelDescription.applyButton:setImageColor("#8f8f8f")
		scheduleEvent(updateTimeRemaining, 1000)
	else
		panelDescription.descTime:setText(tr("Tudo pronto para atualizar!"))
		panelDescription.applyButton:setOpacity(1)
		panelDescription.applyButton:setImageColor("#b9b9b9")
		panelDescription.applyButton:setPhantom(false)
    end
end


function doApplyANewDescription()
    local currentTime = os.time()
    if currentTime - lastExecutionDescTime < blockTime then
		if panelDescription:isVisible() then
			updateTimeRemaining()
		end
        return false
    end

    local text = panelDescription.textEdit:getText()

    if not checkLength(text, 1, 500) then -- tamanho da letra
        doLightLabel(panelDescription.descEdit)
        return false
    end
    if not checkContent(text) then -- palavras ofensivas
        doLightLabel(panelDescription.descEdit3)
        return false
    end
    if not checkPersonalInfo(text) then -- informa��es pessoais
        doLightLabel(panelDescription.descEdit5)
        return false
    end

	local tableCode = {
		protocol = text,
		data = "UpdateDescription",
		character = g_game.getLocalPlayer() and g_game.getLocalPlayer():getName() or nil,
	}
	local protocolGame = g_game.getProtocolGame()
	setProfileDescriptionText(text)
	doSaveLocalProfileForCharacter()
	if protocolGame then
		protocolGame:sendExtendedOpcode(113, json.encode(tableCode))
		toggleEditDescWindow()
	end

    lastExecutionDescTime = currentTime
    return true
end



local stepsLabel = 0
local lightLabelEvent = nil
local lastWidget = nil

function doLightLabel(widget)
	stepsLabel = 0
	if lastWidget then
		lastWidget:setColor("#ffffff")
		lastWidget = nil
	end
	
    local function LightEvent()
		stepsLabel = stepsLabel + 1
		
		if lightLabelEvent then
			removeEvent(lightLabelEvent)
			lightLabelEvent = nil
		end

		if stepsLabel % 2 == 0 then
			widget:setColor("#ffffff")
		else
			widget:setColor("#e25050")
		end
		
		if stepsLabel < 6 then
			lightLabelEvent = scheduleEvent(LightEvent, 150)
		else
			widget:setColor("#ffffff")
		end
	end
	
    if lightLabelEvent then
        removeEvent(lightLabelEvent)
        lightLabelEvent = nil
    end
	
	lastWidget = widget
	LightEvent()
end

function doUpdateProfileXpBar(percent, text)
	mainPanel.progressExp.base:setTooltip(text)
    doUpdateProgresslBar(mainPanel.progressExp.progress, 195, percent)
end

function doSetupSkillLevel(widget, level, percent)
    local textDesc = level.."[P]("..percent.."%)[P/]"
    setColoredText(widget, textDesc, "#ffffff")
end

function doSetupSkills(data)
	local player = g_game.getLocalPlayer()
	if not player then return end
	
	for key, table in pairs(data) do
		local Level = player:getSkillLevel(skillByAbility[key])
		local Exp = table.exp
		local RequireExp = table.nextLevelExp
		local Percent = calculatePercentage(Exp, RequireExp)
		
		if key == "Fishing" then
			profileWindow.skillsPanel.fish.icon.onClick = function() doShowSkillInformations("fishing") end
		elseif key == "Smithing" then
			doSetupSkillLevel(profileWindow.skillsPanel.smithing.info, Level, Percent)
			doUpdateProgresslBar(profileWindow.skillsPanel.smithing.progress, 160, Percent)
			profileWindow.skillsPanel.smithing.icon.onClick = function() doShowSkillInformations("smithing") end
		elseif key == "Construction" then
			doSetupSkillLevel(profileWindow.skillsPanel.construction.info, Level, Percent)
			doUpdateProgresslBar(profileWindow.skillsPanel.construction.progress, 160, Percent)
			profileWindow.skillsPanel.construction.icon.onClick = function() doShowSkillInformations("construction") end
		elseif key == "Woodcutting" then
			doSetupSkillLevel(profileWindow.skillsPanel.woodcutting.info, Level, Percent)
			doUpdateProgresslBar(profileWindow.skillsPanel.woodcutting.progress, 160, Percent)
			profileWindow.skillsPanel.woodcutting.icon.onClick = function() doShowSkillInformations("woodcutting") end
		elseif key == "Mining" then
			doSetupSkillLevel(profileWindow.skillsPanel.mining.info, Level, Percent)
			doUpdateProgresslBar(profileWindow.skillsPanel.mining.progress, 160, Percent)
			profileWindow.skillsPanel.mining.icon.onClick = function() doShowSkillInformations("mining") end
		elseif key == "Total Level" then
		end
	end
end

function doSetupMiningPanel(list)
	local panel = skillMiningInfos.panel[list]

	if panel then
		local nameTr = tr(doCorrectString(list))
		panelSkills.title:setText(string.upper(nameTr))
		panelSkills.panel:destroyChildren()
		for key, button in pairs(panel) do
			local widget = g_ui.createWidget('widgetSkillSelection', panelSkills.panel)
			widget.level:setText(button.level)
			widget.name:setText(button.name)

			local item = skillsItem[button.name]
			if item then
				widget.slotItem:setItemId(item)
				widget.slotItem:setItemCount(100)
				widget.baseSlot:setTooltip(button.name)
			else
				widget.slotItem:setImageSource("images/profile/skills/icons/unknown")
				widget.baseSlot:setTooltip(tr("Undefined"))
			end

			if button.required then
				for key, button in pairs(button.required) do
					-- print(button[1], button[2])
					local slotItem = g_ui.createWidget('skillItemPreview2', widget.panelItem)
	
					local item = skillsItem[button[1]]
					if item then
						slotItem:setItemId(item)
						slotItem:setItemCount(button[2])
						slotItem.slot:setTooltip(button[2].."X "..button[1])
					else
						slotItem.slot:setImageSource("images/profile/skills/icons/unknown")
						slotItem.slot:setTooltip(tr("Undefined"))
					end
				end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
			
			if button.pick then
				local isca = g_ui.createWidget('skillItemPreview', widget.panelItem)

				local item = skillsItem[button.pick]
			    if item then
			    	isca:setItemId(item)
			    	isca.slot:setTooltip(button.pick)
			    else
			    	isca.slot:setImageSource("images/profile/skills/icons/unknown")
			    	isca.slot:setTooltip(tr("Undefined"))
			    end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
		end
	end
end

function doSetupConstructionPanel(list)
	local panel = skillConstructionInfos.panel[list]

	if panel then
		local nameTr = tr(doCorrectString(list))
		panelSkills.title:setText(string.upper(nameTr))
		panelSkills.panel:destroyChildren()
		for key, button in pairs(panel) do
			local widget = g_ui.createWidget('widgetSkillSelection', panelSkills.panel)
			widget.level:setText(button.level)
			widget.name:setText(button.name)

			local item = skillsItem[button.name]
			if item then
				widget.slotItem:setItemId(item)
				widget.slotItem:setItemCount(100)
				widget.baseSlot:setTooltip(button.name)
			else
				widget.slotItem:setImageSource("images/profile/skills/icons/unknown")
				widget.baseSlot:setTooltip(tr("Undefined"))
			end

			if button.required then
				for key, button in pairs(button.required) do
					-- print(button[1], button[2])
					local slotItem = g_ui.createWidget('skillItemPreview2', widget.panelItem)
	
					local item = skillsItem[button[1]]
					if item then
						slotItem:setItemId(item)
						slotItem:setItemCount(button[2])
						slotItem.slot:setTooltip(button[2].."X "..button[1])
					else
						slotItem.slot:setImageSource("images/profile/skills/icons/unknown")
						slotItem.slot:setTooltip(tr("Undefined"))
					end
				end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
			
			if button.pick then
				local isca = g_ui.createWidget('skillItemPreview', widget.panelItem)

				local item = skillsItem[button.pick]
			    if item then
			    	isca:setItemId(item)
			    	isca.slot:setTooltip(button.pick)
			    else
			    	isca.slot:setImageSource("images/profile/skills/icons/unknown")
			    	isca.slot:setTooltip(tr("Undefined"))
			    end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
		end
	end
end

function doSetupWoodcuttingPanel(list)
	local panel = skillWoodcuttingInfos.panel[list]

	if panel then
		local nameTr = tr(doCorrectString(list))
		panelSkills.title:setText(string.upper(nameTr))
		panelSkills.panel:destroyChildren()
		for key, button in pairs(panel) do
			local widget = g_ui.createWidget('widgetSkillSelection', panelSkills.panel)
			widget.level:setText(button.level)
			widget.name:setText(button.name)
			
			local item = skillsItem[button.name]
			if item then
				widget.slotItem:setItemId(item)
				widget.slotItem:setItemCount(100)
				widget.baseSlot:setTooltip(button.name)
			else
				widget.slotItem:setImageSource("images/profile/skills/icons/unknown")
				widget.baseSlot:setTooltip(tr("Undefined"))
			end
			
			if button.pick then
				local isca = g_ui.createWidget('skillItemPreview', widget.panelItem)

				local item = skillsItem[button.pick]
			    if item then
			    	isca:setItemId(item)
			    	isca.slot:setTooltip(button.pick)
			    else
			    	isca.slot:setImageSource("images/profile/skills/icons/unknown")
			    	isca.slot:setTooltip(tr("Undefined"))
			    end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
		end
	end
end

function doSetupSmithingPanel(list)
	local panel = skillSmithingInfos.panel[list]

	if panel then
		local nameTr = tr(doCorrectString(list))
		panelSkills.title:setText(string.upper(nameTr))
		panelSkills.panel:destroyChildren()
		for key, button in pairs(panel) do
			local widget = g_ui.createWidget('widgetSkillSelection', panelSkills.panel)
			widget.level:setText(button.level)
			widget.name:setText(button.name)
			
			local item = skillsItem[button.name]
			if item then
				widget.slotItem:setItemId(item)
				widget.slotItem:setItemCount(100)
				widget.baseSlot:setTooltip(button.name)
			else
				widget.slotItem:setImageSource("images/profile/skills/icons/unknown")
				widget.baseSlot:setTooltip(tr("Undefined"))
			end
			
			if button.pick then
				local isca = g_ui.createWidget('skillItemPreview', widget.panelItem)

				local item = skillsItem[button.pick]
			    if item then
			    	isca:setItemId(item)
			    	isca.slot:setTooltip(button.pick)
			    else
			    	isca.slot:setImageSource("images/profile/skills/icons/unknown")
			    	isca.slot:setTooltip(tr("Undefined"))
			    end
				
				local buttonsCount = widget.panelItem:getChildCount()
				local realSizePanelButtons = (buttonsCount * 37)
				widget.panelItem:setWidth(realSizePanelButtons - 5)
			end
		end
	end
end

function doSetupFishPanel(list)
	local panel = skillFishInfos.panel[list]

	if panel then
		local nameTr = tr(doCorrectString(list))
		panelSkills.title:setText(string.upper(nameTr))
		panelSkills.panel:destroyChildren()
		
		for key, button in pairs(panel) do
			local widget = g_ui.createWidget('widgetSkillSelection', panelSkills.panel)
			widget.level:setText("1")
			
			if list == "pokemons" then
				widget.pokemon:setImageSource("/pokemon/regular/"..string.lower(button.pokemon))
				widget.name:setText(button.pokemon)
				
				if button.isca then
					for key, name in pairs(button.isca) do
						local isca = g_ui.createWidget('skillItemPreview', widget.panelItem)

						local item = skillsItem[name]
				        if item then
				        	isca:setItemId(item)
				        	isca.slot:setTooltip(name)
				        else
				        	isca.slot:setImageSource("images/profile/skills/icons/unknown")
				        	isca.slot:setTooltip(tr("Undefined"))
				        end
					end
					local buttonsCount = widget.panelItem:getChildCount()
					local realSizePanelButtons = (buttonsCount * 37)
					widget.panelItem:setWidth(realSizePanelButtons - 5)
				end
				
				widget.level:setText(button.level)
			elseif list == "comuns" then
				local item = skillsItem[button.name]
				widget.name:setText(button.name)

				if item then
					widget.slotItem:setItemId(item)
				else
					widget.slotItem:setBackgroundColor("red")
				end
				
				widget.level:setVisible(false)
				widget.baseSlot:setMarginLeft(-8)
			elseif list == "lures" then
				local item = skillsItem[button.isca]
				widget.name:setText(button.isca)
				if item then
					widget.slotItem:setItemId(item)
				else
					widget.slotItem:setBackgroundColor("red")
				end

	            if button.quality == 100 then
	            	widget.star.progress:setImageSource("images/bars/stars_max")
	            else
	            	widget.star.progress:setImageSource("images/bars/stars_progress")
	            end
	            
                local starPercent = math.floor(54 * (1 - (button.quality / 100)))
                local starRect = { x = 0, y = 0, width = 54 - starPercent + 1, height = 11 }
                widget.star.progress:setImageClip(starRect)
                widget.star.progress:setImageRect(starRect)
				widget.star:setVisible(true)
				
				widget.level:setVisible(false)
				widget.baseSlot:setMarginLeft(-8)
			elseif list == "rods" then
				local item = skillsItem[button.rod]
				widget.name:setText(button.rod)
				
				if item then
					widget.slotItem:setItemId(item)
				else
					widget.slotItem:setBackgroundColor("red")
				end

	            if button.quality == 100 then
	            	widget.star.progress:setImageSource("images/bars/stars_max")
	            else
	            	widget.star.progress:setImageSource("images/bars/stars_progress")
	            end
	            
                local starPercent = math.floor(54 * (1 - (button.quality / 100)))
                local starRect = { x = 0, y = 0, width = 54 - starPercent + 1, height = 11 }
                widget.star.progress:setImageClip(starRect)
                widget.star.progress:setImageRect(starRect)
				widget.star:setVisible(true)
				widget.level:setVisible(false)
				widget.baseSlot:setMarginLeft(-8)
			end
		end
	end
end

function doShowSkillInformations(skill)
	local skillInfos = {
		fishing = skillFishInfos,
		smithing = skillSmithingInfos,
		construction = skillConstructionInfos,
		woodcutting = skillWoodcuttingInfos,
		mining = skillMiningInfos
	}

	local panel = skillInfos[skill]
	panelSkills.banner:setImageSource("images/profile/skills/banner/"..panel.banner)

	panelSkills.panelButtons:destroyChildren()
	for key, button in pairs(panel.buttons) do
		local widget = g_ui.createWidget('buttonSkillSelection', panelSkills.panelButtons)

		if button.iconType == "IMAGE" then
			widget.slotImage:setImageSource("images/profile/skills/icons/"..button.icon)
		elseif button.iconType == "ITEM" then
			widget.slotItem:setItemId(button.icon)
			widget.slotItem:setItemCount(100)
		end
		
		if button.width then
			widget:setWidth(button.width)
		end

		widget.name:setText(tr(button.name))
		widget.onClick = button.action
	end
	if panel.width then
		panelSkills.panelButtons:setWidth(panel.width)
	else
		local buttonsCount = panelSkills.panelButtons:getChildCount()
		local realSizePanelButtons = (buttonsCount * 110)
		panelSkills.panelButtons:setWidth(realSizePanelButtons - 5)
	end

	panel.firstPanel()
	toggleSkillsPanel(true)
end

function toggleSkillsPanel(status)
  if not status or panelSkills:isVisible() then
    g_effects.fadeOut(panelSkills, 150)
    g_effects.fadeOut(returnWindow, 150)
    scheduleEvent(function() 
      panelSkills:hide()
	  returnWindow:hide()
    end, 200)
  else
    panelSkills:show()
	returnWindow:show()
	returnWindow.onClick = function() toggleSkillsPanel(false) end
    g_effects.fadeIn(panelSkills, 150)
    g_effects.fadeIn(returnWindow, 150)
  end
end



-- EDIT PROFILE WINDOW
  
editListButton = {
	{icon = 1, name = "Imagens", action = function() doShowPanelEditProfile("images") end, enabled = true},
	{icon = 2, name = "Bordas", action = function() doSetupBordersProfile() doShowPanelEditProfile("borders") end, enabled = true},
	{icon = 3, name = "Efeitos", action = function() end, enabled = false},
	{icon = 4, name = "Backgrounds", action = function() end, enabled = false},
}

function doShowPanelEditProfile(id)
	panelEditProfile.panelList:setVisible(false)
	panelEditProfile.scrollBar:setVisible(false)
	panelEditProfile.panelListBorder:setVisible(false)
	panelEditProfile.scrollBar2:setVisible(false)
	
	if id == "images" then
		if doSetupImagesProfile and panelEditProfile.panelList:getChildCount() == 0 then
			doSetupImagesProfile()
		end
		panelEditProfile.panelList:setVisible(true)
		panelEditProfile.scrollBar:setVisible(true)
	elseif id == "borders" then
		if doSetupBordersProfile and panelEditProfile.panelListBorder:getChildCount() == 0 then
			doSetupBordersProfile()
		end
		panelEditProfile.panelListBorder:setVisible(true)
		panelEditProfile.scrollBar2:setVisible(true)
	end
end

function doSetupSelectionEdit()
	panelEditProfile.panelSelection:destroyChildren()
	for key, button in ipairs(editListButton) do
		local widget = g_ui.createWidget('buttonEditSelection', panelEditProfile.panelSelection)
		widget:setId("editSelection" .. key)
		widget:setPhantom(false)
		widget:setFocusable(button.enabled)
		widget:setOpacity(button.enabled and 1 or 0.55)

		widget.icon:setImageSource("images/profile/editprofile/"..button.icon)
		widget.icon:setVisible(true)
		widget.icon:setOpacity(1)

		widget.name:setText(button.name)
		widget.name:setColor("#ffffff")
		if widget.name.setFont then
			widget.name:setFont("verdana-11px-rounded")
		end
		if widget.name.setWidth then
		widget.name:setWidth(104)
		end
		widget.name:setVisible(true)
		widget.name:setOpacity(button.enabled and 1 or 0.7)

		widget.arrow:setVisible(true)
		widget.arrow:setOpacity(button.enabled and 1 or 0.7)

		widget.icon:raise()
		widget.name:raise()
		widget.arrow:raise()

		widget.onClick = function()
			if button.enabled then
				button.action()
			end
		end

		widget.onMouseRelease = function(self, mousePosition, mouseButton)
			if mouseButton == MouseLeftButton then
				if button.enabled then
					button.action()
				end
				return true
			end
			return false
		end
	end
end

local nivel = 0
local imagens = 0
local profileImages = {}

while imagens < 75 do
    nivel = nivel + 8
    imagens = imagens + 1
    table.insert(profileImages, {imagem = imagens, nivel = nivel})
end
for i = 1, 4 do
    nivel = nivel + 1
    imagens = imagens + 1
    table.insert(profileImages, {imagem = imagens, nivel = nivel})
end

-- modules.game_playerbar.doSetupBordersProfile()
function doSetupBordersProfile()
	local player = g_game.getLocalPlayer()
	if not player then return end
	local playerLevel = player:getLevel()
	
	panelEditProfile.perfilBorder:setImageSource("/perfil/border/" .. tostring(profileConfigStatus.border or "none"))
	
	panelEditProfile.panelListBorder:destroyChildren()
	for key, slot in pairs(profileBorders) do
		local widget = g_ui.createWidget('widgetProfileBorder', panelEditProfile.panelListBorder)
		widget.title:setText(tr(slot.name or ""))
		widget.desc:setText(tr(slot.desc or ""))
		widget.require:setText(tr(slot.requireDesc or ""))
		widget.slotIMG = "none"
		
		if slot.image then
			widget.image:setImageSource("/perfil/border/"..slot.image)
		end
		
		local progressStatus, percent, Yhppc, rect
		if slot.type == "NONE" then
			widget.image:setVisible(false)
			widget.progressbar:setVisible(false)
			widget.progressTitle:setVisible(false)
			widget.progressStatus:setVisible(false)
			widget.titleNone:setText("SEM BORDA")
			widget.unlocked = true
		else
			local level = tonumber(slot.level)
			local progress = (slot.type == "LEVEL" and playerLevel) or storagesData[slot.type:lower()]
			if slot.type == "VIP" then
				progress = playerVipDays or vipPlayerDays or 0
			elseif slot.type == "VIPPLUS" then
				progress = storagesData.vipPlus or storagesData.vipplus or 0
			end
			if progress and progress >= level then
				progressStatus = level.."/"..level
				percent = 100
				widget.unlocked = true
			else
				widget:setFocusable(false)
				widget:setPhantom(true)
				widget:setOpacity(0.5)
				progressStatus = (progress or 0).."/"..level
				percent = calculatePercentage(progress or 0, level)
				widget.unlocked = false
			end
			Yhppc = math.floor(393 * (1 - (percent / 100)))
			rect = { x = 0, y = 0, width = 393 - Yhppc + 1, height = 6 }
			widget.progressStatus:setText(progressStatus)
			widget.progressbar.progress:setImageClip(rect)
			widget.progressbar.progress:setImageRect(rect)
			widget.slotIMG = slot.image
		end
		widget.onClick = function(self)
			selectProfileBorderWidget(self)
		end
		widget.onMouseRelease = function(self, mousePosition, mouseButton)
			if mouseButton == MouseLeftButton then
				selectProfileBorderWidget(self)
				return true
			end
			return false
		end
	end

    panelEditProfile.panelListBorder.onChildFocusChange = function(focusedChild, oldFocused, reason)
		selectProfileBorderWidget(focusedChild)
    end
end

function doSetupImagesProfile()
	local player = g_game.getLocalPlayer()
	if not player then return end
	local _, gender = getProfileSexData(nil)
	local genderPath = gender.name
	local playerLevel = player:getLevel()
	if playerLevel < 8 then
		playerLevel = 8
	end
	
	panelEditProfile.panelList:destroyChildren()
	-- local uploadImageButton = g_ui.createWidget('uploadImageButton', panelEditProfile.panelList)
	
	-- if profileImageBy64 and profileImageBy64 ~= "" then
		-- local widget = g_ui.createWidget('widgetProfileImage', panelEditProfile.panelList)
		-- widget.slot:setImageSourceBase64(profileImageBy64)
		-- widget.slot:setSize('80 80')
		-- widget.level:setVisible(false)
		-- widget.level2:setVisible(false)
		
		-- widget.uploaded = true
		-- widget.image = profileImageBy64
		-- widget.slotIMG = 1

		-- panelEditProfile.perfilImage:setImageSourceBase64(profileImageBy64)

		-- profileConfigStatus.useUpload = true
	-- else
		-- panelEditProfile.perfilImage:setImageSource('/perfil/circle/'.. playerGender ..'/1')
		-- profileConfigStatus.useUpload = false
	-- end

	for key, slot in pairs(profileImages) do
		local widget = g_ui.createWidget('widgetProfileImage', panelEditProfile.panelList)
		widget.slot:setImageSource('/perfil/square/'.. genderPath ..'/'..slot.imagem)
		widget.level:setText(slot.nivel.."+")
		widget.level2:setText(slot.nivel.."+")
		
		if playerLevel >= slot.nivel then
			widget.slot:setImageColor("white")
			widget.unlocked = true
		else
			widget.slot:setImageColor("black")
			widget:setFocusable(false)
			widget:setPhantom(true)
			widget.unlocked = false
		end
		
		widget.image = '/perfil/circle/'.. genderPath ..'/'..slot.imagem
		widget.slotIMG = slot.imagem
		widget.uploaded = false
		widget.onClick = function(self)
			selectProfileImageWidget(self)
		end
		widget.onMouseRelease = function(self, mousePosition, mouseButton)
			if mouseButton == MouseLeftButton then
				selectProfileImageWidget(self)
				return true
			end
			return false
		end
	end

    panelEditProfile.panelList.onChildFocusChange = function(focusedChild, oldFocused, reason)
	  selectProfileImageWidget(focusedChild)
    end
end
-- EDIT PROFILE WINDOW
function doSetupImageDiretory(panel)
  panelLoadImage = panel
  
  -- create main settings dir
  if not g_resources.directoryExists("/customImage/") then
    g_resources.makeDir("/customImage/")
  end
  
  panelLoadImage.applyButton.onClick = function()
	togglePanelLoadImage(false)
	doConfirmUploadImageProfile(panelLoadImage.panelList:getFocusedChild())
  end

  doCheckProfileImages(panelLoadImage)
end

function togglePanelLoadImage(status)
  if not status or panelLoadImage:isVisible() then
    g_effects.fadeOut(panelLoadImage, 150)
    scheduleEvent(function() 
	  returnWindow.onClick = function() toggleEditProfileInfos() end
      panelLoadImage:hide()
    end, 200)
  else
	returnWindow.onClick = function() togglePanelLoadImage(false) end
    panelLoadImage:show()
    doCheckProfileImages(panelLoadImage)
    g_effects.fadeIn(panelLoadImage, 150)
  end
end

function doCheckProfileImages(panel)
	local configFiles = g_resources.listDirectoryFiles("/customImage", true, false)
	if panel.panelList then
		local currentWidgets = panel.panelList:getChildren()
		for i, widget in ipairs(currentWidgets) do
			if not table.contains(configFiles, widget.diretory) then
				widget:destroy()
			end
		end

		for i, file in ipairs(configFiles) do
			local ext = file:split(".")
			if ext[#ext]:lower() == "png" then
				local alreadyExists = false
				for j, widget in ipairs(currentWidgets) do
					if widget.diretory == file then
						alreadyExists = true
						break
					end
				end
				if not alreadyExists then
					local widget = g_ui.createWidget('widgetLoadImage', panel.panelList)
					widget.slot:setImageSource(file)
					widget.diretory = file
				end
			end
		end
		
		local buttonsCount = panel.panelList:getChildCount()
		local realSizePanelButtons = (buttonsCount * 105)
		if realSizePanelButtons > 625 then
			panel.panelList:setWidth(625)
		else
			panel.panelList:setWidth(realSizePanelButtons - 5)
		end
		
		if panelLoadImage:isVisible() then
			scheduleEvent(function() 
				doCheckProfileImages(panel)
			end, 1000)
		end
	end
end

local textRuleConfirmLoad = {
	"By uploading this image, you confirm that the image follows all of our appropriate content rules.",
	"This includes, but is not limited to, prohibiting offensive, inappropriate or illegal content.",
	"Please be aware that �[v]o violation of these rules may result in an immediate ban without prior warning[v/]�.",
	"Additionally, please note that �[v]once uploaded, you will only be able to change the image again after 24 hours[v/]�.",
	"We appreciate your understanding and cooperation in keeping our community safe and welcoming.",
	"",
	"",
	"Click '[d]Confirm[d/]' if you agree to these terms and wish to continue uploading the image.",
}
function joinStrings(textArray)
    local text = ""
    for i, line in ipairs(textArray) do
        text = text .. tr(line) .. "\n"
    end
    return text
end

function doConfirmUploadImageProfile(image)
	local fullText = joinStrings(textRuleConfirmLoad)
    setColoredText(panelConfirmLoadImage.desc, fullText, "#ffffff")

	panelUPLOADImage.image.slot:setImageSource(image.diretory)
	panelConfirmLoadImage.image.slot:setImageSource(image.diretory)
	panelConfirmLoadImage.image:setPhantom(true)
	panelConfirmLoadImage.image:setFocusable(false)
	panelConfirmLoadImage.image.slot:setOpacity(1)
	
    panelConfirmLoadImage.applyButton.onClick = function()
	  doStartUploadImage(panelLoadImage.panelList:getFocusedChild())
    end
    panelConfirmLoadImage.cancelButton.onClick = function()
		togglePanelConfirmLoadImages(false)
		togglePanelLoadImage(true)
    end
	
	togglePanelConfirmLoadImages(true)
end

function doStartUploadImage(widget)
	togglePanelConfirmLoadImages(false)
	togglePanelUPLOADImages(true)
	modules.game_playerbar.doSetupUPLOADProfile("Establishing Server Connection�", 0, 10, "wifi")
	
	scheduleEvent(function()
		modules.game_playerbar.doSetupUPLOADProfile("Processing Image Upload�", 10, 30, "data_2")
	end, 5000)
	scheduleEvent(function()
		modules.game_playerbar.doSetupUPLOADProfile("Optimizing Image for Upload�", 30, 50, "compress")
	end, 10000)
	scheduleEvent(function()
		modules.game_playerbar.doSetupUPLOADProfile("Generating Unique Identifier for Image�", 50, 70, "code")
	end, 20000)
	scheduleEvent(function()
		modules.game_playerbar.doSetupUPLOADProfile("Transmitting Image to Server�", 70, 90, "upload")
	    doUpdateImageSelected(widget)
	end, 30000)
end

function doSetupUPLOADProfile(desc, lowPercent, highPercent, icon)
	panelUPLOADImage.titleProgress:setText(tr(desc))
	panelUPLOADImage.iconProgress:setImageSource("/images/api_icons/icon_animated/"..icon)
	doSetupProgressBar(lowPercent, highPercent)
	
	if icon == "sucess" or icon == "error_2" then
		panelUPLOADImage.applyButton:setVisible(true)
		panelUPLOADImage.applyButton.onClick = function()
			togglePanelUPLOADImages(false)
		end
		g_effects.fadeIn(panelUPLOADImage.applyButton, 150)
	else
		panelUPLOADImage.applyButton:setVisible(false)
	end
end

function doSetupProgressBar(percentStart, percentTarget)
    local percentDiff = percentTarget - percentStart
    local i = 0
    local function increasePercentage()
        if i <= percentDiff then
            local percent = percentStart + i
            local Yhppc = math.floor(417 * (1 - (percent / 100)))
            local rect = { x = 0, y = 0, width = 417 - Yhppc + 1, height = 16 }
            panelUPLOADImage.progress:setImageClip(rect)
            panelUPLOADImage.progress:setImageRect(rect)
            panelUPLOADImage.progressPercent:setText(percent.."%")
            i = i + 1
            scheduleEvent(increasePercentage, 50)
        end
    end
    scheduleEvent(increasePercentage, 50)
end

function togglePanelUPLOADImages(status)
  if not status or panelUPLOADImage:isVisible() then
    g_effects.fadeOut(panelUPLOADImage, 150)
    scheduleEvent(function() 
      panelUPLOADImage:hide()
    end, 200)
  else
    panelUPLOADImage:show()
    g_effects.fadeIn(panelUPLOADImage, 150)
  end
end

function togglePanelConfirmLoadImages(status)
  if not status or panelConfirmLoadImage:isVisible() then
    g_effects.fadeOut(panelConfirmLoadImage, 150)
    scheduleEvent(function() 
      panelConfirmLoadImage:hide()
    end, 200)
  else
    panelConfirmLoadImage:show()
    g_effects.fadeIn(panelConfirmLoadImage, 150)
  end
end

function doUpdateImageSelected(image)
	local base64IMAGE = doConvertImageByBase64(image.diretory)
	doConvertImageForCircle(base64IMAGE)
end

function doConvertImageForCircle(IMAGE)
	data = {
		['IMAGE'] = tostring(IMAGE),
		['ID'] = 77099,
		['TIME'] = tostring(os.time()),
		['API_KEY'] = API_KEY
	}

	HTTP.STONElink(goLangAPI..'/api/register/STONELINK/dasdasewakahjsd8as7dkal3l4jalksjdfasd8da', data, API_ENCRYPT, function(data, err)
        doConvertImageForCircleCallback(data, err)
    end)
end
function doConvertImageForCircleCallback(data, err)
    if err then
        print(err)
    else
		for key, status in pairs(data) do
			-- print(key, status)
			if status == "FailedToSaveBase64" or status == "FailedToConvertImage" or status == "unauthorized" then
				modules.game_playerbar.doSetupUPLOADProfile("Image Upload Failed! Please Try Again.", 99, 100, "error_2")
			elseif status == "Image saved" then
				scheduleEvent(function()
					modules.game_playerbar.doSetupUPLOADProfile("Image Upload Successfully Completed!", 90, 100, "sucess")
					doUpdateProfileInfos()
				end, 5000)
			end
		end
    end
end

function doUpdateProfileInfos()
  local tableCode = {
  	data = "UpdateProfile",
  }
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  	protocolGame:sendExtendedOpcode(OPCODE, json.encode(tableCode))
  end
end

function doApplyProfileUpdate()
  doSaveLocalProfileForCharacter()
  doApplyCurrentProfileVisuals()
  local tableCode = {
  	data = "applyProfileUpdate",
	id = profileId,
	image = profileConfigStatus.image,
	useUpload = profileConfigStatus.useUpload,
	border = profileConfigStatus.border,
	character = g_game.getLocalPlayer() and g_game.getLocalPlayer():getName() or nil,
  }

  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  	protocolGame:sendExtendedOpcode(OPCODE, json.encode(tableCode))
	toggleEditProfileInfos()
  end
end
