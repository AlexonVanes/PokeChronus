-- chunkname: @/modules/game_pokebar/protocol.lua

local PokemonPokebarOpcode = 53

local function parseAction(protocol, opcode, jsonData)
	if not jsonData then return end
	
	-- Se receber uma lista (formato do servidor)
	if #jsonData > 0 then
		signalcall(PokeBar.onRemoveAllSlotBars)
		for _, pokemon in ipairs(jsonData) do
			-- Adaptar campos se necessário
			pokemon.fastcallNumber = pokemon.pokeid:gsub("!p ", "")
			signalcall(PokeBar.onAddSlotBar, pokemon)
		end
	else
		-- Caso receba um único update (formato antigo/alternativo)
		if jsonData.action == 1 then -- Add
			jsonData.data.fastcallNumber = jsonData.data.pokeid:gsub("!p ", "")
			signalcall(PokeBar.onAddSlotBar, jsonData.data)
		elseif jsonData.action == 2 then -- Remove
			signalcall(PokeBar.onRemoveSlotBar, jsonData.data)
		elseif jsonData.action == 3 then -- Update
			jsonData.data.fastcallNumber = jsonData.data.pokeid:gsub("!p ", "")
			signalcall(PokeBar.onUpdateSlotBar, jsonData.data)
		end
	end
end

function initProtocol()
	ProtocolGame.registerExtendedJSONOpcode(PokemonPokebarOpcode, parseAction)
end

function terminateProtocol()
	ProtocolGame.unregisterExtendedJSONOpcode(PokemonPokebarOpcode)
end
