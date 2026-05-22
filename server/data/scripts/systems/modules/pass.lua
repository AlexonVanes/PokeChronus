PASS = {
    ITEM_FREE = 1,
    ITEM_PREMIUM = 2,
}

-- Stones IDs
local STONES = {
    FIRE = 26728,
    WATER = 26736,
    LEAF = 26731,
    THUNDER = 26734,
    ICE = 26730,
    ROCK = 26733,
    VENOM = 26735,
    PUNCH = 26732,
    CRYSTAL = 26725,
    DARKNESS = 26726,
    ANCIENT = 26749,
    BOOST = 26723,
}

-- Money
local CRYSTAL_COIN = 2160  -- 1 = 10k gold, 100 = 1kk gold

-- Gerar 100 níveis de recompensas
PASS.ITEMS = {}

for level = 1, 100 do
    PASS.ITEMS[level] = {}
    
    -- Calcular recompensas baseado no nível
    local baseCoins = math.floor(level / 2) + 5  -- 5-55 coins
    local premiumCoins = math.floor(level / 1.5) + 10  -- 10-76 coins
    
    -- Escolher stone baseada no nível
    local stoneList = {STONES.FIRE, STONES.WATER, STONES.LEAF, STONES.THUNDER}
    if level > 25 then
        table.insert(stoneList, STONES.ICE)
        table.insert(stoneList, STONES.ROCK)
    end
    if level > 50 then
        table.insert(stoneList, STONES.VENOM)
        table.insert(stoneList, STONES.PUNCH)
        table.insert(stoneList, STONES.CRYSTAL)
    end
    if level > 75 then
        table.insert(stoneList, STONES.DARKNESS)
        table.insert(stoneList, STONES.ANCIENT)
        table.insert(stoneList, STONES.BOOST)
    end
    
    local stoneId = stoneList[((level - 1) % #stoneList) + 1]
    local stoneCount = math.floor(level / 10) + 1  -- 1-11 stones
    
    -- FREE rewards (dinheiro + stone)
    if level % 2 == 1 then  -- Níveis ímpares: dinheiro
        PASS.ITEMS[level][PASS.ITEM_FREE] = {
            itemId = CRYSTAL_COIN,
            count = baseCoins,
        }
    else  -- Níveis pares: stones
        PASS.ITEMS[level][PASS.ITEM_FREE] = {
            itemId = stoneId,
            count = stoneCount,
        }
    end
    
    -- PREMIUM rewards (mais dinheiro + mais stones)
    if level % 2 == 1 then  -- Níveis ímpares: mais dinheiro
        PASS.ITEMS[level][PASS.ITEM_PREMIUM] = {
            itemId = CRYSTAL_COIN,
            count = premiumCoins,
        }
    else  -- Níveis pares: mais stones
        PASS.ITEMS[level][PASS.ITEM_PREMIUM] = {
            itemId = stoneId,
            count = stoneCount * 2,
        }
    end
    
    -- Bônus especiais em níveis múltiplos de 10
    if level % 10 == 0 then
        PASS.ITEMS[level][PASS.ITEM_FREE] = {
            itemId = CRYSTAL_COIN,
            count = 100,  -- 1kk gold
        }
        PASS.ITEMS[level][PASS.ITEM_PREMIUM] = {
            itemId = CRYSTAL_COIN,
            count = 150,  -- 1.5kk gold
        }
    end
    
    -- Mega bônus no nível 100
    if level == 100 then
        PASS.ITEMS[level][PASS.ITEM_FREE] = {
            itemId = CRYSTAL_COIN,
            count = 500,  -- 5kk gold
        }
        PASS.ITEMS[level][PASS.ITEM_PREMIUM] = {
            itemId = CRYSTAL_COIN,
            count = 1000,  -- 10kk gold
        }
    end
end

CONSTANT_PASS = {
    callbackId = 0x1,
    rewardFree = 9250000,
    rewardPremium = 9260000,
    missionsStates = 9270000,
    maxLevel = 100,
    xpPerLevel = 100,
    seasonStart = {year = 2026, month = 5, day = 21},
    seasonDurationDays = 30
}

local function getPassSeasonTimeLeft()
    local startDate = CONSTANT_PASS.seasonStart
    local startTime = os.time({
        year = startDate.year,
        month = startDate.month,
        day = startDate.day,
        hour = 0,
        min = 0,
        sec = 0
    })
    local finishTime = startTime + (CONSTANT_PASS.seasonDurationDays * 24 * 60 * 60)
    local secondsLeft = math.max(0, finishTime - os.time())
    local daysLeft = math.ceil(secondsLeft / (24 * 60 * 60))

    return daysLeft, secondsLeft
end

local function luaString(value)
    return string.format("%q", tostring(value or ""))
end

local function passPacket(packetType, values)
    return json.encode({type = packetType, values = values or {}})
end

function Player.hasCollectedPassReward(self, level, passItemType)
    local stoId = passItemType == PASS.ITEM_FREE and CONSTANT_PASS.rewardFree or passItemType == PASS.ITEM_PREMIUM and CONSTANT_PASS.rewardPremium
    if not stoId or not level or level < 1 or level > CONSTANT_PASS.maxLevel then
        return false
    end

    return self:getStorageValue(stoId + level) > 0
end

function NetworkMessage:sendPassItems(items)
    self:addU16(#items)
    for id, levelItems in ipairs(items) do
        for passItemType, item in pairs(levelItems) do
            local itemType = ItemType(item.itemId)
            self:addByte(passItemType)
            self:addString(itemType:getName())
            
            -- Descrição customizada com quantidade
            local desc = itemType:getDescription()
            if item.count and item.count > 1 then
                desc = desc .. " (x" .. item.count .. ")"
            end
            self:addString(desc)
            
            self:addU16(itemType:getClientId())
        end
    end
end

function NetworkMessage:setCallbackId(id)
    self:addByte(0xFF)
    self:addByte(id)
end

function NetworkMessage:finish(player)
	self:sendToPlayer(player)
	self:delete()
end

function Player.sendPassData(self)
    -- Enviar info básica do Pass
    local hasPremium = self:getStorageValue(CONSTANT_PASS.rewardPremium) > 0
    local maxXP = CONSTANT_PASS.maxLevel * CONSTANT_PASS.xpPerLevel
    local passXP = math.max(0, self:getStorageValue(CONSTANT_PASS.missionsStates))
    if passXP > maxXP then
        passXP = maxXP
        self:setStorageValue(CONSTANT_PASS.missionsStates, passXP)
    end

    local passLevel = math.floor(passXP / CONSTANT_PASS.xpPerLevel)
    local passStars = math.floor((passXP % CONSTANT_PASS.xpPerLevel) / 10)  -- 0-9 stars
    local passDaysLeft, passTime = getPassSeasonTimeLeft()
    
    self:sendExtendedOpcode(20, passPacket("Pass", {
        hasPremium,
        passLevel,
        CONSTANT_PASS.maxLevel,
        passStars,
        passDaysLeft,
        passTime
    }))
    
    -- Enviar itens do Pass
    self:sendPassItems()
    
    -- Enviar missões
    self:sendPassMissionsData()
end

function Player:sendPassItems()
    -- Formato: {{true, {{item1,item2,level}, {item1,item2,level}, ...}, {}}, 0, 'Items'}
    local buffer = "{{true,{"
    
    for level = 1, 100 do
        if PASS.ITEMS[level] then
            buffer = buffer .. "{"
            
            -- FREE item (índice 1)
            local freeItem = PASS.ITEMS[level][PASS.ITEM_FREE]
            local freeType = ItemType(freeItem.itemId)
            buffer = buffer .. "{style='UIPassItem',name=" .. luaString(freeType:getName()) .. ",item={id=" .. freeItem.itemId .. ",clientId=" .. freeType:getClientId() .. ",count=" .. (freeItem.count or 1) .. "}},"
            
            -- PREMIUM item (índice 2)
            local premItem = PASS.ITEMS[level][PASS.ITEM_PREMIUM]
            local premType = ItemType(premItem.itemId)
            buffer = buffer .. "{style='UIPassItem',name=" .. luaString(premType:getName()) .. ",item={id=" .. premItem.itemId .. ",clientId=" .. premType:getClientId() .. ",count=" .. (premItem.count or 1) .. "}},"
            
            -- Nível (índice 3)
            buffer = buffer .. level
            
            buffer = buffer .. "},"
        end
    end
    
    buffer = buffer .. "},"
    
    -- Adicionar lista de recompensas coletadas
    -- collecteds = {[1]={níveis FREE coletados}, [2]={níveis PREMIUM coletados}}
    buffer = buffer .. "{"
    
    -- FREE coletados
    buffer = buffer .. "{"
    for level = 1, 100 do
        local stoIdFree = 9250000 + level
        if self:getStorageValue(stoIdFree) > 0 then
            buffer = buffer .. level .. ","
        end
    end
    buffer = buffer .. "},"
    
    -- PREMIUM coletados
    buffer = buffer .. "{"
    for level = 1, 100 do
        local stoIdPremium = 9260000 + level
        if self:getStorageValue(stoIdPremium) > 0 then
            buffer = buffer .. level .. ","
        end
    end
    buffer = buffer .. "}"
    
    buffer = buffer .. "}},0,'Items'}"
    
    -- print("[PASS] Enviando 100 níveis com collecteds")
    return buffer
end

function Player:sendPassMissionsData()
    if self.refreshPassMissionResets then
        self:refreshPassMissionResets()
    end

    -- Formato: {{true, {mission1, mission2, ...}}, 0, 'Missions'}
    local buffer = "{{true,{"
    
    -- Missão dummy
    buffer = buffer .. "{progress=0,max=0,stars=0,lookType=0,size=" .. luaString("32 32") .. ",position={x=0,y=0},desc=''},"
    
    -- Adicionar missões reais
    if PASS_MISSIONS then
        for _, mission in ipairs(PASS_MISSIONS.DAILY) do
            local progress = math.max(0, self:getStorageValue(mission.storage))
            buffer = buffer .. "{progress=" .. progress .. ",max=" .. mission.max .. ",stars=" .. mission.stars .. ",lookType=" .. mission.lookType .. ",size=" .. luaString(mission.size) .. ",icon=" .. luaString(mission.icon) .. ",position={x=" .. mission.position.x .. ",y=" .. mission.position.y .. "},desc=" .. luaString(mission.desc) .. "},"
        end
        
        for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
            local progress = math.max(0, self:getStorageValue(mission.storage))
            buffer = buffer .. "{progress=" .. progress .. ",max=" .. mission.max .. ",stars=" .. mission.stars .. ",lookType=" .. mission.lookType .. ",size=" .. luaString(mission.size) .. ",icon=" .. luaString(mission.icon) .. ",position={x=" .. mission.position.x .. ",y=" .. mission.position.y .. "},desc=" .. luaString(mission.desc) .. "},"
        end
    end
    
    buffer = buffer .. "}},0,'Missions'}"
    
    -- print("[PASS] Enviando missões")
    return buffer
end

-- Função para coletar recompensa
function Player:sendPassItems()
    local items = {}

    for level = 1, CONSTANT_PASS.maxLevel do
        if PASS.ITEMS[level] then
            local freeItem = PASS.ITEMS[level][PASS.ITEM_FREE]
            local premItem = PASS.ITEMS[level][PASS.ITEM_PREMIUM]

            if freeItem and premItem then
                local freeType = ItemType(freeItem.itemId)
                local premType = ItemType(premItem.itemId)

                if freeType and premType then
                    items[#items + 1] = {
                        {
                            style = "UIPassItem",
                            name = freeType:getName(),
                            item = {
                                id = freeItem.itemId,
                                clientId = freeType:getClientId(),
                                count = freeItem.count or 1
                            }
                        },
                        {
                            style = "UIPassItem",
                            name = premType:getName(),
                            item = {
                                id = premItem.itemId,
                                clientId = premType:getClientId(),
                                count = premItem.count or 1
                            }
                        },
                        level
                    }
                end
            end
        end
    end

    local collecteds = {{}, {}}
    for level = 1, CONSTANT_PASS.maxLevel do
        local stoIdFree = 9250000 + level
        if self:getStorageValue(stoIdFree) > 0 then
            collecteds[PASS.ITEM_FREE][#collecteds[PASS.ITEM_FREE] + 1] = level
        end

        local stoIdPremium = 9260000 + level
        if self:getStorageValue(stoIdPremium) > 0 then
            collecteds[PASS.ITEM_PREMIUM][#collecteds[PASS.ITEM_PREMIUM] + 1] = level
        end
    end

    self:sendExtendedOpcode(20, passPacket("Items", {true, items, collecteds}))
end

function Player:sendPassMissionsData()
    if self.refreshPassMissionResets then
        self:refreshPassMissionResets()
    end

    local missions = {
        {
            progress = 0,
            max = 0,
            stars = 0,
            lookType = 0,
            size = "32 32",
            position = {x = 0, y = 0},
            desc = ""
        }
    }

    if PASS_MISSIONS then
        for _, mission in ipairs(PASS_MISSIONS.DAILY) do
            local progress = math.max(0, self:getStorageValue(mission.storage))
            missions[#missions + 1] = {
                progress = progress,
                max = mission.max,
                stars = mission.stars,
                lookType = mission.lookType,
                size = mission.size,
                icon = mission.icon,
                position = {x = mission.position.x, y = mission.position.y},
                desc = mission.desc
            }
        end

        for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
            local progress = math.max(0, self:getStorageValue(mission.storage))
            missions[#missions + 1] = {
                progress = progress,
                max = mission.max,
                stars = mission.stars,
                lookType = mission.lookType,
                size = mission.size,
                icon = mission.icon,
                position = {x = mission.position.x, y = mission.position.y},
                desc = mission.desc
            }
        end
    end

    self:sendExtendedOpcode(20, passPacket("Missions", {true, missions}))
end

function Player:collectPassReward(level, passItemType)
    if level < 1 or level > CONSTANT_PASS.maxLevel then
        return false, "Nível inválido"
    end
    
    if not PASS.ITEMS[level] or not PASS.ITEMS[level][passItemType] then
        return false, "Recompensa não encontrada"
    end
    
    if self:hasCollectedPassReward(level, passItemType) then
        return false, "Você já coletou essa recompensa"
    end
    
    local maxXP = CONSTANT_PASS.maxLevel * CONSTANT_PASS.xpPerLevel
    local passXP = math.min(maxXP, math.max(0, self:getStorageValue(CONSTANT_PASS.missionsStates)))
    local passLevel = math.floor(passXP / CONSTANT_PASS.xpPerLevel)
    if level > passLevel then
        return false, "Nivel ainda nao liberado"
    end

    if passItemType == PASS.ITEM_PREMIUM and self:getStorageValue(CONSTANT_PASS.rewardPremium) <= 0 then
        return false, "Passe Elite necessario"
    end

    local reward = PASS.ITEMS[level][passItemType]
    local item = self:addItem(reward.itemId, reward.count or 1)
    
    if not item then
        return false, "Inventário cheio"
    end
    
    -- Marcar como coletado
    local stoId = passItemType == PASS.ITEM_FREE and CONSTANT_PASS.rewardFree or CONSTANT_PASS.rewardPremium
    self:setStorageValue(stoId + level, 1)
    
    return true, "Recompensa coletada!"
end

-- Callback handlers são processados automaticamente pelo sistema
-- A lógica de coleta está em extendedopcode.lua

-- print("[PASS System] Sistema de Pass carregado com 100 níveis!")
-- print("[PASS System] FREE: Dinheiro + Stones | PREMIUM: Mais recompensas!")
