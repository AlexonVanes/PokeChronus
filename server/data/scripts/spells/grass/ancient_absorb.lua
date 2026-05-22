local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ancient Absorb")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    doSendMagicEffect(creature:getPosition(), 15) -- Efeito 15 no jogador

    local target = creature:getTarget()
    if not target then return false end

    local healAmount = creature:getMaxHealth() * 0.1
    creature:addHealth(healAmount)

    -- Causar dano ao alvo
    target:addHealth(-healAmount)
    doSendMagicEffect(target:getPosition(), 14) -- Efeito 14 no alvo
    
    return true
end

spell:name("Ancient Absorb")
spell:words("#Ancient Absorb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
