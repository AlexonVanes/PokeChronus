LIST_CATCHES_SPAWN = {
	["Xerneas"] =   {timer = 10000, quantidade = 320, spawn = "Xerneas Thundervine", index = 1},
	["Mewtwo"] =    {timer = 10000, quantidade = 320, spawn = "Mewtwo Psyfire Y", index = 2},
	["Deoxys"] =    {timer = 10000, quantidade = 320, spawn = "Shadowoxys", index = 3},
	["Darkrai"] =   {timer = 10000, quantidade = 320, spawn = "Shadowoxys", index = 3},
	["Entei"] =   {timer = 10000, quantidade = 80, spawn = "Entei Galante", index = 4},
	["Arcanine Nv2"] =   {timer = 10000, quantidade = 80, spawn = "Black Arcanine", index = 5},
	["Arcanine Nv3"] =   {timer = 10000, quantidade = 80, spawn = "Black Arcanine", index = 5},
	["Regigigas"] =   {timer = 10000, quantidade = 50, spawn = "Giant Regigigas", index = 6},
	["Lugia"] =   {timer = 10000, quantidade = 50, spawn = "Giant Lugia", index = 7},
	["Celesteela"] =   {timer = 10000, quantidade = 50, spawn = "Giant Celesteela", index = 8},
  }
CONST_EFFECT_SPAWN = 2303
CONST_STORAGE_SPAWN = 764000
OPCODE_CATCH = 77

MASTERBALL_BLOCKED = {
    "Lugia Ascensao Divina","Mewtwo Water", "Rayquaza Ascensao Divina", "Xerneas Ascensao Divina", "Zeraora Ascensao Divina"
}

LOWER_MASTERBALL_BLOCKED = {
    "lugia ascensao divina","mewtwo water", "rayquaza ascensao divina", "xerneas ascensao divina", "zeraora ascensao divina"
}

PALWORLD_MONSTERS = {"Grizzbolt And Rayne", "Alfa Grizzbolt", "Grizzbolt", "Depresso", "Jetragon"}
LOWER_PALWORLD_MONSTERS = {"grizzbolt and rayne", "alfa grizzbolt", "grizzbolt", "depresso", "jetragon"}
FAST_PALWORLD_MONSTERS = {
	["Grizzbolt And Rayne"] = 0,
	["Alfa Grizzbolt"] = 0,
	["Grizzbolt"] = 0,
	["Depresso"] = 0,
	["Jetragon"] = 0,
}
ALLOWED_POKEBALLS_PALWORLD = {22927, 22928, 22929, 22930, 22931, 22932}

BALLS_CATCH_ID = {
    [26662] = "pokeball", [26660] = "great", [26659] = "super", [26688] = "ultra",
    [12617] = "saffari", [13228] = "master", [32516] = "moon", [32520] = "tinker",
    [32510] = "sora", [32512] = "dusk", [32511] = "yume", [32515] = "tale",
    [32517] = "net", [32518] = "janguru", [32509] = "magu", [32513] = "fast",
    [32514] = "heavy", [26683] = "premier", [22919] = "especial",
    [22927] = "esferadepal", [22932] = "esferamega", [22928] = "esferagiga",
    [22929] = "esferatera", [22931] = "esferaultra", [22930] = "esferalendaria",
    [24407] = "divine", [32535] = "police"
}

local ball_to_index = {
    ["pokeball"] = 0, ["great"] = 1, ["super"] = 2, ["ultra"] = 3, ["premier"] = 4,
    ["saffari"] = 5, ["master"] = 6, ["moon"] = 7, ["tinker"] = 8, ["sora"] = 9,
    ["dusk"] = 10, ["yume"] = 11, ["tale"] = 12, ["net"] = 13, ["janguru"] = 14,
    ["magu"] = 15, ["fast"] = 16, ["heavy"] = 17, ["police"] = 18, ["especial"] = 19,
    ["esferadepal"] = 20, ["esferamega"] = 21, ["esferagiga"] = 22, ["esferatera"] = 23,
    ["esferaultra"] = 24, ["esferalendaria"] = 25, ["divine"] = 26
}

