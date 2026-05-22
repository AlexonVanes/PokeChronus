local OPCODE = 80
local currentHoveredWidget
pokedexWindow2, pokedexWindow = nil
local timing = os.clock()
local generated = false
local infoPokes
local pokemons = {}

function updateText(description, text, speed, startTime, index)
	local currentTime = os.clock()
	if currentTime - startTime >= 1 / speed then
		local currentText = string.sub(text, 1, index)
		description:setText(currentText)
		index = index + 1
		startTime = currentTime
	end
	if index <= #text then
		currentAnimation = scheduleEvent(function() updateText(description, text, speed, startTime, index) end)
	else
		isAnimating = false
		currentAnimation = nil
	end
end

function sendPokeBuffer(id)
	local buffer = {
		type     = "showPoke",
		pokeName = id,
	}
	g_game.getProtocolGame():sendExtendedOpcode(OPCODE, json.encode(buffer))
end

function getOpCode(protocol, opcode, json_data)
	local action = json_data['action']
	local data = json_data['data']
	local status = json_data['status']
	
	if action == "openPokedex" then
		showDex()
		generatePokedexList()
		return true
	end
	
	if not action or not data then
		return false
	end
	if action == "sendInformation" then
		showInformation(data)
	end

	if action == "lists" then
		pokemons = data
		generatePokedexList()
	end

	if action == "updateList" then
		local id = data.id
		local pokename = capitalizeFirstLetter(pokemons[id].name)
		for _, child in ipairs(pokedexWindow.panelSearch:getChildren()) do
			local childId = capitalizeFirstLetter(child:getId())
			if childId == pokename then
				child.nome:setText(pokename)
				child.nome:setColor("green")
				child.pokemonImageSearch:setOutfit({ type = pokemons[id].outfit.type })
				break
			end
		end
		pokemons[id] = { name = pokemons[id].name, found = true, outfit = { type = pokemons[id].outfit.type } }
	end
end

function capitalizeFirstLetter(word)
	if not word then
		return ""
	end
	word = string.lower(word)
	return word:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end)
end

