-- Sistema de Missoes do Pass
-- Missoes diarias e semanais que dao XP para subir de nivel no Pass.

local PASS_DAILY_RESET_STORAGE = 9270998
local PASS_WEEKLY_RESET_STORAGE = 9270999

PASS_MISSIONS = {
    DAILY = {
        {
            id = 1,
            name = "Capturar Pokemons",
            desc = "Capture 10 Pokemons selvagens",
            lookType = 69,
            size = "42 42",
            icon = "images/mission/icones/capture",
            position = {x = 0, y = 0},
            max = 10,
            stars = 1,
            storage = 9270001,
            type = "capture"
        },
        {
            id = 2,
            name = "Pescar Pokemons",
            desc = "Pesque 15 Pokemons",
            lookType = 129,
            size = "42 42",
            icon = "images/mission/icones/pesque",
            position = {x = 0, y = 0},
            max = 15,
            stars = 1,
            storage = 9270002,
            type = "fishing"
        },
        {
            id = 3,
            name = "Coletar Madeira",
            desc = "Corte 20 arvores",
            lookType = 2826,
            size = "42 42",
            icon = "images/mission/icones/madeira",
            position = {x = 0, y = 0},
            max = 20,
            stars = 1,
            storage = 9270003,
            type = "wood"
        },
        {
            id = 4,
            name = "Minerar",
            desc = "Minere 15 pedras",
            lookType = 2827,
            size = "42 42",
            icon = "images/mission/icones/minerio",
            position = {x = 0, y = 0},
            max = 15,
            stars = 1,
            storage = 9270004,
            type = "mining"
        },
        {
            id = 5,
            name = "Derrotar Pokemons",
            desc = "Derrote 25 Pokemons selvagens",
            lookType = 6,
            size = "48 48",
            icon = "images/mission/icones/charizard",
            position = {x = 0, y = 0},
            max = 25,
            stars = 2,
            storage = 9270005,
            type = "defeat"
        },
    },

    WEEKLY = {
        {
            id = 101,
            name = "Mestre Capturador",
            desc = "Capture 100 Pokemons diferentes",
            lookType = 150,
            size = "48 48",
            icon = "images/mission/icones/capture",
            position = {x = 0, y = 0},
            max = 100,
            stars = 5,
            storage = 9270101,
            type = "capture_unique"
        },
        {
            id = 102,
            name = "Pescador Experiente",
            desc = "Pesque 200 Pokemons",
            lookType = 130,
            size = "48 48",
            icon = "images/mission/icones/gyarados",
            position = {x = 0, y = 0},
            max = 200,
            stars = 5,
            storage = 9270102,
            type = "fishing"
        },
        {
            id = 103,
            name = "Lenhador Profissional",
            desc = "Corte 300 arvores",
            lookType = 2826,
            size = "42 42",
            icon = "images/mission/icones/madeira",
            position = {x = 0, y = 0},
            max = 300,
            stars = 4,
            storage = 9270103,
            type = "wood"
        },
        {
            id = 104,
            name = "Minerador Expert",
            desc = "Minere 250 pedras",
            lookType = 2827,
            size = "42 42",
            icon = "images/mission/icones/stones",
            position = {x = 0, y = 0},
            max = 250,
            stars = 4,
            storage = 9270104,
            type = "mining"
        },
        {
            id = 105,
            name = "Cacador Lendario",
            desc = "Derrote 500 Pokemons",
            lookType = 6,
            size = "48 48",
            icon = "images/mission/icones/task",
            position = {x = 0, y = 0},
            max = 500,
            stars = 10,
            storage = 9270105,
            type = "defeat"
        },
    }
}

function Player:refreshPassMissionResets()
    local today = tonumber(os.date("%Y%m%d"))
    local week = tonumber(os.date("%Y%W"))

    if self:getStorageValue(PASS_DAILY_RESET_STORAGE) ~= today then
        for _, mission in ipairs(PASS_MISSIONS.DAILY) do
            self:setStorageValue(mission.storage, 0)
        end
        self:setStorageValue(PASS_DAILY_RESET_STORAGE, today)
    end

    if self:getStorageValue(PASS_WEEKLY_RESET_STORAGE) ~= week then
        for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
            self:setStorageValue(mission.storage, 0)
        end
        self:setStorageValue(PASS_WEEKLY_RESET_STORAGE, week)
    end
end

