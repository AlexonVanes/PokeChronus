local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Giga Drain")

local function applyEffect(creature, target)
    if not target then
        return
    end
    
    -- Calcular o dano manualmente
    local damage = math.random(2500, 4500)
    local healAmount = math.floor(damage * 0.90)
    
    -- Aplicar o dano ao alvo
    target:addHealth(-damage)
    
    -- Aplicar a cura ao lançador
    creature:addHealth(healAmount)
    
    -- Aplica os efeitos visuais
    target:getPosition():sendMagicEffect(14)  -- Efeito 14 no alvo
    creature:getPosition():sendMagicEffect(15)  -- Efeito 15 no lançador
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    applyEffect(creature, target)
    return true
end

-- Configuração da spell
targetSpell:name("Giga Drain")
targetSpell:words("#Giga Drain")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:register()
