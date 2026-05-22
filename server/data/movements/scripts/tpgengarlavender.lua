function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- Coordenadas do local de destino
    local teleportPosition = {x = 2450, y = 2760, z = 8}

    -- Teleporta o jogador
    player:teleportTo(teleportPosition)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

    return true
end
