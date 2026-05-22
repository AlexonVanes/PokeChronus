local OPCODE_DONATIONGOALS = 8
local OPCODE_REQUEST_MANAGER = 1


local OPCODE_NEW_SELL = 88
local OPCODE_WHEEL = 177
local WHEEL_STORAGE_LAST_FREE_DAY = 105900
local WHEEL_STORAGE_PAID_TICKETS = 105901
local WHEEL_TICKET_PRICE = 10000000
local WHEEL_PENDING_REWARDS = WHEEL_PENDING_REWARDS or {}

local WHEEL_REWARDS = {
	{name = "Hundred Dollar", desc = "Premio de teste.", itemid = 2152, count = 25, rewardType = "item", chance = 15},
	{name = "Hundred Dollar", desc = "Premio de teste.", itemid = 2152, count = 50, rewardType = "item", chance = 10, rare = true},
	{name = "Boost Stone", desc = "Stone de teste.", itemid = 26723, count = 1, rewardType = "item", chance = 15},
	{name = "Fire Stone", desc = "Stone de teste.", itemid = 26728, count = 2, rewardType = "item", chance = 12},
	{name = "Water Stone", desc = "Stone de teste.", itemid = 26736, count = 2, rewardType = "item", chance = 12},
	{name = "Leaf Stone", desc = "Stone de teste.", itemid = 26731, count = 2, rewardType = "item", chance = 12},
	{name = "Thunder Stone", desc = "Stone de teste.", itemid = 26734, count = 2, rewardType = "item", chance = 12},
	{name = "Crystal Stone", desc = "Stone de teste.", itemid = 26725, count = 2, rewardType = "item", chance = 12}
}

local function getWheelToday()
	return tonumber(os.date("%Y%m%d", os.time()))
end

local function getWheelPaidTickets(player)
	return math.max(0, player:getStorageValue(WHEEL_STORAGE_PAID_TICKETS))
end

local function getWheelFreeTickets(player)
	return player:getStorageValue(WHEEL_STORAGE_LAST_FREE_DAY) == getWheelToday() and 0 or 1
end

local function getWheelTickets(player)
	return getWheelFreeTickets(player) + getWheelPaidTickets(player)
end

local function sendWheelPacket(player, data)
	player:sendExtendedOpcode(OPCODE_WHEEL, json.encode({data}))
end

local function getWheelClientRewards()
	local items = {}
	for _, reward in ipairs(WHEEL_REWARDS) do
		local itemType = ItemType(reward.itemid)
		items[#items + 1] = {
			itemid = itemType and itemType:getClientId() or reward.itemid,
			count = reward.count,
			name = reward.name,
			desc = reward.desc,
			poke = reward.poke,
			rare = reward.rare
		}
	end
	return items
end

local function sendWheelOpen(player)
	sendWheelPacket(player, {
		protocol = "openwheel",
		category = 1,
		name = "",
		cost = 1,
		tickets = getWheelTickets(player),
		items = getWheelClientRewards()
	})
end

local function consumeWheelTicket(player)
	if getWheelFreeTickets(player) > 0 then
		player:setStorageValue(WHEEL_STORAGE_LAST_FREE_DAY, getWheelToday())
		return true
	end

	local paidTickets = getWheelPaidTickets(player)
	if paidTickets > 0 then
		player:setStorageValue(WHEEL_STORAGE_PAID_TICKETS, paidTickets - 1)
		return true
	end

	return false
end

local function pickWheelReward()
	local totalChance = 0
	for _, reward in ipairs(WHEEL_REWARDS) do
		totalChance = totalChance + reward.chance
	end

	local roll = math.random(1, totalChance)
	local current = 0
	for slot, reward in ipairs(WHEEL_REWARDS) do
		current = current + reward.chance
		if roll <= current then
			return slot, reward
		end
	end

	return 1, WHEEL_REWARDS[1]
end

local function giveWheelReward(player, reward)
	if not reward then
		return false
	end

	if reward.rewardType == "pokemon" and reward.pokemon then
		local ok, pokeball = pcall(function()
			return player:addPokemon(reward.pokemon)
		end)
		if ok and pokeball then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ganhou " .. reward.name .. " na Pokemon Wheel!")
			return true
		end
		return false
	end

	if reward.itemid then
		local item = player:addItem(reward.itemid, reward.count or 1)
		if item then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ganhou " .. (reward.count or 1) .. "x " .. reward.name .. " na Pokemon Wheel!")
			return true
		end
	end

	return false
