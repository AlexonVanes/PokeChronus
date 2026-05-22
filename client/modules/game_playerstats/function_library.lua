local XpBannerClockWidget = nil

local XP_BANNER_CLOCK_ID = "XpBannerClock"
local XP_BANNER_BONUS_ROW_HEIGHT = 11
local XP_BANNER_BONUS_ROW_SPACING = 5
local XP_BANNER_TOOLTIP_BASE_HEIGHT = 129

local XP_BANNER_BONUS_ORDER = { "exp", "loot", "boss", "shiny", "fishing" }
local XP_BANNER_BONUS_DEFS = {
	exp = { title = "EXP Boost", color = "#30ff00" },
	exp_gain = { title = "Experiênce", color = "#ffff00" },
	loot = { title = "Loot Bonus", color = "#30ff00" },
	boss = { title = "Boss Charm", color = "#30ff00" },
	shiny = { title = "Shiny Charm", color = "#30ff00" },
	fishing = { title = "Fishing Charm", color = "#30ff00" },
}

local function getBannerInteger(value)
	local parsedValue = tonumber(value)
	if not parsedValue then
		return nil
	end

	return math.floor(parsedValue)
end

local function getXpBannerBonusHeight(entriesCount)
	if entriesCount <= 0 then
		return 0
	end

	return (entriesCount * XP_BANNER_BONUS_ROW_HEIGHT) + ((entriesCount - 1) * XP_BANNER_BONUS_ROW_SPACING)
end

local function addXpBannerBonusEntry(entries, key, value)
	local config = XP_BANNER_BONUS_DEFS[key]
	if not config or value == nil then
		return
	end

	table.insert(entries, {
		key = key,
		title = tr(config.title),
		value = tostring(value),
		color = config.color or "#ffffff",
	})
end

local function formatTimerClock(seconds)
	local totalSeconds = math.max(getBannerInteger(seconds) or 0, 0)
	local hours = math.floor(totalSeconds / 3600)
	local minutes = math.floor((totalSeconds % 3600) / 60)
	local remainingSeconds = math.floor(totalSeconds % 60)

	if hours == 0 then
		return string.format("%02d:%02d", minutes, remainingSeconds)
	end

	return string.format("%02d:%02d", hours, minutes)
end

local function formatTimerFull(seconds)
	local totalSeconds = math.max(getBannerInteger(seconds) or 0, 0)
	local hours = math.floor(totalSeconds / 3600)
	local minutes = math.floor((totalSeconds % 3600) / 60)
	local remainingSeconds = math.floor(totalSeconds % 60)

	return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
end

local function setBonusWidgetTimerState(widget, bonus)
	if not widget or not bonus then
		return
	end

	if widget.progressCloseEvent then
		removeEvent(widget.progressCloseEvent)
		widget.progressCloseEvent = nil
	end

	if bonus.remaining_time and bonus.remaining_time > 0 then
		widget.timer:setText(formatTimerClock(bonus.remaining_time))
		widget.timer:setVisible(true)
		widget.decrease:setVisible(true)
		doStartTimerWidget(widget, bonus.id, bonus.remaining_time)
	else
		widget.timer:setVisible(false)
		widget.decrease:setVisible(false)
	end
end

local function updateXpBannerHoverWidget(widget, data)
	if not widget or not data then
		return
	end

	widget.item:setItemId(data.icon)
	widget.title:setText(data.name)

	local bonusHeight = doBuildXpBannerBonusList(widget.bonusList, data.bonus_entries, "labelInfosBannerBonus")
	widget:setHeight(XP_BANNER_TOOLTIP_BASE_HEIGHT + bonusHeight)

	if data.remaining_time and data.remaining_time > 0 then
		widget.timer:setText(formatTimerFull(data.remaining_time))
		widget.timer:setVisible(true)
	else
		widget.timer:setVisible(false)
	end
end

local function buildXpBannerBonusEntries(bonusData)
	local bonusEntries = {}
	local activeBonus = type(bonusData) == "table" and bonusData or {}

	for _, bonusKey in ipairs(XP_BANNER_BONUS_ORDER) do
		local bonusValue = activeBonus[bonusKey]

		if bonusKey == "exp" then
			if type(bonusValue) == "table" then
				local expValue = getBannerInteger(bonusValue.value)
				local gainXp = getBannerInteger(bonusValue.gainxp)

				if expValue then
					addXpBannerBonusEntry(bonusEntries, "exp", "+"..string.format("%d%%", expValue))
				end

				if gainXp then
					addXpBannerBonusEntry(bonusEntries, "exp_gain", "+"..doCorrectNumber(gainXp))
				end
			end
		else
			local normalizedValue = getBannerInteger(bonusValue)
			if normalizedValue then
				addXpBannerBonusEntry(bonusEntries, bonusKey, "+"..string.format("%d%%", normalizedValue))
			end
		end
	end

	return bonusEntries
end