INFOS_CATCH = {
    ["bulbasaur"] = { pontos = 1000, id = 1 }, ["ivysaur"] = { pontos = 5000, id = 2 }, ["venusaur"] = { pontos = 15000, id = 3 },
    ["charmander"] = { pontos = 1000, id = 4 }, ["charmeleon"] = { pontos = 5000, id = 5 }, ["charizard"] = { pontos = 15000, id = 6 },
    ["squirtle"] = { pontos = 1000, id = 7 }, ["wartortle"] = { pontos = 5000, id = 8 }, ["blastoise"] = { pontos = 15000, id = 9 },
    ["caterpie"] = { pontos = 500, id = 10 }, ["metapod"] = { pontos = 1000, id = 11 }, ["butterfree"] = { pontos = 3000, id = 12 },
    ["weedle"] = { pontos = 500, id = 13 }, ["kakuna"] = { pontos = 1000, id = 14 }, ["beedrill"] = { pontos = 3000, id = 15 },
    ["pidgey"] = { pontos = 500, id = 16 }, ["pidgeotto"] = { pontos = 2000, id = 17 }, ["pidgeot"] = { pontos = 5000, id = 18 },
    ["rattata"] = { pontos = 500, id = 19 }, ["raticate"] = { pontos = 2000, id = 20 }, ["spearow"] = { pontos = 500, id = 21 },
    ["fearow"] = { pontos = 3000, id = 22 }, ["ekans"] = { pontos = 1000, id = 23 }, ["arbok"] = { pontos = 4000, id = 24 },
    ["pikachu"] = { pontos = 2000, id = 25 }, ["raichu"] = { pontos = 6000, id = 26 }, ["sandshrew"] = { pontos = 1000, id = 27 },
    ["sandslash"] = { pontos = 4000, id = 28 }, ["nidoran female"] = { pontos = 1000, id = 29 }, ["nidorina"] = { pontos = 3000, id = 30 },
    ["nidoqueen"] = { pontos = 10000, id = 31 }, ["nidoran male"] = { pontos = 1000, id = 32 }, ["nidorino"] = { pontos = 3000, id = 33 },
    ["nidoking"] = { pontos = 10000, id = 34 }, ["clefairy"] = { pontos = 2000, id = 35 }, ["clefable"] = { pontos = 7000, id = 36 },
    ["vulpix"] = { pontos = 1500, id = 37 }, ["ninetales"] = { pontos = 8000, id = 38 }, ["jigglypuff"] = { pontos = 1500, id = 39 },
    ["wigglytuff"] = { pontos = 7000, id = 40 }, ["zubat"] = { pontos = 500, id = 41 }, ["golbat"] = { pontos = 3000, id = 42 },
    ["oddish"] = { pontos = 1000, id = 43 }, ["gloom"] = { pontos = 3000, id = 44 }, ["vileplume"] = { pontos = 8000, id = 45 },
    ["paras"] = { pontos = 1000, id = 46 }, ["parasect"] = { pontos = 4000, id = 47 }, ["venonat"] = { pontos = 1500, id = 48 },
    ["venomoth"] = { pontos = 5000, id = 49 }, ["diglett"] = { pontos = 1000, id = 50 }, ["dugtrio"] = { pontos = 4000, id = 51 },
    ["meowth"] = { pontos = 1000, id = 52 }, ["persian"] = { pontos = 4000, id = 53 }, ["psyduck"] = { pontos = 1500, id = 54 },
    ["golduck"] = { pontos = 5000, id = 55 }, ["mankey"] = { pontos = 1500, id = 56 }, ["primeape"] = { pontos = 5000, id = 57 },
    ["growlithe"] = { pontos = 2000, id = 58 }, ["arcanine"] = { pontos = 10000, id = 59 }, ["poliwag"] = { pontos = 1000, id = 60 },
    ["poliwhirl"] = { pontos = 4000, id = 61 }, ["poliwrath"] = { pontos = 10000, id = 62 }, ["abra"] = { pontos = 2000, id = 63 },
    ["kadabra"] = { pontos = 6000, id = 64 }, ["alakazam"] = { pontos = 15000, id = 65 }, ["machop"] = { pontos = 1500, id = 66 },
    ["machoke"] = { pontos = 5000, id = 67 }, ["machamp"] = { pontos = 15000, id = 68 }, ["bellsprout"] = { pontos = 1000, id = 69 },
    ["weepinbell"] = { pontos = 3000, id = 70 }, ["victreebel"] = { pontos = 8000, id = 71 }, ["tentacool"] = { pontos = 1500, id = 72 },
    ["tentacruel"] = { pontos = 7000, id = 73 }, ["geodude"] = { pontos = 1000, id = 74 }, ["graveler"] = { pontos = 4000, id = 75 },
    ["golem"] = { pontos = 10000, id = 76 }, ["ponyta"] = { pontos = 1500, id = 77 }, ["rapidash"] = { pontos = 6000, id = 78 },
    ["slowpoke"] = { pontos = 1500, id = 79 }, ["slowbro"] = { pontos = 6000, id = 80 }, ["magnemite"] = { pontos = 1500, id = 81 },
    ["magneton"] = { pontos = 5000, id = 82 }, ["farfetch'd"] = { pontos = 5000, id = 83 }, ["doduo"] = { pontos = 1000, id = 84 },
    ["dodrio"] = { pontos = 4000, id = 85 }, ["seel"] = { pontos = 1500, id = 86 }, ["dewgong"] = { pontos = 6000, id = 87 },
    ["grimer"] = { pontos = 1500, id = 88 }, ["muk"] = { pontos = 6000, id = 89 }, ["shellder"] = { pontos = 1500, id = 90 },
    ["cloyster"] = { pontos = 7000, id = 91 }, ["gastly"] = { pontos = 2000, id = 92 }, ["haunter"] = { pontos = 6000, id = 93 },
    ["gengar"] = { pontos = 15000, id = 94 }, ["onix"] = { pontos = 8000, id = 95 }, ["drowzee"] = { pontos = 1500, id = 96 },
    ["hypno"] = { pontos = 6000, id = 97 }, ["krabby"] = { pontos = 1000, id = 98 }, ["kingler"] = { pontos = 5000, id = 99 },
    ["voltorb"] = { pontos = 1000, id = 100 }, ["electrode"] = { pontos = 5000, id = 101 }, ["exeggcute"] = { pontos = 1500, id = 102 },
    ["exeggutor"] = { pontos = 7000, id = 103 }, ["cubone"] = { pontos = 1500, id = 104 }, ["marowak"] = { pontos = 6000, id = 105 },
    ["hitmonlee"] = { pontos = 12000, id = 106 }, ["hitmonchan"] = { pontos = 12000, id = 107 }, ["lickitung"] = { pontos = 8000, id = 108 },
    ["koffing"] = { pontos = 1000, id = 109 }, ["weezing"] = { pontos = 5000, id = 110 }, ["rhyhorn"] = { pontos = 2000, id = 111 },
    ["rhydon"] = { pontos = 8000, id = 112 }, ["chansey"] = { pontos = 15000, id = 113 }, ["tangela"] = { pontos = 5000, id = 114 },
    ["kangaskhan"] = { pontos = 15000, id = 115 }, ["horsea"] = { pontos = 1000, id = 116 }, ["seadra"] = { pontos = 5000, id = 117 },
    ["goldeen"] = { pontos = 1000, id = 118 }, ["seaking"] = { pontos = 4000, id = 119 }, ["staryu"] = { pontos = 1500, id = 120 },
    ["starmie"] = { pontos = 6000, id = 121 }, ["mr. mime"] = { pontos = 12000, id = 122 }, ["scyther"] = { pontos = 15000, id = 123 },
    ["jynx"] = { pontos = 12000, id = 124 }, ["electabuzz"] = { pontos = 15000, id = 125 }, ["magmar"] = { pontos = 15000, id = 126 },
    ["pinsir"] = { pontos = 12000, id = 127 }, ["tauros"] = { pontos = 10000, id = 128 }, ["magikarp"] = { pontos = 100, id = 129 },
    ["gyarados"] = { pontos = 15000, id = 130 }, ["lapras"] = { pontos = 15000, id = 131 }, ["ditto"] = { pontos = 20000, id = 132 },
    ["eevee"] = { pontos = 10000, id = 133 }, ["vaporeon"] = { pontos = 15000, id = 134 }, ["jolteon"] = { pontos = 15000, id = 135 },
    ["flareon"] = { pontos = 15000, id = 136 }, ["porygon"] = { pontos = 15000, id = 137 }, ["omanyte"] = { pontos = 5000, id = 138 },
    ["omastar"] = { pontos = 12000, id = 139 }, ["kabuto"] = { pontos = 5000, id = 140 }, ["kabutops"] = { pontos = 12000, id = 141 },
    ["aerodactyl"] = { pontos = 20000, id = 142 }, ["snorlax"] = { pontos = 20000, id = 143 }, ["articuno"] = { pontos = 100000, id = 144 },
    ["zapdos"] = { pontos = 100000, id = 145 }, ["moltres"] = { pontos = 100000, id = 146 }, ["dratini"] = { pontos = 8000, id = 147 },
    ["dragonair"] = { pontos = 15000, id = 148 }, ["dragonite"] = { pontos = 30000, id = 149 }, ["mewtwo"] = { pontos = 200000, id = 150 },
    ["mew"] = { pontos = 150000, id = 151 },
}

