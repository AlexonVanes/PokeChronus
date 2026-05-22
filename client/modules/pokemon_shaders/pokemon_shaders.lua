mainWindow = nil
local creatureId = 0
local OPCODE = 78

local function hideMainWindow()
  if mainWindow then
    mainWindow:hide()
  end
end

function init()
  mainWindow = g_ui.loadUI("pokemon_shaders", modules.game_interface.getRootPanel())
  mainWindow:hide()
  ProtocolGame.registerExtendedJSONOpcode(OPCODE, receiveOpcode)
  connect(g_game, { onGameStart = hideMainWindow, onGameEnd = hideMainWindow})
   connect(Creature, {
	onDisappear = onDisappear,
  })
end

function terminate()
	mainWindow:hide()
    mainWindow:destroy()
	ProtocolGame.unregisterExtendedJSONOpcode(OPCODE, receiveOpcode)
	disconnect(g_game, { onGameStart = hideMainWindow, onGameEnd = hideMainWindow})
	disconnect(Creature, {onDisappear = onDisappear})
end

function onDisappear(creature)
	if creature:isLocalSummon() then
		mainWindow:hide()
	end
end

function receiveOpcode(protocol, opcode, data)
    if type(data) ~= 'table' then
        return
    end

    if data.type == "updateModule" then
        local shadersList = data.list
        local outfit = data.outfit
        if type(shadersList) ~= 'table' or not outfit or not mainWindow then
            return
        end

        local panel = mainWindow.panelShaders
    
        panel:destroyChildren()

        for id, shader in ipairs(shadersList) do
            local widget = g_ui.createWidget("baseCreature", panel)
            widget.creature:setOutfit({type = outfit, shader = shader})
            widget.creature:setOldScaling(true)
            widget.onClick = function()
                checkShader(id)
            end
        end
    end
end

function showModule()
    mainWindow:show()
end

function checkShader(shader)
        
    local buffer = {
        type = "check",
        shader = shader
    }
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE, json.encode(buffer))
end

function isLocalSummon(id)
    if id == creatureId then
        return true
    end
    return false
end

function getCreatureById(id)
	if not g_game.getLocalPlayer() or not g_game.getLocalPlayer():getPosition() then return nil end
	local spectators = g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)
	for k,v in pairs(spectators) do
		if v:getId() == id then
			return v
		end
	end
	return nil
end