function showInformation(data)
	local dexInfo = data.info

	local typePokemon = dexInfo.type
	local typePokemon2 = dexInfo.type2

	local entryPokemon = dexInfo.entry
	local namePokemon = dexInfo.name

	local habilidades = {
		blink = dexInfo.blink,
		teleport = dexInfo.teleport,
		dig = dexInfo.dig,
		smash = dexInfo.smash,
		cut = dexInfo.cut,
		light = dexInfo.light,
		levitate = dexInfo.levitate,
		controlmind = dexInfo.controlmind,
		fly = dexInfo.fly,
		ride = dexInfo.ride,
		surf = dexInfo.surf,
		-- headbutt =			dexInfo.headbutt,
	}

	namePokemon = namePokemon:lower()
	local funcaoPokemon = dexInfo.funcao
	if funcaoPokemon and funcaoPokemon ~= "" then
		pokedexWindow.funcao:setImageSource("new_images/funcoes/" .. funcaoPokemon)
	end

	local hasShiny = dexInfo.hasShiny
	pokedexWindow.hasShiny:setVisible(false)
	if hasShiny then
		pokedexWindow.hasShiny:setVisible(true)
		pokedexWindow.pokemonImage.onClick = function ()
			sendPokeBuffer("shiny " .. namePokemon)
		end
	elseif string.find(namePokemon, "shiny ") then
		local getShinyName = string.match(namePokemon:lower(), "shiny" .. "%s*(.+)")
		pokedexWindow.pokemonImage.onClick = function ()
			sendPokeBuffer(getShinyName)
		end
	elseif string.find(namePokemon, "mega ") then
		local getMegaName = string.match(namePokemon:lower(), "mega" .. "%s*(.+)")
		pokedexWindow.pokemonImage.onClick = function ()
			sendPokeBuffer(getMegaName)
		end
	else
		pokedexWindow.pokemonImage.onClick = nil
	end

	if typePokemon ~= "none" then
		pokedexWindow.pokemonType:setImageSource("images/types/" .. typePokemon)
		pokedexWindow.pokemonType:setTooltip(textTypes[typePokemon])
	else
		pokedexWindow.pokemonType:setImageSource("")
		pokedexWindow.pokemonType:setTooltip("")
	end

	if typePokemon2 ~= "none" then
		pokedexWindow.pokemonType2:setImageSource("images/types/" .. typePokemon2)
		pokedexWindow.pokemonType2:setTooltip(textTypes[typePokemon2])
	else
		pokedexWindow.pokemonType2:setImageSource("")
		pokedexWindow.pokemonType2:setTooltip("")
	end

	if namePokemon ~= "" then
		local nami = capitalizeFirstLetter(namePokemon)
		pokedexWindow.pokemonName:setText(nami)
	end

	pokedexWindow.pokemonImage:setOutfit({ type = dexInfo.looktype })
	pokedexWindow.pokemonImage:setOldScaling(true)
	pokedexWindow.pokemonImage:setAnimate(true)
	pokedexWindow.pokemonEntry:setText("#" .. entryPokemon)
	pokedexWindow.pokemonRank:setText(dexInfo.rank)

	local painelHabilidades = pokedexWindow.panelAbilities

	painelHabilidades:destroyChildren()
	for i, hability in pairs(habilidades) do
		if hability then
			local widget = g_ui.createWidget("abilitiesButton", painelHabilidades)
			widget:setImageSource("images/abilities/" .. i)
			widget:setTooltip(habilidadesDescription[i])
		end
	end

	local buttonsMain = pokedexWindow.buttonsPokemon
	local textButton = pokedexWindow.textButtons
	local description = buttonsMain.description
	local estatisticas = buttonsMain.estatisticas
	local efetividade = buttonsMain.efetividade
	local moves = buttonsMain.moves
	local loot = buttonsMain.loot
	local textBox = pokedexWindow.panelDesc.description

	local attack          	   = tonumber(dexInfo.attack)
	local health               = tonumber(dexInfo.health)
	local speed                = tonumber(dexInfo.speed)
	local defense      	       = tonumber(dexInfo.defense)

	local maxAttributes = {
		health = 30000,
		attack = 350,
		defense = 350,
		speed = 600
	}

	function showEstatisticas()
		pokedexWindow.healthLabel:setVisible(true)
		pokedexWindow.progressHP_base:setVisible(true)
		pokedexWindow.progressHP:setVisible(true)

		local percentHp = math.floor((health / maxAttributes.health) * 100)
		if percentHp >= 100 then percentHp = 100 end
		local rectHp = { x = 0, y = 0, width = 173 -  math.floor(173 * (1 - (percentHp / 100))) + 1, height = 18 }
		pokedexWindow.progressHP:setImageClip(rectHp)
		pokedexWindow.progressHP:setImageRect(rectHp)
		pokedexWindow.progressHP:setTooltip(tostring(health))

		pokedexWindow.defenseLabel:setVisible(true)
		pokedexWindow.progressDEF_base:setVisible(true)
		pokedexWindow.progressDEF:setVisible(true)

		local percentDef = math.floor((defense / maxAttributes.defense) * 100)
		if percentDef >= 100 then percentDef = 100 end
		local rectDef = { x = 0, y = 0, width = 173 -  math.floor(173 * (1 - (percentDef / 100))) + 1, height = 18 }
		pokedexWindow.progressDEF:setImageClip(rectDef)
		pokedexWindow.progressDEF:setImageRect(rectDef)
		pokedexWindow.progressDEF:setTooltip(tostring(defense))

		pokedexWindow.speedLabel:setVisible(true)
		pokedexWindow.progressSpeed_base:setVisible(true)
		pokedexWindow.progressSpeed:setVisible(true)

		local percentSpeed = math.floor((speed / maxAttributes.speed) * 100)
		if percentSpeed >= 100 then percentSpeed = 100 end
		local rectSpeed = { x = 0, y = 0, width = 173 -  math.floor(173 * (1 - (percentSpeed / 100))) + 1, height = 18 }
		pokedexWindow.progressSpeed:setImageClip(rectSpeed)
		pokedexWindow.progressSpeed:setImageRect(rectSpeed)
		pokedexWindow.progressSpeed:setTooltip(tostring(speed))

		pokedexWindow.attackLabel:setVisible(true)
		pokedexWindow.progressAttack_base:setVisible(true)
		pokedexWindow.progressAttack:setVisible(true)

		local percentAttack = math.floor((attack / maxAttributes.attack) * 100)
		if percentAttack >= 100 then percentAttack = 100 end
		local rectAttack = { x = 0, y = 0, width = 173 -  math.floor(173 * (1 - (percentAttack / 100))) + 1, height = 18 }
		pokedexWindow.progressAttack:setImageClip(rectAttack)
		pokedexWindow.progressAttack:setImageRect(rectAttack)
		pokedexWindow.progressAttack:setTooltip(tostring(attack))
	end

	function hideEstatisticas()
		pokedexWindow.progressHP_base:setVisible(false)
		pokedexWindow.progressHP:setVisible(false)
		pokedexWindow.healthLabel:setVisible(false)

		pokedexWindow.defenseLabel:setVisible(false)
		pokedexWindow.progressDEF_base:setVisible(false)
		pokedexWindow.progressDEF:setVisible(false)

		pokedexWindow.speedLabel:setVisible(false)
		pokedexWindow.progressSpeed_base:setVisible(false)
		pokedexWindow.progressSpeed:setVisible(false)

		pokedexWindow.attackLabel:setVisible(false)
		pokedexWindow.progressAttack_base:setVisible(false)
		pokedexWindow.progressAttack:setVisible(false)
	end

	function showDescription()
		textButton:setText("Informacoes")
		textBox:setVisible(true)
		pokedexWindow.searchBar2:setVisible(true)
		local text = ""

		-- text = text .. "Level: " .. dexInfo.level .. "\n"

		if not shiny then
			for i, evo in ipairs(dexInfo.evo) do
				if evo.name then
					local evoname = capitalizeFirstLetter(evo.name)
					local evoItemName = capitalizeFirstLetter(evo.itemName or "")
					text = text .. ""
					text = text .. "Evolucao: " .. evoname .. "\n"
					if evo.count and evoItemName ~= "" then
						text = text .. "Custo: " .. evo.count .. " " .. evoItemName .. "\n"
					end
					if evo.level then
						text = text .. "Level Minimo: " .. evo.level .. "\n"
					end
				end
			end
		end
		-- if descriptionPokemons[tonumber(entryPokemon)] then
		-- text = text .. "\n"
		-- text = text .. descriptionPokemons[tonumber(entryPokemon)]
		-- end
		textBox:setText(text)
	end

	function hideDescription()
		textButton:setText("Estatisticas")
		textBox:clearText()
		textBox:setVisible(false)
		pokedexWindow.searchBar2:setVisible(false)
	end

	-- Paineis de efetividade

	local painelEfetivo   = pokedexWindow.panelAbilities2.panelEfetivo
	local painelNormal    = pokedexWindow.panelAbilities2.panelNormal
	local painelInefetivo = pokedexWindow.panelAbilities2.panelInefetivo
	local painelImune     = pokedexWindow.panelAbilities2.panelImune

	function showEfetividade()
		textButton:setText("Efetividades")

		painelEfetivo:setVisible(true)
		painelNormal:setVisible(true)
		painelImune:setVisible(true)
		painelInefetivo:setVisible(true)

		pokedexWindow.panelAbilities2.muitoinefetivocontra:setVisible(true)
		pokedexWindow.panelAbilities2.normalcontra:setVisible(true)
		pokedexWindow.panelAbilities2.efetivocontra:setVisible(true)
		pokedexWindow.panelAbilities2.inefetivocontra:setVisible(true)
		pokedexWindow.abilitiesBar2:setVisible(true)

		pokedexWindow.panelAbilities2:setVisible(true)
		-- pokedexWindow.abilitiesBar2:setVisible(true)

		-- painel efetivo

		painelEfetivo:destroyChildren()
		if typePokemon ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon].superEffectiveAgainst) do
				local widget = g_ui.createWidget("efetividadeButtons", painelEfetivo)
				widget:setId(efetividade)
				widget:setImageSource("images/types/" .. efetividade)
				widget:setTooltip(capitalizeFirstLetter(efetividade))
			end
		end

		if typePokemon2 ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon2].superEffectiveAgainst) do
				if not painelEfetivo:getChildren(efetividade) then
					local widget = g_ui.createWidget("efetividadeButtons", painelEfetivo)
					widget:setId(efetividade)
					widget:setImageSource("images/types/" .. efetividade)
					widget:setTooltip(capitalizeFirstLetter(efetividade))
				end
			end
		end

		if #painelEfetivo:getChildren() < 13 then
			painelEfetivo:setSize("300 25")
		end

		-- painel normal

		painelNormal:destroyChildren()
		if typePokemon ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon].normalAgainst) do
				local widget = g_ui.createWidget("efetividadeButtons", painelNormal)
				widget:setId(efetividade)
				widget:setImageSource("images/types/" .. efetividade)
				widget:setTooltip(capitalizeFirstLetter(efetividade))
			end
		end

		if typePokemon2 ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon2].normalAgainst) do
				if not painelNormal:getChildren(efetividade) then
					local widget = g_ui.createWidget("efetividadeButtons", painelNormal)
					widget:setId(efetividade)
					widget:setImageSource("images/types/" .. efetividade)
					widget:setTooltip(capitalizeFirstLetter(efetividade))
				end
			end
		end

		if #painelNormal:getChildren() < 13 then
			painelNormal:setSize("300 25")
		end

		-- painel inefetivo
		painelInefetivo:destroyChildren()
		if typePokemon ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon].notVeryEffectiveAgainst) do
				local widget = g_ui.createWidget("efetividadeButtons", painelInefetivo)
				widget:setId(efetividade)
				widget:setImageSource("images/types/" .. efetividade)
				widget:setTooltip(capitalizeFirstLetter(efetividade))
			end
		end

		if typePokemon2 ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon2].notVeryEffectiveAgainst) do
				if not painelInefetivo:getChildren(efetividade) then
					local widget = g_ui.createWidget("efetividadeButtons", painelInefetivo)
					widget:setId(efetividade)
					widget:setImageSource("images/types/" .. efetividade)
					widget:setTooltip(capitalizeFirstLetter(efetividade))
				end
			end
		end

		if #painelInefetivo:getChildren() < 13 then
			painelInefetivo:setSize("300 25")
		end
		-- painel imune

		painelImune:destroyChildren()
		if typePokemon ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon].noEffectAgainst) do
				local widget = g_ui.createWidget("efetividadeButtons", painelImune)
				widget:setId(efetividade)
				widget:setImageSource("images/types/" .. efetividade)
				widget:setTooltip(capitalizeFirstLetter(efetividade))
			end
		end

		if typePokemon2 ~= "none" then
			for i, efetividade in pairs(typeEffectiveness[typePokemon2].noEffectAgainst) do
				if not painelImune:getChildren(efetividade) then
					local widget = g_ui.createWidget("efetividadeButtons", painelImune)
					widget:setId(efetividade)
					widget:setImageSource("images/types/" .. efetividade)
					widget:setTooltip(capitalizeFirstLetter(efetividade))
				end
			end
		end

		if #painelImune:getChildren() < 13 then
			painelImune:setSize("300 25")
		end

		if #painelImune:getChildren() == 0 then
			painelImune:setVisible(false)
			pokedexWindow.panelAbilities2.muitoinefetivocontra:setVisible(false)
		end

		if #painelNormal:getChildren() == 0 then
			painelNormal:setVisible(false)
			pokedexWindow.panelAbilities2.normalcontra:setVisible(false)
		end

		if #painelEfetivo:getChildren() == 0 then
			painelEfetivo:setVisible(false)
			pokedexWindow.panelAbilities2.efetivocontra:setVisible(false)
		end

		if #painelInefetivo:getChildren() == 0 then
			painelInefetivo:setVisible(false)
			pokedexWindow.panelAbilities2.inefetivocontra:setVisible(false)
		end
	end

	function hideEfetividade()
		pokedexWindow.panelAbilities2:setVisible(false)
		pokedexWindow.abilitiesBar2:setVisible(false)
		painelNormal:destroyChildren()
		painelEfetivo:destroyChildren()
		painelImune:destroyChildren()
		painelInefetivo:destroyChildren()
	end

	painelMoves = pokedexWindow.panelMoves

	function showMoves()
		painelMoves:destroyChildren()
		painelMoves:setVisible(true)
		textButton:setText("Pokemon Moves")

		for i, move in pairs(dexInfo.moves) do
			if i > 12 then break end
			local widget = g_ui.createWidget("movesButton", painelMoves)
			widget:setId(move.name)
			local path = "images/moves_icon/" .. (move.name) .. "_on.png"
			if g_resources.fileExists(path) then
				widget:setImageSource(path)
			else
				widget:setImageSource("images/moves_icon/Base")
			end
			local text = ""
			local moveName = capitalizeFirstLetter(move.name)
			text = text .. "Nome: " .. moveName .. "\n"
			text = text .. "Level: " .. move.level .. "\n"
			text = text .. "Cooldown: " .. move.cooldown .. " segundos\n"
			text = text .. (move.isTarget and "Target: Sim" or "Ranged: Sim")

			widget:setTooltip(text)
		end
	end

	function hideMoves()
		painelMoves:destroyChildren()
		painelMoves:setVisible(false)
	end

	local painelLoot = pokedexWindow.panelLoot

	function showLoot()
		painelLoot:setVisible(true)
		pokedexWindow.lootBar:setVisible(true)
		textButton:setText("Pokemon Drops")
		painelLoot:destroyChildren()

		for i, loot in pairs(dexInfo.loot) do
			local widget = g_ui.createWidget("lootButtons", painelLoot)
			widget.item:setItemId(loot.clientId)
			widget.name:setText(loot.name)
			widget.quantity:setText("1 - " .. loot.maxCount)
			widget.chance:setText(loot.chance .. " %")
		end
	end

	function hideLoot()
		painelLoot:destroyChildren()
		painelLoot:setVisible(false)
		pokedexWindow.lootBar:setVisible(false)
	end

	hideLoot()
	hideMoves()
	hideEstatisticas()
	hideEfetividade()
	showDescription()


	description.onClick = function()
		hideEstatisticas()
		hideMoves()
		hideLoot()
		hideEfetividade()

		showDescription()
	end

	efetividade.onClick = function()
		hideDescription()
		hideEstatisticas()
		hideMoves()
		hideLoot()

		showEfetividade()
	end

	estatisticas.onClick = function()
		hideDescription()
		hideMoves()
		hideLoot()
		hideEfetividade()

		showEstatisticas()
	end

	moves.onClick = function()
		hideDescription()
		hideEstatisticas()
		hideLoot()
		hideEfetividade()

		showMoves()
	end

	loot.onClick = function()
		hideDescription()
		hideEstatisticas()
		hideMoves()
		hideEfetividade()

		showLoot()
	end

	local panelSearchPokemons = pokedexWindow.panelSearch

	if not generated then
		panelSearchPokemons:destroyChildren()
		for i, pokemon in ipairs(pokemons) do
			generated = true
			local widget = g_ui.createWidget("panelSearchBase", panelSearchPokemons)
			local newid = capitalizeFirstLetter(pokemon.name)
			widget:setId(newid)
			widget.nome:setText(pokemon.name)
			widget.nome:setColor("green")
			widget.numero:setText("#" .. i)
			widget.pokemonImageSearch:setOutfit(pokemon.outfit)
			widget.pokemonImageSearch:setOldScaling(true)
			widget.pokemonImageSearch:setAnimate(false)
			widget.onClick = function()
				sendPokeBuffer(newid)
			end

			if pokemon.type and pokemon.type ~= "none" then
				widget.type:setImageSource("images/types/" .. pokemon.type)
			end

			if pokemon.type2 and pokemon.type2 ~= "none" then
				widget.type2:setImageSource("images/types/" .. pokemon.type2)
			end

			if not pokemon.found then
				pokemon.outfit.shader = "outfit_black"
				widget.pokemonImageSearch:setOutfit(pokemon.outfit)
				widget.nome:setColor("red")
			end
		end
	end

	pokedexWindow.search.onTextChange = function(widget, newText)
		newText = newText:lower()
		for i, child in ipairs(panelSearchPokemons:getChildren()) do
			local text = child:getId():lower()
			if child:getId() ~= "search" then
				child:setVisible(text:find(newText))
			end
		end
	end

	showDex()