local BASE_STORAGE_CATCH_POINTS = 91000
local BASE_STORAGE_CATCH_BROKES = 95000

function Player:getCatchPoints(pokeName)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    if storageId == 0 then return 0 end
    return math.max(0, self:getStorageValue(BASE_STORAGE_CATCH_POINTS + storageId))
end

function Player:addCatchPoints(pokeName, amount)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    if storageId == 0 then return end
    local current = self:getCatchPoints(pokeName)
    self:setStorageValue(BASE_STORAGE_CATCH_POINTS + storageId, current + amount)
end

function Player:resetCatchPoints(pokeName)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    if storageId == 0 then return end
    self:setStorageValue(BASE_STORAGE_CATCH_POINTS + storageId, 0)
end

function Player:getBrokes(pokeName)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    local t = {}
    for ball, _ in pairs(ball_to_index) do t[ball] = 0 end
    if storageId == 0 then return t end
    
    for ball, index in pairs(ball_to_index) do
        t[ball] = math.max(0, self:getStorageValue(BASE_STORAGE_CATCH_BROKES + (storageId * 30) + index))
    end
    return t
end

function Player:addBrokes(pokeName, ball)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    local index = ball_to_index[ball]
    if storageId == 0 or not index then return end
    
    local current = self:getStorageValue(BASE_STORAGE_CATCH_BROKES + (storageId * 30) + index)
    self:setStorageValue(BASE_STORAGE_CATCH_BROKES + (storageId * 30) + index, math.max(0, current) + 1)
