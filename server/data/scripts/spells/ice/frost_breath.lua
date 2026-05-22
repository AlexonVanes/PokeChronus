local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 176)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Frost Breath")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 555,
    [DIRECTION_EAST] = 558,
    [DIRECTION_SOUTH] = 556,
    [DIRECTION_WEST] = 557
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    -- Ajusta a posição para o efeito com base na direção
    local offset = {x = 0, y = 0}

    if direction == DIRECTION_NORTH then
        offset.x = 1
        offset.y = -1
    elseif direction == DIRECTION_EAST then
        offset.x = 3
        offset.y = 1
    elseif direction == DIRECTION_SOUTH then
        offset.x = 1
        offset.y = 3
    elseif direction == DIRECTION_WEST then
        offset.x = -1
        offset.y = 1
    end

    -- Ajusta a posição do efeito de acordo com o deslocamento calculado
    pos.x = pos.x + offset.x
    pos.y = pos.y + offset.y

    -- Envia o efeito visual para a posição ajustada
    pos:sendMagicEffect(effectId)

    -- Executa o combate com a área definida
    combat:execute(creature, variant)
    
    return true
end

spell:name("Frost Breath")
spell:words("#Frost Breath#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
