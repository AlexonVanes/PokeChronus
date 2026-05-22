function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- pega o tile
    local tile = Tile(position)
    if not tile then
        return true
    end

    -- verifica se o tile tem algum player vivo
    local hasPlayer = false
    local creatures = tile:getCreatures()

    if creatures then
        for _, c in ipairs(creatures) do
            local p = c:getPlayer()
            if p and p:isPlayer() and p:getId() ~= player:getId() then
                hasPlayer = true
                break
            end
        end
    end

    -- se já tiver outro player, bloqueia
    if hasPlayer then
        player:teleportTo(fromPosition, true)
        player:sendCancelMessage("Essa maquina de boost ja esta em uso.")
        return false
    end

    return true
end
