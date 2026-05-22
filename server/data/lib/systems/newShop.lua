OPCODE_NEW_SHOP = 87

SHOP_DATA = {}
local EASTER_SHOP_ACTIVE = true
local EASTER_CATEGORY_NAME = "EVENTOS"
local EASTER_CATEGORY_INFO = {icon = "assets/categories/icon_pascoa", size = '34 34', iconOffet = {x = 8, y = 8}}

local function hasValue(list, value)
    if type(list) ~= "table" then
        return false
    end

    for _, entry in ipairs(list) do
        if entry == value then
            return true
        end
    end

    return false
end

SHOP_DATA.ORDEM = {
    [1] = "ITEMS",
    [2] = "POKEBALLS",
    [3] = "OUTFITS",
    [4] = "POKEMONS",
    [5] = "PACKS",
    [6] = "ASSINATURA",
    [7] = "AURAS",
    [8] = "WINGS",
    [9] = "SHADERS",
    [10] = "EVENTOS",
}

SHOP_DATA.STYLES = {
    ["outfit"] = "baseOutfit",
    ["item"] = "baseItem",
    ["pokemon"] = "basePokemon",
    ["pack"] = "basePack",
    ["shader"] = "baseOutfit",
    ["wings"] = "baseOutfit",
    ["aura"] = "baseOutfit"
}

