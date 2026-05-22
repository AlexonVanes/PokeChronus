-- =========================================================
-- MEMORY SYSTEM FOR DITTO / SHINY DITTO
-- Integrates with ditto_core.lua
-- Compatible with TFS 1.4 (CreatureEvent / ExtendedOpcode)
-- =========================================================

local MemoryConfig = {
    OPCODE       = 90,
    SLOT_PRICES  = {25, 40, 60, 75, 75, 75},
    MAX_SLOTS    = 6
}

local function getSlotPrice(slot)
    return MemoryConfig.SLOT_PRICES[slot] or 75
end

local function getMonsterLookType(monsterName)
    local mt = MonsterType(monsterName)
    if not mt then
        return 0
    end

    local ok, outfit = pcall(function()
        return mt:getOutfit()
    end)

    if not ok or not outfit then
        return 0
    end

    return outfit.lookType or 0
end

local function getMemoryUnlockAttr(slot)
    return "ditto_memory_unlocked_" .. slot
end

local function getMemoryNameAttr(slot)
    return "ditto_memory_name_" .. slot
end

local function isSlotUnlocked(ball, slot)
    if not ball then
        return false
    end

    return tonumber(ball:getCustomAttribute(getMemoryUnlockAttr(slot)) or 0) == 1
end

local function unlockSlot(ball, slot)
    ball:setCustomAttribute(getMemoryUnlockAttr(slot), 1)
end

local function getSlotMemoryName(ball, slot)
    if not ball then
        return nil
    end

    local value = ball:getCustomAttribute(getMemoryNameAttr(slot))
    if not value or value == "" then
        return nil
    end

    return tostring(value)
end

local function setSlotMemoryName(ball, slot, memoryName)
    ball:setCustomAttribute(getMemoryNameAttr(slot), memoryName)
end

local function clearSlotMemoryName(ball, slot)
    ball:removeCustomAttribute(getMemoryNameAttr(slot))
end

local function canBuySlot(ball, slot)
    if not ball or slot < 1 or slot > MemoryConfig.MAX_SLOTS then
        return false
    end

    if isSlotUnlocked(ball, slot) then
        return false
    end

    if slot == 1 then
        return true
    end

    return isSlotUnlocked(ball, slot - 1)
end

-- Helper: Status do slot para o cliente
local function getSlotStatus(ball, slot)
    if not ball then
        return "locked"
    end

    if not isSlotUnlocked(ball, slot) then
        return canBuySlot(ball, slot) and "canBuy" or "locked"
    end

    local memoryName = getSlotMemoryName(ball, slot)
    if not memoryName then
        return "none"
    end

    return memoryName
end

-- Helper: Enviar dados formatados para o cliente
local function sendOpcode(player, msg)
    -- print("[MEMORY SYSTEM] Sending opcode to client:", msg)
    player:sendExtendedOpcode(MemoryConfig.OPCODE, msg)
end

local function getActiveShinyDittoBall(player)
    if not player or not player.getDittoBall or not Ditto or not Ditto.getBallPokeName then
        return nil
    end

    local ball = player:getDittoBall()
    if not ball then
        return nil
    end

    local pokeName = Ditto.getBallPokeName(ball)
    if pokeName ~= "shiny ditto" then
        return nil
    end

    return ball
end

-- Helper: Atualizar todos os slots na UI
local function sendAllSlots(player)
    local ball = getActiveShinyDittoBall(player)
    local t = {}
    for i = 1, MemoryConfig.MAX_SLOTS do
        t[i] = i .. "," .. getSlotStatus(ball, i)
    end
    sendOpcode(player, "memorySlots=" .. table.concat(t, ";"))
end

-- Helper: Enviar status da transformaÃ§Ã£o ativa
local function sendTransformationStatus(player)
    local ball = getActiveShinyDittoBall(player)
    if not ball then
        sendOpcode(player, "transformation=none,0,0")
        return
    end

    local tf = Ditto and Ditto.getTransform and Ditto.getTransform(ball) or nil
    if not tf then
        local lookType = getMonsterLookType("Shiny Ditto")
        sendOpcode(player, "transformation=none,0," .. lookType)
        return
    end

    local expire = tonumber(ball:getCustomAttribute("ditto_expire")) or 0
    local timeLeft = math.max(0, expire - os.time())
    sendOpcode(player, "transformation=" .. tf.name .. "," .. timeLeft .. "," .. (tf.lookType or 0))
end

local function refreshDittoMemoryWindow(player)
    if not player then
        return
    end

    sendAllSlots(player)
    sendTransformationStatus(player)
end

-- 🔥 DETECTOR REAL (server manda pro client)
local function sendDittoFlag(player)
    local isDitto = 0

    -- 🔥 MAIS SEGURO QUE getUsingBall
    local ball = player and player.getDittoBall and player:getDittoBall() or nil

    if ball and Ditto and Ditto.getBallPokeName then
        local name = Ditto.getBallPokeName(ball)
        if name == "shiny ditto" then
            isDitto = 1
        end
    end

    player:sendExtendedOpcode(90, "isDitto=" .. isDitto)
    return isDitto == 1
end

