local EFFECT_COUNT = 80
local EFFECT_DELAY = 25

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local PRE_CAST_EFFECT = 2536  -- Efeito de aviso (antes da explosão)
local EXPLOSION_EFFECT = 1741  -- Efeito da explosão
local INITIAL_EFFECT = 2435  -- Novo efeito inicial
local DAMAGE_AMOUNT = 50000  -- Dano fixo de 50000
local FREEZE_TIME = 2000  -- Tempo de imobilização em milissegundos

local spell = Spell(SPELL_INSTANT)

-- Função para exibir o efeito de aviso
local function showWarningEffect(targetPos)
    targetPos:sendMagicEffect(PRE_CAST_EFFECT)
end

-- Função para aplicar dano e exibir a explosão
local function applyDamageAndExplosion(targetPos, casterId)
    local tile = Tile(targetPos)  -- Obtém o tile (SQM) da posição
    if tile then
        local creatures = tile:getCreatures()  -- Obtém todas as criaturas no tile
        if creatures and #creatures > 0 then  -- Verifica se há criaturas no tile
            for _, creature in ipairs(creatures) do
                -- Verifica se a criatura é um monstro e se não é o lançador
                if creature:isMonster() and creature:getId() ~= casterId then
                    creature:addHealth(-DAMAGE_AMOUNT)  -- Aplica o dano de 5000
                end
                -- Verifica se é um jogador sem Pokémon
                if creature:isPlayer() then
                    if not creature:getSummon() then  -- Se o jogador não tem Pokémon
                        creature:addHealth(-DAMAGE_AMOUNT)  -- Aplica o dano de 5000 ao jogador sem Pokémon
                    end
                end
            end
        end
        -- Exibe o efeito de explosão em todos os casos, com ou sem criaturas
        targetPos:sendMagicEffect(EXPLOSION_EFFECT)
    else
        print("No tile found at position: " .. targetPos.x .. ", " .. targetPos.y .. ", " .. targetPos.z)
    end
end

-- Função que controla os efeitos visuais e o dano
local function castEffects(creature, centerPos)
    local creatureId = creature:getId()  -- Obtém o ID do lançador

    -- Ajustando o deslocamento para reduzir um pouco a área
    local maxOffset = 6  -- Área menor

    for i = 1, EFFECT_COUNT do
        local randomOffsetX = math.random(-maxOffset, maxOffset)  -- Ajustado para o deslocamento de 5
        local randomOffsetY = math.random(-maxOffset, maxOffset)  -- Ajustado para o deslocamento de 5
        local targetPos = Position(centerPos.x + randomOffsetX, centerPos.y + randomOffsetY, centerPos.z)

        -- Mostra o efeito de aviso imediatamente
        addEvent(showWarningEffect, 0, targetPos)

        -- Aplica o dano e o efeito de explosão 2 segundos depois
        addEvent(applyDamageAndExplosion, 2000, targetPos, creatureId)
    end
end

function spell.onCastSpell(creature, variant)
    local centerPos = creature:getPosition()
    
    -- Mostra o efeito inicial 3 SQM para baixo e 3 SQM para a direita
    local initialEffectPos = Position(centerPos.x + 3, centerPos.y + 3, centerPos.z)
    initialEffectPos:sendMagicEffect(INITIAL_EFFECT)

    -- Criando e aplicando a condição de paralisia
    local condition = Condition(CONDITION_PARALYZE)
    condition:setParameter(CONDITION_PARAM_TICKS, FREEZE_TIME)
    condition:setParameter(CONDITION_PARAM_SPEED, -creature:getSpeed()) -- Zera a velocidade
    creature:addCondition(condition)

    -- Removido o `combat:execute()` para evitar dano em área
    castEffects(creature, centerPos)

    return true
end

spell:name("Testando")
spell:words("#Testando#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