end

function generatePokedexList()
	if not pokemons or #pokemons == 0 then
		return
	end
	
	local panelSearchPokemons = pokedexWindow.panelSearch
	panelSearchPokemons:destroyChildren()
	
	for i, pokemon in ipairs(pokemons) do
		local widget = g_ui.createWidget("panelSearchBase", panelSearchPokemons)
		local newid = capitalizeFirstLetter(pokemon.name)
		widget:setId(newid)
		widget.nome:setText(pokemon.name)
		widget.nome:setColor("green")
		widget.numero:setText("#" .. i)
		widget.pokemonImageSearch:setOutfit(pokemon.outfit)
		widget.pokemonImageSearch:setOldScaling(true)
		widget.pokemonImageSearch:setAnimate(false)
		widget.onClick = function()
			sendPokeBuffer(newid)
		end

		if pokemon.type and pokemon.type ~= "none" then
			widget.type:setImageSource("images/types/" .. pokemon.type)
		end

		if pokemon.type2 and pokemon.type2 ~= "none" then
			widget.type2:setImageSource("images/types/" .. pokemon.type2)
		end

		if not pokemon.found then
			pokemon.outfit.shader = "outfit_black"
			widget.pokemonImageSearch:setOutfit(pokemon.outfit)
			widget.nome:setColor("red")
		end
	end
	
	pokedexWindow.search.onTextChange = function(widget, newText)
		newText = newText:lower()
		for i, child in ipairs(panelSearchPokemons:getChildren()) do
			local text = child:getId():lower()
			if child:getId() ~= "search" then
				child:setVisible(text:find(newText))
			end
		end
	end
