local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hyper Beam")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 914,
    [DIRECTION_EAST] = 913,
    [DIRECTION_SOUTH] = 914,
    [DIRECTION_WEST] = 913
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    local effectPos = Position(pos)

    if direction == DIRECTION_NORTH then
        effectPos.y = effectPos.y - 1
    elseif direction == DIRECTION_EAST then
        effectPos.x = effectPos.x + 6
    elseif direction == DIRECTION_SOUTH then
        effectPos.y = effectPos.y + 6
    elseif direction == DIRECTION_WEST then
        effectPos.x = effectPos.x - 1
    end

    effectPos:sendMagicEffect(effectId)
    combat:execute(creature, variant)
    
    return true
end

spell:name("Hyper Beam")
spell:words("#Hyper Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