-- =========================================================
-- OPCODE HANDLER (Client <-> Server)
-- =========================================================
local function processMemoryOpcode(player, buffer)
    --print('[MEMORY SYSTEM] Received opcode:', buffer)
    if not player or type(buffer) ~= "string" then
        return
    end
    
    local parts = string.split(buffer, ';')
    local cmd = parts[1]

    if cmd == "show" then
        local isDitto = sendDittoFlag(player)

        if not isDitto then
            player:sendCancelMessage("Apenas o Shiny Ditto pode usar o Ditto Memory.")
            sendOpcode(player, "close=")
            return
        end

        sendAllSlots(player)
        sendTransformationStatus(player)
        sendOpcode(player, "showDittoMemoryWindow=")

    elseif cmd == "requestShow" then
        local isDitto = sendDittoFlag(player)
        if not isDitto then return end

        sendAllSlots(player)

    elseif cmd == "tryBuy" then
        local slot = tonumber(parts[2])
        if not slot then return end

        local shinyBall = getActiveShinyDittoBall(player)
        if not shinyBall then return end

        local slotPrice = getSlotPrice(slot)

        if isSlotUnlocked(shinyBall, slot) then
            sendOpcode(player, "refreshSlot=" .. slot .. "," .. getSlotStatus(shinyBall, slot))
            return
        end

        if not canBuySlot(shinyBall, slot) then
            sendOpcode(player, "refreshSlot=" .. slot .. "," .. getSlotStatus(shinyBall, slot))
            return
        end

        if getTotalDiamonds(player) < slotPrice then
            player:sendCancelMessage("Voce nao tem diamantes suficientes.")
            sendOpcode(player, "error=Voce nao tem diamantes suficientes.")
            return
        end

        if removePlayerDiamond(player, slotPrice) then
            unlockSlot(shinyBall, slot)
            sendOpcode(player, "refreshSlot=" .. slot .. ",none")
            sendAllSlots(player)
            if player.sendShopDiamondBalance then
                player:sendShopDiamondBalance()
            end
        else
            player:sendCancelMessage("Erro ao remover os Diamonds. Tente novamente.")
        end

    elseif cmd == "eraseMemory" then
        local slot = tonumber(parts[2])
        if not slot then return end

        local shinyBall = getActiveShinyDittoBall(player)
        if not shinyBall then return end

        clearSlotMemoryName(shinyBall, slot)
        sendOpcode(player, "refreshSlot=" .. slot .. ",none")
    end
end

-- Registro compatÃ­vel com TFS 1.4
if Game.registerExtendedOpcode then
    Game.registerExtendedOpcode(MemoryConfig.OPCODE, function(p, op, buf)
        if op ~= MemoryConfig.OPCODE then return end
        local ok, err = pcall(processMemoryOpcode, p, buf)
        if not ok then
            print("[MEMORY SYSTEM] Opcode error: " .. tostring(err))
        end
    end)
else
    local opcodeEvent = CreatureEvent("MemoryExtendedOpcode")
    function opcodeEvent.onExtendedOpcode(player, opcode, buffer)
        if opcode ~= MemoryConfig.OPCODE then return true end
        local ok, err = pcall(processMemoryOpcode, player, buffer)
        if not ok then
            print("[MEMORY SYSTEM] Opcode error: " .. tostring(err))
        end
        return true
    end
    opcodeEvent:type("extendedopcode")
    opcodeEvent:register()

    local memoryLoginEvent = CreatureEvent("MemoryOpcodeLogin")
    function memoryLoginEvent.onLogin(player)
        player:registerEvent("MemoryExtendedOpcode")
        return true
    end
    memoryLoginEvent:register()
end

-- =========================================================
-- TALKACTION: !memory <slot>
-- =========================================================
local memoryTalk = TalkAction("!memory")
function memoryTalk.onSay(player, words, param)
    local slot = tonumber(param)
    if not slot or slot < 1 or slot > MemoryConfig.MAX_SLOTS then
        player:sendCancelMessage("Uso correto: !memory <slot> (1-" .. MemoryConfig.MAX_SLOTS .. ")")
        return false
    end

    local ball = getActiveShinyDittoBall(player)
    if not ball then
        player:sendCancelMessage("Voce precisa de um Shiny Ditto ativo para usar o Ditto Memory.")
        return false
    end

    local memoryName = getSlotStatus(ball, slot)
    if memoryName == "locked" or memoryName == "canBuy" or memoryName == "none" then
        if memoryName == "none" then
            local currentTransform = Ditto.getTransform(ball)
            if not currentTransform or not currentTransform.name then
                player:sendCancelMessage("Transforme o Shiny Ditto antes de salvar uma memoria neste slot.")
                return false
            end

            setSlotMemoryName(ball, slot, currentTransform.name)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Memoria salva: " .. currentTransform.name .. ".")
            sendOpcode(player, "refreshSlot=" .. slot .. "," .. currentTransform.name)
            refreshDittoMemoryWindow(player)
            return false
        end

        player:sendCancelMessage("Este slot de memoria esta vazio ou bloqueado.")
        return false
    end

    local lookType = getMonsterLookType(memoryName)
    local level = ball:getSpecialAttribute("pokeLevel") or 1

    -- Se jÃ¡ estiver transformado, reverte primeiro (agora sem addEvent e seguro)
    if Ditto.getTransform(ball) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Retransformando...")
        local reverted = Ditto.revert(player)
        
        -- Só continua para transformar se a reversão deu certo
        if not reverted then
            return false
        end
    end

    -- Aplica transformaÃ§Ã£o direta
    Ditto.transform(player, {name = memoryName, lookType = lookType, level = level})
    
    -- O Ditto.transform já mostra as próprias mensagens de erro se falhar (ex. sem espaço).
    -- Verificamos se transformou com sucesso checando se a transform foi salva na ball
    if Ditto.getTransform(ball) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Ditto ativou a memoria de " .. memoryName .. " por 24h!")
    end

    refreshDittoMemoryWindow(player)
    return false
end
memoryTalk:separator(" ")
memoryTalk:register()

print("[MEMORY SYSTEM] Loaded successfully.")