end

local function deliverPendingWheelReward(playerId, reopenWheel)
	local reward = WHEEL_PENDING_REWARDS[playerId]
	if not reward then
		return false
	end

	local player = Player(playerId)
	if not player then
		return false
	end

	WHEEL_PENDING_REWARDS[playerId] = nil
	if not giveWheelReward(player, reward) then
		player:sendTextMessage(MESSAGE_STATUS_WARNING, "Nao foi possivel entregar o premio da Wheel. Verifique espaco na bag.")
	end

	if reopenWheel then
		sendWheelOpen(player)
	end
	return true
end

local function removeWheelMoney(player, price)
	if player.removeTotalMoney then
		return player:removeTotalMoney(price)
	end
	return player:removeMoney(price)
end

local function handleWheelOpcode(player, buffer)
	local ok, data = pcall(function()
		return json.decode(buffer)
	end)
	if not ok or type(data) ~= "table" then
		return
	end

	if data.protocol == "requestOpen" or data.protocol == "requestWheelPage" then
		deliverPendingWheelReward(player:getId(), false)
		sendWheelOpen(player)
		return
	end

	if data.protocol == "buyTickets" then
		local quantity = math.max(1, math.min(100, tonumber(data.quanty) or 1))
		local price = quantity * WHEEL_TICKET_PRICE
		if not removeWheelMoney(player, price) then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, "Voce precisa de " .. (10 * quantity) .. "KK para comprar ticket da Wheel.")
			sendWheelOpen(player)
			return
		end

		player:setStorageValue(WHEEL_STORAGE_PAID_TICKETS, getWheelPaidTickets(player) + quantity)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce comprou " .. quantity .. " ticket(s) da Wheel.")
		sendWheelOpen(player)
		return
	end

	if data.protocol == "requestwheel" then
		if WHEEL_PENDING_REWARDS[player:getId()] then
			deliverPendingWheelReward(player:getId(), true)
			return
		end

		if getWheelTickets(player) <= 0 then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, "Voce ja usou seu giro gratis de hoje. Volte amanha ou compre tickets.")
			sendWheelOpen(player)
			return
		end

		if not consumeWheelTicket(player) then
			sendWheelOpen(player)
			return
		end

		local slot, reward = pickWheelReward()
		WHEEL_PENDING_REWARDS[player:getId()] = reward
		sendWheelPacket(player, {
			protocol = "rollwheel",
			roll = slot,
			tickets = getWheelTickets(player),
			faster = 1.0
		})
		addEvent(function(playerId)
			deliverPendingWheelReward(playerId, true)
		end, 12000, player:getId())
		return
	end

	if data.protocol == "finishwheel" then
		deliverPendingWheelReward(player:getId(), true)
	end
end

local function sendPassPacket(player, packetType, values)
	player:sendExtendedOpcode(20, json.encode({type = packetType, values = values or {}}))
end

local function safePlayerCall(player, label, callback)
	local ok, err = pcall(callback)
	if not ok then
		print("[ExtendedOpcode] " .. label .. " failed for " .. player:getName() .. ": " .. tostring(err))
	end
end

local function getVipDaysRemaining(player)
	local premiumDays = 0
	local vipPlusDays = 0

	local okPremium, premiumResult = pcall(function()
		return player:getPremiumDays()
	end)
	if okPremium then
		premiumDays = tonumber(premiumResult) or 0
	end
	if premiumDays >= 65000 then
		premiumDays = 0
	end

	local okVipPlus, vipPlusResult = pcall(function()
		return player:getVipPlusDays()
	end)
	if okVipPlus then
		vipPlusDays = tonumber(vipPlusResult) or 0
	else
		local expiresAt = player:getStorageValue(STORAGE_VIP or 1650000)
		local seconds = expiresAt - os.time()
		if seconds > 0 then
			vipPlusDays = math.ceil(seconds / (24 * 60 * 60))
		end
	end
	return math.max(premiumDays, vipPlusDays)
end

local function getPlayerBlessCount(player)
	local okBlessings, blessings = pcall(function()
		return player:getBlessings()
	end)
	if okBlessings and blessings then
		return tonumber(blessings) or 0
	end

	local count = 0
	for i = 1, 6 do
		local ok, hasBless = pcall(function()
			return player:hasBlessing(i)
		end)
		if ok and hasBless then
			count = count + 1
		end
	end
	return count
end

