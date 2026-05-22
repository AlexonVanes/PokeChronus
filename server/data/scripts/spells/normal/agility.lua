local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)

local defenseBonusCondition = createConditionObject(CONDITION_ATTRIBUTES)
defenseBonusCondition:setParameter(CONDITION_PARAM_TICKS, 15000)
defenseBonusCondition:setParameter(CONDITION_PARAM_SUBID, 1) -- Identificador único para a condição
defenseBonusCondition:setParameter(CONDITION_PARAM_BUFF, true)
defenseBonusCondition:setParameter(CONDITION_PARAM_STAT_DEFENSE, 5) -- Bônus de defesa

local hasteCondition = createConditionObject(CONDITION_HASTE)
hasteCondition:setParameter(CONDITION_PARAM_TICKS, 15000)  -- Duração do efeito em milissegundos
hasteCondition:setFormula(0.7, 0, 0.7, 0)  -- Aumenta a velocidade do Pokémon

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    creature:addCondition(defenseBonusCondition)
    creature:addCondition(hasteCondition)
    
    local effectInterval = 850 -- Intervalo de 1 segundo para o efeito visual

    local function showEffect()
        if creature:getCondition(CONDITION_HASTE) then
            local position = creature:getPosition()
            position:sendMagicEffect(15)
            addEvent(showEffect, effectInterval)
        end
    end

    showEffect()
    return true
end

spell:name("Agility")
spell:words("### Agility ###")
spell:needLearn(false)
spell:register()