end

function showDex()
	pokedexWindow:show()
end

function hideDex()
	pokedexWindow:hide()
end

function init()
	pokedexWindow  = g_ui.loadUI('game_dex', modules.game_interface.getRootPanel())
	pokedexWindow2 = pokedexWindow:getChildById('mainDex')

	ProtocolGame.registerExtendedJSONOpcode(OPCODE, getOpCode)
	connect(g_game, {
		onGameEnd = function()
			pokedexWindow:hide()
		end,
		onGameStart = sendRequest
	})

	pokedexWindow:hide()
end

function sendRequest()
	local buffer = {
		type = "request"
	}
	g_game.getProtocolGame():sendExtendedOpcode(OPCODE, json.encode(buffer))
end

function toggle()
	if pokedexWindow:isVisible() then
		hideDex()
	else
		showDex()
	end
end

function terminate()
	ProtocolGame.unregisterExtendedJSONOpcode(OPCODE)
	pokedexWindow:destroy()
	pokedexWindow:hide()
	disconnect(g_game, {
		onGameEnd = function()
			pokedexWindow:hide()
		end
	})
end

function hide()
	pokedexWindow:hide()
end

function dump(tbl, indent)
	indent = indent or 0

	for k, v in pairs(tbl) do
		local formattedKey = tostring(k)
		local formattedValue = tostring(v)

		if type(v) == "table" then
			print(string.rep("  ", indent) .. formattedKey .. " =>")
			dump(v, indent + 1)
		else
			print(string.rep("  ", indent) .. formattedKey .. " => " .. formattedValue)
		end
	end
