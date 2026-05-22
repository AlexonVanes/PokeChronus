local AREA_SLASH = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat1:setArea(createCombatArea(AREA_SLASH))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Air Slash")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local pos = creature:getPosition()

    -- posição do efeito: 3 SQM para o sul e 4 SQM para a direita
    local effectPos = Position(
        pos.x + 4,
        pos.y + 3,
        pos.z
    )

    effectPos:sendMagicEffect(2424)

    combat1:execute(creature, variant)
    return true
end

spell:name("Air Slash")
spell:words("### Air Slash ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