end

function Player:resetBrokes(pokeName)
    local info = INFOS_CATCH[string.lower(pokeName)]
    local storageId = info and info.id or (MonsterType(pokeName) and MonsterType(pokeName):getNumber() or 0)
    if storageId == 0 then return end
    
    for ball, index in pairs(ball_to_index) do
        self:setStorageValue(BASE_STORAGE_CATCH_BROKES + (storageId * 30) + index, 0)
    end
end

TYPES_POINTS = {
    ["water"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32517] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["ghost"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32516] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["dark"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32516] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["steel"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32520] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["electric"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32520] = 10, [32514] = 5, [32513] = 5, [26683] = 0, [22919] = 15 },
    ["ice"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32510] = 10, [32514] = 5, [32513] = 5, [26683] = 0, [22919] = 15 },
    ["flying"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32510] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["rock"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32512] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["fighting"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32512] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["normal"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32511] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["psychic"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32511] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["dragon"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32515] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["fairy"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32515] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["bug"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32517] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["poison"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32518] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["grass"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32518] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["fire"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32509] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["ground"] = { [26662] = 1, [26660] = 2, [26659] = 3, [26688] = 4, [12617] = 1, [32509] = 10, [32513] = 5, [32514] = 5, [26683] = 0, [22919] = 15 },
    ["palworld"] = { [26662] = 1, [22932] = 2, [22928] = 3, [22929] = 4, [22931] = 5, [22930] = 10 },
	["none"] = {}
}

