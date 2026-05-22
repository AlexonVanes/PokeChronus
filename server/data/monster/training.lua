local mType = Game.createMonsterType("Training")
local pokemon = {}

pokemon.description = "a Training"
pokemon.experience = 0
pokemon.outfit = { lookType = 6520 }

-- Vida absurdamente alta (imortalidade por quantidade)
pokemon.health = 2000000000   -- 2 bilhões
pokemon.maxHealth = pokemon.health

pokemon.race = "normal"
pokemon.race2 = "none"
pokemon.corpse = 0
pokemon.speed = 0
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4000,
    chance = 0
}

pokemon.flags = {
    minimumLevel = 1000,
    maximumLevel = 1000,
    attackable = true,
    summonable = false,
    hostile = false,
    passive = true,
    convinceable = false,
    illusionable = false,
    canPushItems = false,
    canPushCreatures = false,
    targetDistance = 1,
    staticAttackChance = 0,
    runHealth = 0,
    isBlockable = true,
}

-- Nenhum evento externo para evitar erros
pokemon.events = {}   -- vazio
pokemon.summons = {}
pokemon.voices = {}
pokemon.loot = {}
pokemon.moves = {}
pokemon.attacks = {}
pokemon.defenses = {}
pokemon.elements = {}
pokemon.immunities = {}

-- Impede o monstro de atacar e o mantém imóvel
function mType.onThink(monster, interval)
    if not monster then
        return true
    end

    -- Remove qualquer alvo
    if monster:getTarget() then
        monster:setTarget(nil)
    end

    -- Restaura a vida completamente a cada think (1 segundo)
    local currentHealth = monster:getHealth()
    local maxHealth = monster:getMaxHealth()
    if currentHealth < maxHealth then
        monster:addHealth(maxHealth - currentHealth)
    end

    return true
end

-- Impede movimento
function mType.onMove(monster, creature, fromPosition, toPosition)
    return false
end

-- Ao surgir, garante vida máxima e define o maxHealth corretamente
function mType.onAppear(monster, creature)
    if monster then
        monster:setMaxHealth(pokemon.maxHealth)
        monster:addHealth(pokemon.maxHealth)
    end
    return true
end

mType:register(pokemon)