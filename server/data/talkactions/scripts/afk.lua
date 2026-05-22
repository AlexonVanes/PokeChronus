local FRASES = {"Off-Line!", "Ausente!", "Afk!", "Ja volto!", "Ocupado."} -- Auto-Mensagens.
local TEMPO = 1 -- Intervalo de Tempo em segundos.

local function sendAutoMessage(player)
    local pos = player:getPosition()
    local text = FRASES[math.random(#FRASES)]
    if pos then
        Game.sendAnimatedText(pos, text, math.random(1, 255))
        pos:sendMagicEffect(13)
    end
end

local function startAutoMessages(player)
    local startTime = os.time()

    addEvent(function()
        while isPlayer(player) do
            local currentTime = os.time()
            if currentTime - startTime >= TEMPO then
                sendAutoMessage(player)
                startTime = currentTime
            end
        end
    end, 0)
end

function onSay(player, words, param)
    local pos = player:getPosition()
    local text = FRASES[math.random(#FRASES)]
    Game.sendAnimatedText(pos, text, math.random(1, 255))
    pos:sendMagicEffect(13)
    player:sendCancelMessage("Vocês Esta Ausente")

    startAutoMessages(player)
    return true
end
