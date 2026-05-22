local WEB_API = "http://localhost/spectating.php"
local THUMB_TIME = 2 * 60 * 1000

local OPCODE = 114

local window = nil
local host = nil
local stop = nil
local spectateInfo = nil

local protocolGame = nil
isHosting = false
isSpectating = false
local lastFetchTime = 0

local function canUseWebApi()
  return type(WEB_API) == "string" and (
    WEB_API:match("^https?://localhost/") or
    WEB_API:match("^https?://127%.0%.0%.1/")
  )
end

function init()
  connect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )

  ProtocolGame.registerOpcode(GameServerOpcodes.GameServerSpectate, onStartSpectate)
  ProtocolGame.registerCallback(0x2, onCallback)
  ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)

  if g_game.isOnline() then
    create()
  end
end

function terminate()
  disconnect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )

  ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerSpectate)
  ProtocolGame.unregisterCallback(0x2, onCallback)
  ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)

  destroy()
end



function create()
  if window then
    return
  end

  window = g_ui.displayUI("spectate")
  window:hide()

  host = g_ui.displayUI("host")
  host:hide()

  stop = g_ui.loadUI("stop", modules.game_interface.getRootPanel())
  stop:hide() 

  spectateInfo = g_ui.loadUI("spectateInfo", modules.game_interface.getRootPanel())
  spectateInfo:hide()

  protocolGame = g_game.getProtocolGame()
end

function destroy()
  isHosting = false
  isSpectating = false
  lastFetchTime = 0

  if window then
    window:destroy()
    window = nil
  end

  if host then
    host:destroy()
    host = nil
  end

  if stop then
    stop:destroy()
    stop = nil
  end

  if spectateInfo then
    spectateInfo:destroy()
    spectateInfo = nil
  end
end

function onExtendedOpcode(protocol, code, buffer)
  local json_status, json_data =
    pcall(
    function()
      return json.decode(buffer)
    end
  )

  if not json_status or type(json_data) ~= "table" then
    g_logger.error("[Spectate] JSON error")
    return false
  end

  local action = json_data.action
  local data = json_data.data

  if action == "show" then
    show(data)
  elseif action == "hosting" then
    onStartHosting()
  elseif action == "stopHosting" then
    onStopHosting()
  elseif action == "hosterData" then
    updateHosterData(data)
  end
end

--[[[
  local hostData = {
    name = target:getName(),
    description = Hosts[cid].description,
    pokeballs = Hosts[cid].pokeballs,
    viewers = Hosts[cid].viewers,
  }
]]

function updateHosterData(data)
  if type(data) ~= "table" or type(data.pokeballs) ~= "table" then
    return
  end

  local hosterName = data.name
  local hosterDescription = data.description
  local hosterPokeballs = data.pokeballs
  local hosterViewers = tonumber(data.viewers) or 0
 
  spectateInfo.viewers:setText(("Viewers: %d"):format(hosterViewers))
  spectateInfo.pokemons:destroyChildren()
  for id, pokemon in ipairs(hosterPokeballs) do
    if type(pokemon) ~= "table" or not pokemon.lookType then
      return
    end

    local widget = g_ui.createWidget("PokemonHost", spectateInfo.pokemons)
    widget:setId(tostring(pokemon.name or id))
    widget.pokeImage:setOutfit({type = pokemon.lookType})
    widget.pokeImage:setTooltip(tostring(pokemon.name or ""))
  end
end

function onStartHosting()
  isHosting = true
  stop.stop.onClick = function()
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "stopHost"}))
  end
  stop:show()
  doScreenshot()
end

function onStopHosting()
  isHosting = false
  stop:hide()
  hide()
end

function showHosting()
  if isHosting then
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "stopHost"}))
    hide()
    return
  end

  host.description:setText("")
  host.password:setText("")
  host:raise()
  host:show()
end

function confirmHost()
  local description = host.description:getText()
  local password = host.password:getText()
  if password:len() == 0 then
    password = nil
  end
  host:hide()
  window:hide()

  protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "host", data = {description = description, password = password}}))
end

function cancelHost()
  host:hide()
end

function doScreenshot()
  if not isHosting then
    return
  end

  g_app.doMapScreenshot("cast.png")
  scheduleEvent(
    function()
      local file = g_resources.getWriteDir() .. "cast.png"
      if not canUseWebApi() then
        return
      end

      local f = io.open(file, "rb")
      if not f then
        return
      end

      local screenData = f:read("*all")
      f:close()
      HTTP.post(WEB_API .. "?new=" .. g_game.getCharacterName():gsub(" ", "%%20"), screenData)
    end,
    500
  )

  scheduleEvent(doScreenshot, THUMB_TIME)
end

function onCallback(protocol, msg)
  local movementBlocked = msg:getU8()
  local localPlayer = g_game.getLocalPlayer()
  if movementBlocked == 1 then
    localPlayer:setCanWalk(false)
  else
    localPlayer:setCanWalk(true)
  end
end

function onStartSpectate(protocol, msg)
  local start = msg:getU8()
  local creature = g_map.getCreatureById(msg:getU32())
  if start == 1 then
    isSpectating = true
    spectateInfo.stop.onClick = function()
      protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "stopSpectate"}))
    end
    spectateInfo:show()
  else
    spectateInfo:hide()
    isSpectating = false
  end
  if creature then
    modules.game_interface.getMapPanel():followCreature(creature)
  end
  hide()
end

function show(data)
  if type(data) ~= "table" then
    return
  end

  if lastFetchTime + (THUMB_TIME / 1000) < os.time() then
    lastFetchTime = os.time()
  end

  window.hosts:destroyChildren()
  for _, host in ipairs(data) do
    if type(host) ~= "table" or type(host.name) ~= "string" then
      return
    end

    local widget = g_ui.createWidget("HostPanel", window.hosts)
    local url = WEB_API .. "?name=" .. host.name:gsub(" ", "%%20") .. "&cache=" .. lastFetchTime
    HTTP.downloadImage(
      url,
      function(path, err)
        if err then
          g_logger.warning("HTTP error: " .. err .. " - " .. url)
          return
        end

        widget.thumb:setImageSource(path)
      end
    )
    widget:setId(host.name)
    widget.name:setText(host.name)
    widget.desc:setText(tostring(host.description or ""))
    widget.viewers:setText(tostring(host.viewers or 0))
    widget.pass:setVisible(host.password and true or false)
    widget.passBack:setVisible(host.password and true or false)
    widget.onClick = startSpectating
  end
  window:show()

  window.hostBtn:setText(isHosting and "Stop Hosting" or "Start Hosting")
end

function startSpectating(button)
  if button.pass:isVisible() then
    modules.client_textedit.show(
      "",
      {
        title = "Password",
        description = "Enter password to spectate this player",
        width = 280
      },
      function(password)
        protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "spectate", data = {name = button:getId(), password = password}}))
      end
    )
  else
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "spectate", data = {name = button:getId()}}))
  end
end

function hideProtected(widget)
  local checked = widget:isChecked()
  if checked then
    for _, host in pairs(window.hosts:getChildren()) do
      host:setVisible(true)
    end
  else
    for _, host in pairs(window.hosts:getChildren()) do
      host:setVisible(not host.pass:isVisible())
    end
  end
  widget:setChecked(not checked)
end

function kickPlayer(name)
  protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "kick", data = name}))
end

function banPlayer(name)
  protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "ban", data = name}))
end

function hide()
  if window then
    window:hide()
  end
end
