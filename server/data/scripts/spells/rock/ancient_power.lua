local AREA_COUNT = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat1:setArea(createCombatArea(AREA_COUNT))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ancient Power")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    if not creature or not variant then return false end

    local creatureid = creature:getId()
    local position = creature:getPosition()
    
    local effectPos1 = Position(position.x + 1, position.y + 1, position.z)
    doSendMagicEffect(effectPos1, 1056)

    addEvent(function()
        if isCreature(creatureid) then
            local newPosition = creature:getPosition()
            combat1:execute(creature, variant)
            local effectPos2 = Position(newPosition.x + 3, newPosition.y + 3, newPosition.z)
            doSendMagicEffect(effectPos2, 2086)
        end
    end, 2000)

    return true
end

spell:name("Ancient Power")
spell:words("### Ancient Power ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
