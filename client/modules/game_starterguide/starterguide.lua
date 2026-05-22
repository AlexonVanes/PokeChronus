local STARTER_OPCODE = 175 -- example ID, keep in sync with server
local STARTER_GUIDE_ENABLED = false -- toggle to reativar o módulo quando necessário

local window
local taskList
local progressBar
local progressValue
local startJourneyButton
local topMenuButton

local tasksConfig
local taskWidgets = {}
local taskStates = {}
local totalTasks = 0
local completedTasks = 0
local completionEvent

local DEFAULT_DISCORD_URL = 'https://discord.gg/pokechronus'

local starterGuide = {}

local TASKS = {
  { id = 1, name = 'Conhecer o Professor', iconText = 'PR', storage = 45001, description = 'Visite o professor Oak no laboratório de Pallet.' },
  { id = 2, name = 'Escolher seu Pokémon Inicial', iconText = 'PK', storage = 45002, description = 'Selecione seu parceiro inicial e conclua o diálogo.' },
  { id = 3, name = 'Aprender a Capturar', iconText = 'CT', storage = 45003, description = 'Complete o mini tutorial de captura com o professor.' },
  { id = 4, name = 'Aprender a Batalhar', iconText = 'BT', storage = 45004, description = 'Finalize as instruções básicas de batalha.' },
  { id = 5, name = 'Explorar a Primeira City', iconText = 'EX', storage = 45005, description = 'Chegue à cidade inicial e converse com os NPCs principais.' },
  { id = 6, name = 'Entrar no Discord', iconText = 'DC', storage = 45006, description = 'Entre no servidor oficial do Discord via botão Ir.', action = 'openDiscord', actionLabel = 'Entrar' },
  { id = 7, name = 'Fale com a Nurse', iconText = 'NU', storage = 45007, description = 'Converse com qualquer Nurse do centro Pokémon inicial.' },
  { id = 8, name = 'Task: Capturar um Tangela', iconText = 'TG', storage = 45101, reward = 'XP + 1 Rare Candy', description = 'Capture um Tangela selvagem para desbloquear a recompensa.' },
  { id = 9, name = 'Task: Coletar todas as stones', iconText = 'ST', storage = 45102, reward = 'XP + 5 Stones aleatórias', description = 'Entregue 1 stone de cada elemento usando o botão Entregar.', action = 'deliverStones', actionLabel = 'Entregar' },
  { id = 10, name = 'Task: Kill 30 Pokémons (nível 70)', iconText = 'K30', storage = 45103, progress = true, reward = 'XP + TM Especial', description = 'Com nível 70+, derrote 30 pokémons. Progresso enviado pelo servidor.' },
  { id = 11, name = 'Task: Capturar 1 Shiny (nível 80)', iconText = 'SH', storage = 45104, reward = 'XP + Outfit', description = 'Capture qualquer pokémon shiny a partir do nível 80.' },
  { id = 12, name = 'Task Final: Nurse Outlands (nível 120)', iconText = 'FN', storage = 45105, reward = 'XP + Mount', description = 'Aproxime-se da Nurse nas Outlands e use o botão Checar.', action = 'completeNurse', actionLabel = 'Checar' }
}

local function shouldAutoOpen()
  local char = g_game.getCharacterName()
  if not char or char == '' then
    return false
  end
  local node = g_settings.getNode('starterguide_autoopen') or {}
  if not node[char] then
    node[char] = true
    g_settings.setNode('starterguide_autoopen', node)
    return true
  end
  return false
end

local function sendOpcode(payload)
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  protocol:sendExtendedOpcode(STARTER_OPCODE, json.encode(payload))
end

local function updateProgressUI()
  if not progressBar then return end
  local percent = totalTasks > 0 and (completedTasks / totalTasks) * 100 or 0
  progressBar:setPercent(percent)
  progressValue:setText(('%d / %d'):format(completedTasks, totalTasks))
end

local function playCompletionEffect()
  if completionEvent then
    removeEvent(completionEvent)
    completionEvent = nil
  end
  if not window then return end
  window:setOpacity(0.5)
  completionEvent = scheduleEvent(function()
    if window then
      window:setOpacity(1)
    end
    completionEvent = nil
  end, 1200)
end

