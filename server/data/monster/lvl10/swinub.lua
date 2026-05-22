
local mType = Game.createMonsterType("Swinub")
local pokemon = {}
pokemon.eventFile = false -- will try to load the file example.lua in data/scripts/pokemons/events
pokemon.eventFile = "default" -- will try to load the file test.lua in data/scripts/pokemons/events
pokemon.description = "a Swinub"
pokemon.experience = 103
pokemon.outfit = {
    lookType = 896
}

pokemon.health = 932
pokemon.maxHealth = pokemon.health
pokemon.race = "ice"
pokemon.race2 = "ground"
pokemon.corpse = 27081
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
    minimumLevel = 15,
    maximumLevel = 25,
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
    moveMagicAttackBase = 15,
    moveMagicDefenseBase = 10,
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
        pokeName = "Piloswine",
        level = 80,
        chance = 100,
        stones = {
            {stoneId = 26730, stoneCount = 1},
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
{id = "earth ball", chance = 8000000, maxCount = 13},
{id = "sandbag", chance = 3250000, maxCount = 1},
{id = "snow ball", chance = 8000000, maxCount = 13},
{id = "ice orb", chance = 3250000, maxCount = 1},
}

pokemon.moves = {
	{name = "melee", power = 3, interval = 2000},
    {name = "Tackle", power = 7, interval = 10000},
    {name = "Mud-Slap", power = 7, interval = 25000},
    {name = "Mud Bomb", power = 7, interval = 25000},
    {name = "Ice Fang", power = 10, interval = 25000},
    {name = "Ice Wind", power = 7, interval = 20000},
    {name = "Frost Breath", power = 15, interval = 20000},
}



pokemon.attacks = {
	{name = "melee", power = 3, interval = 2000, chance = 100},
    {name = "Tackle", power = 7, interval = 10000, chance = 100},
    {name = "Mud-Slap", power = 7, interval = 25000, chance = 100},
    {name = "Mud Bomb", power = 7, interval = 25000, chance = 100},
    {name = "Ice Fang", power = 10, interval = 25000, chance = 100},
    {name = "Ice Wind", power = 7, interval = 20000, chance = 100},
    {name = "Frost Breath", power = 15, interval = 20000, chance = 100},
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


