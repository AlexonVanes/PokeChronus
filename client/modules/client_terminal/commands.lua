local function pcolored(text, color)
  color = color or 'white'
  modules.client_terminal.addLine(tostring(text), color)
end


function live(name)
  if not name then
    pcolored('ERROR: missing module name', 'red')
    return
  end

  local module = g_modules.getModule(name)
  if not module then
    pcolored('ERROR: unable to find module ' .. name, 'red')
    return
  end

  if not module:isReloadble() then
    pcolored('ERROR: that module is not reloadable', 'red')
    return
  end

  if not module:canReload() then
    pcolored('ERROR: some other modules requires this module, cannot reload now', 'red')
    return
  end

  local files = {}
  local hasFile = false
  pcolored("Live Reloading...", 'blue')
  for _,file in pairs(g_resources.listDirectoryFiles('/' .. name)) do
    local filepath = '/modules/' .. name .. '/' .. file
	 pcolored(file, 'green')
    local time = g_resources.getFileTime(filepath)
    if time > 0 then
      files[filepath] = time
      hasFile = true
    end
  end

  if not hasFile then
    pcolored('ERROR: unable to find any file for module', 'red')
    return
  end

  cycleEvent(function()
    for filepath,time in pairs(files) do
      local newtime = g_resources.getFileTime(filepath)
      if newtime > time then
        pcolored('Reloading... ' .. name, 'green')
        modules.client_terminal.flushLines()
        module:reload()
        files[filepath] = newtime

        if name == 'client_terminal' then
          modules.client_terminal.show()
        end
        break
      end
    end
  end, 1000)
end



function module_reload(name)
  if not name then
    pcolored('ERROR: missing module name', 'red')
    return
  end

  local module = g_modules.getModule(name)
  if not module then
    pcolored('ERROR: unable to find module ' .. name, 'red')
    return
  end

  if not module:isReloadble() then
    pcolored('ERROR: that module is not reloadable', 'red')
    return
  end

  if not module:canReload() then
    pcolored('ERROR: some other modules requires this module, cannot reload now', 'red')
    return
  end

	module:reload()
end


function draw_debug_boxes()
  g_ui.setDebugBoxesDrawing(not g_ui.isDrawingDebugBoxes())
end

function hide_map()
  modules.game_interface.getMapPanel():hide()
end

function show_map()
  modules.game_interface.getMapPanel():show()
end

local ping_media = {}

function resetPing()
	ping_media = {}
end