local function setTaskCompleted(widget, completed)
  if not widget.completeCheck or not widget.actionButton then
    return
  end
  if completed then
    widget.completeCheck:setImageSource('')
    widget.completeCheck:setImageColor('#34d399')
    if widget.completeCheck.setText then
      widget.completeCheck:setText('✔')
    end
    widget.actionButton:setVisible(false)
  else
    widget.completeCheck:setImageSource('')
    widget.completeCheck:setImageColor('#334155')
    if widget.completeCheck.setText then
      widget.completeCheck:setText('—')
    end
    widget.actionButton:setVisible(true)
  end
  if widget.taskData then
    taskStates[widget.taskData.id] = completed and 1 or 0
  end
end

local function setTaskProgress(widget, current, total)
  if not widget.taskProgressBar or not widget.taskProgressLabel then
    return
  end
  widget.taskProgressBar:setVisible(true)
  widget.taskProgressLabel:setVisible(true)
  widget.taskProgressBar:setPercent(total > 0 and (current / total) * 100 or 0)
  widget.taskProgressLabel:setText(('%d / %d'):format(current, total))
end

local function updateSync(values)
  completedTasks = 0
  local storageMap = {}
  if type(values) == 'table' then
    for _, entry in ipairs(values) do
      if type(entry) == 'table' and entry.storage then
        storageMap[entry.storage] = entry.value or entry.storageValue or 0
      end
    end
  end
  for _, task in ipairs(tasksConfig) do
    local widget = taskWidgets[task.id]
    if widget then
      local value = storageMap[task.storage] or storageMap[tostring(task.storage)] or 0
      local completed = value == 1
      widget.storageValue = value
      setTaskCompleted(widget, completed)
      if completed then
        completedTasks = completedTasks + 1
      end
    end
  end
  updateProgressUI()
  if completedTasks == totalTasks and totalTasks > 0 then
    playCompletionEffect()
  end
end

local function updateTaskStatus(taskId, completed)
  local widget = taskWidgets[taskId]
  if not widget then return end

  local alreadyCompleted = taskStates[taskId] == 1
  widget.storageValue = completed and 1 or 0
  setTaskCompleted(widget, completed)

  if completed and not alreadyCompleted then
    completedTasks = math.min(totalTasks, completedTasks + 1)
  elseif not completed and alreadyCompleted then
    completedTasks = math.max(0, completedTasks - 1)
  end
  updateProgressUI()

  if completed and completedTasks == totalTasks then
    playCompletionEffect()
  end
end

local function updateTaskProgress(taskId, current, total)
  local widget = taskWidgets[taskId]
  if not widget then return end
  setTaskProgress(widget, current, total)
end

local function createTaskEntry(data)
  local widget = g_ui.createWidget('TaskEntry', taskList)
  if not widget then
    g_logger.error('[StarterGuide] TaskEntry style missing (check starterguide.otui)')
    return
  end

  widget.taskIcon = widget:recursiveGetChildById('taskIcon')
  widget.taskName = widget:recursiveGetChildById('taskName')
  widget.taskDescription = widget:recursiveGetChildById('taskDescription')
  widget.taskProgressBar = widget:recursiveGetChildById('taskProgressBar')
  widget.taskProgressLabel = widget:recursiveGetChildById('taskProgressLabel')
  widget.completeCheck = widget:recursiveGetChildById('completeCheck')
  widget.actionButton = widget:recursiveGetChildById('actionButton')
  widget.rewardLabel = widget:recursiveGetChildById('rewardValue')

  if widget.taskName then
    widget.taskName:setText(data.name)
  end

  if widget.taskIcon then
    if widget.taskIcon.setText then
      widget.taskIcon:setText(data.iconText or 'TS')
    elseif data.icon then
      widget.taskIcon:setImageSource(data.icon)
    end
  end

  local descriptionText = data.description or 'Complete esta etapa para avançar!'
  if widget.taskDescription then
    widget.taskDescription:setText(descriptionText)
  end

  if widget.rewardLabel then
    if data.reward then
      widget.rewardLabel:setText('Recompensa: ' .. data.reward)
      widget.rewardLabel:setVisible(true)
    else
      widget.rewardLabel:setVisible(false)
    end
  end

  if widget.actionButton then
    widget.actionButton:setText(data.actionLabel or 'Ir')
    widget.actionButton.taskId = data.id
    widget.actionButton.onClick = function()
      if data.action then
        local payload = { action = data.action, taskId = data.id }
        if data.action == 'completeNurse' then
          payload.npcName = 'nurse'
        end
        sendOpcode(payload)
      else
        sendOpcode({ action = 'goToTask', taskId = data.id })
      end
    end
  end

  if data.progress then
    if widget.taskProgressBar then
      widget.taskProgressBar:setVisible(true)
    end
    if widget.taskProgressLabel then
      widget.taskProgressLabel:setVisible(true)
      widget.taskProgressLabel:setText('0 / 0')
    end
  end

  widget.taskData = data
  widget.storageValue = 0
  taskStates[data.id] = 0
  taskWidgets[data.id] = widget
