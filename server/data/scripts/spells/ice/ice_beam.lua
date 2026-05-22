local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ice Beam")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 98,
    [DIRECTION_EAST] = 97,
    [DIRECTION_SOUTH] = 98,
    [DIRECTION_WEST] = 97
}

local offsets = {
    [DIRECTION_NORTH] = {x = 1, y = -1},
    [DIRECTION_EAST] = {x = 6, y = 1},
    [DIRECTION_SOUTH] = {x = 1, y = 6},
    [DIRECTION_WEST] = {x = -1, y = 1}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    local offset = offsets[direction]
    pos.x = pos.x + offset.x
    pos.y = pos.y + offset.y

    pos:sendMagicEffect(effectId)
    combat:execute(creature, variant)
    return true
end

spell:name("Ice Beam")
spell:words("#Ice Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
