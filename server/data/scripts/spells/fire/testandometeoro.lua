local EFFECT_COUNT = 30
local EFFECT_DELAY = 200  -- Ajustado para espaçamento entre os meteoros

local METEOR_WARNING_EFFECT = 2312  -- Efeito visual do meteoro caindo
local METEOR_EXPLOSION_EFFECT = 2311  -- Efeito visual da explosão
local DAMAGE_AMOUNT = 50000  -- Dano fixo
local FREEZE_TIME = 2000  -- Tempo de imobilização em milissegundos

local spell = Spell(SPELL_INSTANT)

-- Função para exibir o efeito de aviso do meteoro
local function showMeteorWarning(targetPos)
    targetPos:sendMagicEffect(METEOR_WARNING_EFFECT)
end

-- Função para aplicar dano em área 2x2 e exibir a explosão
local function applyMeteorExplosion(targetPos, casterId)
    local affectedPositions = {
        Position(targetPos.x, targetPos.y, targetPos.z),
        Position(targetPos.x + 1, targetPos.y, targetPos.z),
        Position(targetPos.x, targetPos.y + 1, targetPos.z),
        Position(targetPos.x + 1, targetPos.y + 1, targetPos.z)
    }
    
    for _, pos in ipairs(affectedPositions) do
        local tile = Tile(pos)
        if tile then
            local creatures = tile:getCreatures()
            if creatures and #creatures > 0 then
                for _, creature in ipairs(creatures) do
                    if creature:getId() ~= casterId then
                        creature:addHealth(-DAMAGE_AMOUNT)
                    end
                end
            end
        end
    end
    
    -- Exibir os efeitos no mesmo sqm da explosão
    targetPos:sendMagicEffect(METEOR_EXPLOSION_EFFECT)
end

-- Função para controlar os meteoros caindo e explodindo
local function castMeteors(creature, centerPos)
    local creatureId = creature:getId()
    local maxOffset = 6

    for i = 1, EFFECT_COUNT do
        local randomOffsetX = math.random(-maxOffset, maxOffset)
        local randomOffsetY = math.random(-maxOffset, maxOffset)
        local targetPos = Position(centerPos.x + randomOffsetX, centerPos.y + randomOffsetY, centerPos.z)

        -- Mostra o efeito de aviso do meteoro
        addEvent(showMeteorWarning, i * EFFECT_DELAY, targetPos)

        -- Aplica dano e efeito de explosão após 2 segundos
        addEvent(applyMeteorExplosion, (i * EFFECT_DELAY) + 800, targetPos, creatureId)
    end
end

function spell.onCastSpell(creature, variant)
    local centerPos = creature:getPosition()

    -- Criando condição de paralisia
    local condition = Condition(CONDITION_PARALYZE)
    condition:setParameter(CONDITION_PARAM_TICKS, FREEZE_TIME)
    condition:setParameter(CONDITION_PARAM_SPEED, -creature:getSpeed())
    creature:addCondition(condition)

    castMeteors(creature, centerPos)
    return true
end

spell:name("Meteor Shower")
spell:words("#Meteor Shower#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
