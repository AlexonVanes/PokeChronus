-- Sistema de Daily Login Rewards
-- 21 dias de recompensas progressivas
-- Integrado com imagens da PSTORY

mainWindow = nil
buttonRewards = nil
local OPCODE = 2 -- Callback ID do servidor (0x2)

local rewardWidgets = {}
local currentDay = 1
local canClaim = false
local nextClaimTime = 0
local updateTimer = nil
local initialized = false
local lastResetRefreshRequest = 0

-- Dados das recompensas (21 dias) - Será preenchido pelo servidor
local rewardsData = {}

function init()
    -- Evitar inicialização dupla
    if initialized then
        return
    end
    
    -- Aguardar que os módulos necessários sejam carregados
    scheduleEvent(function()
        -- Verificar se módulos necessários estão carregados
        if not modules.game_interface then
            scheduleEvent(init, 100)
            return
        end
        
        -- Carregar interface
        mainWindow = g_ui.loadUI("game_daily_rewards", modules.game_interface.getRootPanel())
        
        -- Verificar se carregou corretamente
        if not mainWindow then
            return
        end
        
        mainWindow:hide()
        
        -- Conectar eventos do jogo
        connect(g_game, {
            onGameEnd = onGameEnd,
            onGameStart = onGameStart
        })
        
        -- Registrar protocolo
        ProtocolGame.registerExtendedOpcode(OPCODE, onReceiveRewards)
        
        -- Botão no topo
        if modules.client_topmenu then
            buttonRewards = modules.client_topmenu.addRightGameToggleButton("dailyRewards", tr("Daily Rewards"), "/modules/game_daily_rewards/images/gift.png", toggleWindow, true)
        end
        
        -- Criar widgets das recompensas
        createRewardWidgets()
        
        -- Solicitar dados do servidor imediatamente
        scheduleEvent(function()
            if g_game.isOnline() then
                requestRewardsData()
            end
        end, 500)
        
        initialized = true
    end, 100)
end

function terminate()
    disconnect(g_game, {
        onGameEnd = onGameEnd,
        onGameStart = onGameStart
    })
    
    ProtocolGame.unregisterExtendedOpcode(OPCODE)
    
    if updateTimer then
        removeEvent(updateTimer)
        updateTimer = nil
    end
    
    if buttonRewards then
        buttonRewards:destroy()
        buttonRewards = nil
    end
    
    if mainWindow then
        mainWindow:destroy()
        mainWindow = nil
    end
end

function onGameStart()
    -- Solicitar dados ao conectar
    scheduleEvent(function()
        if g_game.isOnline() then
            requestRewardsData()
        end
    end, 1000)
end

function onGameEnd()
    mainWindow:hide()
    currentDay = 1
    canClaim = false
end

function toggleWindow()
    if not mainWindow then
        return
    end
    
    if mainWindow:isVisible() then
        mainWindow:hide()
    else
        mainWindow:show()
        mainWindow:raise()
        mainWindow:focus()
    end
end

function show()
    if not mainWindow then
        return
    end
    
    mainWindow:show()
    mainWindow:raise()
    mainWindow:focus()
    updateRewardsDisplay()
    startTimerUpdate()
end

function hide()
    if not mainWindow then
        return
    end
    
    mainWindow:hide()
    if updateTimer then
        removeEvent(updateTimer)
        updateTimer = nil
    end
end

function closeWindow()
    hide()
end

-- Criar os 21 widgets de recompensas
function createRewardWidgets()
    local rewardsPanel = mainWindow:getChildById('rewardsPanel')
    if not rewardsPanel then
        return
    end
    
    -- Limpar widgets antigos
    rewardsPanel:destroyChildren()
    rewardWidgets = {}
    
    -- Criar 21 dias (3 linhas de 7 dias)
    for dayIndex = 1, 21 do
        local widget = g_ui.createWidget('DailyRewardBox', rewardsPanel)
        
        if widget then
            -- Configurar dia
            local dayLabel = widget:getChildById('dayNumber')
            if dayLabel then
                dayLabel:setText(tostring(dayIndex))
            end
            
            -- Marcar como bloqueado inicialmente
            widget:setOn(false)
            widget.day = dayIndex
            widget.claimed = false
            widget.canClaim = false
            
            rewardWidgets[dayIndex] = widget
        end
    end
    
    -- Atualizar display dos itens
    updateRewardsDisplay()
end

