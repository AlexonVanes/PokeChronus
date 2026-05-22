
local mType = Game.createMonsterType("Gligar")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Gligar"
pokemon.experience = 625
pokemon.outfit = {
    lookType = 883
}

pokemon.health = 2897
pokemon.maxHealth = pokemon.health
pokemon.race = "ground"
pokemon.race2 = "flying"
pokemon.corpse = 27068
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
    minimumLevel = 20,
    maximumLevel = 30,
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
    moveMagicAttackBase = 65,
    moveMagicDefenseBase = 55,
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
        pokeName = "Gliscor",
        level = 100,
        chance = 100,
        stones = {
            {stoneId = 26743, stoneCount = 1},
            {stoneId = 26742, stoneCount = 1}
        } --water = 26736, fire = 26728, leaf = 26731, cocoon = 26724, heart = 26729, venom = 26735,thunder = 26734
    } --enigma = 26727, earth = 26742, punch = 26732,crystal = 26725, ancient = 26749, feather = 26743 ice = 26730
} --steel = 26747, rock = 26733 darkness = 26726

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
{id = "straw", chance = 8000000, maxCount = 4},
{id = "rubber ball", chance = 3250000, maxCount = 1},
{id = "feather stone", chance = 150000, maxCount = 1},
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
{id = "earth stone", chance = 150000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Sand Attack", power = 7, interval = 8000},
    {name = "Slash", power = 9, interval = 10000},
    {name = "Dig", power = 5, interval = 40000},
    {name = "U-Turn", power = 15, interval = 10000},
    {name = "X-Scissor", power = 15, interval = 30000},
    {name = "Fury Cutter", power = 7, interval = 18000},
    {name = "Guillotine", power = 7, interval = 40000},
    {name = "Harden", power = 0, interval = 40000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Sand Attack", power = 7, interval = 8000, chance = 100},
    {name = "Slash", power = 9, interval = 10000, chance = 100},
    {name = "Dig", power = 5, interval = 40000, chance = 100},
    {name = "U-Turn", power = 15, interval = 10000, chance = 100},
    {name = "X-Scissor", power = 15, interval = 30000, chance = 100},
    {name = "Fury Cutter", power = 7, interval = 18000, chance = 100},
    {name = "Guillotine", power = 7, interval = 40000, chance = 100},
    {name = "Harden", power = 0, interval = 40000, chance = 100},
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


