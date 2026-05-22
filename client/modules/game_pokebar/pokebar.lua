local function getPokeTeam()
  return modules and modules.game_poketeam
end

function init()
end

function terminate()
end

function getPokemonBar()
  local pokeTeam = getPokeTeam()
  if pokeTeam and pokeTeam.getPokemonBar then
    return pokeTeam.getPokemonBar()
  end
  return nil
end

function doCallPokemon(index)
  local pokeTeam = getPokeTeam()
  if pokeTeam and pokeTeam.doCallPokemon then
    return pokeTeam.doCallPokemon(index)
  end
  return false
end
