local OPCODE = 8
local donateGoalWindow, donateButton, onGameEnd
local currentGoal = {}

local function normalizeNumber(value)
    if type(value) == "table" then
        value = value.value or value.amount or value.playerDonate or value[1] or 0
    end
    return tonumber(value) or 0
end

local function requestDonationGoals()
    local protocol = g_game.getProtocolGame()
    if protocol and protocol:isConnected() then
        protocol:sendExtendedOpcode(OPCODE, json.encode({type = "request"}))
    end
end

local function getGlobalReward(data)
    if data.globalGoal and data.globalGoal[1] then
        return data.globalGoal[1]
    end
    if data.globalRewards and data.globalRewards[1] then
        return data.globalRewards[1]
    end
    if data.goalRewards and data.goalRewards[1] and data.goalRewards[1][1] then
        return data.goalRewards[1][1]
    end
    return {}
end

local function formatMoney(value)
    value = normalizeNumber(value)
    if value % 1 == 0 then
        return "R$" .. value .. ",00"
    end
    local text = string.format("R$%.2f", value)
    return text:gsub("%.", ",")
end

local function goalWidget(id)
    if not donateGoalWindow then
        return nil
    end
    return donateGoalWindow:recursiveGetChildById(id)
end

local function setProgress(current, goal)
    local back = goalWidget("progressBack")
    local full = goalWidget("progressFull")
    local text = goalWidget("progressText")
    if not back or not full then
        return
    end

    current = normalizeNumber(current)
    goal = normalizeNumber(goal)
    local visibleGoal = goal > 0 and goal or 100
    local visibleCurrent = math.min(current, visibleGoal)
    local percent = visibleGoal > 0 and math.min(100, math.floor((visibleCurrent / visibleGoal) * 100)) or 0
    local width = math.max(1, math.floor(back:getWidth() * (percent / 100)))
    local rect = {x = 0, y = 0, width = width, height = full:getHeight()}

    full:setImageClip(rect)
    full:setImageRect(rect)
    if text then
        text:setText(visibleCurrent .. " / " .. visibleGoal)
        text:setWidth(110)
        text:setTooltip("Meta global: " .. visibleCurrent .. " / " .. visibleGoal)
    end
end

local function setButtonState(canRedeem, statusText)
    local button = goalWidget("redeemButton")
    local status = goalWidget("statusLabel")
    if not button then
        return
    end

    button:setEnabled(canRedeem)
    button:setOpacity(canRedeem and 1 or 0.55)
    button:setBackgroundColor(canRedeem and "#067a27" or "#333333")
    if status then
        status:setText(statusText or "")
    end
end

local function renderReward(reward)
    local slot = goalWidget("rewardSlot")
    if not slot then
        return
    end

    local item = slot:recursiveGetChildById("rewardItem")
    if item then
        local itemId = reward.reward and reward.reward.id or 27634
        item:setItemId(itemId)
        item:setItemCount(reward.reward and reward.reward.count or 1)
        item:setVisible(true)
        item:setTooltip(reward.desc or "Bike Cronus")
    end
end

