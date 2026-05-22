OPCODE_NEW_SELL = 88

SELL_DATA = {}

SELL_DATA.ORDEM = {
    [1] = "ITEMS",
    [2] = "TMS",
    [3] = "CELULAS",
    [4] = "POKEMONS",
}

SELL_DATA.STYLES = {
    ["outfit"] = "baseOutfit",
    ["item"] = "baseItem",
    ["pokemon"] = "basePokemon",
    ["pack"] = "basePack",
    ["shader"] = "baseOutfit",
    ["wings"] = "baseOutfit",
    ["aura"] = "baseOutfit"
}

SELL_DATA.CATEGORYINFO = {
    ["ITEMS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["TMS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["CELULAS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["POKEMONS"] = {icon = "assets/categories/icon_pokemon", size = '34 34', iconOffet = {x = 8, y = 8}},
}

SELL_DATA.CATEGORY = {
    ["ITEMS"] = {
        {type = "item", valor = 80, moeda = 12237, item = {id = 16265, qtd = 1, name = "Phione Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16273, qtd = 1, name = "Heatran Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16275, qtd = 1, name = "Giratina Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16283, qtd = 1, name = "Celebi Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16287, qtd = 1, name = "Latios Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16288, qtd = 1, name = "Latias Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16289, qtd = 1, name = "Ho-oh Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 80, moeda = 12237, item = {id = 16299, qtd = 1, name = "Palkia Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16244, qtd = 1, name = "Dialga Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16262, qtd = 1, name = "Zapdos Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16263, qtd = 1, name = "Moltres Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16264, qtd = 1, name = "Articuno Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16266, qtd = 1, name = "Jirachi Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16268, qtd = 1, name = "Shaymin Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16269, qtd = 1, name = "Registeel Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16270, qtd = 1, name = "Rayquaza Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16274, qtd = 1, name = "Regirock Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16278, qtd = 1, name = "Deoxys Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16280, qtd = 1, name = "Genesect Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16281, qtd = 1, name = "Kyogre Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16284, qtd = 1, name = "Groudon Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16296, qtd = 1, name = "Yveltal Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16297, qtd = 1, name = "Regice Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 100, moeda = 12237, item = {id = 16298, qtd = 1, name = "Hoopa Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16267, qtd = 1, name = "Xerneas Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16271, qtd = 1, name = "Volcanion Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16272, qtd = 1, name = "Zygarde Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16277, qtd = 1, name = "Virizion Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16285, qtd = 1, name = "Meloetta Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16286, qtd = 1, name = "Terrakion Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16290, qtd = 1, name = "Cresselia Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16292, qtd = 1, name = "Arceus Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 150, moeda = 12237, item = {id = 16293, qtd = 1, name = "Lunala Card"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 500, moeda = 12237, item = {id = 21261, qtd = 1, name = "Plate Halloween"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 1, moeda = 12237, item = {id = 13234, qtd = 1, name = "Shiny Stone"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 1, moeda = 12237, item = {id = 14435, qtd = 1, name = "Black Stone"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 1, moeda = 12237, item = {id = 13198, qtd = 1, name = "Mega Stone"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 1, moeda = 12237, item = {id = 14434, qtd = 1, name = "Cell Stone"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
    },
    ["TMS"] = {
        {type = "item", valor = 9, moeda = 2145, item = {id = 25195, qtd = 1, name = "Tm Bugquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25196, qtd = 1, name = "Tm Fury Cutter"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25197, qtd = 1, name = "Tm Infestation"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25198, qtd = 1, name = "Tm Megahorn"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25199, qtd = 1, name = "Tm Pin Missile"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25200, qtd = 1, name = "Tm Quiver Dance"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25201, qtd = 1, name = "Tm Signal Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25202, qtd = 1, name = "Tm Spider Web"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25203, qtd = 1, name = "Tm U-Turn"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25204, qtd = 1, name = "Tm Assurance"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25205, qtd = 1, name = "Tm Curse"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25206, qtd = 1, name = "Tm Darkquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25207, qtd = 1, name = "Tm Flatter"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25208, qtd = 1, name = "Tm Hollow Wind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25209, qtd = 1, name = "Tm Hone Claws"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25210, qtd = 1, name = "Tm Howl"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25211, qtd = 1, name = "Tm Nasty plot"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25212, qtd = 1, name = "Tm Night Daze"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25213, qtd = 1, name = "Tm Night Slash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25214, qtd = 1, name = "Tm Payback"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25215, qtd = 1, name = "Tm Pursuit"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25216, qtd = 1, name = "Tm Shadowave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25217, qtd = 1, name = "Tm Taunt"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25218, qtd = 1, name = "Tm Torment"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25220, qtd = 1, name = "Tm Draco Meteor"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25221, qtd = 1, name = "Tm Dragon Breath"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25222, qtd = 1, name = "Tm Dragon Dance"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25223, qtd = 1, name = "Tm Dragon Flight"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25224, qtd = 1, name = "Tm Dragon Pulse"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25225, qtd = 1, name = "Tm Dragon Tail"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25226, qtd = 1, name = "Tm Dragonquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25227, qtd = 1, name = "Tm Inner Focus"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25228, qtd = 1, name = "Tm Outrage"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25229, qtd = 1, name = "Tm Rage"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25230, qtd = 1, name = "Tm Twister"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25231, qtd = 1, name = "Tm Charge"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25232, qtd = 1, name = "Tm Charge Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25233, qtd = 1, name = "Tm Discharge"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25234, qtd = 1, name = "Tm Electric Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25235, qtd = 1, name = "Tm Electric Terrain"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25236, qtd = 1, name = "Tm Electricquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25237, qtd = 1, name = "Tm Electrify"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25238, qtd = 1, name = "Tm Electro Field"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25240, qtd = 1, name = "Tm Fake Tears"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25241, qtd = 1, name = "Tm Illuminate"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25243, qtd = 1, name = "Tm Mamaragan"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25244, qtd = 1, name = "Tm Rising Voltage"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25245, qtd = 1, name = "Tm Shock Wave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25246, qtd = 1, name = "Tm Thunder"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25247, qtd = 1, name = "Tm Thunder Sphere"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25248, qtd = 1, name = "Tm Thunder Wave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25249, qtd = 1, name = "Tm Thunder Wrath"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25250, qtd = 1, name = "Tm Vital Spirit"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25251, qtd = 1, name = "Tm Volt Tackle"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25252, qtd = 1, name = "Tm Wild Charge"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25253, qtd = 1, name = "Tm Zap Cannon"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25254, qtd = 1, name = "Tm Disarming Voice"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25256, qtd = 1, name = "Tm Fairyquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25257, qtd = 1, name = "Tm Falling Stars"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25258, qtd = 1, name = "Tm Floral Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25259, qtd = 1, name = "Tm Great Love"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25260, qtd = 1, name = "Tm Heart Pound"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25261, qtd = 1, name = "Tm Life Dew"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25262, qtd = 1, name = "Tm Lifesteal"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25263, qtd = 1, name = "Tm Moonblast"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25264, qtd = 1, name = "Tm Moonlight"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25265, qtd = 1, name = "Tm Multi-Slap"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25269, qtd = 1, name = "Tm Arm Thrust"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25270, qtd = 1, name = "Tm Brick Break"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25271, qtd = 1, name = "Tm Counter Spin"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25272, qtd = 1, name = "Tm Cross Chop"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25274, qtd = 1, name = "Tm Dynamic Punch"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25275, qtd = 1, name = "Tm Elemental Hands"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25276, qtd = 1, name = "Tm Fightingquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25277, qtd = 1, name = "Tm Final Gambit"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25278, qtd = 1, name = "Tm Focus Blast"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25279, qtd = 1, name = "Tm Focus Punch"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25281, qtd = 1, name = "Tm Furious Legs"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25282, qtd = 1, name = "Tm Hammer Arm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25283, qtd = 1, name = "Tm Hi Jump Kick"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25284, qtd = 1, name = "Tm High Jump Kick"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25285, qtd = 1, name = "Tm Jump Kick"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25287, qtd = 1, name = "Tm Low Sweep"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25290, qtd = 1, name = "Tm Rage Punching"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25291, qtd = 1, name = "Tm Revenge"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25292, qtd = 1, name = "Tm Reversal"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25293, qtd = 1, name = "Tm Rolling Kick"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25294, qtd = 1, name = "Tm Sky Uppercut"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25295, qtd = 1, name = "Tm Stickmerang"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25296, qtd = 1, name = "Tm Stickslash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25297, qtd = 1, name = "Tm Superpower"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25298, qtd = 1, name = "Tm Ultimate Champion"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25299, qtd = 1, name = "Tm Vacuum Wave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25300, qtd = 1, name = "Tm Vital Throw"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25302, qtd = 1, name = "Tm Burn Up"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25303, qtd = 1, name = "Tm Burning Jealousy"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25304, qtd = 1, name = "Tm Fire Ball"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25305, qtd = 1, name = "Tm Fire Blast"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25306, qtd = 1, name = "Tm Fire Fang"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25307, qtd = 1, name = "Tm Firequake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25308, qtd = 1, name = "Tm Flame Burst"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25310, qtd = 1, name = "Tm Flame Circle"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25311, qtd = 1, name = "Tm Flame Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25313, qtd = 1, name = "Tm Flamethrower"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25314, qtd = 1, name = "Tm Flare Blitz"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25315, qtd = 1, name = "Tm Flip Turn"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25316, qtd = 1, name = "Tm Heat Wave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25317, qtd = 1, name = "Tm Heatzone"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25318, qtd = 1, name = "Tm Hell Fire"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25319, qtd = 1, name = "Tm Hellfire Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25320, qtd = 1, name = "Tm Inferno"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25321, qtd = 1, name = "Tm Lava Plume"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25322, qtd = 1, name = "Tm Magma Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25323, qtd = 1, name = "Tm Overheat"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25326, qtd = 1, name = "Tm Sunny Day"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25327, qtd = 1, name = "Tm fire lash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25328, qtd = 1, name = "Tm Aerial Ace"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25330, qtd = 1, name = "Tm Air Cutter"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25331, qtd = 1, name = "Tm Air Slash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25332, qtd = 1, name = "Tm Air Vortex"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25333, qtd = 1, name = "Tm Bounce"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25339, qtd = 1, name = "Tm Flyingquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25341, qtd = 1, name = "Tm Gust"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25342, qtd = 1, name = "Tm Hurricane"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25345, qtd = 1, name = "Tm Roost"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25346, qtd = 1, name = "Tm Sky Attack"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25347, qtd = 1, name = "Tm Tailwind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25348, qtd = 1, name = "Tm Tornado"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25349, qtd = 1, name = "Tm Whirlwind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25350, qtd = 1, name = "Tm Wing Attack"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25351, qtd = 1, name = "Tm Astonish"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25352, qtd = 1, name = "Tm Black Box"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25353, qtd = 1, name = "Tm Cotton Spore"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25356, qtd = 1, name = "Tm Ghostquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25357, qtd = 1, name = "Tm Hex"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25361, qtd = 1, name = "Tm Night Shade"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25362, qtd = 1, name = "Tm Ominous Wind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25365, qtd = 1, name = "Tm Shadow Blast"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25366, qtd = 1, name = "Tm Shadow Claw"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25367, qtd = 1, name = "Tm Shadow Sphere"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25368, qtd = 1, name = "Tm Shadow Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25369, qtd = 1, name = "Tm Solar Blade"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25372, qtd = 1, name = "Tm Vanish"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25373, qtd = 1, name = "Tm Bullet Seed"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25374, qtd = 1, name = "Tm Compass Slash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25375, qtd = 1, name = "Tm Frenzy Plant"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25377, qtd = 1, name = "Tm Grass Whistle"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25379, qtd = 1, name = "Tm Leaf Guard"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25380, qtd = 1, name = "Tm Leaf Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25381, qtd = 1, name = "Tm Leaf Tornado"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25382, qtd = 1, name = "Tm Leafage"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25383, qtd = 1, name = "Tm Leafquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25384, qtd = 1, name = "Tm Mega Drain"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25385, qtd = 1, name = "Tm Petal Blizzard"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25386, qtd = 1, name = "Tm Petal Bullets"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25387, qtd = 1, name = "Tm Petal Dance"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25388, qtd = 1, name = "Tm Power Whip"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25389, qtd = 1, name = "Tm Seed Bomb"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25390, qtd = 1, name = "Tm Sleep Powder"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25391, qtd = 1, name = "Tm Solar Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25392, qtd = 1, name = "Tm Spiky Shield"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25393, qtd = 1, name = "Tm Stun Spore"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25394, qtd = 1, name = "Tm Vine Whip"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25395, qtd = 1, name = "Tm Worry Seed"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25396, qtd = 1, name = "Tm Bone Rush"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25397, qtd = 1, name = "Tm Bulldoze"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25399, qtd = 1, name = "Tm Dig"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25400, qtd = 1, name = "Tm Drill Run"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25401, qtd = 1, name = "Tm Earth Power"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25402, qtd = 1, name = "Tm Earthquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25404, qtd = 1, name = "Tm Ground Collapse"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25408, qtd = 1, name = "Tm Sand Attack"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25409, qtd = 1, name = "Tm Sand Eruption"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25410, qtd = 1, name = "Tm Sand Tomb"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25411, qtd = 1, name = "Tm Spikes"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25412, qtd = 1, name = "Tm Stomping Tantrum"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25414, qtd = 1, name = "Tm Aurora Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25415, qtd = 1, name = "Tm Blizzard"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25416, qtd = 1, name = "Tm Frost Breath"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25417, qtd = 1, name = "Tm Frost Power"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25418, qtd = 1, name = "Tm Frost Tornado"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25419, qtd = 1, name = "Tm Hail"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25420, qtd = 1, name = "Tm Ice Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25421, qtd = 1, name = "Tm Ice Storm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25423, qtd = 1, name = "Tm Icequake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25424, qtd = 1, name = "Tm Iceshock"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25425, qtd = 1, name = "Tm Ice Wind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25426, qtd = 1, name = "Tm Powder Snow"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25427, qtd = 1, name = "Tm Sheer Cold"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25428, qtd = 1, name = "Tm Acid Armor"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25429, qtd = 1, name = "Tm Acid Rain"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25431, qtd = 1, name = "Tm Clear Smog"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25433, qtd = 1, name = "Tm Cross Poison"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25435, qtd = 1, name = "Tm Gastro Acid"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25438, qtd = 1, name = "Tm Mortal Gas"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25439, qtd = 1, name = "Tm Mud Sludge"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25441, qtd = 1, name = "Tm Poison Bomb"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25442, qtd = 1, name = "Tm Poison Gas"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25443, qtd = 1, name = "Tm Poison Powder"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25444, qtd = 1, name = "Tm Poison Tail"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25445, qtd = 1, name = "Tm Poison Touch"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25446, qtd = 1, name = "Tm Poisonquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25448, qtd = 1, name = "Tm Sludge Bomb"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25449, qtd = 1, name = "Tm Smog"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25450, qtd = 1, name = "Tm Snake Sense"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25451, qtd = 1, name = "Tm Spike Skin"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25452, qtd = 1, name = "Tm Swamp Mist"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25453, qtd = 1, name = "Tm Toxic"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25455, qtd = 1, name = "Tm Venomous Gale"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25456, qtd = 1, name = "Tm Venoshock"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25458, qtd = 1, name = "Tm Calm Mind"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25459, qtd = 1, name = "Tm Confusion"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25461, qtd = 1, name = "Tm Couterstrike"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25462, qtd = 1, name = "Tm Expanding Force"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25463, qtd = 1, name = "Tm Extrasensory"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25465, qtd = 1, name = "Tm Gravity"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25466, qtd = 1, name = "Tm Guard Split"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25467, qtd = 1, name = "Tm Healing Wish"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25468, qtd = 1, name = "Tm Heart Stamp"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25469, qtd = 1, name = "Tm Instant Teleportation"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25470, qtd = 1, name = "Tm Kinesis"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25471, qtd = 1, name = "Tm Light Screen"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25477, qtd = 1, name = "Tm Psy Impact"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25478, qtd = 1, name = "Tm Psychic"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25479, qtd = 1, name = "Tm Psychicquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25481, qtd = 1, name = "Tm Psychock"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25482, qtd = 1, name = "Tm Psychokinesis"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25483, qtd = 1, name = "Tm Psyshock"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25485, qtd = 1, name = "Tm Psyusion"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25486, qtd = 1, name = "Tm Psywave"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25487, qtd = 1, name = "Tm Reflect"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25488, qtd = 1, name = "Tm Rest"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25489, qtd = 1, name = "Tm Stored Power"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25490, qtd = 1, name = "Tm Stunning Confusion"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25491, qtd = 1, name = "Tm Trick Room"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25493, qtd = 1, name = "Tm Ancient Power"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25494, qtd = 1, name = "Tm Cannon Ball"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25495, qtd = 1, name = "Tm Falling Rocks"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25496, qtd = 1, name = "Tm Head Smash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25497, qtd = 1, name = "Tm Meteor Beam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25498, qtd = 1, name = "Tm Power Gem"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25499, qtd = 1, name = "Tm Rock Blast"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25500, qtd = 1, name = "Tm Rock Wrecker"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25501, qtd = 1, name = "Tm Rockquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25502, qtd = 1, name = "Tm Rollout"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25503, qtd = 1, name = "Tm Sandstorm"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25504, qtd = 1, name = "Tm Stealth Rock"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25506, qtd = 1, name = "Tm Flash Cannon"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25507, qtd = 1, name = "Tm Gyro Ball"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25508, qtd = 1, name = "Tm Heavy Metal"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25509, qtd = 1, name = "Tm Heavy Slam"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25510, qtd = 1, name = "Tm Hunter Mark"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25511, qtd = 1, name = "Tm Impale"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25513, qtd = 1, name = "Tm Iron Spiner"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25515, qtd = 1, name = "Tm Magnet Pull"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25517, qtd = 1, name = "Tm Metal Sound"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25518, qtd = 1, name = "Tm Meteor Mash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25519, qtd = 1, name = "Tm Red Fury"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25520, qtd = 1, name = "Tm Scrap Shot"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25522, qtd = 1, name = "Tm Steelquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25525, qtd = 1, name = "Tm Wing Blade"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25526, qtd = 1, name = "Tm Aqua Jet"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25527, qtd = 1, name = "Tm Aqua Ring"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25528, qtd = 1, name = "Tm Brine"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25529, qtd = 1, name = "Tm Giant Water Gun"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25531, qtd = 1, name = "Tm Hydro Cannon"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25532, qtd = 1, name = "Tm Hydro Pump"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25533, qtd = 1, name = "Tm Muddy Water"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25534, qtd = 1, name = "Tm Octazooka"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25536, qtd = 1, name = "Tm Rain Dance"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25537, qtd = 1, name = "Tm Scald"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25538, qtd = 1, name = "Tm Splash"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25539, qtd = 1, name = "Tm Surf"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25542, qtd = 1, name = "Tm Water Gun"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25543, qtd = 1, name = "Tm Water Pulse"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25545, qtd = 1, name = "Tm Water Spout"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25546, qtd = 1, name = "Tm Waterfall"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25547, qtd = 1, name = "Tm Waterquake"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 26103, qtd = 1, name = "Tm Misty Terrain"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
    },
    ["CELULAS"] = {
        {type = "item", valor = 3, moeda = 2145, item = {id = 25110, qtd = 1, name = "Celula A"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25111, qtd = 1, name = "Celula S"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25112, qtd = 1, name = "Celula SS"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 3, moeda = 2145, item = {id = 25113, qtd = 1, name = "Celula SSS"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 6, moeda = 2145, item = {id = 25114, qtd = 1, name = "Celula U"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 6, moeda = 2145, item = {id = 25115, qtd = 1, name = "Celula Op"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25116, qtd = 1, name = "Celula Deus"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 9, moeda = 2145, item = {id = 25117, qtd = 1, name = "Celula Supreme"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 15, moeda = 2145, item = {id = 26167, qtd = 1, name = "Celula Infernal"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
        {type = "item", valor = 15, moeda = 2145, item = {id = 26168, qtd = 1, name = "Celula Celestial"}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
    },
    ["POKEMONS"] = {
        {type = "pokemon", valor = 40, moeda = 23498, pokeName = "Zeraora Raijin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 60, moeda = 23498, pokeName = "Pidgeot Phoenix", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 70, moeda = 23498, pokeName = "Lugia Mythical", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 130, moeda = 23498, pokeName = "Jirachi Dragao Lunar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 80, moeda = 23498, pokeName = "Yveltal Eclipse Lunar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 150, moeda = 23498, pokeName = "Mewtwo Nemesis M2", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 140, moeda = 23498, pokeName = "Alakazam Ceifador Sombrio", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 210, moeda = 23498, pokeName = "Arceus Ascensao Filosofal", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 138, moeda = 23498, pokeName = "Super Tengen", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 108, moeda = 23498, pokeName = "Hoopa Florecer Espiritual", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 108, moeda = 23498, pokeName = "Shiny Hoopa Florecer Espiritual", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 90, moeda = 23498, pokeName = "Zygarde All Might Mode", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 74, moeda = 23498, pokeName = "Regigigas Sword of Lush", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 60, moeda = 23498, pokeName = "Regidrake", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 50, moeda = 23498, pokeName = "Draknus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 50, moeda = 23498, pokeName = "Eternatus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 42, moeda = 23498, pokeName = "Esquelect Regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 30, moeda = 23498, pokeName = "Mewtwo Estrela Negra", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 14, moeda = 23498, pokeName = "Celestial Mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 12, moeda = 23498, pokeName = "Lucario Souls", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8, moeda = 23498, pokeName = "Perfect Xerneas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 24, moeda = 25660, pokeName = "Genesect Crono King", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 36, moeda = 25660, pokeName = "Buzzwole Ascendent", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 48, moeda = 25660, pokeName = "Arceus Leviathan Astral", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 68, moeda = 25660, pokeName = "Zygarde Celula Mestre", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 100, moeda = 25660, pokeName = "Ho-Oh Radiante", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 120, moeda = 25660, pokeName = "Kyurem Carga Total", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 10, moeda = 25660, pokeName = "Jirachi Pijaminha", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 15, moeda = 25660, pokeName = "Zamazenta Royal", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 45, moeda = 25660, pokeName = "Shuckle Peruzudo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 75, moeda = 25660, pokeName = "Dragapult Nebuloso", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 90, moeda = 25660, pokeName = "Raichu Polarity", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 80, moeda = 25660, pokeName = "Salazzle Ethereal", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 100, moeda = 25660, pokeName = "Gengar Brawler", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 200, moeda = 25660, pokeName = "Gengar Eclipse", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 110, moeda = 25660, pokeName = "Hoopa Imperador Dragao", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 100, moeda = 25660, pokeName = "Gengar Fire Brawler", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 110, moeda = 25660, pokeName = "Dialga Dragao Imperial", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 110, moeda = 25660, pokeName = "Dialga Ordem Celestial", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 120, moeda = 25660, pokeName = "Voltaeon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 100, moeda = 25660, pokeName = "Brutal Snorlax", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"}, 
        {type = "pokemon", valor = 240, moeda = 25660, pokeName = "Dialga Dragao Supremo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 290, moeda = 25660, pokeName = "Salamence Shadow Kaisel", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 325, moeda = 25660, pokeName = "Charizard Hellwing", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "giant regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "giant lugia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "giant celesteela", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "tirtouga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "larvesta", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "yamper", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "bunnelby", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 500, moeda = 12237, pokeName = "zygarde", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 510, moeda = 12237, pokeName = "entei", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 512, moeda = 12237, pokeName = "mew", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 517, moeda = 12237, pokeName = "kyogre", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 523, moeda = 12237, pokeName = "moltres", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 538, moeda = 12237, pokeName = "regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 553, moeda = 12237, pokeName = "suicune", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 569, moeda = 12237, pokeName = "mesprit", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 573, moeda = 12237, pokeName = "zapdos", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 573, moeda = 12237, pokeName = "giratina", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 582, moeda = 12237, pokeName = "raikou", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 587, moeda = 12237, pokeName = "dialga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 598, moeda = 12237, pokeName = "ho-oh", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 605, moeda = 12237, pokeName = "uxie", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 622, moeda = 12237, pokeName = "manaphy", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 640, moeda = 12237, pokeName = "mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 646, moeda = 12237, pokeName = "palkia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 653, moeda = 12237, pokeName = "deoxys", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 662, moeda = 12237, pokeName = "registeel", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 671, moeda = 12237, pokeName = "phione", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 673, moeda = 12237, pokeName = "articuno", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 711, moeda = 12237, pokeName = "jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 716, moeda = 12237, pokeName = "azelf", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 716, moeda = 12237, pokeName = "regice", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 732, moeda = 12237, pokeName = "latios", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 749, moeda = 12237, pokeName = "celebi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 750, moeda = 12237, pokeName = "yamask", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 750, moeda = 12237, pokeName = "applin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 750, moeda = 12237, pokeName = "popplio", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 750, moeda = 12237, pokeName = "mini hoopa", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 750, moeda = 12237, pokeName = "mini hoopa unbound", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 756, moeda = 12237, pokeName = "zekrom", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 778, moeda = 12237, pokeName = "groudon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 800, moeda = 12237, pokeName = "bunnelby looney", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 800, moeda = 12237, pokeName = "arceus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 805, moeda = 12237, pokeName = "lugia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 810, moeda = 12237, pokeName = "shaymin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 824, moeda = 12237, pokeName = "genesect", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 880, moeda = 12237, pokeName = "reshiram", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 886, moeda = 12237, pokeName = "latias", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 898, moeda = 12237, pokeName = "heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 961, moeda = 12237, pokeName = "darkrai", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 964, moeda = 12237, pokeName = "regirock", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 966, moeda = 12237, pokeName = "rayquaza", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 983, moeda = 12237, pokeName = "genesect star", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "archeops", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "carracosta", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "skiddo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "volcarona", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "chespin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "milcery", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "togedemaru", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "ice entei", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "ice heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "ice jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "ice victini", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "mini shiny hoopa unbound", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny arceus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny azelf", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny celebi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny darkrai", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny deoxys", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny dialga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny entei", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny genesect", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny giratina", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny groudon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny ho-oh", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny kyogre", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny lugia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny manaphy", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny mesprit", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny palkia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny phione", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny raikou", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny rayquaza", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny regice", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny regirock", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny registeel", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny reshiram", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny shaymin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny suicune", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny uxie", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny victini", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1000, moeda = 12237, pokeName = "shiny zekrom", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1100, moeda = 12237, pokeName = "diggersby", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "lunala", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "comfey", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "darumaka", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "rockruff", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black celebi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black genesect", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black groudon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black kyogre", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black lugia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black manaphy", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "black zekrom", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal celebi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal entei", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "infernal victini", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "mech mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "mini black hoopa unbound", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "pluss azelf", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "pluss mesprit", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1250, moeda = 12237, pokeName = "pluss uxie", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "cofagrigus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "diggersby pernalonga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "green dialga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "green manaphy", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "legendary entei", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "legendary heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "legendary raikou", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1500, moeda = 12237, pokeName = "legendary suicune", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1750, moeda = 12237, pokeName = "polteageist", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1750, moeda = 12237, pokeName = "ultra deoxys", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1875, moeda = 12237, pokeName = "zacian", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1875, moeda = 12237, pokeName = "zamazenta", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1875, moeda = 12237, pokeName = "mewtwo psyfire y", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1875, moeda = 12237, pokeName = "grizzbolt", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 1875, moeda = 12237, pokeName = "keldeo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2000, moeda = 12237, pokeName = "frosmoth", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2000, moeda = 12237, pokeName = "swanna", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2000, moeda = 12237, pokeName = "perfect jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2000, moeda = 12237, pokeName = "perfect manaphy", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2125, moeda = 12237, pokeName = "entei galante", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2125, moeda = 12237, pokeName = "black arcanine", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2175, moeda = 12237, pokeName = "diance", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2250, moeda = 12237, pokeName = "heliolisk", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2500, moeda = 12237, pokeName = "necrozma", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2500, moeda = 12237, pokeName = "skwovet", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 2750, moeda = 12237, pokeName = "appletun", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3000, moeda = 12237, pokeName = "oranguru", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3000, moeda = 12237, pokeName = "toucannon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3125, moeda = 12237, pokeName = "perfect dialga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3250, moeda = 12237, pokeName = "xerneas thundervine", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3500, moeda = 12237, pokeName = "lycanroc", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3750, moeda = 12237, pokeName = "shadowoxys", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3750, moeda = 12237, pokeName = "brionne", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 3750, moeda = 12237, pokeName = "rayquaza guardiao estelar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 4000, moeda = 12237, pokeName = "thievul", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 4250, moeda = 12237, pokeName = "dragapult", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 4500, moeda = 12237, pokeName = "nihilego", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 4750, moeda = 12237, pokeName = "quilladin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 4750, moeda = 12237, pokeName = "salandit", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 5250, moeda = 12237, pokeName = "galarian rapidash", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 5500, moeda = 12237, pokeName = "eiscue", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 5500, moeda = 12237, pokeName = "pyroar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 5750, moeda = 12237, pokeName = "miraidon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6000, moeda = 12237, pokeName = "crabominable", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6250, moeda = 12237, pokeName = "barbaracle", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6250, moeda = 12237, pokeName = "regidrago", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6350, moeda = 12237, pokeName = "koraidon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6750, moeda = 12237, pokeName = "ceruledge", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6750, moeda = 12237, pokeName = "greedent", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 6850, moeda = 12237, pokeName = "jetragon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7000, moeda = 12237, pokeName = "toxtricity", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7250, moeda = 12237, pokeName = "hatterene", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7250, moeda = 12237, pokeName = "malamar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7250, moeda = 12237, pokeName = "vikavolt", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7500, moeda = 12237, pokeName = "corviknight", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 7750, moeda = 12237, pokeName = "turtonator", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8000, moeda = 12237, pokeName = "dubwool", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8000, moeda = 12237, pokeName = "primarina", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8250, moeda = 12237, pokeName = "regieleki", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8500, moeda = 12237, pokeName = "wishiwashi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 8750, moeda = 12237, pokeName = "clawitzer", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 9000, moeda = 12237, pokeName = "darmanitan", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 9000, moeda = 12237, pokeName = "pa'u style", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 9500, moeda = 12237, pokeName = "galarian meowth", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 9500, moeda = 12237, pokeName = "toxapex", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 12500, moeda = 12237, pokeName = "araquanid", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 12500, moeda = 12237, pokeName = "goodra", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 12500, moeda = 12237, pokeName = "krookodile", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 12500, moeda = 12237, pokeName = "shiinotic", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 15000, moeda = 12237, pokeName = "centiskorch", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 15000, moeda = 12237, pokeName = "galarian zen mode", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 15000, moeda = 12237, pokeName = "palossand", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 17500, moeda = 12237, pokeName = "chesnaught", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 17500, moeda = 12237, pokeName = "duraludon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 17500, moeda = 12237, pokeName = "noivern", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 20000, moeda = 12237, pokeName = "coalossal", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 20000, moeda = 12237, pokeName = "dhelmise", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 20000, moeda = 12237, pokeName = "kommo-o", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 20000, moeda = 12237, pokeName = "runerigus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 22500, moeda = 12237, pokeName = "bewear", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 22500, moeda = 12237, pokeName = "grapploct", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 22500, moeda = 12237, pokeName = "obstagoon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 25750, moeda = 12237, pokeName = "gengar lua superior", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 25750, moeda = 12237, pokeName = "gengar festival lunar", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 25750, moeda = 12237, pokeName = "mega gengar pernalonga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 28750, moeda = 12237, pokeName = "shiny mega gengar pernalonga", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 28750, moeda = 12237, pokeName = "mega lopunny", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 30750, moeda = 12237, pokeName = "shiny mega lopunny", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 34750, moeda = 12237, pokeName = "mega lopunny y", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 37750, moeda = 12237, pokeName = "mewtwo water", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "pokemon", valor = 38750, moeda = 12237, pokeName = "shiny mega lopunny y", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},    },
}

local isSellLoaded = false
SELL_CACHE = {}
SELL_JSON = {}

local POKEMON_ATTRIBUTE_REFUND = {
    {attr = "starFusion", itemId = 20669},
    {attr = "CrystalAttack", itemId = 22897},
    {attr = "CrystalDefense", itemId = 22885},
    {attr = "CrystalBoost", itemId = 22893},
    {attr = "CrystalCritical", itemId = 22889},
    {attr = "GC", itemId = 24837},
    {attr = "celulaInfinita", itemId = 26170},
    {attr = "regenOrb", itemId = 17165},
    {attr = "expOrb", itemId = 17166},
    {attr = "orbCooldown", itemId = 17164},
}

local function isRentalPokemonBall(item)
    if not item or not item.isPokeball or not item:isPokeball() then
        return false
    end
    return RentalSystem and RentalSystem.isRentalItem and RentalSystem.isRentalItem(item) or false
end

local function collectAttributeRefundsFromPokeballs(container, pokeName, quantityToCollect)
    local refundItems = {}
    local collected = 0

    local function collectFromContainer(c, pokeNameLower, maxToCollect)
        if collected >= maxToCollect then return end
        for i = c:getSize() - 1, 0, -1 do
            if collected >= maxToCollect then break end
            local item = c:getItem(i)
            if item then
                if item:isPokeball() then
                    local ballPokeName = item:getSpecialAttribute("pokeName")
                    if ballPokeName and ballPokeName:lower() == pokeNameLower and not isRentalPokemonBall(item) then
                        for _, mapping in ipairs(POKEMON_ATTRIBUTE_REFUND) do
                            local value = tonumber(item:getSpecialAttribute(mapping.attr)) or 0
                            if value > 0 then
                                refundItems[mapping.itemId] = (refundItems[mapping.itemId] or 0) + value
                            end
                        end
                        if HeldRefundMapping and ITEM_ATTRIBUTE_HELDX and ITEM_ATTRIBUTE_HELDY then
                            local heldSlots = {
                                {attr = ITEM_ATTRIBUTE_HELDX, key = "getAttribute"},
                                {attr = "heldx2", key = "getSpecialAttribute"},
                                {attr = "heldx3", key = "getSpecialAttribute"},
                                {attr = "heldx4", key = "getSpecialAttribute"},
                            }
                            for _, slot in ipairs(heldSlots) do
                                local ident = (slot.key == "getAttribute") 
                                    and (item:getAttribute(slot.attr) or 0) 
                                    or (tonumber(item:getSpecialAttribute(slot.attr)) or 0)
                                if ident > 0 then
                                    local heldItemId = HeldRefundMapping.getHeldItemId(ITEM_ATTRIBUTE_HELDX, ident)
                                    if heldItemId > 0 then
                                        refundItems[heldItemId] = (refundItems[heldItemId] or 0) + 1
                                    end
                                end
                            end
                            local heldYSlots = {
                                {attr = ITEM_ATTRIBUTE_HELDY, key = "getAttribute"},
                                {attr = "heldy2", key = "getSpecialAttribute"},
                            }
                            for _, slot in ipairs(heldYSlots) do
                                local ident = (slot.key == "getAttribute") 
                                    and (item:getAttribute(slot.attr) or 0) 
                                    or (tonumber(item:getSpecialAttribute(slot.attr)) or 0)
                                if ident > 0 then
                                    local heldItemId = HeldRefundMapping.getHeldItemId(ITEM_ATTRIBUTE_HELDY, ident)
                                    if heldItemId > 0 then
                                        refundItems[heldItemId] = (refundItems[heldItemId] or 0) + 1
                                    end
                                end
                            end
                        end
                        collected = collected + 1
                    end
                elseif item:isContainer() then
                    collectFromContainer(item, pokeNameLower, maxToCollect)
                end
            end
        end
    end

    collectFromContainer(container, pokeName:lower(), quantityToCollect)
    return refundItems
end

local function giveAttributeRefundItems(player, refundItems)
    local received = {}
    for itemId, count in pairs(refundItems) do
        if count > 0 then
            player:addItem(itemId, count)
            local itemName = ItemType(itemId):getName() or ("ID " .. itemId)
            table.insert(received, count .. "x " .. itemName)
        end
    end
    return received
end

function countItemInContainer(container, itemId)
    local count = 0
    for i = 0, container:getSize() - 1 do
        local item = container:getItem(i)
        if item then
            if item:getId() == itemId then
                if not (RentalSystem and RentalSystem.isRentalItem and RentalSystem.isRentalItem(item)) then
                    count = count + item:getCount()
                end
            elseif item:isContainer() then
                count = count + countItemInContainer(item, itemId)
            end
        end
    end
    return count
end

function removeItemFromContainer(container, itemId, quantityToRemove)
    local removed = 0
    for i = 0, container:getSize() - 1 do
        local item = container:getItem(i)
        if item then
            if item:getId() == itemId and removed < quantityToRemove then
                if not (RentalSystem and RentalSystem.isRentalItem and RentalSystem.isRentalItem(item)) then
                    local toRemove = math.min(item:getCount(), quantityToRemove - removed)
                    if item:remove(toRemove) then
                        removed = removed + toRemove
                    end
                end
            end
            if removed < quantityToRemove and item:isContainer() then
                removed = removed + removeItemFromContainer(item, itemId, quantityToRemove - removed)
            end
            if removed >= quantityToRemove then
                break
            end
        end
    end
    return removed
end

local function countPokemonsInContainer(container, pokeName)
    if not container or not pokeName then
        return 0
    end

    local count = 0
    local pokeNameLower = pokeName:lower()
    for i = 0, container:getSize() - 1 do
        local item = container:getItem(i)
        if item then
            if item:isPokeball() then
                local ballPokeName = item:getSpecialAttribute("pokeName")
                if ballPokeName and ballPokeName:lower() == pokeNameLower and not isRentalPokemonBall(item) then
                    count = count + 1
                end
            elseif item:isContainer() then
                count = count + countPokemonsInContainer(item, pokeName)
            end
        end
    end
    return count
end

local function findPokemonInContainer(container, pokeName)
    if not container or not pokeName then
        return nil
    end

    local pokeNameLower = pokeName:lower()
    for i = 0, container:getSize() - 1 do
        local item = container:getItem(i)
        if item then
            if item:isPokeball() then
                local ballPokeName = item:getSpecialAttribute("pokeName")
                if ballPokeName and ballPokeName:lower() == pokeNameLower and not isRentalPokemonBall(item) then
                    return item
                end
            elseif item:isContainer() then
                local found = findPokemonInContainer(item, pokeName)
                if found then
                    return found
                end
            end
        end
    end
    return nil
end

function removePokemonsFromContainer(container, pokeName, quantityToRemove)
    local removed = 0
    for i = container:getSize() - 1, 0, -1 do
        local item = container:getItem(i)
        if item then
            if item:isPokeball() then
                local ballPokeName = item:getSpecialAttribute("pokeName")
                if ballPokeName and ballPokeName:lower() == pokeName:lower()
                    and not isRentalPokemonBall(item) and removed < quantityToRemove then
                    item:remove()
                    removed = removed + 1
                end
            end
            if removed < quantityToRemove and item:isContainer() then
                removed = removed + removePokemonsFromContainer(item, pokeName, quantityToRemove - removed)
            end
            if removed >= quantityToRemove then
                break
            end
        end
    end
    return removed
end

function handleSell(player, data)
    if not data or not data.type then 
        return false 
    end

    if data.type == "sell" then
        local category = data.category
        local quantityClient = data.quantity or 0

        if quantityClient <= 0 then
            player:popupFYI("Quantidade invalida para venda.")
            return false
        end

        local selectedCat = SELL_DATA.CATEGORY[category]
        if not selectedCat then
            return false
        end

        local item = nil

        if category == "POKEMONS" then
            local pokeName = data.pokeName
            for _, itemData in ipairs(selectedCat) do
                if itemData.type == "pokemon" and itemData.pokeName == pokeName then
                    item = itemData
                    break
                end
            end
        else
            local clientId = math.floor(tonumber(data.id))
            for catName, catItems in pairs(SELL_DATA.CATEGORY) do
                for _, itemData in ipairs(catItems) do
                    if itemData.type == "item" then
                        local itemType = ItemType(itemData.item.id)
                        local itemClientId = math.floor(itemType:getClientId())
                        if itemClientId == clientId then
                            item = itemData
                            break
                        end
                    end
                end
                if item then break end
            end
        end

        if not item then
            player:popupFYI("Item nao encontrado.")
            return false
        end

        local currency = tonumber(item.moeda)
        local price = tonumber(item.valor) * quantityClient

        if item.type == "item" then
            local container = player:getSlotItem(CONST_SLOT_BACKPACK)
            local totalCount = 0
            if container then
                totalCount = countItemInContainer(container, item.item.id)
            end
            local requiredCount = item.item.qtd * quantityClient

            if totalCount < requiredCount then
                player:popupFYI("Voce nao possui itens suficientes para vender.")
                return false
            end
            local removed = removeItemFromContainer(container, item.item.id, item.item.qtd * quantityClient)
            if removed < (item.item.qtd * quantityClient) then
                player:popupFYI("Erro ao remover os itens.")
                return false
            end
            player:addItem(currency, price)
            player:popupFYI("Parabens, sua venda foi bem sucedida.")
            local logFile = io.open("data/logs/game_shop_vendas/shop_sales.txt", "a")
            if logFile then
                local data = os.date("%Y-%m-%d %H:%M:%S")
                local nomeItem = item.item.name
                if not nomeItem or nomeItem == "" then
                    nomeItem = ItemType(item.item.id):getName() or tostring(item.item.id)
                end
                local nomeMoeda = ItemType(currency):getName() or tostring(currency)
                logFile:write(string.format("[VENDA ITEM] [%s] Player: %s | Item: %s | Quantidade: %d | Valor Recebido: %d %s\n", data, player:getName(), nomeItem, item.item.qtd * quantityClient, price, nomeMoeda))
                logFile:close()
            end
            if player.sendSellCategory then
                player:sendSellCategory(category)
            elseif player.sendSellData then
                player:sendSellData()
            end
        elseif item.type == "pokemon" then
            local summons = player:getSummons()
            if summons and #summons > 0 then
                for _, summon in ipairs(summons) do
                    if summon:isPokemon() then
                        player:popupFYI("Guarde seu pokemon na pokeball antes de vender.")
                        return false
                    end
                end
            end
            local container = player:getCatchBag()
            if not container then
                player:popupFYI("Sua Catch Bag nao foi encontrada.")
                return false
            end

            local pokemonCount = 0
            pokemonCount = countPokemonsInContainer(container, item.pokeName)

            if pokemonCount < quantityClient then
                player:popupFYI("Voce nao possui quantidade suficiente deste pokemon para vender. Pokemon alugado nao pode ser vendido.")
                return false
            end
            local wantRefund = (data.wantRefund == true)
            local refundItems = {}
            if wantRefund then
                refundItems = collectAttributeRefundsFromPokeballs(container, item.pokeName, quantityClient)
            end
            local removedCount = removePokemonsFromContainer(container, item.pokeName, quantityClient)
            if removedCount > 0 then
                local finalPrice = tonumber(item.valor) * removedCount
                if wantRefund then
                    finalPrice = math.floor(finalPrice * 0.75)
                end
                player:addItem(currency, finalPrice)
                local refundReceived = {}
                if wantRefund then
                    refundReceived = giveAttributeRefundItems(player, refundItems)
                end
                player:popupFYI(string.format("Parabens, sua venda de %d pokemon(s) foi bem sucedida.", removedCount))
                if wantRefund and #refundReceived > 0 then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu de volta: " .. table.concat(refundReceived, ", ") .. ".")
                end
                local logFile = io.open("data/logs/game_shop_vendas/shop_salespokemon.log", "a")
                if logFile then
                    local dataLog = os.date("%Y-%m-%d %H:%M:%S")
                    local nomeMoeda = ItemType(currency):getName() or tostring(currency)
                    local refundStr = ""
                    if #refundReceived > 0 then
                        refundStr = " | Itens devolvidos: " .. table.concat(refundReceived, ", ")
                    end
                    logFile:write(string.format("[VENDA POKEMON] [%s] Player: %s | Pokemon: %s | Quantidade: %d | Valor Recebido: %d %s%s\n", dataLog, player:getName(), item.pokeName, removedCount, finalPrice, nomeMoeda, refundStr))
                    logFile:close()
                end
                if doSendPokeTeamByClient then
                    doSendPokeTeamByClient(player)
                end
                if player.sendSellCategory then
                    player:sendSellCategory(category)
                elseif player.sendSellData then
                    player:sendSellData()
                end
            else
                player:popupFYI("Erro ao remover os pokemons.")
                return false
            end
        end
    end
    return true
end

_G.handleSell = handleSell

function loadSellJSONCache()
    local ok, encoded = pcall(json.encode, SELL_CACHE)
    if ok and type(encoded) == "string" then
        SELL_JSON = encoded
    else
        SELL_JSON = "{}"
    end
end

function loadSellCache()
    SELL_CACHE = {
        CATEGORY = {},
        ORDEM = SELL_DATA.ORDEM,
        STYLES = SELL_DATA.STYLES,
        CATEGORYINFO = SELL_DATA.CATEGORYINFO
    }

    for category, list in pairs(SELL_DATA.CATEGORY) do
        SELL_CACHE.CATEGORY[category] = {}
        for id, itemData in ipairs(list) do
            SELL_CACHE.CATEGORY[category][id] = {
                type = itemData.type,
                valor = tonumber(itemData.valor),
                offset = itemData.offset,
                size = itemData.size,
                backgroundImage = itemData.backgroundImage,
                moeda = ItemType(itemData.moeda):getClientId()
            }

            if itemData.type == "outfit" then
                SELL_CACHE.CATEGORY[category][id].lookType = itemData.lookType
                SELL_CACHE.CATEGORY[category][id].name = itemData.name
                SELL_CACHE.CATEGORY[category][id].animated = itemData.animated or false
            elseif itemData.type == "item" then
                local itemType = ItemType(itemData.item.id)
                local clientId = math.floor(itemType:getClientId())
                SELL_CACHE.CATEGORY[category][id].item = {id = clientId, qtd = itemData.item.qtd, name = itemType:getName()}
            elseif itemData.type == "pokemon" then
                local mType = MonsterType(itemData.pokeName)
                if mType then
                    SELL_CACHE.CATEGORY[category][id].lookType = {type = mType:outfit().lookType or 0}
                    SELL_CACHE.CATEGORY[category][id].bonus = {boost = itemData.bonus.boost}
                    SELL_CACHE.CATEGORY[category][id].pokeName = itemData.pokeName
                    SELL_CACHE.CATEGORY[category][id].rank = mType:pokemonRank() or "A"
                end
            end
        end
    end
end

function loadSell()
    if not isSellLoaded then
        loadSellCache()
        loadSellJSONCache()
        isSellLoaded = true
    end
end

local function cloneSellEntryForPlayer(entry, availableQuantity)
    local cloned = {}
    for key, value in pairs(entry) do
        cloned[key] = value
    end

    if entry.item then
        cloned.item = {
            id = entry.item.id,
            qtd = entry.item.qtd,
            name = entry.item.name
        }
    end

    if entry.lookType then
        cloned.lookType = {}
        for key, value in pairs(entry.lookType) do
            cloned.lookType[key] = value
        end
    end

    if entry.bonus then
        cloned.bonus = {}
        for key, value in pairs(entry.bonus) do
            cloned.bonus[key] = value
        end
    end

    cloned.availableQuantity = availableQuantity or 0
    return cloned
end

local function buildSellCategoryItemsForPlayer(player, categoryName)
    local categoryItems = SELL_CACHE.CATEGORY[categoryName]
    if not categoryItems then
        return nil
    end

    local payloadItems = {}
    local filterByInventory = (categoryName == "TMS" or categoryName == "CELULAS")

    for _, entry in ipairs(categoryItems) do
        local availableQuantity = 0
        if categoryName == "POKEMONS" then
            availableQuantity = player:getSellableQuantity(categoryName, nil, entry.pokeName)
        elseif entry.item and entry.item.id then
            availableQuantity = player:getSellableQuantity(categoryName, entry.item.id, nil)
        end

        if (not filterByInventory) or availableQuantity > 0 then
            table.insert(payloadItems, cloneSellEntryForPlayer(entry, availableQuantity))
        end
    end

    return payloadItems
end

function Player:sendSellStructure()
    loadSell()

    local structure = {
        ORDEM = SELL_CACHE.ORDEM,
        STYLES = SELL_CACHE.STYLES,
        CATEGORYINFO = SELL_CACHE.CATEGORYINFO,
        type = "structure"
    }

    local ok, encoded = pcall(json.encode, structure)
    if not ok or type(encoded) ~= "string" then
        encoded = "{}"
    end

    return self:sendExtendedOpcode(OPCODE_NEW_SELL, encoded)
end

function Player:sendSellCategory(categoryName)
    loadSell()

    if not categoryName or not SELL_CACHE.CATEGORY[categoryName] then
        return false
    end

    local categoryData = {
        type = "category",
        category = categoryName,
        items = buildSellCategoryItemsForPlayer(self, categoryName)
    }

    local ok, encoded = pcall(json.encode, categoryData)
    if not ok or type(encoded) ~= "string" then
        encoded = "{}"
    end

    return self:sendExtendedOpcode(OPCODE_NEW_SELL, encoded)
end

function Player:sendSellData()
    return self:sendSellStructure()
end

function onLogin(player)
    return true
end

function Player:hasPokemon(pokeName)
    local container = self:getCatchBag()
    if not container then return false end

    local ball = findPokemonInContainer(container, pokeName)
    if ball then
        return true, ball
    end
    return false
end

function Player:removePokemon(pokeName)
    local hasPoke, ball = self:hasPokemon(pokeName)
    if hasPoke and ball then
        ball:remove()
        return true
    end
    return false
end

function Player:getSellableQuantity(category, itemId, pokeName)
    local quantity = 0

    if category == "POKEMONS" then
        local container = self:getCatchBag()
        quantity = countPokemonsInContainer(container, pokeName)
    else
        local container = self:getSlotItem(CONST_SLOT_BACKPACK)
        if container then
            local serverId = 0
            for _, itemData in ipairs(SELL_DATA.CATEGORY[category]) do
                if itemData.type == "item" then
                    local itemType = ItemType(itemData.item.id)
                    local clientId = math.floor(itemType:getClientId())
                    if clientId == itemId then
                        serverId = itemData.item.id
                        break
                    end
                end
            end

            if serverId > 0 then
                for i = 0, container:getSize() - 1 do
                    local item = container:getItem(i)
                    if item then
                        if item:isContainer() then
                            for j = 0, item:getSize() - 1 do
                                local containerItem = item:getItem(j)
                                if containerItem and containerItem:getId() == serverId then
                                    quantity = quantity + containerItem:getCount()
                                end
                            end
                        elseif item:getId() == serverId then
                            quantity = quantity + item:getCount()
                        end
                    end
                end
            end
        end
    end

    return quantity
end 
