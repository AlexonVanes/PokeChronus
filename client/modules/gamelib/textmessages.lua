local messageModeCallbacks = {}

-- Mapeamento de cores (ID -> TextColors)
local colorMap = {
  [5] = TextColors.blue,              -- TEXTCOLOR_BLUE
  [30] = TextColors.lightgreen,       -- TEXTCOLOR_LIGHTGREEN
  [35] = TextColors.lightblue,        -- TEXTCOLOR_LIGHTBLUE
  [143] = TextColors.skyblue,         -- TEXTCOLOR_SKYBLUE
  [154] = TextColors.purple,          -- TEXTCOLOR_PURPLE
  [155] = TextColors.electricpurple,  -- TEXTCOLOR_ELECTRICPURPLE
  [180] = TextColors.red,             -- TEXTCOLOR_RED
  [198] = TextColors.orange,          -- TEXTCOLOR_ORANGE
  [210] = TextColors.yellow,          -- TEXTCOLOR_YELLOW
  [215] = TextColors.white            -- TEXTCOLOR_WHITE_EXP
}

-- Variável global para armazenar a cor atual do broadcast
_G.currentBroadcastColor = nil

function g_game.onTextMessage(messageMode, message, color)
  -- Salvar a cor globalmente para MESSAGE_LOOT
  if color and colorMap[color] and messageMode == MessageModes.Loot then
    _G.currentBroadcastColor = colorMap[color]
  end
  
  local callbacks = messageModeCallbacks[messageMode]
  if not callbacks or #callbacks == 0 then
    perror(string.format('Unhandled onTextMessage message mode %i: %s', messageMode, message))
    return
  end

  for _, callback in pairs(callbacks) do
    callback(messageMode, message)
  end
  
  -- Limpar a cor após processamento
  _G.currentBroadcastColor = nil
end

function registerMessageMode(messageMode, callback)
  if not messageModeCallbacks[messageMode] then
    messageModeCallbacks[messageMode] = {}
  end

  table.insert(messageModeCallbacks[messageMode], callback)
  return true
end

function unregisterMessageMode(messageMode, callback)
  if not messageModeCallbacks[messageMode] then
    return false
  end

  return table.removevalue(messageModeCallbacks[messageMode], callback)
end
