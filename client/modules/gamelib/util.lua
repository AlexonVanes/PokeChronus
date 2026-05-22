function postostring(pos)
  return pos.x .. " " .. pos.y .. " " .. pos.z
end

function dirtostring(dir)
  for k,v in pairs(Directions) do
    if v == dir then
      return k
    end
  end
end

function getHealthColor(health)
	return health < 9 and "#AB2F2FFA" or health < 31 and "#DF6E56" or health < 61 and "#D7CB60EB" or "#23B266"
end

function isShinyName(pokemonName)
	if not pokemonName then return false end
	return string.find(pokemonName:lower(), "shiny") ~= nil
end

function getPokemonName(pokemonName)
	if not pokemonName then return pokemonName end
	local clean = pokemonName:match("[sS]hiny%s*(.+)")
	return clean or pokemonName
end

function capitalizeWords(text)
	if not text then return text end
	return text:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
end

function getPokemonImage(pokemonName)
  if not pokemonName then
    return "/data/images/game/portrait/abra"
  end

  local name = pokemonName:lower()

  local fullPath = "/data/images/game/portrait/" .. name
  if g_resources.fileExists(fullPath .. ".png") then
    return fullPath
  end

  local cleanName = getPokemonName(name):lower()
  local fallback = "/data/images/game/portrait/" .. cleanName
  if g_resources.fileExists(fallback .. ".png") then
    return fallback
  end

  return "/data/images/game/portrait/abra"
end

function getPokemonPortrait(pokemonName)
	return getPokemonImage(pokemonName)
end
