local function sendVisualEffect(position, effectId, times, interval, current)
    if current > times then
        return
    end
    doSendMagicEffect(position, effectId)
    addEvent(sendVisualEffect, interval, position, effectId, times, interval, current + 1)
end

function onStepIn(cid, item, position, fromPosition)
    local player = Player(cid)
    if not player then
        return true
    end
    
    local effectStorage = 111111 -- Storage para controlar se os efeitos já foram ativados
    local effectPosition = Position(2275, 2693, 6) -- Posição dos efeitos visuais

    if player:getStorageValue(111110) ~= 1 then
        if player:getStorageValue(effectStorage) ~= 1 then
            -- Disparando os dois efeitos visuais no mesmo local
            sendVisualEffect(effectPosition, 2337, 7, 815, 1)
            sendVisualEffect(effectPosition, 713, 7, 815, 1)
            
            player:setStorageValue(effectStorage, 1) -- Marca que os efeitos já foram ativados
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Fale com a Esther para liberar sua task inicial!")
    end

    return true
end