function Player:updatePassMission(missionType, amount)
    amount = tonumber(amount) or 1
    if not missionType or amount <= 0 then
        return false
    end

    self:refreshPassMissionResets()

    local missionCompleted = false
    local missionUpdated = false

    local function updateMission(mission, completeText)
        if mission.type ~= missionType then
            return
        end

        local progress = math.max(0, self:getStorageValue(mission.storage))
        if progress >= mission.max then
            return
        end

        local newProgress = math.min(progress + amount, mission.max)
        self:setStorageValue(mission.storage, newProgress)
        missionUpdated = true

        self:sendTextMessage(MESSAGE_STATUS_SMALL, mission.name .. ": " .. newProgress .. "/" .. mission.max)

        if newProgress >= mission.max then
            self:addPassXP(mission.stars * 10)
            self:sendTextMessage(MESSAGE_EVENT_ADVANCE, completeText .. ": " .. mission.name .. " (+" .. (mission.stars * 10) .. " XP)")
            missionCompleted = true
        end
    end

    for _, mission in ipairs(PASS_MISSIONS.DAILY) do
        updateMission(mission, "Missao Completa")
    end

    for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
        updateMission(mission, "Missao Semanal Completa")
    end

    if missionUpdated then
        local playerId = self:getId()
        addEvent(function()
            local player = Player(playerId)
            if not player then
                return
            end

            if missionCompleted and player.sendPassData then
                player:sendPassData()
            elseif player.sendPassMissionsData then
                player:sendPassMissionsData()
            end
        end, 100)
    end

    return missionUpdated
end

function Player:addPassXP(amount)
    local maxXP = (CONSTANT_PASS and CONSTANT_PASS.maxLevel and CONSTANT_PASS.xpPerLevel) and (CONSTANT_PASS.maxLevel * CONSTANT_PASS.xpPerLevel) or 10000
    amount = tonumber(amount) or 0

    local currentXP = math.max(0, self:getStorageValue(9270000))
    if currentXP > maxXP then
        currentXP = maxXP
        self:setStorageValue(9270000, currentXP)
    end

    if amount <= 0 then
        return false
    end

    local newXP = math.min(maxXP, currentXP + amount)
    if newXP <= currentXP then
        return false
    end

    self:setStorageValue(9270000, newXP)

    local oldLevel = math.floor(currentXP / 100)
    local newLevel = math.floor(newXP / 100)

    if newLevel > oldLevel then
        self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Pass Level UP! Voce esta no nivel " .. newLevel)
    end

    return true
end

function resetDailyMissions()
    for _, mission in ipairs(PASS_MISSIONS.DAILY) do
        db.query("UPDATE player_storage SET value = 0 WHERE key = " .. mission.storage)
    end
end

function resetWeeklyMissions()
    for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
        db.query("UPDATE player_storage SET value = 0 WHERE key = " .. mission.storage)
    end
end

function Player:sendPassMissions()
    self:refreshPassMissionResets()

    local missionsData = {}

    for _, mission in ipairs(PASS_MISSIONS.DAILY) do
        local progress = math.max(0, self:getStorageValue(mission.storage))
        table.insert(missionsData, {
            id = mission.id,
            name = mission.name,
            desc = mission.desc,
            lookType = mission.lookType,
            size = mission.size,
            icon = mission.icon,
            position = mission.position,
            progress = progress,
            max = mission.max,
            stars = mission.stars
        })
    end

    for _, mission in ipairs(PASS_MISSIONS.WEEKLY) do
        local progress = math.max(0, self:getStorageValue(mission.storage))
        table.insert(missionsData, {
            id = mission.id,
            name = mission.name,
            desc = mission.desc,
            lookType = mission.lookType,
            size = mission.size,
            icon = mission.icon,
            position = mission.position,
            progress = progress,
            max = mission.max,
            stars = mission.stars
        })
    end

    return missionsData
end

local passKillEvent = CreatureEvent("PassMissionKill")

function passKillEvent.onKill(player, target)
    if not player:isPlayer() then
        return true
    end

    if not target or not target:isMonster() or target:getMaster() then
        return true
    end

    if player.updatePassMission then
        player:updatePassMission("defeat", 1)
    end

    return true
end

passKillEvent:register()

local passLoginEvent = CreatureEvent("PassMissionLogin")

function passLoginEvent.onLogin(player)
    player:registerEvent("PassMissionKill")
    return true
end

passLoginEvent:register()

for _, player in ipairs(Game.getPlayers()) do
    player:registerEvent("PassMissionKill")
end