local function renderGoal(data)
    if not donateGoalWindow then
        return
    end

    local reward = getGlobalReward(data)
    local globalGoal = normalizeNumber(data.ServerGoal or data.globalGoalValue or data.globalGoal)
    local goalMeta = normalizeNumber(reward.meta)
    local playerDonate = normalizeNumber(data.PlayerGoal or data.playerGoal)
    local playerRequired = normalizeNumber(reward.playerDonate or 5)
    local claimed = reward.claimed == true

    currentGoal = {
        globalGoal = globalGoal,
        goalMeta = goalMeta,
        playerDonate = playerDonate,
        playerRequired = playerRequired,
        claimed = claimed
    }

    renderReward(reward)
    local rewardNameLabel = goalWidget("rewardNameLabel")
    local requirementLabel = goalWidget("requirementLabel")
    local descLabel = goalWidget("descLabel")
    if rewardNameLabel then
        rewardNameLabel:setText(reward.name or "Bike Cronus")
    end
    if requirementLabel then
        requirementLabel:setText([=[Quando o servidor atingir esta meta, voce podera resgatar a recompensa ao lado!

Para resgatar a recompensa, voce precisa ter doado pelo menos R$5.]=])
    end
    if descLabel then
        descLabel:setText([=[Bike Cronus

A Bike Cronus e uma recompensa feita para quem quer ganhar tempo na jornada. Ela aumenta sua velocidade ao equipar, ajuda muito nas hunts, encurta viagens entre cidades e deixa quests longas bem mais rapidas e confortaveis.]=])
    end
    setProgress(globalGoal, goalMeta)

    if claimed then
        setButtonState(false, "Voce ja resgatou esta recompensa este mes.")
    elseif globalGoal < goalMeta then
        setButtonState(false, "Meta global ainda nao foi atingida.")
    elseif playerDonate < playerRequired then
        setButtonState(false, "Voce precisa ter donatado pelo menos " .. formatMoney(playerRequired) .. ".")
    else
        setButtonState(true, "Recompensa liberada para resgate.")
    end
end

function receiveOpcode(protocol, opcode, buffer)
    if not donateGoalWindow or buffer == "TESTE_DONATION_GOALS" then
        return
    end

    local success, decoded = pcall(json.decode, buffer)
    if not success or type(decoded) ~= "table" then
        return
    end

    local data = decoded.action and decoded.data or decoded
    if type(data) ~= "table" then
        return
    end
    renderGoal(data)
end

function collectGoal()
    if not currentGoal.goalMeta then
        return
    end

    local protocol = g_game.getProtocolGame()
    if protocol and protocol:isConnected() then
        protocol:sendExtendedOpcode(OPCODE, json.encode({type = "collect", rewardType = "global", id = 1}))
    end
end

local function renderDefaultGoal()
    renderGoal({
        ServerGoal = 0,
        PlayerGoal = 0,
        globalGoal = {
            {
                type = "ITEM",
                name = "Bike Cronus",
                reward = {id = 27634, count = 1},
                desc = "Bike Cronus",
                meta = 100,
                playerDonate = 5,
                claimed = false
            }
        }
    })
end

function init()
    donateGoalWindow = g_ui.loadUI("donationgoals", modules.game_interface.getRootPanel())
    if not donateGoalWindow then
        return
    end
    donateButton = modules.client_topmenu.addRightGameToggleButton("donationGoalsButton", tr("Donate Goal"), "/images/topbuttons/donation", toggle, true)
    ProtocolGame.registerExtendedOpcode(OPCODE, receiveOpcode)

    local redeemButton = goalWidget("redeemButton")
    if redeemButton then
        redeemButton.onClick = collectGoal
    end
    renderDefaultGoal()
    onGameEnd = function()
        if donateGoalWindow then
            donateGoalWindow:hide()
        end
    end
    connect(g_game, {
        onGameEnd = onGameEnd
    })
    donateGoalWindow:hide()
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE)
    if onGameEnd then
        disconnect(g_game, {
            onGameEnd = onGameEnd
        })
        onGameEnd = nil
    end
    if donateGoalWindow then
        donateGoalWindow:destroy()
        donateGoalWindow = nil
    end
    if donateButton then
        donateButton:destroy()
        donateButton = nil
    end
end

function toggle()
    if donateGoalWindow:isVisible() then
        g_effects.fadeOut(donateGoalWindow, 350)
        scheduleEvent(function()
            donateGoalWindow:hide()
        end, 400)
    else
        requestDonationGoals()
        donateGoalWindow:show()
        donateGoalWindow:raise()
        donateGoalWindow:focus()
        g_effects.fadeIn(donateGoalWindow, 350)
    end
end
