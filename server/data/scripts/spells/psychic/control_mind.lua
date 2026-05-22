local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Verificar se a criatura é um jogador
    if not creature or not creature:isPlayer() then
        return false
    end

    local player = creature  -- O jogador (a criatura que usou a spell)
    
    -- Verificar se o jogador tem summons
    local summon = player:getSummons()[1]
    if not summon then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need to have a summon to use this spell.")
        return false
    end

    -- Salva o estado original da visão e posição do jogador
    local originalPosition = player:getPosition()  -- Posição do jogador
    local originalOutfit = player:getOutfit()      -- Outfit do jogador
    local originalViewport = player:getViewport()  -- Faixa de visão do jogador

    -- Obtém a posição e outfit do summon (Pokémon)
    local summonPosition = summon:getPosition()   -- Posição do Pokémon
    local summonOutfit = summon:getOutfit()       -- Outfit do Pokémon

    -- Alterar a visão do jogador para a do summon (Pokémon)
    player:setOutfit(summonOutfit) -- Jogador assume o visual do Pokémon

    -- Muda a posição de visão do jogador para o Pokémon (sem teletransportá-lo)
    player:setViewport(summon:getViewport())  -- Jogador passa a ter a visão do Pokémon

    -- Envia mensagem informando que agora está visualizando pelo Pokémon
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You are now viewing through the eyes of your Pokémon!")

    -- Define o tempo para reverter a visão após 15 segundos
    addEvent(function()
        -- Restaurar a posição, visual e faixa de visão original do jogador
        player:setOutfit(originalOutfit)    -- Restaura o outfit original
        player:teleportTo(originalPosition)  -- Restaura a posição original
        player:setViewport(originalViewport)  -- Restaura a faixa de visão original
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are now back to your original perspective.")
    end, 15000)  -- Ajuste o tempo de duração (15 segundos)

    return true
end

-- Nome correto da magia
spell:name("PokeView")
spell:words("#PokeView#")
spell:isAggressive(false)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
