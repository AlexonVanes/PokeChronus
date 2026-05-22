local AREA_ROOM = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_ROOM))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Trick Room")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 2285)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Obtém a posição atual do jogador
    local position = creature:getPosition()

    -- Calcula a nova posição (2 sqm ao sul e 3 sqm à direita)
    local effectPosition = Position(position.x + 3, position.y + 2, position.z)

    -- Envia o efeito mágico para a nova posição calculada
    doSendMagicEffect(effectPosition, 1855)

    -- Executa o combate (o efeito do combate ainda será na área definida pela 'combat1')
    combat1:execute(creature, variant)

    return true
end

spell:name("Trick Room")
spell:words("### Trick Room ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
