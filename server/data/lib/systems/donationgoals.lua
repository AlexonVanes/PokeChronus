local OPCODE = 8
DonationGoalKey = 85210
GoalStartDate = "2024-04-09T00:00:00Z"
GoalEndDate = "2024-05-09T23:59:59Z"
newGoalStartDate = "2024-04-09 00:00:00"
newGoalEndDate = "2024-05-09 00:00:00"
local function refreshDonationGoalPeriod()
  local now = os.time()
  local date = os.date("*t", now)
  local startTime = os.time({year = date.year, month = date.month, day = 1, hour = 0, min = 0, sec = 0})
  local nextMonthYear = date.year
  local nextMonth = date.month + 1
  if nextMonth > 12 then
    nextMonth = 1
    nextMonthYear = nextMonthYear + 1
  end
  local endTime = os.time({year = nextMonthYear, month = nextMonth, day = 1, hour = 0, min = 0, sec = 0}) - 1
  GoalStartDate = os.date("%Y-%m-%dT%H:%M:%SZ", startTime)
  GoalEndDate = os.date("%Y-%m-%dT%H:%M:%SZ", endTime)
  newGoalStartDate = os.date("%Y-%m-%d %H:%M:%S", startTime)
  newGoalEndDate = os.date("%Y-%m-%d %H:%M:%S", endTime)
end
local function getDonationGoalStorageValue()
  return tonumber(os.date("%Y%m", os.time())) or 1
end
local function parseDonationGoalAmount(value)
  value = tostring(value or "0")
  value = value:gsub(",", ".")
  return tonumber(value) or 0
end

local function getDonationGoalDateField(fieldName)
  return "REPLACE(REPLACE(`" .. fieldName .. "`, 'T', ' '), 'Z', '')"
end
local function addDonationGoalItemReward(player, reward)
  if not reward or not reward.id then
    return false
  end

  local count = math.max(1, math.floor(tonumber(reward.count) or 1))
  if player.addShopItemToCoinsBag then
    return player:addShopItemToCoinsBag(reward.id, count) >= count
  end

  local coinsBag = nil
  if player.getOrCreateCoinsBag then
    coinsBag = player:getOrCreateCoinsBag()
  end

  local itemType = ItemType(reward.id)
  local isStackable = itemType and itemType:isStackable() or false
  if isStackable then
    local delivered = 0
    while delivered < count do
      local addCount = math.min(100, count - delivered)
      local added = coinsBag and coinsBag:addItem(reward.id, addCount) or nil
      if not added then
        added = player:addItem(reward.id, addCount, false)
      end
      if not added then
        break
      end
      delivered = delivered + addCount
    end
    return delivered >= count
  end

  for i = 1, count do
    local added = coinsBag and coinsBag:addItem(reward.id, 1) or nil
    if not added then
      added = player:addItem(reward.id, 1, false)
    end
    if not added then
      return false
    end
  end
  return true
end
globalGoalReward = {
  {
    type = "ITEM",
    name = "Bike Cronus",
    reward = {id = 27634, count = 1},
    desc = "Uma bike especial para acelerar sua jornada pelo mapa. Use no slot correto para viajar mais rapido entre hunts, quests e cidades.",
    meta = 100,
    playerDonate = 5,
    storage = DonationGoalKey+1
  },
}
goalsReward = {
  { type = "ITEM", meta = 5, reward = {id = 27634, count = 1}, desc = "Uma bike especial para acelerar sua jornada pelo mapa. Use no slot correto para viajar mais rapido entre hunts, quests e cidades.", storage = DonationGoalKey+2 },
}
function doSendDonationGoalsInformation(player)
  refreshDonationGoalPeriod()
  informations = {
    ServerGoal = doGetDonateGlobal(GoalStartDate, GoalEndDate),
    PlayerGoal = getTotalDonationPlayer(GoalStartDate, GoalEndDate, player:getName()),
    globalGoal = getTableConverted(player, globalGoalReward),
    personalGoal = getTableConverted(player, goalsReward),
    date = {
        AtualDate = getFormattedDate(),
        EndDate = GoalEndDate
    }
  }
  sendDonateGoalsByJSON(player, "DonationGoalsInformation", informations)
