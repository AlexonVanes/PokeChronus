local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1046)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Flaming Dash")

local effects = {
    [DIRECTION_NORTH] = 1015,
    [DIRECTION_EAST] = 1018,
    [DIRECTION_SOUTH] = 1016,
    [DIRECTION_WEST] = 1017
}

local directionOffsets = {
    [DIRECTION_NORTH] = {x = 0, y = -1},
    [DIRECTION_EAST]  = {x = 1, y = 0},
    [DIRECTION_SOUTH] = {x = 0, y = 1},
    [DIRECTION_WEST]  = {x = -1, y = 0},
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    if not creature then return false end

    local creatureId = creature:getId()
    local originalOutfit = creature:getOutfit()
    local creaturePosition = creature:getPosition()
    local direction = creature:getDirection()

    creature:setNoMove(true)

    local function applyDamageAround(creature, pos)
        for x = -1, 1 do
            for y = -1, 1 do
                local targetPos = Position(pos.x + x, pos.y + y, pos.z)
                if targetPos ~= pos then
                    for _, target in ipairs(Tile(targetPos):getCreatures() or {}) do
                        if target ~= creature then
                            combat:execute(creature, Variant(target:getPosition()))
                        end
                    end
                end
            end
        end
    end

    local function applyEffectAndMove(cid, pos, direction, index)
        local creature = Creature(cid)
        if not creature then return end

        applyDamageAround(creature, pos)

        local offset = directionOffsets[direction]
        local nextPos = Position(pos.x + offset.x, pos.y + offset.y, pos.z)

        if index < 6 then
            local effectPos = Position(pos.x, pos.y, pos.z)
            if direction == DIRECTION_SOUTH or direction == DIRECTION_NORTH then
                effectPos.x = effectPos.x + 1 -- Move o efeito 1 sqm para a direita quando for para o sul ou norte
            end
            effectPos:sendMagicEffect(effects[direction])

            if index == 1 then
                creature:setOutfit({lookType = 0})
            end

            creature:teleportTo(nextPos)
            addEvent(applyEffectAndMove, 350, cid, nextPos, direction, index + 1)
        else
            local currentCreature = Creature(cid)
            if not currentCreature then
                return
            end

            currentCreature:setOutfit(originalOutfit)

            -- Não envia efeito visual extra após o retorno à posição inicial
            if currentCreature:getPosition() == creaturePosition then
                -- Não aplica efeito visual quando o Pokémon retornar
                currentCreature:getPosition():sendMagicEffect(0)
            end

            addEvent(function()
                currentCreature:setNoMove(false)
            end, 500)
        end
    end

    applyEffectAndMove(creatureId, creaturePosition, direction, 1)

    return true
end

spell:name("Flaming Dash")
spell:words("#Flaming Dash#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