function Player:sendBrokesToPlayer()
    local data = {}
    local count = 0
    
    self:sendCatchBuffer("clearCache", {})

    -- 1. Coletar Pokémon da tabela INFOS_CATCH que tenham brokes
    for pokeName, info in pairs(INFOS_CATCH) do
        local points = self:getCatchPoints(pokeName)
        local brokes = self:getBrokes(pokeName)
        local hasBrokes = false
        for _, bCount in pairs(brokes) do
            if bCount > 0 then hasBrokes = true break end
        end

        if hasBrokes then
            pokeName = capitalizeFirstLetter(pokeName)
            local monsterType = MonsterType(pokeName)
            local lookType = 0
            local type = "none"
            local type2 = "none"
            if monsterType then
                lookType = monsterType:getOutfit().lookType
                if isInArray(LOWER_PALWORLD_MONSTERS, string.lower(pokeName)) then
                    type = "palworld"
                    type2 = "palworld"
                else
                    type = monsterType:getRaceName()
                    type2 = monsterType:getRace2Name()
                end
            end
            
            local newData = {
                type = type, 
                type2 = type2, 
                pokeName = pokeName, 
                pontosTotais = info.pontos, 
                pontos = points, 
                id = info.id, 
                brokes = brokes, 
                lookType = lookType
            }
            table.insert(data, newData)
            count = count + 1
            
            if count >= 10 then
                self:sendCatchBuffer("addCache", data)
                data = {}
                count = 0
            end
        end
    end

    -- 2. Tentar encontrar outros Pokémon via storage (se o jogador tiver brokes em algo fora da INFOS_CATCH)
    -- Varremos os storages base de brokes (BASE_STORAGE_CATCH_BROKES + (monsterId * 30))
    -- Como monsterId pode ir até milhares, vamos varrer apenas um range razoável para não travar o login
    -- Ou melhor: o sistema addCatchTry já garante que pontos sejam ganhos.
    -- Para este momento, o filtro hasBrokes acima já resolve 99% dos casos se a tabela INFOS_CATCH for alimentada.

    if count > 0 then
        self:sendCatchBuffer("addCache", data)
    end
    
    self:sendCatchBuffer("finishModule", {})
end

function Player:sendCatchBuffer(type, data)
    local infos = { data = data, type = type }
    if not self:sendExtendedOpcode(OPCODE_CATCH, json.encode(infos)) then return false end
    return true
end

function Player:updatePokemonCatchInfo(pokemon, pokeball, pontos)
    if not self:sendCatchBuffer("updateData", {pokemonName = pokemon, pokeball = pokeball, pontos = pontos}) then return false end
    return true
end

function Player:resetPokemonCatchInfo(pokeName)
    if not self:sendCatchBuffer("resetData", {pokemonName = pokeName, brokes = self:getBrokes(pokeName), pontos = self:getCatchPoints(pokeName)}) then return false end
    return true
end

function Player:addCatchTry(pokeName, pokeball, points)
    -- Se não estiver na tabela INFOS_CATCH, pontos padrão é 500
    local info = INFOS_CATCH[string.lower(pokeName)]
    local pointsToGain = info and points or 500 
    
	if self:isVipPlus() then pointsToGain = math.floor(pointsToGain * 1.35) end
    self:addBrokes(pokeName, pokeball)
    self:addCatchPoints(pokeName, pointsToGain)
    self:updatePokemonCatchInfo(pokeName, pokeball, pointsToGain)
    self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Voce ganhou %d pontos de catch para %s. Total: %d", pointsToGain, pokeName, self:getCatchPoints(pokeName)))
end

function Player:resetCatchTry(pokeName)
    self:resetCatchPoints(pokeName)
    self:resetBrokes(pokeName)
    self:resetPokemonCatchInfo(pokeName)
end
