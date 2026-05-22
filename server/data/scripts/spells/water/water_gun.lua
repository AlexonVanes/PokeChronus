local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Gun")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 70,
    [DIRECTION_EAST] = 71,
    [DIRECTION_SOUTH] = 72,
    [DIRECTION_WEST] = 73
}

local offsets = {
    [DIRECTION_NORTH] = {x = 1, y = -1},
    [DIRECTION_EAST] = {x = 5, y = 1},
    [DIRECTION_SOUTH] = {x = 1, y = 5},
    [DIRECTION_WEST] = {x = -1, y = 1}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    if offsets[direction] then
        local offset = offsets[direction]
        pos.x = pos.x + offset.x
        pos.y = pos.y + offset.y
    end

    pos:sendMagicEffect(effectId)
    combat:execute(creature, variant)
    return true
end

spell:name("Water Gun")
spell:words("#Water Gun#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