function doParseXpBannerPayload(payload)
	if type(payload) ~= "table" then
		return nil
	end

	return {
		id = payload.id or XP_BANNER_CLOCK_ID,
		icon = getBannerInteger(payload.icon) or getBannerInteger(payload.bannerId) or 0,
		name = payload.name or "",
		banner_name = payload.bannerName or payload.name or "",
		owner_name = payload.bannerName and (payload.name or "") or nil,
		level = getBannerInteger(payload.level),
		remaining_time = math.max(getBannerInteger(payload.remaining_time) or 0, 0),
		time_end = getBannerInteger(payload.timeEnd),
		gender = getBannerInteger(payload.gender) or 0,
		image = payload.image,
		border = payload.border,
		is_in_radius = payload.isInRadius == true,
		bonus_entries = buildXpBannerBonusEntries(payload.bonus),
		bonus = type(payload.bonus) == "table" and payload.bonus or {},
	}
end

function doBuildXpBannerBonusList(panel, bonusEntries, widgetStyle)
	if not panel then
		return 0
	end

	panel:destroyChildren()

	local entries = type(bonusEntries) == "table" and bonusEntries or {}
	for _, entry in ipairs(entries) do
		local widget = g_ui.createWidget(widgetStyle, panel)
		widget.title:setText(entry.title)
		widget.info:setText(entry.value)
		widget.info:setColor(entry.color or "#ffffff")
	end

	local totalHeight = getXpBannerBonusHeight(#entries)
	panel:setHeight(totalHeight)
	panel:setVisible(#entries > 0)
	panel:updateLayout()

	if panel.updateScrollBars then
		panel:updateScrollBars()
	end

	return totalHeight
end

function doSetupAllBonus(data)
	if type(data) ~= "table" then
		return
	end

	for _, bonus in pairs(data) do
		doCreateBonusCooldown(bonus)
	end
end

function doRemoveBonusCooldown(id)
	if not id then
		return
	end

	local bonusWidget = listBonus:recursiveGetChildById(id)
	if not bonusWidget then
		return
	end

	if bonusWidget.progressCloseEvent then
		removeEvent(bonusWidget.progressCloseEvent)
		bonusWidget.progressCloseEvent = nil
	end

	bonusWidget:destroy()
	doUpdatePanelBonusSize()

	if id == XP_BANNER_CLOCK_ID then
		doCloseXpBannerClockHover()
	end
end

function doCreateBonusCooldown(bonus, isBanner)
	if not bonus then
		return false
	end

	local normalizedBonus = bonus
	if bonus.id == XP_BANNER_CLOCK_ID then
		normalizedBonus = doParseXpBannerPayload(bonus)
		if not normalizedBonus then
			return false
		end
	end

	local checkBonus = listBonus:recursiveGetChildById(normalizedBonus.id)

	if not isBanner or not checkBonus then
		if checkBonus then
			if checkBonus.progressCloseEvent then
				removeEvent(checkBonus.progressCloseEvent)
				checkBonus.progressCloseEvent = nil
			end
			checkBonus:destroy()
		end

		local bonusWidget = g_ui.createWidget("bonusBaseSlot", listBonus)
		bonusWidget:setId(normalizedBonus.id)
		bonusWidget.item:setItemId(normalizedBonus.icon)
		bonusWidget.base.bonus = normalizedBonus

		setBonusWidgetTimerState(bonusWidget, normalizedBonus)
		doSetupHoverBonus(bonusWidget, normalizedBonus)
		doUpdatePanelBonusSize()

		return true
	end

	checkBonus.item:setItemId(normalizedBonus.icon)
	checkBonus.base.bonus = normalizedBonus

	setBonusWidgetTimerState(checkBonus, normalizedBonus)
	doSetupHoverBonus(checkBonus, normalizedBonus)

	if normalizedBonus.id == XP_BANNER_CLOCK_ID and XpBannerClockWidget then
		updateXpBannerHoverWidget(XpBannerClockWidget, normalizedBonus)
	end

	return true
end

function doSetupHoverBonus(self, bonus)
	if bonus.id == XP_BANNER_CLOCK_ID then
		self.base.onHoverChange = onHoverBonusBanner
	elseif bonus.id == "DGBonus" then
		local luckCount = math.floor(bonus.lucky or 0)
		local catchCount = math.floor(bonus.catch or 0)
		local expCount = math.floor(bonus.experience or 0)
		local formatTextBonus = (tr(bonus.name) or tr("Dungeon Bonus")) .. ":"

		local bonusLines = {}

		if luckCount > 0 then
			table.insert(bonusLines, "[F]" .. tr("Extra Loot") .. "[F/]" .. " x" .. luckCount)
		end

		if catchCount > 0 then
			table.insert(bonusLines, "[N]" .. tr("Extra Catch") .. "[N/]" .. " x" .. catchCount)
		end

		if expCount > 0 then
			table.insert(bonusLines, "[B]" .. tr("Extra XP") .. "[B/]" .. " x" .. expCount)
		end

		if #bonusLines > 0 then
			formatTextBonus = formatTextBonus .. "\n" .. table.concat(bonusLines, "\n")
		else
			formatTextBonus = formatTextBonus .. "\n" .. "[c]" .. tr("No bonus active") .. "[c/]"
		end

		self.base.tooltip = formatTextBonus
	else
		self.base.tooltip = bonus.name
	end
end

function onHoverBonusBanner(self, hovered)
	if hovered then
		doShowXpBannerClockHover(self)
	else
		doCloseXpBannerClockHover()
	end
end

function doShowXpBannerClockHover(self)
	local flag = listBonus:recursiveGetChildById(XP_BANNER_CLOCK_ID)
	if not flag then
		return false
	end

	local data = self.bonus
	if not data then
		return false
	end

	if XpBannerClockWidget then
		XpBannerClockWidget:destroy()
		XpBannerClockWidget = nil
	end

	XpBannerClockWidget = g_ui.createWidget("XpBannerClockWidget", playerstatsWindow)
	XpBannerClockWidget:addAnchor(AnchorBottom, "listBonus", AnchorTop)
	XpBannerClockWidget:addAnchor(AnchorHorizontalCenter, "moveChild", AnchorHorizontalCenter)

	updateXpBannerHoverWidget(XpBannerClockWidget, data)

	local increment = 31
	local posIndex = listBonus:getChildIndex(flag) - 1
	local posLeft = posIndex * (increment + 6)

	playerstatsWindow.moveChild:setMarginLeft(posLeft)
	return true
end

function doCloseXpBannerClockHover()
	if XpBannerClockWidget then
		g_effects.fadeOut(XpBannerClockWidget, 350)

		local flag = playerstatsWindow:recursiveGetChildById("XpBannerClockWidget")
		if flag and XpBannerClockWidget then
			XpBannerClockWidget:destroy()
			XpBannerClockWidget = nil
		end
	end
end

function doStartTimerWidget(self, id, seconds)
	if self.progressCloseEvent then
		removeEvent(self.progressCloseEvent)
		self.progressCloseEvent = nil
	end

	if self.timer then
		self.timer:setVisible(true)
	end

	if self.decrease then
		self.decrease:setVisible(true)
	end

	local interval = 60
	local totalTicks = seconds * 1000 / interval
	local tick = 1

	local function doCheckSlide(widget, timerId)
		local button = listBonus:recursiveGetChildById(timerId)
		if not button or not widget then
			if widget and widget.progressCloseEvent then
				removeEvent(widget.progressCloseEvent)
				widget.progressCloseEvent = nil
			end
			return false
		end

		local percent = math.ceil((tick / totalTicks) * 100)
		local progresspercent = math.floor(percent)
		if progresspercent < 5 then
			progresspercent = 5
		end

		local heightPercent = math.floor(24 * (progresspercent / 100))
		local rect = { x = 0, y = 24 - heightPercent, width = 24, height = heightPercent }
		widget.decrease:setImageClip(rect)
		widget.decrease:setImageRect(rect)

		local remainingSeconds = math.max((totalTicks - tick) * (interval / 1000), 0)
		local hours = math.floor(remainingSeconds / 3600)
		local minutes = math.floor((remainingSeconds % 3600) / 60)
		local remainingClockSeconds = math.floor(remainingSeconds % 60)

		if hours == 0 then
			widget.timer:setText(string.format("%02d:%02d", minutes, remainingClockSeconds))
		else
			widget.timer:setText(string.format("%02d:%02d", hours, minutes))
		end

		if timerId == XP_BANNER_CLOCK_ID and XpBannerClockWidget then
			XpBannerClockWidget.timer:setText(string.format("%02d:%02d:%02d", hours, minutes, remainingClockSeconds))
		end

		widget.timer:setTooltip(string.format("Tempo restante: %02d:%02d:%02d", hours, minutes, remainingClockSeconds))

		tick = tick + 1
		if tick <= totalTicks then
			widget.progressCloseEvent = scheduleEvent(function()
				doCheckSlide(widget, timerId)
			end, interval)
		else
			local expiredButton = listBonus:recursiveGetChildById(timerId)
			if expiredButton then
				if widget.progressCloseEvent then
					removeEvent(widget.progressCloseEvent)
					widget.progressCloseEvent = nil
				end
				expiredButton:destroy()
				doUpdatePanelBonusSize()
				doCloseXpBannerClockHover()
			end
		end
	end

	local button = listBonus:recursiveGetChildById(id)
	if not button or not self then
		if self and self.progressCloseEvent then
			removeEvent(self.progressCloseEvent)
			self.progressCloseEvent = nil
		end
		return false
	end

	self.progressCloseEvent = scheduleEvent(function()
		doCheckSlide(self, id)
	end, interval)

	return true
end

function doUpdatePanelBonusSize()
	local bonusCount = #listBonus:getChildren()
	local totalSize = bonusCount * (30 + 6)

	listBonus:setWidth(math.max(totalSize - 6, 0))
end
