STORAGE_VIP = 1650000

function Player:addVipPlus(days)
	if not self:isVipPlus() then
		self:setStorageValue(STORAGE_VIP, os.time() + (days * 24 * 60 * 60))
	else
		local timeRemaining = self:getStorageValue(STORAGE_VIP)
		self:setStorageValue(STORAGE_VIP, timeRemaining + (days * 24 * 60 * 60))
	end
		self:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Você recebeu %d dias vip plus!", days))
	pcall(function() self:titleHandler() end)
	return true
end

function Player:isVipPlus()
	if self:getStorageValue(STORAGE_VIP) > os.time() then
		return true
	end
	return false
end

function Player:getVipPlusDaysFormatted()
	return convertTime(self:getStorageValue(STORAGE_VIP) - os.time())
end

function Player:getVipPlusDays()
	local seconds = self:getStorageValue(STORAGE_VIP) - os.time()
	if seconds <= 0 then
		return 0
	end
	return math.ceil(seconds / (24 * 60 * 60))
end

function Player:getDisplayVipDays()
	local okPremium, premiumResult = pcall(function() return self:getPremiumDays() end)
	local premiumDays = okPremium and (tonumber(premiumResult) or 0) or 0
	local vipPlusDays = self:getVipPlusDays()

	if premiumDays >= 65000 then
		premiumDays = 0
	end

	return math.max(premiumDays, vipPlusDays)
end

function Player:getPlayerbarBlessCount()
	local okBlessings, blessings = pcall(function() return self:getBlessings() end)
	if okBlessings and blessings then
		return tonumber(blessings) or 0
	end

	local count = 0
	for i = 1, 6 do
		local ok, hasBless = pcall(function() return self:hasBlessing(i) end)
		if ok and hasBless then
			count = count + 1
		end
	end
	return count
end

function Player:sendPlayerbarVipData()
	local vipDays = self:getDisplayVipDays()
	self:sendExtendedOpcode(113, json.encode({
		action = "RefreshAvatar",
		data = {
			premiumDay = vipDays,
			blessCount = self:getPlayerbarBlessCount(),
			gainRateXP = self:isVipPlus() and 135 or 100,
			sex = self:getSex(),
			storagesData = {
				vipPlus = vipDays
			}
		}
	}))
end

function Player:sendVipPlusDays()
	self:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Você tem: %s VIP PLUS DAYS", self:getVipPlusDaysFormatted()))
end