-- Atualizar display das recompensas
function updateRewardsDisplay()
    for day, widget in pairs(rewardWidgets) do
        local itemIcon = widget:getChildById('itemIcon')
        local statusLabel = widget:getChildById('statusLabel')
        local dayLabel = widget:getChildById('dayNumber')
        
        -- Configurar dados da recompensa se disponível
        if rewardsData[day] then
            local reward = rewardsData[day]
            
            -- Mostrar ícone do item usando clientId do servidor
            if itemIcon and reward.clientId then
                itemIcon:setItemId(reward.clientId)
                if reward.count then
                    itemIcon:setItemCount(reward.count)
                end
                itemIcon:setVisible(true)
            end
        else
            -- Se não houver dados, esconder o ícone
            if itemIcon then
                itemIcon:setVisible(false)
            end
        end
        
        -- Estados visuais
        local dayBadge = widget:getChildById('dayBadge')
        local glowEffect = widget:getChildById('glowEffect')
        
        if day < currentDay then
            -- Já coletado
            widget:setOn(false)
            widget:setOpacity(0.7)
            widget:setBackgroundColor('#0a2a0a')
            widget:setBorderColor('#00aa00')
            if statusLabel then
                statusLabel:setText('OK')
                statusLabel:setColor('#00ff00')
            end
            if dayLabel then dayLabel:setColor('#00ff00') end
            if dayBadge then dayBadge:setBackgroundColor('#0a2a0a') end
            
        elseif day == currentDay then
            -- Dia atual - pode ou não coletar
            widget:setOn(canClaim)
            widget:setOpacity(1.0)
            if canClaim then
                widget:setBackgroundColor('#2a2a00')
                widget:setBorderColor('#ffcc00')
                if glowEffect then
                    glowEffect:setBorderColor('#ffcc0066')
                    glowEffect:setVisible(true)
                end
                if statusLabel then
                    statusLabel:setText('!')
                    statusLabel:setColor('#ffff00')
                end
                if dayLabel then dayLabel:setColor('#ffff00') end
                if dayBadge then dayBadge:setBackgroundColor('#3a3a00') end
            else
                widget:setBackgroundColor('#2a0a0a')
                widget:setBorderColor('#ff6666')
                if statusLabel then
                    statusLabel:setText('...')
                    statusLabel:setColor('#ff8888')
                end
                if dayLabel then dayLabel:setColor('#ffaaaa') end
                if dayBadge then dayBadge:setBackgroundColor('#2a0a0a') end
            end
            
        else
            -- Dias futuros - bloqueados
            widget:setOn(false)
            widget:setOpacity(0.5)
            widget:setBackgroundColor('#0f0f0f')
            widget:setBorderColor('#2a2a2a')
            if statusLabel then
                statusLabel:setText('---')
                statusLabel:setColor('#555555')
            end
            if dayLabel then dayLabel:setColor('#777777') end
            if dayBadge then dayBadge:setBackgroundColor('#1a1a1a') end
            if glowEffect then glowEffect:setVisible(false) end
        end
    end
    
    -- Atualizar texto informativo
    updateInfoText()
end

function updateInfoText()
    local infoLabel = mainWindow:getChildById('infoText')
    if not infoLabel then return end
    
    if canClaim then
        infoLabel:setText(string.format("Aperte em Claim para coletar a recompensa do dia %d!", currentDay))
        infoLabel:setColor('#00ff00')
    elseif nextClaimTime > 0 then
        local timeLeft = nextClaimTime - os.time()
        if timeLeft > 0 then
            local hours = math.floor(timeLeft / 3600)
            local minutes = math.floor((timeLeft % 3600) / 60)
            infoLabel:setText(string.format("Proxima recompensa em %dh %dm", hours, minutes))
            infoLabel:setColor('#ffaa00')
        else
            infoLabel:setText("Atualizando recompensas...")
            infoLabel:setColor('#ffffff')
            if os.time() > lastResetRefreshRequest then
                lastResetRefreshRequest = os.time() + 5
                requestRewardsData()
            end
        end
    else
        infoLabel:setText(string.format("Voce esta no dia %d de 21 - Continue entrando todos os dias!", currentDay))
        infoLabel:setColor('#ffffff')
    end
end

-- Atualizar timer periodicamente
function startTimerUpdate()
    if updateTimer then
        removeEvent(updateTimer)
    end
    
    updateTimer = scheduleEvent(function()
        if mainWindow and mainWindow:isVisible() then
            updateInfoText()
        end
        startTimerUpdate()
    end, 1000)
end

-- Receber dados do servidor
function onReceiveRewards(protocol, opcode, buffer)
    local status, data = pcall(function() return json.decode(buffer) end)
    
    if not status then
        return
    end
    
    -- Processar dados de recompensas do servidor
    if data.rewards then
        -- Limpar dados antigos completamente
        rewardsData = {}
        
        -- Recebeu lista de recompensas do servidor
        -- As chaves podem vir como strings do JSON, então converter para números
        for dayStr, reward in pairs(data.rewards) do
            local day = tonumber(dayStr)
            if day then
                -- Validar que clientId é um número válido
                if reward.clientId then
                    rewardsData[day] = {
                        clientId = tonumber(reward.clientId) or reward.clientId,
                        count = tonumber(reward.count) or 1,
                        name = reward.name or "Unknown"
                    }
                end
            end
        end
    end
    
    if data.currentDay then
        currentDay = tonumber(data.currentDay) or 1
    end
    
    if data.canClaim ~= nil then
        canClaim = data.canClaim
    end
    
    if data.nextClaim then
        nextClaimTime = tonumber(data.nextClaim) or 0
    end
    
    -- Atualizar display
    updateRewardsDisplay()
    
    -- Se dados foram recebidos, mostrar janela
    if data.autoShow then
        show()
    end
end

-- Solicitar dados ao servidor
function requestRewardsData()
    if not g_game.isOnline() then
        return
    end
    
    local buffer = json.encode({
        action = "refresh"
    })
    
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(OPCODE, buffer)
    end
end

-- Coletar recompensa
function claimReward()
    if not canClaim then
        modules.game_textmessage.displayGameMessage("Você já coletou a recompensa de hoje!")
        return
    end
    
    local buffer = json.encode({
        action = "claim"
    })
    
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(OPCODE, buffer)
    end
end