end

textTypes = {
    water = 
    "Os Pok�mon do tipo �gua s�o frequentemente encontrados em ambientes aqu�ticos.\n Eles t�m uma afinidade natural com a �gua e geralmente s�o bons nadadores. Alguns exemplos incluem Squirtle e Vaporeon.",
    fire = 
    "Os Pok�mon do tipo Fogo s�o conhecidos por sua chama interior.\n Eles s�o criaturas ardentes e muitas vezes vivem em �reas vulc�nicas. Charizard e Arcanine s�o exemplos not�veis desse tipo.",
    grass = 
    "Os Pok�mon do tipo Grama s�o encontrados em �reas verdes e s�o geralmente associados � natureza.\n Eles t�m habilidades bot�nicas, como o Bulbasaur, que possui uma planta em suas costas.",
    electric = 
    "Pok�mon do tipo El�trico t�m a capacidade de gerar eletricidade.\n Eles s�o conhecidos por seus ataques el�tricos, como Pikachu e Jolteon.",
    flying = 
    "Os Pok�mon do tipo Voador t�m a habilidade de voar.\n Muitos deles t�m asas e podem se mover rapidamente pelo c�u, como Pidgeot e Swellow.",
    psychic = 
    "Os Pok�mon do tipo Ps�quico possuem poderes mentais e s�o capazes de ler pensamentos e prever o futuro.\n Mewtwo e Alakazam s�o exemplos de Pok�mon Ps�quicos poderosos.",
    poison = 
    "Pok�mon do tipo Venenoso t�m veneno em seus corpos.\n Eles s�o conhecidos por seus ataques t�xicos e incluem criaturas como Arbok e Muk.",
    rock = 
    "Os Pok�mon do tipo Pedra s�o geralmente robustos e resistentes.\n Eles podem ser encontrados em cavernas e montanhas. Onix e Geodude s�o exemplos desse tipo.",
    ice = 
    "Os Pok�mon do tipo Gelo t�m afinidade com o frio e s�o frequentemente encontrados em regi�es geladas.\n Lapras e Articuno s�o exemplos not�veis.",
    fighting = 
    "Pok�mon do tipo Lutador s�o conhecidos por suas habilidades em combate corpo a corpo.\n Eles s�o fortes e �geis, como Machamp e Hitmonlee.",
    bug = 
    "Os Pok�mon do tipo Inseto s�o frequentemente pequenos e �geis, e muitas vezes t�m apar�ncia de insetos reais.\n Scyther e Pinsir s�o exemplos desse tipo.",
    ghost = 
    "Pok�mon do tipo Fantasma s�o misteriosos e muitas vezes associados a eventos sobrenaturais.\n Gengar e Haunter s�o exemplos de Pok�mon Fantasmas.",
    dragon = 
    "Os Pok�mon do tipo Drag�o s�o poderosos e lend�rios.\n Eles t�m habilidades impressionantes e s�o raros. Dragonite e Salamence s�o alguns exemplos.",
    steel = 
    "Os Pok�mon do tipo A�o s�o conhecidos por sua resist�ncia e durabilidade.\n Eles s�o frequentemente feitos de metal ou t�m uma cobertura de a�o. Exemplos incluem Steelix e Aggron.",
    dark = 
    "Os Pok�mon do tipo Noturno s�o ativos principalmente durante a noite e t�m habilidades relacionadas � escurid�o.\n Umbreon e Honchkrow s�o exemplos desse tipo.",
    fairy = 
    "Os Pok�mon do tipo Fada s�o criaturas m�gicas e encantadoras.\n Eles s�o conhecidos por sua resist�ncia a tipos como Drag�o e Lutador. Clefable e Gardevoir s�o exemplos not�veis.",
    normal = 
    "O tipo Normal � vers�til e comum, n�o tem fraquezas naturais e � resistente a ataques do tipo Fantasma.\n Eles s�o conhecidos por sua adaptabilidade e aprendem uma variedade de movimentos. Alguns exemplos incluem Snorlax, Eevee e Porygon.",
    ground = 
    "O tipo Ground (Terra) � associado a Pok�mon que vivem na terra firme e em ambientes terrestres.\n Eles s�o imunes a ataques el�tricos, t�m movimentos poderosos como Terremoto e s�o conhecidos por sua resist�ncia. Exemplos incluem Onix e Groudon.",
}

