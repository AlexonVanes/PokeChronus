-- IDs de storage para cada Guardian (defina conforme os nomes dos Guardians)
local STORAGE_GUARDIAN_COOLDOWN = {
    ["Guardian Raikou"] = 90000,
    ["Guardian Suicune"] = 90001,
    ["Guardian Entei"] = 90002,
}

local GUARDIAN_DURATION = 10    -- tempo que o Guardian fica ativo em segundos
local GUARDIAN_COOLDOWN = 3600  -- cooldown em segundos (1 hora)

function Player:summonGuardianTimed(guardianName)
    local storageId = STORAGE_GUARDIAN_COOLDOWN[guardianName]
    local lastUse = self:getStorageValue(storageId)
    if lastUse == -1 then lastUse = 0 end
    local now = os.time()

    -- Verifica cooldown
    if now - lastUse < GUARDIAN_COOLDOWN then
        local remaining = GUARDIAN_COOLDOWN - (now - lastUse)
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        self:sendCancelMessage(string.format(
            "Você só pode usar %s 1 vez a cada 1 hora. Tempo restante: %02dh:%02dm", 
            guardianName, hours, minutes
        ))
        return false
    end

    -- Impede invocar se tiver Pokémon/summon ativo
    local summons = self:getSummons() or {}
    if #summons > 0 then
        self:sendCancelMessage("Você não pode chamar um Guardian enquanto estiver com um Pokémon.")
        return false
    end

    -- Cria o Guardian
    local pos = self:getPosition()
    local guardian = Game.createMonster(guardianName, pos, true, true)
    if not guardian then
        self:sendCancelMessage("Erro ao criar o Guardian.")
        return false
    end

    guardian:setMaster(self)
    guardian:setType(CONST_MONSTER_TYPE_NORMAL)
    guardian:setFollowCreature(self)
    guardian:setTarget(nil)
    self:say("Vá " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)

    -- Marca o cooldown
    self:setStorageValue(storageId, now)

    -- Timer para despawn automático após GUARDIAN_DURATION segundos
    addEvent(function()
        if guardian and not guardian:isRemoved() then
            self:despawnGuardian(guardianName)
        end
    end, GUARDIAN_DURATION * 1000)

    return guardian
end


function Player:summonGuardian(guardianName)
    local guardian = Game.createMonster(guardianName, self:getPosition(), true, true)
    if guardian then
        self:addGuardian(guardian)
        guardian:updateCreatureType()
        local pokemon = self:getSummons()[1]
        if pokemon then
            guardian:removeTarget(pokemon)
        end
        self:say("Vá " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)
        return guardian
    end
end

function Player:despawnGuardian(guardianName)
    local guardians = self:getGuardians()
    for _, guardian in ipairs(guardians) do
        if guardian:getName() == guardianName then
            self:removeGuardian(guardian)
            self:say("Volte " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)
            guardian:remove()
            return true
        end
    end
end

function Player:hasGuardian(guardianName)
    local guardians = self:getGuardians()
    for _, guardian in ipairs(guardians) do
        if guardian:getName() == guardianName then
            return true
        end
    end
    return false
end

local onLogout_Guardian_Player = CreatureEvent("onLogout_guardian")
function onLogout_Guardian_Player.onLogout(player)
    local guardians = player:getGuardians()
    if #guardians == 0 then return true end
    for _, guardian in ipairs(guardians) do
        player:removeGuardian(guardian)
        guardian:remove()
    end
	return true
end
onLogout_Guardian_Player:register()

local guardians_list = {
    [40608] = "Guardian Raikou",
    [40609] = "Guardian Suicune",
    [40610] = "Guardian Entei",
}

function Player:summonGuardianTimed(guardianName)
-- IDs de storage para cada Guardian (defina conforme os nomes dos Guardians)
local STORAGE_GUARDIAN_COOLDOWN = {
    ["Guardian Raikou"] = 90000,
    ["Guardian Suicune"] = 90001,
    ["Guardian Entei"] = 90002,
}

local GUARDIAN_DURATION = 10    -- tempo que o Guardian fica ativo em segundos
local GUARDIAN_COOLDOWN = 3600  -- cooldown em segundos (1 hora)

function Player:summonGuardianTimed(guardianName)
    local storageId = STORAGE_GUARDIAN_COOLDOWN[guardianName]
    local lastUse = self:getStorageValue(storageId)
    if lastUse == -1 then lastUse = 0 end
    local now = os.time()

    -- Verifica cooldown
    if now - lastUse < GUARDIAN_COOLDOWN then
        local remaining = GUARDIAN_COOLDOWN - (now - lastUse)
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        self:sendCancelMessage(string.format(
            "Você só pode usar %s 1 vez a cada 1 hora. Tempo restante: %02dh:%02dm", 
            guardianName, hours, minutes
        ))
        return false
    end

    -- Impede invocar se tiver Pokémon/summon ativo
    local summons = self:getSummons() or {}
    if #summons > 0 then
        self:sendCancelMessage("Você não pode chamar um Guardian enquanto estiver com um Pokémon.")
        return false
    end

    -- Cria o Guardian
    local pos = self:getPosition()
    local guardian = Game.createMonster(guardianName, pos, true, true)
    if not guardian then
        self:sendCancelMessage("Erro ao criar o Guardian.")
        return false
    end

    guardian:setMaster(self)
    guardian:setType(CONST_MONSTER_TYPE_NORMAL)
    guardian:setFollowCreature(self)
    guardian:setTarget(nil)
    self:say("Vá " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)

    -- Marca o cooldown
    self:setStorageValue(storageId, now)

    -- Timer para despawn automático após GUARDIAN_DURATION segundos
    addEvent(function()
        if guardian and not guardian:isRemoved() then
            self:despawnGuardian(guardianName)
        end
    end, GUARDIAN_DURATION * 1000)

    return guardian
end

end


local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition)
    local guardianName = guardians_list[item:getId()]
    if not player:hasGuardian(guardianName) then
        player:summonGuardian(guardianName)
    else
        player:despawnGuardian(guardianName)
    end
    return true
end

for id in pairs(guardians_list) do
    action:id(id)
end

action:register()