end

local function buildTaskList()
  if not taskList then return end
  taskList:destroyChildren()
  taskWidgets = {}
  taskStates = {}
  tasksConfig = TASKS
  totalTasks = #tasksConfig
  for _, task in ipairs(tasksConfig) do
    createTaskEntry(task)
  end
  updateProgressUI()
end

local function ensureWindow()
  if window then return end
  window = g_ui.loadUI('starterguide', modules.game_interface.getRootPanel())
  if not window then
    g_logger.error('[StarterGuide] Failed to load starterguide.otui')
    return
  end
  window:hide()

  taskList = window:recursiveGetChildById('taskList')
  progressBar = window:recursiveGetChildById('progressBar')
  progressValue = window:recursiveGetChildById('progressValue')

  if not taskList then
    g_logger.error('[StarterGuide] taskList widget missing in starterguide.otui')
    return
  end

  buildTaskList()
end

local function requestSync()
  if not g_game.isOnline() then return end
  sendOpcode({ action = 'requestSync' })
end

local function showWindow()
  if not window then return end
  window:show()
  window:raise()
  window:focus()
end

local function autoOpen(opts)
  ensureWindow()
  if not window then return end
  showWindow()
  if not opts or opts.sync ~= false then
    requestSync()
  end
end

local function ensureVisible(opts)
  ensureWindow()
  if not window then return end
  if not window:isVisible() then
    autoOpen(opts)
  end
end

local function toggle()
  ensureWindow()
  if not window then return end
  if window:isVisible() then
    window:hide()
  else
    autoOpen()
  end
end

local function onExtended(protocol, opcode, buffer)
  if opcode ~= STARTER_OPCODE then return end
  local ok, data = pcall(function() return json.decode(buffer) end)
  if not ok or type(data) ~= 'table' then return end

  if data.action == 'openGuide' then
    autoOpen()
  elseif data.action == 'updateStatus' then
    ensureVisible({ sync = false })
    updateTaskStatus(data.taskId, data.completed)
  elseif data.action == 'updateProgress' then
    ensureVisible({ sync = false })
    updateTaskProgress(data.taskId, data.current or 0, data.total or 0)
  elseif data.action == 'syncAll' then
    ensureVisible({ sync = false })
    updateSync(data.values or {})
  elseif data.action == 'openDiscord' then
    local url = data.url or DEFAULT_DISCORD_URL
    if url and url ~= '' then
      g_platform.openUrl(url)
    end
  elseif data.action == 'message' then
    if data.message then
      modules.game_textmessage.displayStatusMessage(data.message)
    end
  end
end

local function onGameStart()
  sendOpcode({ action = 'playerLogin' })
  addEvent(function()
    autoOpen()
  end, 200)
end

local function onGameEnd()
  if completionEvent then
    removeEvent(completionEvent)
    completionEvent = nil
  end
  if window then
    window:hide()
  end
end

local function ensureTopMenuButton()
  if topMenuButton or not modules.client_topmenu then return end
  topMenuButton = modules.client_topmenu.addRightGameButton('starterguideTopButton', tr('Guia Inicial'), '/images/topbuttons/questlog', toggle)
end

local function destroyTopMenuButton()
  if not topMenuButton then return end
  topMenuButton:destroy()
  topMenuButton = nil
end

function init()
  if not STARTER_GUIDE_ENABLED then
    g_logger.info('[StarterGuide] módulo desativado temporariamente.')
    return
  end

  ensureWindow()
  if not window then
    return
  end
  ensureTopMenuButton()
  ProtocolGame.registerExtendedOpcode(STARTER_OPCODE, onExtended)
  connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
end

function terminate()
  if not STARTER_GUIDE_ENABLED then
    return
  end

  disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
  ProtocolGame.unregisterExtendedOpcode(STARTER_OPCODE)
  destroyTopMenuButton()
  if window then
    window:destroy()
    window = nil
  end
end

modules.game_starterguide = starterGuide
starterGuide.toggle = toggle
starterGuide.open = autoOpen
starterGuide.ensureTopButton = ensureTopMenuButton
starterGuide.destroyTopButton = destroyTopMenuButton

