local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Aurora Beam")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = {effect = 187, offset = {x = 1, y = -1}}, -- 1 sqm norte, 1 sqm direita
    [DIRECTION_EAST] = {effect = 58, offset = {x = 6, y = 1}},
    [DIRECTION_SOUTH] = {effect = 187, offset = {x = 1, y = 6}},
    [DIRECTION_WEST] = {effect = 58, offset = {x = -1, y = 1}} -- 1 sqm esquerda, 1 sqm sul
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectData = effects[direction]
    local pos = creature:getPosition()
    
    local effectPos = Position(pos.x + effectData.offset.x, pos.y + effectData.offset.y, pos.z)
    effectPos:sendMagicEffect(effectData.effect)

    combat:execute(creature, variant)
    return true
end

spell:name("Aurora Beam")
spell:words("#Aurora Beam#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
