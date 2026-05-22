local EFFECT_COUNT = 20
local EFFECT_DELAY = 100
local EXECUTION_COUNT = 2
local EXECUTION_INTERVAL = 500
local AREA_WIND = {
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}
local EFFECTS = {971, 972}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shadow Claw")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local x = centerPos.x + math.random(-5, 5)
    local y = centerPos.y + math.random(-5, 5)
    Position(x, y, centerPos.z):sendMagicEffect(randomEffect)
end

local function castEffects(centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(doRandomEffect, i * EFFECT_DELAY, centerPos)
    end
end

local function executeSpell(creatureId, centerPos, count)
    if count > 0 then
        local creature = Creature(creatureId)
        if not creature then return end

        combat:execute(creature, Variant(centerPos))
        castEffects(centerPos)
        addEvent(executeSpell, EXECUTION_INTERVAL, creatureId, centerPos, count - 1)
    end
end

function spell.onCastSpell(creature, variant)
    executeSpell(creature:getId(), creature:getPosition(), EXECUTION_COUNT)
    return true
end

spell:name("Shadow Claw")
spell:words("#Shadow Claw#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