SHOP_DATA.CATEGORYINFO = {
    ["ITEMS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["POKEBALLS"] = {icon = "assets/categories/icon_pokeballs", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["OUTFITS"] = {icon = "assets/categories/icon_outfit", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["POKEMONS"] = {icon = "assets/categories/icon_pokemon", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["PACKS"] = {icon = "assets/categories/icon_packs", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["ASSINATURA"] = {icon = "assets/categories/icon_clube", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["AURAS"] = {icon = "assets/categories/icon_aura", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["WINGS"] = {icon = "assets/categories/icon_wings", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["SHADERS"] = {icon = "assets/categories/icon_outfit", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["EVENTOS"] = {icon = "assets/categories/icon_pascoa", size = '34 34', iconOffet = {x = 8, y = 8}},
}

SHOP_DATA.CATEGORY = {
    ["ITEMS"] = {
        {type = "item", valor = 10, moeda = 27635, item = {id = 27634, qtd = 1, name = "Bicycle"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 10, moeda = 27635, item = {id = 40608, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 10, moeda = 27635, item = {id = 40609, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 10, moeda = 27635, item = {id = 40610, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
    },
    ["POKEBALLS"] = {
        {type = "item", valor = 5, moeda = 27635, item = {id = 26683, qtd = 50, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 8, moeda = 27635, item = {id = 26683, qtd = 100, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 35, moeda = 27635, item = {id = 26683, qtd = 500, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 60, moeda = 27635, item = {id = 26683, qtd = 1000, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
    },
    ["OUTFITS"] = {
		{type = "outfit", valor = 15, moeda = 27635, name = "Minecraftx", lookType = {type = 3138}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 15, moeda = 27635, name = "Sir Mario", lookType = {type = 3300}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 15, moeda = 27635, name = "Sir Luigi", lookType = {type = 3299}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Bender", lookType = {type = 3297}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Zang", lookType = {type = 2937}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Mega Man", lookType = {type = 2938}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Squirtle", lookType = {type = 2961}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Bulbasaur", lookType = {type = 2962}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Brown", lookType = {type = 2963}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Sceptile", lookType = {type = 2964}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Chikorita", lookType = {type = 2965}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Torchic", lookType = {type = 2966}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Kacleon", lookType = {type = 2967}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Totodile", lookType = {type = 2968}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Chimchar", lookType = {type = 2969}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Poliwag", lookType = {type = 2970}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Tortwig", lookType = {type = 2971}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Tepig", lookType = {type = 2972}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Crossplay Oshawott", lookType = {type = 2973}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Cossplay Sh Zard", lookType = {type = 2904}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Cossplay Mewtwo", lookType = {type = 2614}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Billy", lookType = {type = 2739}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "A Freira", lookType = {type = 2745}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Lily Fox", lookType = {type = 2747}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Gilbert", lookType = {type = 2748}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Freddy", lookType = {type = 2749}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Pikachu Trainer", lookType = {type = 2756}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Eevee Trainer", lookType = {type = 2757}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Heloyse", lookType = {type = 2775}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Emily", lookType = {type = 2776}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Rose", lookType = {type = 2784}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Josephine", lookType = {type = 2785}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Victor", lookType = {type = 2786}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Lyra", lookType = {type = 2787}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "James", lookType = {type = 2788}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Elyse", lookType = {type = 2789}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Gerald", lookType = {type = 2790}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Guardian Zard", lookType = {type = 2600}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 27635, name = "Arca Talles", lookType = {type = 2602}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
    ["POKEMONS"] = {
		{type = "pokemon", valor = 15, moeda = 27635, pokeName = "Ditto", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 200, moeda = 27635, pokeName = "Shiny Ditto", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
    ["PACKS"] = {
        {type = "pack", valor = 10, moeda = 27635, 
            items = {
                {type = "pokemon", pokeName = "Pack Inicial"},
                {type = "item", id = 26688, qtd = 250}, -- ultraball
                {type = "item", id = 27645, qtd = 200}, --revive
                {type = "item", id = 27641, qtd = 100}, --ultra potion
                {type = "item", id = 27647, qtd = 100}, -- hyper potion
                {type = "item", id = 26662, qtd = 250}, --pokeball
                {type = "item", id = 26659, qtd = 250}, --superball
	            {type = "item", id = 26660, qtd = 250}, --greatball
                {type = "item", id = 27642, qtd = 100}, --small potion
                {type = "item", id = 27641, qtd = 100}, --ultra potion
                {type = "item", id = 27647, qtd = 100}, -- hyper potion
            },
            name = "Pack Inicial",
            description = "Dê um boost para sua jornada!\nNesse pack contem:\n250x Pokeballs.\n250x Superballs.\n250x Greatballs.\n250x Ultraballs.\n250x Revives.\n100x Small Potions.\n100x Ultra Potions.\n100x Hyper potions.",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 400, moeda = 23498, 
            items = {
                {type = "pokemon", pokeName = "Arceus Divindade Lunar"},
                {type = "item", id = 26183, qtd = 1},
                {type = "item", id = 25642, qtd = 25},
                {type = "item", id = 20708, qtd = 25},
                {type = "item", id = 20669, qtd = 10},
                {type = "item", id = 22664, qtd = 1},
                {type = "item", id = 24837, qtd = 10},
                {type = "item", id = 25658, qtd = 5}
            },
            name = "Pack Arceus Divindade Lunar",
            description = "Pack Arceus Divindade Lunar",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 650, moeda = 23498, 
            items = {
                {type = "pokemon", pokeName = "Volcanion Dragao de Jade"},
                {type = "item", id = 2145, qtd = 10000},
                {type = "item", id = 20669, qtd = 15},
                {type = "item", id = 22885, qtd = 5},
                {type = "item", id = 22897, qtd = 5},
                {type = "item", id = 25588, qtd = 1},
                {type = "item", id = 26287, qtd = 5},
                {type = "item", id = 25658, qtd = 10},
                {type = "item", id = 20708, qtd = 25}
            },
            name = "Pack Volcanion Dragao de Jade",
            description = "Pack Volcanion Dragao de Jade",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 900, moeda = 23498, 
            items = {
                {type = "pokemon", pokeName = "Necrozma Selo Dourado"},
                {type = "item", id = 26170, qtd = 8},
                {type = "item", id = 26627, qtd = 1},
                {type = "item", id = 16361, qtd = 20},
                {type = "item", id = 20669, qtd = 20},
                {type = "item", id = 26288, qtd = 3},
                {type = "item", id = 25574, qtd = 100},
                {type = "item", id = 25658, qtd = 15},
                {type = "item", id = 20708, qtd = 40}   
            },
            name = "Pack Necrozma Selo Dourado",
            description = "Pack Necrozma Selo Dourado",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 1100, moeda = 23498, 
            items = {
                {type = "pokemon", pokeName = "Eternatus Colosso Solar"},
                {type = "item", id = 26170, qtd = 20},
                {type = "item", id = 26628, qtd = 1},
                {type = "item", id = 16361, qtd = 50},
                {type = "item", id = 20669, qtd = 50},
                {type = "item", id = 26289, qtd = 5},
                {type = "item", id = 25574, qtd = 250},
                {type = "item", id = 26673, qtd = 1},
                {type = "item", id = 20708, qtd = 50}
            },
            name = "Pack Eternatus Colosso Solar",
            description = "Pack Eternatus Colosso Solar",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "64 64"
        },
        {type = "pack", valor = 1800, moeda = 23498, 
            items = {
                {type = "pokemon", pokeName = "Regigigas Imperador Ancestral"},
                {type = "item", id = 26170, qtd = 50},
                {type = "item", id = 26629, qtd = 1},
                {type = "item", id = 16361, qtd = 100},
                {type = "item", id = 20669, qtd = 100},
                {type = "item", id = 26642, qtd = 5},
                {type = "item", id = 25574, qtd = 250},
                {type = "item", id = 26673, qtd = 3},
                {type = "item", id = 20708, qtd = 50}
            },
            name = "Pack Regigigas Imperador Ancestral",
            description = "Pack Regigigas Imperador Ancestral",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "64 64"
        },
        {type = "pack", valor = 50, moeda = 23498, 
            items = {
                {type = "item", id = 26710, qtd = 3},
                {type = "item", id = 26711, qtd = 5},
                {type = "item", id = 26712, qtd = 3},
                {type = "item", id = 26717, qtd = 4},
                {type = "item", id = 26770, qtd = 1}
            },
            displayItems = {26713, 26714, 26715, 26716, 26770},
            name = "Pack Banners I",
            description = "3x Banner Spawn I, 5x Banner XP I, 3x Banner Loot I, 4x Banner Captura I",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 80, moeda = 23498, 
            items = {
                {type = "item", id = 26718, qtd = 5},
                {type = "item", id = 26724, qtd = 3},
                {type = "item", id = 26722, qtd = 3},
                {type = "item", id = 26720, qtd = 4},
                {type = "item", id = 26771, qtd = 1}
            },
            displayItems = {26726, 26732, 26730, 26728, 26771},
            name = "Pack Banners II",
            description = "5x Banner XP II, 3x Banner Spawn II, 3x Banner Loot II, 4x Banner Captura II",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 120, moeda = 23498, 
            items = {
                {type = "item", id = 26719, qtd = 5},
                {type = "item", id = 26725, qtd = 5},
                {type = "item", id = 26772, qtd = 5},
                {type = "item", id = 26723, qtd = 5},
                {type = "item", id = 26772, qtd = 5}
            },
            displayItems = {26727, 26733, 26729, 26731, 26769},
            name = "Pack Banners III",
            description = "5x Banner XP III, 5x Banner Spawn III, 5x Banner Captura III, 5x Banner Loot III, 5x Banner Pesca III",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },
        {type = "pack", valor = 25, moeda = 26946, 
            items = {
                {type = "item", id = 26950, qtd = 5},
                {type = "item", id = 26951, qtd = 5},
                {type = "item", id = 26955, qtd = 5},
            },
            displayItems = {26953, 26952, 26954},
            name = "Pack Banners IV",
            description = "5x Banner XP IV, 5x Banner Spawn IV, 5x Banner Pesca IV",
            backgroundImage = "default_item2",
            offset = {x = 0, y = 0},
            size = "48 48"
        },

    },
    ["ASSINATURA"] = {
        {   type = "clube",
            beneficios = "     35% Bonus:\nBonus Experiencia\nBonus Catch Points\nBonus Loot Rate\nKit Naruto: (Outfit+Poke)",
            info = "Ao comprar o vip plus, voce recebera 31 dias do beneficio,\napenas no personagem no qual voce comprar. Necessario: 10 diamantes",
            price = 10,
            moeda = 27635
        }
    },
    ["AURAS"] = {
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Fire Dragon", lookType = {type = 0, aura = 4616}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Leaf Dragon", lookType = {type = 0, aura = 4617}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Water Dragon", lookType = {type = 0, aura = 4618}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Piso 4", lookType = {type = 0, aura = 4715}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
	},
    ["WINGS"] = {
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Golden", lookType = {type = 0, wings = 79}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Purple", lookType = {type = 0, wings = 81}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Fire and Ice", lookType = {type = 0, wings = 4649}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
       {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Grey 2", lookType = {type = 0, wings = 4656}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
["SHADERS"] = {
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Rainbow",lookType={type=6608,shader="outfit_rainbow"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Calor",lookType={type=6609,shader="outfit_heat"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Party",lookType={type=6644,shader="outfit_party"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Light Blue",lookType={type=6645,shader="ShaderLightBlue"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Blue",lookType={type=6234,shader="ShaderBlue"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Red",lookType={type=6647,shader="ShaderRed"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Dark Red",lookType={type=6648,shader="ShaderDarkRed"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Purple",lookType={type=6649,shader="ShaderPurple"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="White",lookType={type=6553,shader="ShaderWhite"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Light Blue Static",lookType={type=6554,shader="ShaderLightBlueStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Blue Static",lookType={type=6555,shader="ShaderBlueStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Red Static",lookType={type=6556,shader="ShaderRedStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Dark Red Static",lookType={type=6557,shader="ShaderDarkRedStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Purple Static",lookType={type=6558,shader="ShaderPurpleStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="White Static",lookType={type=6560,shader="ShaderWhiteStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Rage",lookType={type=6562,shader="ShaderRage"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Freeze",lookType={type=6564,shader="ShaderFreeze"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Green",lookType={type=6570,shader="ShaderGreen"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Green Static",lookType={type=6572,shader="ShaderGreenStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Yellow",lookType={type=6574,shader="ShaderYellow"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Yellow Static",lookType={type=6575,shader="ShaderYellowStatic"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Highlight",lookType={type=6576,shader="ShaderCreatureHighlight"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Outline",lookType={type=6458,shader="Outfit_3line"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Circle",lookType={type=6580,shader="Outfit_circle"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Outline 2",lookType={type=6581,shader="Outfit_Line"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Outline 3",lookType={type=6582,shader="Outfit_Outline"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Cintilante",lookType={type=6583,shader="Outfit_Shimmering"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Brilho",lookType={type=6594,shader="Outfit_Shine"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Brazil",lookType={type=6595,shader="Outfit_brazil"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Gold",lookType={type=6596,shader="Outfit_Gold"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Stars",lookType={type=6597,shader="Outfit_Stars"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Blood",lookType={type=6598,shader="Outfit_blood"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Camuflagem",lookType={type=6599,shader="Outfit_camouflage"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Flash",lookType={type=6454,shader="Outfit_Flash"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Glitch",lookType={type=6455,shader="Outfit_Glitch"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Ice",lookType={type=6456,shader="Outfit_Ice"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Purple Neon",lookType={type=6457,shader="Outfit_Purpleneon"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Cosmos",lookType={type=6458,shader="Outfit_Cosmos"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Purple Sky",lookType={type=6459,shader="Outfit_Purplesky"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Static",lookType={type=6460,shader="Outfit_Static"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Sun",lookType={type=6310,shader="Outfit_Sun"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Red",lookType={type=6311,shader="outfit_red"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Blue",lookType={type=6033,shader="outfit_blue"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Green",lookType={type=6313,shader="outfit_green"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Purple",lookType={type=6314,shader="outfit_purple"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Yellow",lookType={type=6315,shader="outfit_yellow"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Grey",lookType={type=6316,shader="outfit_gray"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Black",lookType={type=6317,shader="outfit_black"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="White",lookType={type=6318,shader="outfit_white"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Rainbow 2",lookType={type=6319,shader="outfit_rainbow"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Rainbow 3",lookType={type=6320,shader="rainbow2"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Circle White",lookType={type=6321,shader="outfit_circle_white"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"},
    {type="outfit",subtype="shader",valor=20,moeda=27635,name="Circle Red",lookType={type=6357,shader="outfit_circle_red"},animated=true,offset={x=0,y=0},size="48 48",backgroundImage="default_item"}
	},
    ["EVENTOS"] = {
        {type = "item", valor = 10, moeda = 24653, item = {id = 14508, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 15, moeda = 24653, item = {id = 25642, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 25, moeda = 24653, item = {id = 20651, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 50, moeda = 24653, item = {id = 26287, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 50, moeda = 24653, item = {id = 26287, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 100, moeda = 24653, item = {id = 26971, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 200, moeda = 24653, item = {id = 26289, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 200, moeda = 24653, item = {id = 27010, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 300, moeda = 24653, item = {id = 26673, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "item", valor = 400, moeda = 24653, item = {id = 26642, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "pascoa"},
        {type = "outfit", valor = 25, moeda = 24653, name = "Coelinho Da Pascoa", lookType = {type = 3769}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
		{type = "outfit", valor = 25, moeda = 24653, name = "Coelinha Da Pascoa", lookType = {type = 3770}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
		{type = "outfit", valor = 150, moeda = 24653, name = "Pernalonga", lookType = {type = 6555}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
        {type = "pokemon", valor = 400, moeda = 24653, pokeName = "diggersby pijaminha", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
        {type = "pokemon", valor = 800, moeda = 24653, pokeName = "togepi eggzord", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
        {type = "pokemon", valor = 1200, moeda = 24653, pokeName = "chamafofinho", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "pascoa"},
    },
}

local SHOP_DIAMOND_ID = CONSTANT_ITEM_DIAMOND or 27635
local SHOP_DIAMOND_CLIENT_ID = 25218
local SHOP_TRANSFER_LIMIT = 1000000

local function trimShopText(value)
    if not value then
        return ""
    end
    return tostring(value):gsub("^%s*(.-)%s*$", "%1")
end

local function normalizeShopAmount(value, maxValue)
    local amount = math.floor(tonumber(value) or 0)
    if amount < 1 then
        return 0
    end
    if maxValue and amount > maxValue then
        return 0
    end
    return amount
end

local function isShopDiamondCurrency(currency)
    return tonumber(currency) == SHOP_DIAMOND_ID
end

local function getShopCurrencyName(currency)
    local itemType = ItemType(currency)
    return itemType and itemType:getName() or tostring(currency)
end

local function getShopDiamondBalance(player)
    if player.syncDiamondBalance then
        return player:syncDiamondBalance()
    end
    return getDiamonds(player)
end

function Player:sendShopDiamondBalance()
    local itemType = ItemType(SHOP_DIAMOND_ID)
    local clientId = itemType and itemType:getClientId() or SHOP_DIAMOND_CLIENT_ID
    return self:sendExtendedOpcode(OPCODE_NEW_SHOP, json.encode({
        type = "balance",
        diamonds = getShopDiamondBalance(self),
        diamondClientId = clientId
    }))
end

local function getShopCurrencyBalance(player, currency)
    if isShopDiamondCurrency(currency) then
        return getShopDiamondBalance(player)
    end
    return player:getItemCount(currency)
end

local function removeShopCurrency(player, currency, amount)
    amount = normalizeShopAmount(amount)
    if amount < 1 then
        return false
    end

    if isShopDiamondCurrency(currency) then
        return removePlayerDiamond(player, amount)
    end

    if player:getItemCount(currency) < amount then
        return false
    end
    return player:removeItem(currency, amount)
end

local function addShopCurrency(player, currency, amount)
    amount = normalizeShopAmount(amount)
    if amount < 1 then
        return false
    end

    if isShopDiamondCurrency(currency) then
        return addPlayerDiamond(player, amount)
    end
    return player:addItem(currency, amount)
end

function Player:sendShopTransferResult(success, message)
    return self:sendExtendedOpcode(OPCODE_NEW_SHOP, json.encode({
        type = "transferResult",
        success = success == true,
        message = message or "",
        diamonds = getShopDiamondBalance(self),
        diamondClientId = (ItemType(SHOP_DIAMOND_ID) and ItemType(SHOP_DIAMOND_ID):getClientId()) or SHOP_DIAMOND_CLIENT_ID
    }))
end

function Player:handleShopDiamondTransfer(data)
    local info = type(data.info) == "table" and data.info or data
    local targetName = trimShopText(info.target or info.player or info.name)
    local amount = normalizeShopAmount(info.amount or info.quantity, SHOP_TRANSFER_LIMIT)

    if targetName == "" or #targetName < 3 or #targetName > 32 or targetName:find("[%c]") then
        self:popupFYI("Jogador invalido para transferencia.")
        self:sendShopTransferResult(false, "invalid_target")
        return true
    end

    if amount < 1 then
        self:popupFYI("Quantidade invalida para transferencia.")
        self:sendShopTransferResult(false, "invalid_amount")
        return true
    end

    local targetGuid = getPlayerGUIDByName(targetName)
    if not targetGuid or targetGuid <= 0 then
        self:popupFYI("Jogador nao encontrado.")
        self:sendShopTransferResult(false, "target_not_found")
        return true
    end

    if targetGuid == self:getGuid() then
        self:popupFYI("Voce nao pode transferir diamantes para si mesmo.")
        self:sendShopTransferResult(false, "same_player")
        return true
    end

    if getShopDiamondBalance(self) < amount then
        self:popupFYI("Voce nao possui diamantes suficientes.")
        self:sendShopTransferResult(false, "not_enough_diamonds")
        return true
    end

    if not removePlayerDiamond(self, amount) then
        self:popupFYI("Erro ao remover os diamantes.")
        self:sendShopTransferResult(false, "remove_failed")
        return true
    end

    local credited = db.query("UPDATE `players` SET `diamond` = `diamond` + " .. amount .. " WHERE `id` = " .. targetGuid)
    if credited == false then
        addPlayerDiamond(self, amount)
        self:popupFYI("Erro ao creditar os diamantes. Valor devolvido.")
        self:sendShopTransferResult(false, "credit_failed")
        return true
    end

    self:popupFYI(string.format("Voce transferiu %d diamantes para %s.", amount, targetName))
    self:sendShopTransferResult(true, "ok")

    local target = Player(targetName)
    if target then
        target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Voce recebeu %d diamantes de %s.", amount, self:getName()))
        if target.sendShopDiamondBalance then
            target:sendShopDiamondBalance()
        end
    end

    local logFile = io.open("data/logs/game_shop_compras/shop_diamond_transfers.log", "a")
    if logFile then
        logFile:write(string.format("[TRANSFER DIAMOND] [%s] From: %s (%d) | To: %s (%d) | Amount: %d\n", os.date("%Y-%m-%d %H:%M:%S"), self:getName(), self:getGuid(), targetName, targetGuid, amount))
        logFile:close()
    end

    return true
end

local isShopLoaded = false

SHOP_CACHE = {}
SHOP_JSON = {}

function Player:handleShop(buffer)
    if not buffer then return false end

    local ok, data = pcall(function() return json.decode(buffer) end)
    if not ok or type(data) ~= "table" then return false end

    local packetType = data.type
    if not packetType then return false end

    if packetType == "balance" then
        self:sendShopDiamondBalance()
        return true
    elseif packetType == "transferDiamonds" then
        return self:handleShopDiamondTransfer(data)
    end

    if packetType == "buy" then
        local infos = data.info
        if not infos then return false end

        local category = infos.category
        if type(category) ~= "string" then return false end
        local selectedCat = SHOP_DATA.CATEGORY[category]
        local quantityClient = tonumber(infos.quantity) or 1
        if quantityClient < 1 or quantityClient > 100 then return false end
        quantityClient = math.floor(quantityClient)

        if not selectedCat then return false end

		if category == "ASSINATURA" then
			local currency = tonumber(selectedCat[1].moeda)
			local price = normalizeShopAmount(selectedCat[1].price)
			if not currency or price < 1 then return false end

			if getShopCurrencyBalance(self, currency) < price then
				self:popupFYI("Voce nao possui dinheiro suficiente para comprar.")
                self:sendShopDiamondBalance()
			else
                if not removeShopCurrency(self, currency, price) then
                    self:popupFYI("Erro ao processar pagamento.")
                    self:sendShopDiamondBalance()
                    return true
                end
				self:addVipPlus(31)
				pcall(function() self:sendPlayerbarVipData() end)

				local pokeball = self:addPokemon("Webersaur")
				if not pokeball then
					addShopCurrency(self, currency, price)
					self:popupFYI("Erro ao adicionar Pokemon! Libere espaco no inventario, inbox ou depot e tente novamente.")
                    self:sendShopDiamondBalance()
					return true
				end
				pokeball:setSpecialAttribute("boughtBy", self:getName())
				pokeball:setSpecialAttribute("boughtAt", os.date("%d/%m/%Y as %H:%M"))

				self:addOutfit(6437)
				self:addShopItemToCoinsBag(26262, 2)
				self:popupFYI("Voce adquiriu o vip plus mensal!")
                self:sendShopDiamondBalance()
			end
			return true
		end

		local idItem = tonumber(infos.id)
        if not idItem then return false end

        local item = selectedCat[idItem]
        if not item then return false end

        local currency = tonumber(item.moeda)
        local price = normalizeShopAmount(item.valor) * quantityClient
        if not currency or price < 1 then return false end

        if getShopCurrencyBalance(self, currency) < price then
             self:popupFYI("Voce nao possui dinheiro suficiente para comprar.")
             self:sendShopDiamondBalance()
        else
            if item.type == "outfit" then
                if not item.subtype then
                    if self:hasOutfit(item.lookType.type) then
                        self:popupFYI("Voce ja possui este outfit: " .. item.name)
                        return true
                    end
                else
                    local subtype = item.subtype
                    if subtype == "wing" then
                        local wingId = item.lookType.wings
                        local wingName = item.name
                        if self.hasWing then
                            if wingId and self:hasWing(wingId) then
                                self:popupFYI("Voce ja possui esta wing: " .. wingName)
                                return true
                            end
                            if wingName and self:hasWing(wingName) then
                                self:popupFYI("Voce ja possui esta wing: " .. wingName)
                                return true
                            end
                        end
                    elseif subtype == "aura" then
                        local auraId = item.lookType.aura
                        local auraName = item.name
                        if self.hasAura then
                            if auraId and self:hasAura(auraId) then
                                self:popupFYI("Voce ja possui esta aura: " .. auraName)
                                return true
                            end
                            if auraName and self:hasAura(auraName) then
                                self:popupFYI("Voce ja possui esta aura: " .. auraName)
                                return true
                            end
                        end
                    elseif subtype == "shader" then
                        local shaderName = item.lookType.shader
                        if self.hasShader then
                            if shaderName and self:hasShader(shaderName) then
                                self:popupFYI("Voce ja possui este shader: " .. shaderName)
                                return true
                            end
                        end
                    end
                end
            end
            if not removeShopCurrency(self, currency, price) then
                self:popupFYI("Erro ao processar pagamento.")
                self:sendShopDiamondBalance()
                return true
            end

            if item.type == "item" then
                local totalQtd = item.item.qtd * quantityClient
                local delivered = self:addShopItemToCoinsBag(item.item.id, totalQtd)

                local missing = totalQtd - delivered
                local refund = 0
                if missing > 0 then
                    local unitsPerPurchase = math.max(1, tonumber(item.item.qtd) or 1)
                    refund = math.floor((item.valor * missing) / unitsPerPurchase)
                    if refund > 0 then
                        addShopCurrency(self, currency, refund)
                    end
                    self:popupFYI(string.format(
                        "Entregues %d de %d itens. Libere espaco na Coins Bag ou na bag e tente novamente. %d %s reembolsados.",
                        delivered, totalQtd, refund,
                        getShopCurrencyName(currency)))
                end

                local logFile = io.open("data/logs/game_shop_compras/shop_buyitems.log", "a")
                if logFile then
                    local data = os.date("%Y-%m-%d %H:%M:%S")
                    local nomeItem = item.item.name
                    if not nomeItem or nomeItem == "" then
                        nomeItem = ItemType(item.item.id):getName() or tostring(item.item.id)
                    end
                    local nomeMoeda = getShopCurrencyName(currency)
                    local pagoReal = price - refund
                    logFile:write(string.format(
                        "[COMPRA ITEM] [%s] Player: %s | Item: %s | Solicitado: %d | Entregue: %d | Valor Pago: %d %s\n",
                        data, self:getName(), nomeItem, totalQtd, delivered, pagoReal, nomeMoeda))
                    logFile:close()
                end
            elseif item.type == "outfit" then
                if not item.subtype then
                    local success = self:addOutfit(item.lookType.type)
                    if not success then
                        self:popupFYI("Erro ao adicionar outfit: " .. item.name)
                    end
                else
                    local subtype = item.subtype
                    if subtype == "wing" then
                        local wingId = item.lookType.wings
                        local wingName = item.name
                        local success = nil
                        if wingId then
                            success = self:addWing(wingId)
                        end
                        if success == nil then
                            success = self:addWing(wingName)
                        end
                        if success == nil then
                            self:popupFYI("Erro ao adicionar wing: " .. wingName)
                        end
                    elseif subtype == "aura" then
                        local auraId = item.lookType.aura
                        local auraName = item.name
                        local success = nil
                        if auraId then
                            success = self:addAura(auraId)
                        end
                        if success == nil then
                            success = self:addAura(auraName)
                        end
                        if success == nil then
                            self:popupFYI("Erro ao adicionar aura: " .. auraName)
                        end
                    elseif subtype == "shader" then
                        local shaderName = item.lookType.shader
                        local success = self:addShader(shaderName)
                        if success == nil then
                            self:popupFYI("Erro ao adicionar shader: " .. shaderName)
                        end
                    end
                end
                local logFile = io.open("data/logs/game_shop_compras/shop_buyoutfits.log", "a")
                if logFile then
                    local data = os.date("%Y-%m-%d %H:%M:%S")
                    local nomeOutfit = item.name or (item.lookType and item.lookType.type) or "outfit"
                    local nomeMoeda = getShopCurrencyName(currency)
                    logFile:write(string.format("[COMPRA OUTFIT] [%s] Player: %s | Outfit: %s | Quantidade: %d | Valor Pago: %d %s\n", data, self:getName(), nomeOutfit, quantityClient, price, nomeMoeda))
                    logFile:close()
                end
            elseif item.type == "pokemon" then
				local pokeName = item.pokeName
                local successCount = 0
                for i = 1, quantityClient do
                    local pokeball = self:addPokemon(pokeName)
                    if pokeball then
                        pokeball:setSpecialAttribute("boughtBy", self:getName())
                        pokeball:setSpecialAttribute("boughtAt", os.date("%d/%m/%Y as %H:%M"))
                        successCount = successCount + 1
                    else
                        self:sendTextMessage(MESSAGE_STATUS_WARNING, string.format("Erro ao adicionar Pokemon %d/%d! Libere espaco no inventario, inbox ou depot.", i, quantityClient))
                        break
                    end
                end

                if successCount < quantityClient then
                    local refundAmount = (quantityClient - successCount) * item.valor
                    addShopCurrency(self, currency, refundAmount)
                    self:popupFYI(string.format("Apenas %d/%d Pokemons foram adicionados. %d moedas foram devolvidas.", successCount, quantityClient, refundAmount))
                end

                if successCount > 0 then
                    local logFile = io.open("data/logs/game_shop_compras/shop_buypokemons.log", "a")
                    if logFile then
                        local data = os.date("%Y-%m-%d %H:%M:%S")
                        local nomeMoeda = getShopCurrencyName(currency)
                        logFile:write(string.format("[COMPRA POKEMON] [%s] Player: %s | Pokemon: %s | Quantidade: %d/%d | Valor Pago: %d %s\n", data, self:getName(), pokeName, successCount, quantityClient, price - ((quantityClient - successCount) * item.valor), nomeMoeda))
                        logFile:close()
                    end
                end
            elseif item.type == "pack" then
                local packSuccess = true
                local failedDeliveries = {}

                for _, packItem in ipairs(item.items) do
                    if packItem.type == "pokemon" then
                        local pokeball = self:addPokemon(packItem.pokeName)
                        if pokeball then
                            pokeball:setSpecialAttribute("boughtBy", self:getName())
                            pokeball:setSpecialAttribute("boughtAt", os.date("%d/%m/%Y as %H:%M"))
                            pokeball:setSpecialAttribute("packSource", item.name or "Pack")
                        else
                            table.insert(failedDeliveries, packItem.pokeName)
                            packSuccess = false
                        end
                    elseif packItem.type == "item" then
                        local requested = math.max(1, tonumber(packItem.qtd) or 1)
                        local delivered = self:addShopItemToCoinsBag(packItem.id, requested)
                        if delivered < requested then
                            local itemType = ItemType(packItem.id)
                            local itemName = itemType and itemType:getName() or tostring(packItem.id)
                            table.insert(failedDeliveries, itemName)
                            packSuccess = false
                        end
                    end
                end

                if not packSuccess then
                    local failedNames = table.concat(failedDeliveries, ", ")
                    self:sendTextMessage(MESSAGE_STATUS_WARNING, "Alguns itens do pack nao foram adicionados: " .. failedNames .. ". Libere espaco na Coins Bag ou na bag!")
                end
            end

            self:popupFYI(string.format("Parabens, sua compra foi bem sucedida."))
            self:sendShopDiamondBalance()
        end
    end
    return true
end

function loadShopJSONCache()
    local success, result = pcall(function()
        return json.encode(SHOP_CACHE)
    end)

    if success then
        SHOP_JSON = result
    else
        SHOP_JSON = json.encode({
            ORDEM = {},
            STYLES = {},
            CATEGORYINFO = {},
            CATEGORY = {}
        })
    end
end

function loadShopCache()
    if not SHOP_DATA then
        return
    end

    if not SHOP_DATA.ORDEM or #SHOP_DATA.ORDEM == 0 then
        return
    end

    if EASTER_SHOP_ACTIVE then
        if not hasValue(SHOP_DATA.ORDEM, EASTER_CATEGORY_NAME) then
            table.insert(SHOP_DATA.ORDEM, EASTER_CATEGORY_NAME)
        end

        if not SHOP_DATA.CATEGORYINFO[EASTER_CATEGORY_NAME] then
            SHOP_DATA.CATEGORYINFO[EASTER_CATEGORY_NAME] = EASTER_CATEGORY_INFO
        end
    end

    SHOP_CACHE = {}
    SHOP_CACHE.CATEGORY = {}
    SHOP_CACHE.ORDEM = SHOP_DATA.ORDEM
    SHOP_CACHE.STYLES = SHOP_DATA.STYLES
    SHOP_CACHE.CATEGORYINFO = SHOP_DATA.CATEGORYINFO

    for category, list in pairs(SHOP_DATA.CATEGORY) do
        SHOP_CACHE.CATEGORY[category] = {}
        for id, itemData in ipairs(list) do
            local success, error = pcall(function()
                SHOP_CACHE.CATEGORY[category][id] = {}
                SHOP_CACHE.CATEGORY[category][id].type = itemData.type

            if itemData.type == "outfit" then
                SHOP_CACHE.CATEGORY[category][id].lookType = itemData.lookType
                SHOP_CACHE.CATEGORY[category][id].name = itemData.name
                if itemData.animated then
                    SHOP_CACHE.CATEGORY[category][id].animated = true
                end
            elseif itemData.type == "item" then
                local itemType = ItemType(itemData.item.id)
                if itemType then
                    SHOP_CACHE.CATEGORY[category][id].item = {
                        id = itemType:getClientId(), 
                        qtd = itemData.item.qtd, 
                        name = itemType:getName()
                    }
                end
            elseif itemData.type == "pokemon" then
                local mType = MonsterType(itemData.pokeName)
                if mType then
                    SHOP_CACHE.CATEGORY[category][id].lookType = {type = mType:outfit().lookType or 0}
                    SHOP_CACHE.CATEGORY[category][id].pokeName = itemData.pokeName
                    SHOP_CACHE.CATEGORY[category][id].rank = mType:pokemonRank() or "A"
                    SHOP_CACHE.CATEGORY[category][id].pokemonStats = {
                        health = mType:maxHealth() or 0,
                        moveMagicAttackBase = mType:moveMagicAttackBase() or 0,
                        moveMagicDefenseBase = mType:moveMagicDefenseBase() or 0
                    }
                else
                    SHOP_CACHE.CATEGORY[category][id].lookType = {type = 0}
                    SHOP_CACHE.CATEGORY[category][id].pokeName = itemData.pokeName
                    SHOP_CACHE.CATEGORY[category][id].rank = "A"
                    SHOP_CACHE.CATEGORY[category][id].pokemonStats = {
                        health = 0,
                        moveMagicAttackBase = 0,
                        moveMagicDefenseBase = 0
                    }
                end
            elseif itemData.type == "pack" then
                SHOP_CACHE.CATEGORY[category][id].name = itemData.name
                SHOP_CACHE.CATEGORY[category][id].description = itemData.description or itemData.name
                SHOP_CACHE.CATEGORY[category][id].items = {}

                for _, packItem in ipairs(itemData.items) do
                    local newItem = {type = packItem.type}
                    if packItem.type == "pokemon" then
                        local mType = MonsterType(packItem.pokeName)
                        if mType then
                            newItem.lookType = {type = mType:outfit().lookType or 0}
                            newItem.rank = mType:pokemonRank() or "A"
                            newItem.name = packItem.pokeName
                            newItem.pokemonStats = {
                                health = mType:maxHealth() or 0,
                                moveMagicAttackBase = mType:moveMagicAttackBase() or 0,
                                moveMagicDefenseBase = mType:moveMagicDefenseBase() or 0
                            }
                        else
                            newItem.lookType = {type = 0}
                            newItem.rank = "S"
                            newItem.name = packItem.pokeName
                            newItem.pokemonStats = {
                                health = 0,
                                moveMagicAttackBase = 0,
                                moveMagicDefenseBase = 0
                            }
                        end
                    elseif packItem.type == "item" then
                        local itemType = ItemType(packItem.id)
                        if itemType then
                            newItem.id = itemType:getClientId()
                            newItem.name = itemType:getName()
                            newItem.qtd = packItem.qtd
                        end
                    end
                    table.insert(SHOP_CACHE.CATEGORY[category][id].items, newItem)
                end

                if itemData.displayItems then
                    local clientDisplayItems = {}
                    for _, serverId in ipairs(itemData.displayItems) do
                        local dispItemType = ItemType(serverId)
                        if dispItemType then
                            table.insert(clientDisplayItems, dispItemType:getClientId())
                        else
                            table.insert(clientDisplayItems, serverId)
                        end
                    end
                    SHOP_CACHE.CATEGORY[category][id].displayItems = clientDisplayItems
                end
            elseif itemData.type == "clube" then
                SHOP_CACHE.CATEGORY[category][id].beneficios = itemData.beneficios
                SHOP_CACHE.CATEGORY[category][id].info = itemData.info
            end

            if itemData.type ~= "clube" then
                SHOP_CACHE.CATEGORY[category][id].valor = itemData.valor
                SHOP_CACHE.CATEGORY[category][id].offset = itemData.offset
                SHOP_CACHE.CATEGORY[category][id].size = itemData.size
                SHOP_CACHE.CATEGORY[category][id].backgroundImage = itemData.backgroundImage  

                local itemType = ItemType(itemData.moeda)
                if itemType then
                    SHOP_CACHE.CATEGORY[category][id].moeda = itemType:getClientId()
                else
                    SHOP_CACHE.CATEGORY[category][id].moeda = itemData.moeda
                end
            end
            end)
        end
    end
end

function loadShop()
    if not isShopLoaded then
        local success, error = pcall(function()
            loadShopCache()
            loadShopJSONCache()
        end)

        if not success then
            return false
        end

        isShopLoaded = true

        if not SHOP_JSON or #SHOP_JSON == 0 then
            return false
        end

        return true
    else
        return true
    end
end

function reloadShop()
    isShopLoaded = false
    loadShopCache()
    loadShopJSONCache()
    isShopLoaded = true
end

function Player:sendShopStructure()
    loadShop()

    local structure = {
        ORDEM = SHOP_CACHE.ORDEM,
        STYLES = SHOP_CACHE.STYLES,
        CATEGORYINFO = SHOP_CACHE.CATEGORYINFO,
        type = "structure"
    }

    local structureJSON = json.encode(structure)
    local sent = self:sendExtendedOpcode(OPCODE_NEW_SHOP, structureJSON)
    self:sendShopDiamondBalance()
    return sent
end

function Player:sendShopCategory(categoryName)
    loadShop()

    if not categoryName or not SHOP_CACHE.CATEGORY[categoryName] then
        return false
    end

    local categoryData = {
        type = "category",
        category = categoryName,
        items = SHOP_CACHE.CATEGORY[categoryName]
    }

    local categoryJSON = json.encode(categoryData)
    local sent = self:sendExtendedOpcode(OPCODE_NEW_SHOP, categoryJSON)
    self:sendShopDiamondBalance()
    return sent
end

function Player:sendShopData()
    loadShop()

    if #SHOP_JSON <= 65000 then
        if self:sendExtendedOpcode(OPCODE_NEW_SHOP, SHOP_JSON) then
            self:sendShopDiamondBalance()
            return true
        end
    end

    local optimizedCache = {
        ORDEM = SHOP_CACHE.ORDEM,
        STYLES = SHOP_CACHE.STYLES,
        CATEGORYINFO = SHOP_CACHE.CATEGORYINFO,
        CATEGORY = {}
    }

    for category, items in pairs(SHOP_CACHE.CATEGORY) do
        optimizedCache.CATEGORY[category] = {}

        for i = 1, #items do
            local item = items[i]
            local optimizedItem = {
                type = item.type,
                valor = item.valor,
                moeda = item.moeda,
                offset = item.offset,
                size = item.size,
                backgroundImage = item.backgroundImage
            }

            if item.type == "outfit" then
                optimizedItem.lookType = item.lookType
                optimizedItem.name = item.name
                if item.animated then optimizedItem.animated = true end
                if item.subtype then optimizedItem.subtype = item.subtype end
            elseif item.type == "item" then
                optimizedItem.item = item.item
            elseif item.type == "pokemon" then
                optimizedItem.lookType = item.lookType
                optimizedItem.pokeName = item.pokeName
                optimizedItem.rank = item.rank
                optimizedItem.pokemonStats = item.pokemonStats
            elseif item.type == "pack" then
                optimizedItem.name = item.name
                optimizedItem.description = item.description or item.name
                optimizedItem.items = item.items
            elseif item.type == "clube" then
                optimizedItem.beneficios = item.beneficios
                optimizedItem.info = item.info
            end

            table.insert(optimizedCache.CATEGORY[category], optimizedItem)
        end
    end

    local optimizedJSON = json.encode(optimizedCache)

    if #optimizedJSON <= 65535 then
        if self:sendExtendedOpcode(OPCODE_NEW_SHOP, optimizedJSON) then
            self:sendShopDiamondBalance()
            return true
        end
    end

    local ultraSimplifiedCache = {
        ORDEM = SHOP_CACHE.ORDEM,
        STYLES = SHOP_CACHE.STYLES,
        CATEGORYINFO = SHOP_CACHE.CATEGORYINFO,
        CATEGORY = {}
    }

    for category, items in pairs(SHOP_CACHE.CATEGORY) do
        ultraSimplifiedCache.CATEGORY[category] = {}
        local maxItems = 30

        for i = 1, math.min(#items, maxItems) do
            table.insert(ultraSimplifiedCache.CATEGORY[category], optimizedCache.CATEGORY[category][i])
        end
    end

    local ultraSimplifiedJSON = json.encode(ultraSimplifiedCache)

    if self:sendExtendedOpcode(OPCODE_NEW_SHOP, ultraSimplifiedJSON) then
        self:sendShopDiamondBalance()
        return true
    end

    return false
end