function pingMedia()
	local value = 0
	for index, ping in ipairs(ping_media) do
		value = value + ping
	end
	return pcolored("M�dia:" .. math.floor(value/#ping_media), "green")
end

local pinging = false

local function pingBack(ping)

  table.insert(ping_media, ping)
  if ping < 300 then color = 'green'
  elseif ping < 600 then color = 'yellow'
  else color = 'red' end
  pcolored(g_game.getWorldName() .. ' => ' .. ping .. ' ms', color)
  pingMedia()
end

function ping()
  if pinging then
    pcolored('Ping stopped.')
    g_game.setPingDelay(1000)
    disconnect(g_game, 'onPingBack', pingBack)
  else
    if not (g_game.getFeature(GameClientPing) or g_game.getFeature(GameExtendedClientPing)) then
      pcolored('this server does not support ping', 'red')
      return
    elseif not g_game.isOnline() then
      pcolored('ping command is only allowed when online', 'red')
      return
    end

    pcolored('Starting ping...')
	
    g_game.setPingDelay(0)
    connect(g_game, 'onPingBack', pingBack)
  end
  pinging = not pinging
end

function clear()
  modules.client_terminal.clear()
end

function ls(path)
  path = path or '/'
  local files = g_resources.listDirectoryFiles(path)
  for k,v in pairs(files) do
    if g_resources.directoryExists(path .. v) then
      pcolored(path .. v, 'blue')
    else
      pcolored(path .. v)
    end
  end
end

function about_version()
  pcolored(g_app.getName() .. ' ' .. g_app.getVersion() .. '\n' .. g_app.getAuthor())
end

function about_graphics()
  pcolored('Vendor ' .. g_graphics.getVendor() )
  pcolored('Renderer' .. g_graphics.getRenderer())
  pcolored('Version' .. g_graphics.getVersion())
end

function about_modules()
  for k,m in pairs(g_modules.getModules()) do
    local loadedtext
    if m:isLoaded() then
      pcolored(m:getName() .. ' => loaded', 'green')
    else
      pcolored(m:getName() .. ' => not loaded', 'red')
    end
  end
end

-- Fun��o segura para recarregar um m�dulo
function live_module_reload(name)
  if not name then
    pcolored('ERROR: missing module name', 'red')
    return
  end

  local module = g_modules.getModule(name)
  local mod = g_mods.getMod(name)

  if module then
    if not module:isReloadble() then
      pcolored('ERROR: that module is not reloadable', 'red')
      return
    end

    if not module:canReload() then
      pcolored('ERROR: some other modules require this module, cannot reload now', 'red')
      return
    end

    local files = {}
    local hasFile = false
    for _, file in pairs(g_resources.listDirectoryFiles('/' .. name)) do
      local filepath = 'modules/' .. name .. '/' .. file
      local time = g_platform.getFileModificationTime(filepath)
      if time > 0 then
        files[filepath] = time
        hasFile = true
      end
    end

    if not hasFile then
      pcolored('ERROR: unable to find any file for module', 'red')
      return
    end

    cycleEvent(function()
      for filepath, time in pairs(files) do
        local newtime = g_platform.getFileModificationTime(filepath)
        if newtime > time then
          pcolored('Reloading module: ' .. name, 'green')
          modules.client_terminal.flushLines()
          module:reload()
          files[filepath] = newtime

          if name == 'client_terminal' then
            modules.client_terminal.show()
          end
          break
        end
      end
    end, 1000)

  elseif mod then
    -- Para mods, o reload � mais direto
    pcolored('Reloading mod: ' .. name, 'green')
    mod:reload()
  else
    pcolored('ERROR: "' .. name .. '" not found in /modules or /mods', 'red')
  end
end



-- Fun��o autom�tica para recarregar TODOS os styles de /styles
function reloadAllStyles()
  local styleFiles = g_resources.listDirectoryFiles('/styles')

  for _, file in ipairs(styleFiles) do
    if file:ends('.otui') then
      local fullPath = '/styles/' .. file
      g_ui.importStyle(fullPath)
      print('[Reload] Style "' .. fullPath .. '" recarregado.')
    end
  end

  print('[Reload] Todos os styles recarregados.')
end

-- Fun��o para recarregar tudo de uma vez
function reloadAll()
  local modules = {
    'client_entergame',
    'client_gameinterface',
    'client_topmenu'
  }

  local mods = {
    'meu_mod_customizado', -- adicione aqui os mods da pasta /mods
    'outro_mod'
  }

  for _, mod in ipairs(modules) do
    liveModuleReload(mod)
  end

  for _, mod in ipairs(mods) do
    liveModuleReload(mod)
  end

  reloadAllStyles()
  print('[Reload] Tudo recarregado com sucesso.')
end


-- Opcional: atalho de teclado
g_keyboard.bindKeyPress('Ctrl+R', function()
  reloadAll()
end)

function live_module_reload(name)
  if not name then
    pcolored('ERROR: missing module name', 'red')
    return
  end
 
  local module = g_modules.getModule(name)
  if not module then
    pcolored('ERROR: unable to find module ' .. name, 'red')
    return
  end
 
  if not module:isReloadble() then
    pcolored('ERROR: that module is not reloadable', 'red')
    return
  end
 
  if not module:canReload() then
    pcolored('ERROR: some other modules requires this module, cannot reload now', 'red')
    return
  end
 
  local files = {}
  local hasFile = false
  for _,file in pairs(g_resources.listDirectoryFiles('/' .. name)) do
    local filepath = 'modules/' .. name .. '/' .. file
    local time = g_platform.getFileModificationTime(filepath)
    if time > 0 then
      files[filepath] = time
      hasFile = true
    end
  end
 
  if not hasFile then
    pcolored('ERROR: unable to find any file for module', 'red')
    return
  end
 
  cycleEvent(function()
    for filepath,time in pairs(files) do
      local newtime = g_platform.getFileModificationTime(filepath)
      if newtime > time then
        pcolored('Reloading ' .. name, 'green')
        modules.client_terminal.flushLines()
        module:reload()
        files[filepath] = newtime
        
        if name == 'client_terminal' then
          modules.client_terminal.show()
        end
        break
      end
    end
  end, 1000)
end

function live_reload_mod_or_module(name)
  if not name or name == '' then
    print('[Reload] Erro: nome vazio.')
    return
  end

  local function tryReloadModule(path)
    local files = g_resources.listDirectoryFiles('/' .. path)
    if #files == 0 then return false end

    local modified = false
    for _, file in ipairs(files) do
      local filepath = path .. '/' .. file
      local time = g_platform.getFileModificationTime(filepath)
      if time > 0 then
        modified = true
        break
      end
    end

    if modified then
      local module = g_modules.getModule(name)
      if module then
        module:reload()
        print('[Reload] M�dulo "' .. name .. '" recarregado de /' .. path .. '.')
        return true
      end
    end
    return false
  end

  if not tryReloadModule('modules/' .. name) then
    if not tryReloadModule('mods/' .. name) then
      print('[Reload] Erro: n�o foi poss�vel recarregar "' .. name .. '". Verifique se o nome est� certo.')
    end
  end
end

function autoReloadModuleOrMod(name)
  if not name or name == '' then
    print('[AutoReload] Erro: nome vazio.')
    return
  end

  local function buildFileMap(basePath)
    local fileMap = {}
    for _, file in ipairs(g_resources.listDirectoryFiles('/' .. basePath)) do
      local filepath = basePath .. '/' .. file
      local time = g_platform.getFileModificationTime(filepath)
      if time > 0 then
        fileMap[filepath] = time
      end
    end
    return fileMap
  end

  local module = g_modules.getModule(name)
  if not module then
    print('[AutoReload] Erro: m�dulo "' .. name .. '" n�o encontrado.')
    return
  end

  local path = ''
  if g_resources.directoryExists('/modules/' .. name) then
    path = 'modules/' .. name
  elseif g_resources.directoryExists('/mods/' .. name) then
    path = 'mods/' .. name
  else
    print('[AutoReload] Erro: pasta do m�dulo/mod n�o encontrada.')
    return
  end

  local files = buildFileMap(path)

  cycleEvent(function()
    for filepath, lastTime in pairs(files) do
      local newTime = g_platform.getFileModificationTime(filepath)
      if newTime > lastTime then
        print('[AutoReload] Altera��o detectada em "' .. filepath .. '". Recarregando "' .. name .. '".')
        module:reload()
        files = buildFileMap(path) -- Atualiza o mapa de arquivos
        break
      end
    end
  end, 1000) -- checa a cada 1 segundo
end
