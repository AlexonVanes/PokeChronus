
function onLogin(player)
	player:forceReturnPokemonOnLogin()
	player:loginHandler()
	player:forceReturnPokemonOnLogin()
	player:migratePokeballsToBallpack()
	player:updateStoredPokemonList()
	player:sendPassData()
	addEvent(function(playerId)
		local delayedPlayer = Player(playerId)
		if delayedPlayer then
			pcall(function() delayedPlayer:sendPlayerbarVipData() end)
		end
	end, 2000, player:getId())
	addEvent(function(playerId)
		local delayedPlayer = Player(playerId)
		if delayedPlayer then
			pcall(function() delayedPlayer:sendPlayerbarVipData() end)
		end
	end, 5000, player:getId())
	return true
end