habilidadesDescription = {
    blink = "Teletransporta instantaneamente curtas dist�ncias.",
    teleport = "Teletransporta para um local espec�fico, mesmo distante.",
    dig = "Cava o solo para abrir caminho.",
    smash = "Pode destruir obst�culos que est�o obstruindo o caminho",
    cut = "Corta objetos ou vegeta��o.",
    light = "Gera luz para iluminar �reas escuras.",
    levitate = "Permite flutuar acima do ch�o.",
    controlmind = "Controla a mente de outros seres.",
    fly = "Permite voar pelos c�us.",
    ride = "Monta criaturas para se deslocar mais rapidamente.",
    surf = "Navega na �gua para atravessar corpos d'�gua.",
    -- headbutt = "Derruba pokemons de �rvores.",
}


typeEffectiveness      = {
	none = {
		superEffectiveAgainst = {},
		notVeryEffectiveAgainst = {},
		noEffectAgainst = {},
		normalAgainst = {}
	},
	physical = {
		superEffectiveAgainst = {},
		notVeryEffectiveAgainst = {},
		noEffectAgainst = {},
		normalAgainst = {}
	},
	unknown = {
		superEffectiveAgainst = {},
		notVeryEffectiveAgainst = {},
		noEffectAgainst = {},
		normalAgainst = {}
	},
	normal = {
		superEffectiveAgainst = {},
		notVeryEffectiveAgainst = { "rock", "steel" },
		noEffectAgainst = { "ghost" },
		normalAgainst = { "normal", "fire", "water", "electric", "grass", "ice", "fighting", "poison", "ground", "flying", "psychic", "bug", "dragon", "dark", "fairy" }
	},
	fire = {
		superEffectiveAgainst = { "grass", "ice", "bug", "steel" },
		notVeryEffectiveAgainst = { "fire", "water", "rock", "dragon" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "electric", "fighting", "poison", "ground", "flying", "psychic", "ghost", "dark", "fairy" }
	},
	water = {
		superEffectiveAgainst = { "fire", "ground", "rock" },
		notVeryEffectiveAgainst = { "water", "grass", "dragon" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "electric", "ice", "fighting", "poison", "flying", "psychic", "bug", "ghost", "dark", "steel", "fairy" }
	},
	electric = {
		superEffectiveAgainst = { "water", "flying" },
		notVeryEffectiveAgainst = { "electric", "grass", "dragon" },
		noEffectAgainst = { "ground" },
		normalAgainst = { "normal", "fire", "ice", "fighting", "poison", "psychic", "bug", "rock", "ghost", "dark", "steel", "fairy" }
	},
	grass = {
		superEffectiveAgainst = { "water", "ground", "rock" },
		notVeryEffectiveAgainst = { "fire", "grass", "poison", "flying", "bug", "dragon", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "electric", "ice", "fighting", "psychic", "ghost", "dark", "fairy" }
	},
	ice = {
		superEffectiveAgainst = { "grass", "ground", "flying", "dragon" },
		notVeryEffectiveAgainst = { "fire", "water", "ice", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "electric", "fighting", "poison", "psychic", "bug", "rock", "ghost", "dark", "fairy" }
	},
	fighting = {
		superEffectiveAgainst = { "normal", "ice", "rock", "dark", "steel" },
		notVeryEffectiveAgainst = { "poison", "flying", "psychic", "bug", "fairy" },
		noEffectAgainst = { "ghost" },
		normalAgainst = { "fire", "water", "electric", "grass", "fighting", "ground", "dragon" }
	},
	poison = {
		superEffectiveAgainst = { "grass", "fairy" },
		notVeryEffectiveAgainst = { "poison", "ground", "rock", "ghost" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "fire", "water", "electric", "ice", "fighting", "flying", "psychic", "bug", "dragon", "dark", "steel" }
	},
	ground = {
		superEffectiveAgainst = { "fire", "electric", "poison", "rock", "steel" },
		notVeryEffectiveAgainst = { "grass", "bug" },
		noEffectAgainst = { "flying" },
		normalAgainst = { "normal", "water", "ice", "fighting", "ground", "psychic", "ghost", "dragon", "dark", "fairy" }
	},
	flying = {
		superEffectiveAgainst = { "grass", "fighting", "bug" },
		notVeryEffectiveAgainst = { "electric", "rock", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "fire", "water", "ice", "poison", "ground", "flying", "psychic", "ghost", "dragon", "dark", "fairy" }
	},
	psychic = {
		superEffectiveAgainst = { "fighting", "poison" },
		notVeryEffectiveAgainst = { "psychic", "steel" },
		noEffectAgainst = { "dark" },
		normalAgainst = { "normal", "fire", "water", "electric", "grass", "ice", "ground", "flying", "bug", "rock", "ghost", "dragon", "fairy" }
	},
	bug = {
		superEffectiveAgainst = { "grass", "psychic", "dark" },
		notVeryEffectiveAgainst = { "fire", "fighting", "poison", "flying", "ghost", "steel", "fairy" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "water", "electric", "ice", "ground", "bug", "rock", "dragon" }
	},
	rock = {
		superEffectiveAgainst = { "fire", "ice", "flying", "bug" },
		notVeryEffectiveAgainst = { "fighting", "ground", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "water", "electric", "grass", "poison", "psychic", "rock", "ghost", "dragon", "dark", "fairy" }
	},
	ghost = {
		superEffectiveAgainst = { "psychic", "ghost" },
		notVeryEffectiveAgainst = { "dark" },
		noEffectAgainst = { "normal" },
		normalAgainst = { "fire", "water", "electric", "grass", "ice", "fighting", "poison", "ground", "flying", "bug", "rock", "dragon", "steel", "fairy" }
	},
	dragon = {
		superEffectiveAgainst = { "dragon" },
		notVeryEffectiveAgainst = { "steel" },
		noEffectAgainst = { "fairy" },
		normalAgainst = { "normal", "fire", "water", "electric", "grass", "ice", "fighting", "poison", "ground", "flying", "psychic", "bug", "rock", "ghost", "dark" }
	},
	dark = {
		superEffectiveAgainst = { "psychic", "ghost" },
		notVeryEffectiveAgainst = { "fighting", "dark", "fairy" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "fire", "water", "electric", "grass", "ice", "poison", "ground", "flying", "bug", "rock", "dragon", "steel" }
	},
	steel = {
		superEffectiveAgainst = { "ice", "rock", "fairy" },
		notVeryEffectiveAgainst = { "fire", "water", "electric", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "grass", "fighting", "poison", "ground", "flying", "psychic", "bug", "ghost", "dragon", "dark" }
	},
	fairy = {
		superEffectiveAgainst = { "fighting", "dragon", "dark" },
		notVeryEffectiveAgainst = { "fire", "poison", "steel" },
		noEffectAgainst = {},
		normalAgainst = { "normal", "water", "electric", "grass", "ice", "ground", "flying", "psychic", "bug", "rock", "ghost", "fairy" }
	}
}
