local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    if not creature then
        return false
    end
    
    local direction = creature:getDirection()
    local position = creature:getPosition()
    local effectPosition = Position(position)
    local effect = 0
    local steps = 4
    local delay = 250
    local moveX, moveY = 0, 0

    -- Determina a direção do movimento
    if direction == NORTH then
        moveY = 1
        effectPosition.y = position.y + steps
        effectPosition.x = position.x + 1  -- Efeito visual à direita
        effect = 1014
    elseif direction == SOUTH then
        moveY = -1
        effectPosition.x = position.x + 1  -- Efeito visual à direita
        effect = 1013
    elseif direction == EAST then
        moveX = -1
        effect = 1011
    elseif direction == WEST then
        moveX = 1
        effectPosition.x = position.x + steps
        effect = 1012
    end

    -- Adiciona o efeito visual
    effectPosition:sendMagicEffect(effect)
    
    -- Oculta a outfit do personagem
    local originalOutfit = creature:getOutfit()
    creature:setOutfit({lookType = 0})

    -- Movimenta o personagem
    for i = 1, steps do
        addEvent(function()
            if creature then
                local stepPosition = Position(position.x + (moveX * i), position.y + (moveY * i), position.z)
                local targetTile = Tile(stepPosition)
                
                -- Verifica se o tile é válido antes de mover
                if targetTile and targetTile:getGround() then
                    creature:teleportTo(stepPosition)
                end
            end
        end, i * delay)
    end

    -- Restaura a outfit após o movimento
    addEvent(function()
        if creature then
            creature:setOutfit(originalOutfit)
        end
    end, steps * delay)
    
    return true
end

spell:name("Acrobatic Dodge")
spell:words("### AcrobaticDodge ###")
spell:needLearn(false)
spell:register()
