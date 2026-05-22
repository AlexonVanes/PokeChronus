local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local voices = { {text = 'Procuro treinadores capazes de realizar tarefas!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function sendVisualEffect(position, effectId, times, interval, current)
    if current > times then return end
    doSendMagicEffect(position, effectId)
    addEvent(sendVisualEffect, interval, position, effectId, times, interval, current + 1)
end

local function creatureGreetCallback(cid, message)
    local player = Player(cid)
    local dialog6 = "Ola, futuro(a) treinador(a)! Seja bem-vindo a um mundo cheio de desafios! Voce podera escolher um Pokemon para te ajudar a iniciar a sua jornada. Voce esta pronto para iniciar essa aventura?"
    local buttons = {
        { type = "Text", text = "<color=#008000>Sim, estou pronto.<color/>", response = "afirmativo" },
        { type = "Text", text = "<color=#c70000>Nao, ainda nao estou pronto.<color/>", response = "negativo" },
    }
    doSendCallForNpc(getNpcCid(), player, START_CONVERSATION, COLORS.white, nil, dialog6, buttons, closeTime)
    npcHandler.topic[cid] = 0
    return false
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    local playerTopic = npcHandler.topic[cid]
    
    print("Mensagem recebida: ", msg) -- Debug para verificar a entrada do jogador

    if msg == "afirmativo" and playerTopic == 0 then
        if player:getStorageValue(505050) == 0 then
            -- player:setStorageValue(505050, 1)
            sendVisualEffect(Position(2277, 2694, 5), 2337, 7, 815, 1)
			local dialog3 = "Agora voce pode escolher seu Pokemon inicial. Clique na maquina e escolha o seu!"
			doSendCallForNpc(getNpcCid(), player, CONVERSATION, COLORS.white, nil, dialog3, nil, 5)
        elseif player:getStorageValue(505051) ~= 1 then
            player:setStorageValue(505051, 1)
            sendVisualEffect(Position(2277, 2694, 5), 2337, 7, 815, 1)
			local dialog2 = "Escolha seu Pokemon inicial clicando na maquina ao lado."
			doSendCallForNpc(getNpcCid(), player, CONVERSATION, COLORS.white, nil, dialog2, nil, 2)
        else
			local dialog4 = "Voce ja escolheu seu Pokemon inicial!"
			doSendCallForNpc(getNpcCid(), player, CONVERSATION, COLORS.white, nil, dialog4, nil, 5)
        end
        npcHandler:releaseFocus(cid)
    end
    
    local function cancel()
        local dialog = "Que pena! Se mudar de ideia, estarei por aqui."
        doSendCallForNpc(getNpcCid(), player, CONVERSATION, COLORS.white, nil, dialog, nil, 2)
        npcHandler.topic[cid] = 1
    end

local function confirm()
    -- Aqui pode ser inserida qualquer lógica necessária para confirmação.
    local dialog5 = "Muito bem! Agora voce pode escolher seu Pokemon inicial."
    doSendCallForNpc(getNpcCid(), Player(cid), CONVERSATION, COLORS.white, nil, dialog5, nil, 2)
end

    local actions = {
        ["afirmativo"] = {func = confirm, topic = 0},
        ["negativo"] = {func = cancel, topic = 0},
    }

    if actions[msg] and actions[msg].topic == playerTopic then
        actions[msg].func()
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, creatureGreetCallback)
npcHandler:addModule(FocusModule:new())

function onPlayerInteraction(cid)
    local player = Player(cid)
    if player then
        npcHandler:say("Bem-vindo, jovem treinador! Voce esta pronto para escolher seu Pokemon inicial?", cid)
        npcHandler.topic[cid] = 1
        npcHandler:focus(cid)
    end
end
