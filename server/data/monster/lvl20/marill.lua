
local mType = Game.createMonsterType("Marill")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Marill"
pokemon.experience = 243
pokemon.outfit = {
    lookType = 834
}

pokemon.health = 1640
pokemon.maxHealth = pokemon.health
pokemon.race = "water"
pokemon.race2 = "fairy"
pokemon.corpse = 27044
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
    minimumLevel = 10,
    maximumLevel = 20,
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
    hasShiny = 1,
    hasMega = 0,
    moveMagicAttackBase = 25,
    moveMagicDefenseBase = 15,
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

pokemon.evolutions = {
    {
        pokeName = "Azumarill",
        level = 80,
        chance = 100,
        stones = {
            {stoneId = 26736, stoneCount = 2}
        } --water = 26736, fire = 26728, leaf = 26731, cocoon = 26724, heart = 26729, venom = 26735,thunder = 26734
    } --enigma = 26727, earth = 26742, punch = 26732,crystal = 26725, ancient = 26749, feather = 26743 ice = 26730
} --ice =26726, steel = 26747, rock = 26733 

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
{id = "rubber ball", chance = 8000000, maxCount = 13},
{id = "comb", chance = 1950000, maxCount = 1},
{id = "water gem", chance = 8000000, maxCount = 13},
{id = "water pendant", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Tackle", power = 7, interval = 10000},
    {name = "Aqua Tail", power = 8, interval = 10000},
    {name = "Water Gun", power = 8, interval = 15000},
    {name = "Waterfall", power = 20, interval = 30000},
    {name = "Bubble Beam", power = 10, interval = 30000},
    {name = "Rain Dance", power = 0, interval = 40000},
    {name = "Defense Curl", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Tackle", power = 7, interval = 10000, chance = 100},
    {name = "Aqua Tail", power = 8, interval = 10000, chance = 100},
    {name = "Water Gun", power = 8, interval = 15000, chance = 100},
    {name = "Waterfall", power = 20, interval = 30000, chance = 100},
    {name = "Bubble Beam", power = 10, interval = 30000, chance = 100},
    {name = "Rain Dance", power = 0, interval = 40000, chance = 100},
    {name = "Defense Curl", power = 7, interval = 40000, chance = 100},
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


