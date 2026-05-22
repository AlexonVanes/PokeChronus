
local mType = Game.createMonsterType("Sabrina's Espeon")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Sabrina's Espeon"
pokemon.experience = 0
pokemon.outfit = {
    lookType = 847
}

pokemon.health = 14796
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
    speed = 220
}

pokemon.flags = {
    minimumLevel = 80,
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
    pokemonRank = "",
    hasShiny = 0,
    hasMega = 0,
    moveMagicAttackBase = 300,
    moveMagicDefenseBase = 300,
    catchChance = 250,
    canControlMind = 0,
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
    {text = "ABUUUH!", yell = FALSE},
}

pokemon.loot = {
{id = "enchanted gem", chance = 8000000, maxCount = 13},
{id = "future orb", chance = 3250000, maxCount = 1},
{id = "darkness stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 200},
    {name = "Swift", power = 7, interval = 1000},
    {name = "Bite", power = 9, interval = 1500},
    {name = "Psywave", power = 7, interval = 1000},
    {name = "Psy Pulse", power = 12, interval = 1200},
    {name = "Confusion", power = 10, interval = 3000},
    {name = "Psychic", power = 15, interval = 2500},
    {name = "Psyshock", power = 25, interval = 3000},
    {name = "Trick Room", power = 30, interval = 6000},
    {name = "Miracle Eye", power = 0, interval = 1500},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Swift", power = 7, interval = 5000, chance = 100},
    {name = "Bite", power = 9, interval = 3500, chance = 100},
    {name = "Psywave", power = 7, interval = 4000, chance = 100},
    {name = "Psy Pulse", power = 12, interval = 4200, chance = 100},
    {name = "Confusion", power = 10, interval = 3000, chance = 100},
    {name = "Psychic", power = 15, interval = 5500, chance = 100},
    {name = "Psyshock", power = 25, interval = 6000, chance = 100},
    {name = "Trick Room", power = 30, interval = 7000, chance = 100},
    {name = "Miracle Eye", power = 0, interval = 1500, chance = 100},
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
