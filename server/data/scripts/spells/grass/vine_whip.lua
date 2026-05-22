local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Vine Whip")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 81,
    [DIRECTION_EAST] = 84,
    [DIRECTION_SOUTH] = 82,
    [DIRECTION_WEST] = 83
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    
    -- Ajuste a posição do efeito para diagonal norte-direita quando direcionado para cima
    if direction == DIRECTION_NORTH then
        pos.y = pos.y - 1 -- Move um SQM para cima
        pos.x = pos.x + 1 -- Move um SQM para a direita
    elseif direction == DIRECTION_SOUTH then
        pos.y = pos.y + 2 -- Move um SQM para baixo
        pos.x = pos.x + 1 -- Move um SQM para a direita
    elseif direction == DIRECTION_EAST then
        pos.y = pos.y + 1 -- Move um SQM para baixo
        pos.x = pos.x + 2 -- Move dois SQMs para a direita
    elseif direction == DIRECTION_WEST then
        pos.y = pos.y + 1 -- Move um SQM para baixo
        pos.x = pos.x - 1 -- Move dois SQMs para a esquerda
    end

    pos:sendMagicEffect(effectId)
    combat:execute(creature, variant)
    return true
end

spell:name("Vine Whip")
spell:words("#Vine Whip#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
