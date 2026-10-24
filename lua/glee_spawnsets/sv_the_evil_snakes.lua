
local snake = scripted_ents.GetStored( "evil_snake" )
if not snake then return end

local set = {
    name = "the_evil_snakes", -- unique name
    prettyName = "The Snakes",
    description = "They slither...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.15,
    chanceToBeVotableWhenHard = 4,

    roundStartSound = "common/null.wav",

    maxSpawnDist = "default*0.5",
    minSpawnDist = "default*0.5",

    resourcesAdded = { "3823748254" },

    spawns = {
        {
            name = "a_snake", -- spawn 1 snake at the start
            prettyName = "A Snake",
            class = "evil_snake",
            spawnType = "hunter",
            preferredEFlags = GAMEMODE.NavEFlags.UNDER_SKY,
            scaryAsATerminator = true,
            countClass = "evil_snake",
            maxCount = 2,  -- this one does not check :Health
            difficultyCost = { 10 },
        },
        {
            name = "a_snake_EXTRA", -- and some more later as difficulty goes up
            prettyName = "A Snake",
            class = "evil_snake",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_snake",
            maxCount = 8,  -- this one does not check :Health
            difficultyCost = { 75, 100 },
        },
    },
}

if scripted_ents.GetStored( "evil_fungus" ) then
    local neverStale = GAMEMODE.setHelpers.postSpawnedNeverStale
    local seedFungus = GAMEMODE.setHelpers.preSpawnedSeedFungus

    table.insert( set.resourcesAdded, "3821991353" )
    table.insert( set.spawns, {
        name = "a_fungus",
        prettyName = "The Fungus",
        class = "evil_fungus",
        spawnType = "hunter",
        scaryAsATerminator = true,
        countClass = "evil_fungus",
        maxCount = 3,
        difficultyCost = { 50 },
        difficultyNeeded = { 50, 500 }, -- rerolled each round, early in some, late in others
        preSpawnedFuncs = { seedFungus },
        postSpawnedFuncs = { neverStale },
        removeAfterStillSeconds = 30,
    } )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