end
function getTableConverted(player, receivedTable)
  local convertedTable = {}
  for i, item in ipairs(receivedTable) do
    local convertedItem = {}
    if item.type == "ITEM" then
      if item.reward then
        local rewardItem = ItemType(item.reward.id)
        local clientId = rewardItem:getClientId()
        local itemName = getItemName(item.reward.id)
        local rewardDesc = itemName .. "\n" .. (item.desc or "")
        convertedItem.type = item.type
        convertedItem.name = item.name or itemName
        convertedItem.reward = { id = clientId, count = item.reward.count }
        convertedItem.desc = rewardDesc
      else
        convertedItem.type = item.type
        convertedItem.name = item.name or "Reward"
        convertedItem.desc = item.desc or ""
      end
      if item.storage then
        local storageValue = player:getStorageValue(item.storage)
        convertedItem.storage = storageValue
        convertedItem.claimed = storageValue == getDonationGoalStorageValue()
      end
      if item.meta then
        convertedItem.meta = item.meta
      end
      if item.playerDonate then
        convertedItem.playerDonate = item.playerDonate
      end
    elseif item.type == "POKEMON" then
      if item.reward then
        local rewardDesc = item.reward .. "\n" .. (item.desc or "")
        convertedItem.type = item.type
        convertedItem.name = item.name or item.reward
        convertedItem.desc = rewardDesc
      else
        convertedItem.type = item.type
        convertedItem.name = item.name or "Reward"
        convertedItem.desc = item.desc or ""
      end
      if item.storage then
        local storageValue = player:getStorageValue(item.storage)
        convertedItem.storage = storageValue
        convertedItem.claimed = storageValue == getDonationGoalStorageValue()
      end
      if item.meta then
        convertedItem.meta = item.meta
      end
      if item.outfit then
        convertedItem.outfit = item.outfit
      end
      if item.playerDonate then
        convertedItem.playerDonate = item.playerDonate
      end
    end
    table.insert(convertedTable, convertedItem)
  end
  return convertedTable
end
function doCollectGoalReward(player, position)
  refreshDonationGoalPeriod()
  position = tonumber(position) or 1
  local goalReward = goalsReward[position]
  if not goalReward then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Recompensa de meta pessoal invalida.")
    return
  end
  local jogadorSelecionado = player:getName()
  local playerDonateValue = getTotalDonationPlayer(GoalStartDate, GoalEndDate, jogadorSelecionado)
  local currentStorageValue = getDonationGoalStorageValue()
  local getGlobalStorage = player:getStorageValue(goalReward.storage)

  if playerDonateValue >= goalReward.meta then

     if getGlobalStorage ~= currentStorageValue then
        if goalReward.type == "ITEM" then
        local reward = goalReward.reward
        if not addDonationGoalItemReward(player, reward) then
          player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nao foi possivel enviar a recompensa para sua Coins Bag.")
          doSendDonationGoalsInformation(player)
          return
        end
        player:setStorageValue(goalReward.storage, currentStorageValue)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabens! Sua recompensa foi enviada para a Coins Bag: "..ItemType(reward.id):getName())
      elseif goalReward.type == "POKEMON" then
        local reward = goalReward.reward
            doAddPokeball(player, reward)
            doSendPokeTeamByClient(player)
        player:setStorageValue(goalReward.storage, currentStorageValue)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabéns Você ajudou o servidor a atingir a meta de doação global e recebeu o seguinte pokémon: "..reward)
      end
     else
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você já coletou essa recompensa.")
     end
  else
     player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa ajudar o servidor com pelo menos "..goalReward.meta.." pontos para coletar essa recompensa.")
  end
  doSendDonationGoalsInformation(player)
end
function doCollectGlobalReward(player)
    refreshDonationGoalPeriod()
    local goalReward = globalGoalReward[1]
    if not goalReward then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Recompensa de meta global invalida.")
        return
    end
    local jogadorSelecionado = player:getName()
    local globalDonateValue = doGetDonateGlobal(GoalStartDate, GoalEndDate)
    local playerDonateValue = getTotalDonationPlayer(GoalStartDate, GoalEndDate, jogadorSelecionado) -- getTotalSpendingAmountOfDiamonds(GoalStartDate, GoalEndDate, player:getName())
    local currentStorageValue = getDonationGoalStorageValue()
    local getGlobalStorage = player:getStorageValue(goalReward.storage)
    if globalDonateValue >= goalReward.meta then
        if playerDonateValue >= goalReward.playerDonate then
            if getGlobalStorage ~= currentStorageValue then
                if goalReward.type == "ITEM" then
                    local reward = goalReward.reward
                    if not addDonationGoalItemReward(player, reward) then
                        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nao foi possivel enviar a recompensa para sua Coins Bag.")
                        doSendDonationGoalsInformation(player)
                        return
                    end
                    player:setStorageValue(goalReward.storage, currentStorageValue)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabens! Sua recompensa foi enviada para a Coins Bag: "..ItemType(reward.id):getName())
                elseif goalReward.type == "POKEMON" then
                    local reward = goalReward.reward
                    if reward == "Maga Negra" then
                        player:addOutfit(goalReward.outfit.type)
                        player:setStorageValue(goalReward.storage, currentStorageValue)
                        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabéns! Você ajudou o servidor a atingir a meta de doação global e recebeu a outfit maga negra")
                        doSendDonationGoalsInformation(player)
                        return
                    end
                    doAddPokeball(player:getId(), reward)
                    doSendPokeTeamByClient(player)
                    player:setStorageValue(goalReward.storage, currentStorageValue)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabéns! Você ajudou o servidor a atingir a meta de doação global e recebeu o seguinte pokémon: "..reward)
                end
            else
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você já coletou a recompensa global deste mês.")
            end
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa ajudar o servidor com pelo menos "..goalReward.playerDonate.." pontos para coletar a recompensa de meta global.")
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Ainda não atingimos a meta de doação global!")
    end
    doSendDonationGoalsInformation(player)
