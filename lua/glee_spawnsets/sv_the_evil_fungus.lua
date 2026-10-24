
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

local neverStale = GAMEMODE.setHelpers.postSpawnedNeverStale
local seedFungus = GAMEMODE.setHelpers.preSpawnedSeedFungus

local set = {
    name = "the_evil_fungus", -- unique name
    prettyName = "The Rot",
    description = "It spreads...",
    maxSpawnCount = 40, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.15,
    chanceToBeVotableWhenHard = 6,

    waveInterval = "default*0.25",

    roundStartSound = "common/null.wav",

    maxSpawnDist = "default*0.25",
    minSpawnDist = "default*0.25",

    resourcesAdded = { "3821991353" },

    spawns = {
        {
            name = "a_fungus", -- spawn 1 fungus at the start
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 3,  -- this one does not check :Health
            difficultyCost = { 10 },
            preSpawnedFuncs = { seedFungus },
            postSpawnedFuncs = { neverStale },
            removeAfterStillSeconds = 30,
        },
        {
            name = "a_fungus_EXTRA", -- and some more later as difficulty goes up
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 15,  -- this one does not check :Health
            difficultyCost = { 50, 100 },
            preSpawnedFuncs = { seedFungus },
            postSpawnedFuncs = { neverStale },
            removeAfterStillSeconds = 30,
        },
    },
}

if scripted_ents.GetStored( "evil_crawler" ) then
    table.insert( set.resourcesAdded, "3818771209" )
    table.insert( set.spawns, {
        name = "a_crawler",
        prettyName = "A Crawler",
        class = "evil_crawler",
        spawnType = "hunter",
        scaryAsATerminator = true,
        countClass = "evil_crawler",
        maxCount = 1,
        difficultyCost = { 10 },
        difficultyNeeded = { 30, 100 },
    } )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
