local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bulldoze")

local effects = {
    [DIRECTION_NORTH] = 127,
    [DIRECTION_EAST] = 125,
    [DIRECTION_SOUTH] = 126,
    [DIRECTION_WEST] = 124
}

-- Mapa de deslocamento por direção (x, y)
local directionOffsets = {
    [DIRECTION_NORTH] = {x = 1, y = 0},      -- 1 sqm à direita
    [DIRECTION_EAST]  = {x = 2, y = 1},      -- 2 sqms à direita, 1 para o sul
    [DIRECTION_SOUTH] = {x = 1, y = 2},      -- 1 para a direita, 2 para o sul
    [DIRECTION_WEST]  = {x = 0, y = 1},      -- 1 para o sul
}

local spell = Spell(SPELL_INSTANT)

local function sendEffect(index, cid, pos, direction)
    local creature = Creature(cid)
    if not creature then return end

    -- Aplica dano nos alvos na posição
    for _, target in ipairs(Tile(pos):getCreatures() or {}) do
        if target ~= creature then
            combat:execute(creature, Variant(target:getPosition()))
        end
    end

    -- Obtém o deslocamento baseado na direção
    local offset = directionOffsets[direction]
    local effectPos = Position(pos.x + offset.x, pos.y + offset.y, pos.z)

    -- Aplica o efeito visual na posição ajustada
    effectPos:sendMagicEffect(effects[direction])

    -- Move para o próximo SQM
    if index < 5 then
        local nextPos = Position(pos)
        if direction == DIRECTION_NORTH then nextPos.y = nextPos.y - 1
        elseif direction == DIRECTION_EAST then nextPos.x = nextPos.x + 1
        elseif direction == DIRECTION_SOUTH then nextPos.y = nextPos.y + 1
        elseif direction == DIRECTION_WEST then nextPos.x = nextPos.x - 1
        end

        -- Aumentando a velocidade do efeito visual para 300ms
        addEvent(sendEffect, 370, index + 1, cid, nextPos, direction)
    end
end

function spell.onCastSpell(creature, variant)
    sendEffect(1, creature:getId(), creature:getPosition(), creature:getDirection())
    return true
end

spell:name("Bulldoze")
spell:words("#Bulldoze#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