local function sendPlayerbarProfileData(player)
	local ok = pcall(function()
		player:sendPlayerbarVipData()
	end)
	if ok then
		return
	end

	local vipDays = getVipDaysRemaining(player)
	player:sendExtendedOpcode(113, json.encode({
		action = "RefreshAvatar",
		data = {
			premiumDay = vipDays,
			blessCount = getPlayerBlessCount(player),
			gainRateXP = player:isVipPlus() and 135 or 100,
			sex = player:getSex(),
			storagesData = {
				vipPlus = vipDays
			}
		}
	}))
end

function onExtendedOpcode(player, opcode, buffer)

	if opcode == OPCODE_WHEEL then
		return handleWheelOpcode(player, buffer)
	end

	if opcode == 113 then
		local success, data = pcall(function()
			return json.decode(buffer)
		end)

		if success and data and (data.data == "ShowProfile" or data.data == "UpdateProfile") then
			sendPlayerbarProfileData(player)
		end
		return
	end

	if opcode == OPCODE_MARKET then
		safePlayerCall(player, "market", function() player:handleMarket(buffer) end)
		return
	end

	if opcode == OPCODE_TASKS_KILL then
		safePlayerCall(player, "tasks_kill", function() player:handleTasksKill(buffer) end)
		return
	end

	if opcode == EXTENDED_OPCODE_CONTRACT then
		safePlayerCall(player, "contract", function() player:handleContract(buffer) end)
		return
	end

	if opcode == OPCODE_REQUEST_MANAGER then
		if type(buffer) ~= "string" or #buffer > 64 then
			return
		end

		if buffer == "shop" then
			player:sendShopStructure()
		elseif buffer == "sell" then
			if player.sendSellStructure then
				player:sendSellStructure()
			else
				player:sendSellData()
			end
		elseif string.sub(buffer, 1, 13) == "shop_category" then
			local categoryName = string.sub(buffer, 15)
			player:sendShopCategory(categoryName)
		elseif string.sub(buffer, 1, 13) == "sell_category" then
			local categoryName = string.sub(buffer, 15)
			if player.sendSellCategory then
				player:sendSellCategory(categoryName)
			else
				player:sendSellData()
			end
		else
			player:requestModule(buffer)
		end
		return
	end

	if opcode == OPCODE_BANK then
		safePlayerCall(player, "bank", function() player:handleBank(buffer) end)
		return
	end

	if opcode == OPCODE_REDEEM_CODES then
		safePlayerCall(player, "redeem_codes", function() player:handleRedeemCodes(buffer) end)
		return
	end
	if opcode == OPCODE_NEW_SELL then
		if not buffer then
			return
		end

		local success, data = pcall(function()
			return json.decode(buffer)
		end)

		if not success or not data then
			return
		end

		pcall(function()
			return handleSell(player, data)
		end)

		return
	end

	if opcode == OPCODE_NEW_SHOP then
		safePlayerCall(player, "new_shop", function() player:handleShop(buffer) end)
		return
	end
	
	-- Opcode 20 = Pass System
	if opcode == 20 then
		if type(buffer) ~= "string" then
			return
		end

		local passLevelPrice = 10
		local passElitePrice = 50
		local passLevelXP = 100
		local passMaxLevel = 100
		local passMaxXP = passMaxLevel * passLevelXP

		local function getPassDiamonds()
			if player.syncDiamondBalance then
				return player:syncDiamondBalance()
			end
			return getTotalDiamonds(player)
		end

		local function removePassDiamonds(amount)
			if player.syncDiamondBalance then
				player:syncDiamondBalance()
			end
			return removePlayerDiamond(player, amount)
		end

		local function addPassExperience(amount)
			local currentXP = math.min(passMaxXP, math.max(0, player:getStorageValue(9270000)))
			local newXP = math.min(passMaxXP, currentXP + amount)
			if newXP <= currentXP then
				return false
			end

			if player.addPassXP then
				player:addPassXP(newXP - currentXP)
			else
				player:setStorageValue(9270000, newXP)
			end
			return true
		end

		if buffer == "Open" then
			player:sendPassData()
			return
		end

		-- Comprar Passe Elite (50 diamonds)
		if buffer == "BuyPass35" then
			-- print("[PASS] Tentando comprar Passe Elite...")
			
			-- Verificar se já tem o passe
			if player:getStorageValue(9260000) > 0 then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você já possui o Passe Elite!")
				return
			end
			
			-- Verificar se tem 50 diamonds
			if getPassDiamonds() < passElitePrice then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você precisa de 50 diamonds!")
				sendPassPacket(player, "NoDiamondsBuyPass")
				return
			end
			
			-- Remover diamonds
			if not removePassDiamonds(passElitePrice) then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Erro ao processar pagamento!")
				return
			end
			
			-- Ativar Passe Elite
			player:setStorageValue(9260000, 1)
			
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
				"Parabéns! Você comprou o Passe Elite! Agora pode coletar todas as recompensas!")
			
			sendPassPacket(player, "Pass35Buyed")

			-- Reenviar dados do Pass para atualizar UI
			player:sendPassData()
			if player.sendShopDiamondBalance then
				player:sendShopDiamondBalance()
			end
			
			-- print("[PASS] Passe Elite vendido para " .. player:getName())
			return
		end
		
		-- Processar ação do Pass
		if buffer == "BuyLevel" then
			if player:getStorageValue(9260000) <= 0 then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Voce precisa do Passe Elite para comprar niveis!")
				sendPassPacket(player, "NoPass")
				return
			end

			local passXP = math.min(passMaxXP, math.max(0, player:getStorageValue(9270000)))
			if passXP >= passMaxXP then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Seu passe ja esta no nivel maximo!")
				return
			end

			if getPassDiamonds() < passLevelPrice then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Voce precisa de 10 diamonds!")
				sendPassPacket(player, "NoDiamonds")
				return
			end

			if not removePassDiamonds(passLevelPrice) then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Erro ao processar pagamento!")
				return
			end

			addPassExperience(passLevelXP)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce comprou 1 nivel do Passe!")
			sendPassPacket(player, "PassLevelUp")
			player:sendPassData()
			if player.sendShopDiamondBalance then
				player:sendShopDiamondBalance()
			end
			return
		end

		if buffer:find("#Collect#") then
			local parts = buffer:split("#")
			local level = tonumber(parts[1])
			local passType = tonumber(parts[3])
			if not level or not passType then
				return
			end

			if level < 1 or level > passMaxLevel or (passType ~= 1 and passType ~= 2) then
				return
			end
			
			-- print("[PASS] Coletando recompensa: level=" .. level .. ", type=" .. passType)
			
			-- Verificar se pode coletar
			local passXP = math.min(passMaxXP, math.max(0, player:getStorageValue(9270000)))
			local passLevel = math.floor(passXP / 100)
			
			if level > passLevel then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você ainda não alcançou este nível!")
				return
			end
			
			-- Storage específico por nível
			local stoId = (passType == 1) and 9250000 or 9260000
			local specificStoId = stoId + level
			
			if player:getStorageValue(specificStoId) > 0 then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você já coletou esta recompensa!")
				return
			end
			
			-- Verificar se tem Premium (se for recompensa premium)
			if passType == 2 then
				if player:getStorageValue(9260000) <= 0 then
					sendPassPacket(player, "NoPass")
					player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você precisa do Passe Elite!")
					return
				end
			end
			
			-- Coletar recompensa
			if PASS.ITEMS[level] and PASS.ITEMS[level][passType] then
				local reward = PASS.ITEMS[level][passType]
				local item = player:addItem(reward.itemId, reward.count or 1)
				
				if not item then
					player:sendTextMessage(MESSAGE_STATUS_WARNING, "Inventário cheio!")
					return
				end
				
				-- Marcar como coletado
				player:setStorageValue(specificStoId, 1)
				
				local itemType = ItemType(reward.itemId)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
					"Recompensa coletada: " .. (reward.count or 1) .. "x " .. itemType:getName() .. "!")
				
				-- Enviar atualização para o cliente
				sendPassPacket(player, "UpdateReward", {level, passType})
				
				-- print("[PASS] Recompensa entregue!")
			end
		end
		return
	end

    if opcode == 53 then
        -- Request initial categories
        local categories = {}
        for cat, _ in pairs(AUTOLOOT_CATEGORIES) do
            table.insert(categories, cat)
        end
        player:sendExtendedOpcode(170, table.concat(categories, "@"))
        
        -- Send first category items
        local firstCat = categories[1]
        if firstCat then
            local items = AUTOLOOT_CATEGORIES[firstCat]
            for _, itemId in ipairs(items) do
                local it = ItemType(itemId)
                player:sendExtendedOpcode(106, it:getClientId() .. "@" .. it:getName() .. "@" .. (player:getStorageValue(AUTOLOOT_ALL_ENABLED) == 1 and "true" or "false"))
            end
        end
        
        -- Send already added items
        player:sendAutolootList()
      	return
    end

    if opcode == 54 then
        -- Change category
        local category = buffer
        local items = AUTOLOOT_CATEGORIES[category]
        if items then
            player:sendExtendedOpcode(107, "destroy")
            for _, itemId in ipairs(items) do
                local it = ItemType(itemId)
                player:sendExtendedOpcode(108, it:getClientId() .. "@" .. it:getName() .. "@" .. (player:getStorageValue(AUTOLOOT_ALL_ENABLED) == 1 and "true" or "false"))
            end
        end
        return
    end

    if opcode == 55 then
        -- Add item by name
        local itemName = tostring(buffer or "")
        if itemName == "" or #itemName > 64 then return end
        local it = ItemType(itemName)
        if not it or it:getId() == 0 then return end
        
        local alreadyIn = false
        local freeSlot = nil
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            if isAutoLootItemStorage(i) then
                local sto = player:getStorageValue(i)
                if sto == it:getId() then alreadyIn = true break end
                if not freeSlot and sto <= 0 then freeSlot = i end
            end
        end
        
        if not alreadyIn and freeSlot then
            player:setStorageValue(freeSlot, it:getId())
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .. " has been added to the list.")
            player:sendAutolootList()
        elseif alreadyIn then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .. " is already in the list.")
        end
        return
    end

    if opcode == 56 then
        -- Remove item by name
        local itemName = tostring(buffer or "")
        if itemName == "" or #itemName > 64 then return end
        local it = ItemType(itemName)
        if not it or it:getId() == 0 then return end
        
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            if isAutoLootItemStorage(i) then
                if player:getStorageValue(i) == it:getId() then
                    player:setStorageValue(i, 0)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .. " has been removed from the list.")
                    player:sendAutolootList()
                    break
                end
            end
        end
        return
    end

    if opcode == 65 then
        -- Search only items configured for auto loot
        local params = tostring(buffer or ""):split("@")
        local search = tostring(params[1] or "")
        local category = tostring(params[2] or "")
        if #search > 32 then return end
        local searchLower = search:lower()
        
        player:sendExtendedOpcode(107, "destroy")
        local categories = AUTOLOOT_CATEGORIES[category] and {category} or {}
        if #categories == 0 then
            for cat, _ in pairs(AUTOLOOT_CATEGORIES) do
                table.insert(categories, cat)
            end
        end

        for _, cat in ipairs(categories) do
            for _, itemId in ipairs(AUTOLOOT_CATEGORIES[cat]) do
                local it = ItemType(itemId)
                local itemName = it and it:getName() or ""
                if it and itemName ~= "" and (search == "none" or #search < 2 or itemName:lower():find(searchLower, 1, true)) then
                    player:sendExtendedOpcode(108, it:getClientId() .. "@" .. itemName .. "@" .. (player:getStorageValue(AUTOLOOT_ALL_ENABLED) == 1 and "true" or "false"))
                end
            end
        end
        return
    end
	
	if opcode == 57 then
		-- Toggle autoloot ON/OFF
		if buffer == "ligar" then
			player:setStorageValue(AUTOLOOT_ALL_ENABLED, 1)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto-Loot ATIVADO - Apenas itens da sua lista serao coletados!")
		else
			player:setStorageValue(AUTOLOOT_ALL_ENABLED, -1)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto-Loot DESATIVADO")
		end
        player:sendAutolootList()
        -- Send state to update power button in UI (using 106 or similar)
        player:sendExtendedOpcode(106, "0@state@" .. (player:getStorageValue(AUTOLOOT_ALL_ENABLED) == 1 and "true" or "false"))
		return
	end
	
    if opcode == POKEDEX_OPCODE then
        safePlayerCall(player, "pokedex", function() player:handlePokedex(buffer) end)
        return
    end

    if opcode == OPCODE_DONATIONGOALS then
		local ok, data = pcall(function() return json.decode(buffer) end)
		if ok and type(data) == "table" then
			if data.type == "request" then
				doSendDonationGoalsInformation(player)
			elseif data.type == "collect" then
				if data.rewardType == "global" then
					doCollectGlobalReward(player)
				elseif data.rewardType == "pessoal" or data.rewardType == "personal" then
					local rewardPosition = math.max(1, math.min(3, tonumber(data.subId or data.id or 1) - 1))
					doCollectGoalReward(player, rewardPosition)
				end
			end
        elseif buffer == "request" then
            doSendDonationGoalsInformation(player)
        elseif buffer == "doCollectPersonalReward1" then
            doCollectGoalReward(player, 1)
        elseif buffer == "doCollectPersonalReward2" then
            doCollectGoalReward(player, 2)
        elseif buffer == "doCollectPersonalReward3" then
            doCollectGoalReward(player, 3)
        elseif buffer == "doCollectGlobalReward" then
            doCollectGlobalReward(player)
        end
		return
    end

    if opcode == OPCODE_CATCH then
        if buffer == "require" then
            player:sendBrokesToPlayer()
        end
        return
    end

	if opcode == 78 then
		local ok, data = pcall(function() return json.decode(buffer) end)
		if not ok or type(data) ~= "table" then
			return true
		end

		local packetType = data.type
		
		if packetType == "check" then
			if #player:getSummons() == 0 then
				doPlayerPopupFYI(player, "Voc� n�o possui o pokemon ativo.")
				return true
			end
			local ball = player:getUsingBall()
			if not ball then return end
			if ball:getSpecialAttribute("shader") or getBallKey(ball:getId()) == "premier" then
				local shaderId = tonumber(data.shader)
				local shader = SHADERSLIST[shaderId]
				if shader then
					ball:setSpecialAttribute("shader", shaderId)
					doPlayerPopupFYI(player, "Particle aura alterado.")
					player:modifierPokemon(0, 0, SHADER_NAMES_TO_IDS[shader], -1)
				end
			else
				doPlayerPopupFYI(player, "Este pok�mon n�o possui particle aura.")
			end
		end
		return true
	end

	if opcode == CODE_GAMESTORE then
		if not GAME_STORE then
			gameStoreInitialize()
			addEvent(refreshPlayersPoints, 10 * 1000)
		end
	
		local status, json_data =
			pcall(
			function()
				return json.decode(buffer)
			end
		)
		if not status then
			return
		end
	
		local action = json_data.action
		local data = json_data.data
		if not action or not data then
			return
		end
	
		if action == "fetch" then
			gameStoreFetch(player)
		elseif action == "purchase" then
			gameStorePurchase(player, data)
		elseif action == "gift" then
			gameStorePurchaseGift(player, data)
		end
	end
	
	-- Opcode 100 = Protagonist Mode (ativar/desativar)
	if opcode == 100 then
		if buffer == "protagonist_on" then
			print("[PROTAGONIST] " .. player:getName() .. " ativando modo...")
			player:activateProtagonistMode()
		elseif buffer == "protagonist_off" then
			print("[PROTAGONIST] " .. player:getName() .. " desativando modo...")
			player:deactivateProtagonistMode()
		end
		return
	end
	
	-- Opcode 106 = Map ACK (cliente confirmou que processou MapDescription)
	if opcode == 106 then
		if buffer == "protag_map_ack" then
			player:setProtagonistWaitingForMapAck(false)
			print("[PROTAGONIST] ✅ Cliente confirmou processamento do mapa (ACK recebido)")
		end
		return
	end
	
	-- Opcode 2 = Daily Rewards
	if opcode == 2 then
		local status, data = pcall(function() return json.decode(buffer) end)
		if not status then
			return
		end
		
		if data.action == "refresh" then
			-- Enviar dados de recompensas com clientId convertido do itemId
			local rewardsDataServer = {
				[1] = {itemId = 26731, count = 1, name = "Leaf Stone"},
				[2] = {itemId = 26728, count = 1, name = "Fire Stone"},
				[3] = {itemId = 26736, count = 1, name = "Water Stone"},
				[4] = {itemId = 26734, count = 1, name = "Thunder Stone"},
				[5] = {itemId = 2152, count = 5, name = "Hundred Dollar"},
				[6] = {itemId = 27643, count = 3, name = "Great Potion"},
				[7] = {itemId = 26748, count = 1, name = "Sun Stone"},
				[8] = {itemId = 38787, count = 2, name = "Rare Candy"},
				[9] = {itemId = 2160, count = 1, name = "Ten Thousand Dollar"},
				[10] = {itemId = 27641, count = 2, name = "Ultra Potion"},
				[11] = {itemId = 26731, count = 2, name = "Leaf Stone"},
				[12] = {itemId = 27645, count = 3, name = "Revive"},
				[13] = {itemId = 2152, count = 10, name = "Hundred Dollar"},
				[14] = {itemId = 26728, count = 2, name = "Fire Stone"},
				[15] = {itemId = 38787, count = 3, name = "Rare Candy"},
				[16] = {itemId = 26736, count = 2, name = "Water Stone"},
				[17] = {itemId = 2160, count = 2, name = "Ten Thousand Dollar"},
				[18] = {itemId = 27647, count = 5, name = "Hyper Potion"},
				[19] = {itemId = 26734, count = 2, name = "Thunder Stone"},
				[20] = {itemId = 38787, count = 5, name = "Rare Candy"},
				[21] = {itemId = 2160, count = 10, name = "Ten Thousand Dollar"}
			}
			
			-- Converter itemId para clientId
			local rewardsData = {}
			for day, reward in pairs(rewardsDataServer) do
				local itemType = ItemType(reward.itemId)
				local clientId = itemType and itemType:getClientId() or reward.itemId
				rewardsData[day] = {
					clientId = clientId,
					count = reward.count,
					name = reward.name
				}
			end
			
			local currentDay = math.max(1, player:getStorageValue(STORAGE_DAILY_REWARDS_DAY) or 1)
			local lastClaimTime = player:getStorageValue(STORAGE_DAILY_REWARDS_LAST_CLAIM) or 0
			local now = os.time()
			local canClaim = false
			local nextClaim = 0
			
			-- Verificar se pode coletar hoje
			if lastClaimTime == 0 or (now - lastClaimTime) >= 86400 then
				canClaim = true
				nextClaim = now + 86400
			else
				nextClaim = lastClaimTime + 86400
			end
			
			local response = {
				rewards = rewardsData,
				currentDay = currentDay,
				canClaim = canClaim,
				nextClaim = nextClaim,
				autoShow = false
			}
			
			player:sendExtendedOpcode(2, json.encode(response))
			
		elseif data.action == "claim" then
			-- Coletar recompensa
			local currentDay = math.max(1, player:getStorageValue(STORAGE_DAILY_REWARDS_DAY) or 1)
			local lastClaimTime = player:getStorageValue(STORAGE_DAILY_REWARDS_LAST_CLAIM) or 0
			local now = os.time()
			
			-- Verificar se pode coletar
			if lastClaimTime > 0 and (now - lastClaimTime) < 86400 then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Você já coletou a recompensa de hoje!")
				return
			end
			
			-- Itens de recompensa (DEVE SER IGUAL AO CLIENTE!)
			local rewardsData = {
				[1] = {itemId = 26731, count = 1},
				[2] = {itemId = 26728, count = 1},
				[3] = {itemId = 26736, count = 1},
				[4] = {itemId = 26734, count = 1},
				[5] = {itemId = 2152, count = 5},
				[6] = {itemId = 27643, count = 3},
				[7] = {itemId = 26748, count = 1},
				[8] = {itemId = 38787, count = 2},
				[9] = {itemId = 2160, count = 1},
				[10] = {itemId = 27641, count = 2},
				[11] = {itemId = 26731, count = 2},
				[12] = {itemId = 27645, count = 3},
				[13] = {itemId = 2152, count = 10},
				[14] = {itemId = 26728, count = 2},
				[15] = {itemId = 38787, count = 3},
				[16] = {itemId = 26736, count = 2},
				[17] = {itemId = 2160, count = 2},
				[18] = {itemId = 27647, count = 5},
				[19] = {itemId = 26734, count = 2},
				[20] = {itemId = 38787, count = 5},
				[21] = {itemId = 2160, count = 10}
			}
			
			local reward = rewardsData[currentDay]
			if not reward then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Recompensa não encontrada!")
				return
			end
			
			-- Adicionar item ao jogador
			local item = Game.createItem(reward.itemId, reward.count)
			if not item or not player:addItemEx(item) then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, "Seu inventário está cheio!")
				return
			end
			
			-- Atualizar storage
			local newDay = currentDay + 1
			if newDay > 21 then
				newDay = 1
			end
			
			player:setStorageValue(STORAGE_DAILY_REWARDS_DAY, newDay)
			player:setStorageValue(STORAGE_DAILY_REWARDS_LAST_CLAIM, now)
			
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa coletada com sucesso!")
			
			-- Enviar dados atualizados com clientId convertido
			local rewardsDataServer = {
				[1] = {itemId = 26731, count = 1, name = "Leaf Stone"},
				[2] = {itemId = 26728, count = 1, name = "Fire Stone"},
				[3] = {itemId = 26736, count = 1, name = "Water Stone"},
				[4] = {itemId = 26734, count = 1, name = "Thunder Stone"},
				[5] = {itemId = 2152, count = 5, name = "Hundred Dollar"},
				[6] = {itemId = 27643, count = 3, name = "Great Potion"},
				[7] = {itemId = 26748, count = 1, name = "Sun Stone"},
				[8] = {itemId = 38787, count = 2, name = "Rare Candy"},
				[9] = {itemId = 2160, count = 1, name = "Ten Thousand Dollar"},
				[10] = {itemId = 27641, count = 2, name = "Ultra Potion"},
				[11] = {itemId = 26731, count = 2, name = "Leaf Stone"},
				[12] = {itemId = 27645, count = 3, name = "Revive"},
				[13] = {itemId = 2152, count = 10, name = "Hundred Dollar"},
				[14] = {itemId = 26728, count = 2, name = "Fire Stone"},
				[15] = {itemId = 38787, count = 3, name = "Rare Candy"},
				[16] = {itemId = 26736, count = 2, name = "Water Stone"},
				[17] = {itemId = 2160, count = 2, name = "Ten Thousand Dollar"},
				[18] = {itemId = 27647, count = 5, name = "Hyper Potion"},
				[19] = {itemId = 26734, count = 2, name = "Thunder Stone"},
				[20] = {itemId = 38787, count = 5, name = "Rare Candy"},
				[21] = {itemId = 2160, count = 10, name = "Ten Thousand Dollar"}
			}
			
			-- Converter itemId para clientId
			local rewardsDataResponse = {}
			for day, reward in pairs(rewardsDataServer) do
				local itemType = ItemType(reward.itemId)
				local clientId = itemType and itemType:getClientId() or reward.itemId
				rewardsDataResponse[day] = {
					clientId = clientId,
					count = reward.count,
					name = reward.name
				}
			end
			
			local response = {
				rewards = rewardsDataResponse,
				currentDay = newDay,
				canClaim = false,
				nextClaim = now + 86400,
				autoShow = false
			}
			
			player:sendExtendedOpcode(2, json.encode(response))
		end
		
		return
	end
	
	if opcode == 101 then
		if player:isProtagonistMode() then
			local data = PROTAGONIST_MODE[player:getId()]
			if data and data.pokemon then
				local pokemon = data.pokemon
				
				-- VALIDAÇÃO ULTRA RIGOROSA: verificar pokeball E nome
				local ball = player:getUsingBall()
				if not ball then
					print("[PROTAGONIST] ERRO: Pokeball removida!")
					player:deactivateProtagonistMode()
					return
				end
				
				local pokeName = ball:getSpecialAttribute("pokeName")
				if not pokeName or pokemon:getName():lower() ~= pokeName:lower() then
					print("[PROTAGONIST] ERRO: Pokémon (" .. pokemon:getName() .. ") não corresponde à pokeball (" .. (pokeName or "null") .. ")!")
					player:deactivateProtagonistMode()
					return
				end
				
				-- VALIDAR que é summon do player
				if not pokemon:getMaster() or pokemon:getMaster():getId() ~= player:getId() then
					print("[PROTAGONIST] ERRO: Pokémon não pertence ao player!")
					player:deactivateProtagonistMode()
					return
				end
				
				-- GARANTIR que pokémon não está seguindo ninguém
				if pokemon:getFollowCreature() then
					pokemon:setFollowCreature(nil)
				end
				local dirMap = {
					north = DIRECTION_NORTH,
					east = DIRECTION_EAST,
					south = DIRECTION_SOUTH,
					west = DIRECTION_WEST,
					northeast = DIRECTION_NORTHEAST,
					southeast = DIRECTION_SOUTHEAST,
					southwest = DIRECTION_SOUTHWEST,
					northwest = DIRECTION_NORTHWEST
				}
				local direction = dirMap[buffer:lower()]
				if direction then
					-- Verificar se não está em exhaust (anti-spam)
					local now = os.mtime()
					local lastMove = data.lastMove or 0
					
					-- Delay mínimo de 150ms entre movimentos (evita speed hack)
					if now - lastMove >= 150 then
						-- COLISÃO INTELIGENTE: pokemon:move() considera automaticamente:
						-- ✅ Propriedades da criatura (voar, atravessar água, etc)
						-- ✅ Colisões com outras criaturas
						-- ✅ Bloqueios de terreno específicos para aquele tipo
						-- ✅ Se o tile existe e é válido
						local result = pokemon:move(direction)
						if result then
							data.lastMove = now
						end
						-- Se move() retornar false/nil, o Pokémon não se move (bloqueio válido para aquela criatura)
					end
				end
			end
		end
		return
	end

end
