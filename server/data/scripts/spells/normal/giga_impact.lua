local AREA_IMPACT = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_IMPACT))
combat1:setParameter(COMBAT_PARAM_EFFECT, 104)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Giga Impact")

local spell = Spell(SPELL_INSTANT)

local function activateEffect(creature_id, duration, interval)
    local elapsed = 0
    
    local function repeatEffect()
        local creature = Creature(creature_id)
        if creature and elapsed < duration then
            doSendMagicEffect(Position(creature:getPosition().x + 2, creature:getPosition().y + 2, creature:getPosition().z), 2417)
            elapsed = elapsed + interval
            addEvent(repeatEffect, interval)
        end
    end
    
    repeatEffect()
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    activateEffect(creature_id, 3000, 3000)
    
    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            creature:sendJump(30, 300)
            addEvent(function()
                local creature = Creature(creature_id)
                if creature then
                    combat1:execute(creature, Variant(creature:getPosition()))
                end
            end, 400)
        end
    end, 3000)
    
    return true
end

spell:name("Giga Impact")
spell:words("### Giga Impact ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
