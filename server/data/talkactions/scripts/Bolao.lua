local storageValue = 17110 -- valor de storage único para esse evento
local betCost = 300 -- o custo da aposta
local cooldown = 60 -- cooldown em segundos
local playersBets = {} -- tabela para armazenar as apostas dos jogadores
local isActive = false -- variável para controlar o estado do evento

function toggleEvent()
  if isActive then
    isActive = false
    Game.setStorageValue(storageValue, 0)
    Game.broadcastMessage("O evento de apostas foi desativado.", MESSAGE_EVENT_ADVANCE)
  else
    isActive = true
    Game.setStorageValue(storageValue, 1)
    Game.broadcastMessage("O evento de apostas foi ativado.", MESSAGE_EVENT_ADVANCE)
  end
end

function onSay(player, words, param)
  if not player:isPlayer() then
    return false
  end
  
  if not isActive then
    player:sendCancelMessage("Desculpe, o evento de apostas não está ativo no momento.")
    return false
  end

  local number = tonumber(param)

  if not number or number < 1 or number > 100 then
    player:sendCancelMessage("Por favor, informe um número de 1 a 100.")
    return false
  end

  local playerName = player:getName()
  local playerBets = player:getStorageValue(storageValue)
  local playerBlackDiamonds = player:getItemCount(12237) -- id das Black Diamonds

  if playerBlackDiamonds < betCost then
    player:sendCancelMessage("Você não tem Black Diamonds suficientes para fazer essa aposta.")
    return false
  end

  if playerBets ~= -1 then
    local remainingTime = playerBets + cooldown - os.time()
    player:sendCancelMessage("Você já fez sua aposta. Por favor, aguarde " .. remainingTime .. " segundos antes de fazer uma nova aposta.")
    return false
  end

  player:removeItem(12237, betCost)

  playersBets[playerName] = number
  player:setStorageValue(storageValue, os.time())

  Game.broadcastMessage("O jogador " .. playerName .. " fez uma aposta no número " .. number .. ".", MESSAGE_EVENT_ADVANCE)

  return true
end

function onThink(interval, lastExecution)
  local active = Game.getStorageValue(storageValue)
  
  if active == nil then
    isActive = false
    Game.setStorageValue(storageValue, 0)
  else
    isActive = active == 1
  end
  
  if not isActive then
    Game.broadcastMessage("O evento de apostas está desativado. Aguarde até que seja ativado novamente.", MESSAGE_EVENT_ADVANCE)
    return true
  end
  
  local result = math.random(1, 100)
  local closest = nil
  local distance = 100

  for name, bet in pairs(playersBets) do
    local currentDistance = math.abs(bet - result)

    if currentDistance < distance then
      closest = name
      distance = currentDistance
    end
  end

  if closest then
    local betAmount = betCost * tableCount(playersBets)
    local winnerName = closest
    local winner = Game.getPlayersByName(winnerName)[1]

    if winner then
      winner:addItem(12237, betAmount)
      Game.broadcastMessage("Parabéns ao jogador " .. winnerName .. " por acertar o número " .. result .. " e ganhar " .. betAmount .. " Black Diamonds!", MESSAGE_EVENT_ADVANCE)
      
      scheduler.scheduleEvent(function()
        winner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você ganhou " .. betAmount .. " Black Diamonds no evento de apostas!")
      end, 5 * 60 * 1000)
    end
  else
    Game.broadcastMessage("Nenhum jogador acertou o número sorteado " .. result .. ".", MESSAGE_EVENT_ADVANCE)
  end

  playersBets = {}
  return true
end