end
function doGetDonateGlobal(dataInicial, dataFinal)
  local totalDonate = 0
  refreshDonationGoalPeriod()

  local resultId = db.storeQuery("SELECT `price` FROM `pix_payment` WHERE " .. getDonationGoalDateField("creation") .. " BETWEEN '" .. newGoalStartDate .. "' AND '" .. newGoalEndDate .. "' AND `status` = 'CONCLUIDA' ORDER BY `loc_id` DESC")
  if resultId ~= false then
      repeat
        totalDonate = totalDonate + parseDonationGoalAmount(result.getDataString(resultId, "price"))
      until not result.next(resultId)
      result.free(resultId)
  end

  local newResultId = db.storeQuery("SELECT `valor` FROM `historico_pagamentos` WHERE `date_created` BETWEEN '" .. newGoalStartDate .. "' AND '" .. newGoalEndDate .. "' AND `status` = '4' AND `entregue` = '1' ORDER BY `id` DESC")
  if newResultId ~= false then
    repeat
      totalDonate = totalDonate + parseDonationGoalAmount(result.getDataInt(newResultId, "valor"))
    until not result.next(newResultId)
      result.free(newResultId)
  end

  return totalDonate
end
function getTotalDonationPlayer(startDate, endDate, jogadorSelecionado)
  refreshDonationGoalPeriod()
  local playerGUID = getPlayerGUIDByName(jogadorSelecionado)
  if not playerGUID or playerGUID <= 0 then
    return 0
  end

  local totalDonate = 0
  local resultId = db.storeQuery("SELECT `price` FROM `pix_payment` WHERE `player_id` = '" .. playerGUID .. "' AND " .. getDonationGoalDateField("creation") .. " BETWEEN '" .. newGoalStartDate .. "' AND '" .. newGoalEndDate .. "' AND `status` = 'CONCLUIDA' ORDER BY `loc_id` DESC")
  if resultId ~= false then
      repeat
        totalDonate = totalDonate + parseDonationGoalAmount(result.getDataString(resultId, "price"))
      until not result.next(resultId)
        result.free(resultId)
  end

  local newResultId = db.storeQuery("SELECT `valor` FROM `historico_pagamentos` WHERE `player_id` = '" .. playerGUID .. "' AND `date_created` BETWEEN '" .. newGoalStartDate .. "' AND '" .. newGoalEndDate .. "' AND `status` = '4' AND `entregue` = '1' ORDER BY `id` DESC")
  if newResultId ~= false then
    repeat
      totalDonate = totalDonate + parseDonationGoalAmount(result.getDataInt(newResultId, "valor"))
    until not result.next(newResultId)
      result.free(newResultId)
  end

  return totalDonate
end
function string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end
function sendDonateGoalsByJSON(player, action, data)
  local MAX_PACKET_SIZE = 50000

  local buffer = json.encode({action = action, data = data})
  local s = {}
  for i = 1, #buffer, MAX_PACKET_SIZE do
      s[#s + 1] = buffer:sub(i, i + MAX_PACKET_SIZE - 1)
  end
  local msg = NetworkMessage()
  if #s == 1 then
      msg:addByte(50)
      msg:addByte(OPCODE)
      msg:addString(s[1])
      msg:sendToPlayer(player)
      return
  end
  -- split message if too big
  msg:addByte(50)
  msg:addByte(OPCODE)
  msg:addString("S" .. s[1])
  msg:sendToPlayer(player)
  for i = 2, #s - 1 do
      msg = NetworkMessage()
      msg:addByte(50)
      msg:addByte(OPCODE)
      msg:addString("P" .. s[i])
      msg:sendToPlayer(player)
  end
  msg = NetworkMessage()
  msg:addByte(50)
  msg:addByte(OPCODE)
  msg:addString("E" .. s[#s])
  msg:sendToPlayer(player)
end
function getFormattedDate()
  local currentTime = os.time()
  local formattedDate = os.date("%d-%m-%Y", currentTime)
  return formattedDate
end