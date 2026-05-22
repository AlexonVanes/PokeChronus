local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Giant Water Gun")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = {effect = 70, offset = {x = 1, y = -1}},
    [DIRECTION_EAST] = {effect = 71, offset = {x = 5, y = 1}},
    [DIRECTION_SOUTH] = {effect = 72, offset = {x = 1, y = 5}},
    [DIRECTION_WEST] = {effect = 73, offset = {x = -1, y = 1}}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectData = effects[direction]
    local pos = creature:getPosition()
    
    if effectData then
        local effectPos = Position(pos.x + effectData.offset.x, pos.y + effectData.offset.y, pos.z)
        effectPos:sendMagicEffect(effectData.effect)
    end
    
    combat:execute(creature, variant)
    return true
end

spell:name("Giant Water Gun")
spell:words("#Giant Water Gun#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()