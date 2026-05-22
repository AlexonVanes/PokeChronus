-- Função que verifica se o Pokémon está sumonado (fora da Pokébola)
function isSummonActive(player, summonName)
    local summons = player:getSummons()  -- Obtém todos os summons do jogador
    for _, summon in ipairs(summons) do
        if summon:getName() == summonName then
            return true  -- Pokémon está sumonado
        end
    end
    return false  -- Pokémon não está sumonado
end

-- Configuração da quantidade de Pokémon a serem revividos
local REVIVE_COUNT = 6 -- Altere este valor para a quantidade desejada

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target then
        return false
    end

    if type(target) ~= "userdata" then
        return true
    end

    if target:isCreature() then
        return false
    end

    if target:isItem() and not target:isPokeball() then
        player:sendCancelMessage("Sorry, not possible. You can only use on pokeballs.")
        return true
    end

    local summonHealth = target:getSpecialAttribute("pokeHealth")
    local summonName = target:getSpecialAttribute("pokeName")

    -- Verifica se o summon está sumonado. Se sim, não permite o revive
    if isSummonActive(player, summonName) then
        player:sendCancelMessage("Sorry, you cannot revive a Pokémon that is currently summoned.")
        return true
    end

    -- if summonHealth and summonHealth > 0 then
        -- player:sendCancelMessage("Sorry, not possible. You can only use on fainted summons.")
        -- return true
    -- end

    if player:isDuelingWithNpc() then
        player:sendCancelMessage("Sorry, not possible while in duels.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    if player:isOnLeague() then
        if not player:canUseReviveOnLeague() then
            player:sendCancelMessage("Sorry, you can not use revive anymore.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
    end

    local monster = MonsterType(summonName)
    if not monster then
        player:sendCancelMessage("Invalid Pokémon.")
        return true
    end
    
    target:setSpecialAttribute("pokeHealth", 9999999999) -- Definir vida para um valor extremamente alto para garantir cura completa
    
    local ballKey = getBallKey(target:getId())
    target:transform(balls[ballKey].usedOn)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    target:resetMoves()
    item:remove(1)
    return true
end
