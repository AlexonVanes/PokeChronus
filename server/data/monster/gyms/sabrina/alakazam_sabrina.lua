
local mType = Game.createMonsterType("Sabrina's Alakazam")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Sabrina's Alakazam"
pokemon.experience = 0
pokemon.outfit = {
    lookType = 65
}

pokemon.health = 16156
pokemon.maxHealth = pokemon.health
pokemon.race = "psychic"
pokemon.race2 = "none"
pokemon.corpse = 0
pokemon.speed = 180
pokemon.maxSummons = 0

pokemon.changeTarget = {
    interval = 4*1000,
    chance = 20
}
pokemon.wild = {
    health = pokemon.health * 1.8,
    maxHealth = pokemon.health * 1.8,
    speed = 280  -- Pode ajustar a velocidade se necess�rio
}

pokemon.flags = {
    minimumLevel = 100,
    attackable = true,
    summonable = true,
    passive = false,
    hostile = true,
    convinceable = true,
    illusionable = true,
    canPushItems = false,
    canPushCreatures = false,
    targetDistance = 1,
    staticAttackChance = 97,
    pokemonRank = "T2",
    funcao = "burstdmg",
    hasShiny = 1,
    hasMega = 0,
    moveMagicAttackBase = 160,
    moveMagicDefenseBase = 130,
    catchChance = 10,
    canControlMind = 1,
    canLevitate = 0,
    canLight = 0,
    canCut = 0,
    canSmash = 0,
    canDig = 0,
    canTeleport = 0,
    canBlink = 0,
    isSurfable = 0,
    isRideable = 0,
    isFlyable = 0,
}

pokemon.events = {
    "MonsterHealthChange"
}
pokemon.summons = {}

pokemon.voices = {
    interval = 5000,
    chance = 65,
    {text = "ZAAM", yell = FALSE},
    {text = "Alakaaa", yell = FALSE},
}

pokemon.loot = {
{id = "seed", chance = 5000000, maxCount = 235,
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "enigma stone", chance = 8000000, maxCount = 1},
},
    {id = "leaves", chance = 2000000, maxCount = 7},
    {id = "leaf stone", chance = 10000},
}
pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Swift", power = 7, interval = 1000},
    {name = "Bite", power = 9, interval = 1500},
    {name = "Psywave", power = 7, interval = 1000},
    {name = "Psy Pulse", power = 12, interval = 1200},
    {name = "Confusion", power = 10, interval = 3000},
    {name = "Psychic", power = 15, interval = 2500},
    {name = "Psyshock", power = 25, interval = 3000},
    {name = "Trick Room", power = 30, interval = 6000},
    -- {name = "Control Mind", power = 0, interval = 1500},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 200000, chance = 10000},
    {name = "Swift", power = 7, interval = 10000000, chance = 1000000},
    {name = "Bite", power = 9, interval = 15000000, chance = 1000000},
    {name = "Psywave", power = 7, interval = 10000000, chance = 1000000},
    {name = "Psy Pulse", power = 12, interval = 12000000, chance = 100000},
    {name = "Confusion", power = 10, interval = 30000000, chance = 100000},
    {name = "Psychic", power = 15, interval = 25000000, chance = 100000},
    {name = "Psyshock", power = 25, interval = 30000000, chance = 100000},
    {name = "Trick Room", power = 30, interval = 60000000, chance = 100000},
    {name = "Miracle Eye", power = 0, interval = 15000000, chance = 100000},
}



pokemon.defenses = {}

pokemon.elements = {}

pokemon.immunities = {}

mType.onThink = function(pokemon, interval)
end

mType.onAppear = function(pokemon, creature)
end

mType.onDisappear = function(pokemon, creature)
end

mType.onMove = function(pokemon, creature, fromPosition, toPosition)
end

mType.onSay = function(pokemon, creature, type, message)
end

mType:register(pokemon)
