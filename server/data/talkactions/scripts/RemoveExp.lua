function onSay(player, words, param, channel)
  -- Define os valores das storages que serão removidas
  local storage1 = 45144
  local storage2 = 45145

  -- Verifica se o jogador possui as storages que serão removidas
  if player:getStorageValue(storage1) ~= -1 and player:getStorageValue(storage2) ~= -1 then
    -- Remove as duas storages do próprio jogador que digitou o comando
    player:setStorageValue(storage1, -1)
    player:setStorageValue(storage2, -1)

    -- Informa o jogador que as storages foram removidas com sucesso
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você removeu sua Experience Boost!")
  else
    -- Informa o jogador que não possui as storages a serem removidas
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem nenhuma Experience Boost ativa!")
  end
end
