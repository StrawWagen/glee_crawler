
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

-- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
local function neverStale( _, spawned )
    spawned.glee_NoEnemyToRemove = math.huge

end

local set = {
    name = "the_evil_fungus", -- unique name
    prettyName = "The Rot",
    description = "It spreads...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.15,
    chanceToBeVotableWhenHard = 3,

    roundStartSound = "common/null.wav",

    -- FAR AWAY FROM THE PLAYER
    maxSpawnDist = 10000,
    minSpawnDist = "default",

    resourcesAdded = { "3821991353" },

    spawns = {
        {
            name = "a_fungus", -- spawn 1 fungus at the start
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 1,  -- this one does not check :Health
            difficultyCost = { 10 },
            postSpawnedFuncs = { neverStale },
        },
        {
            name = "a_fungus_EXTRA", -- and some more later as difficulty goes up
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 3,  -- this one does not check :Health
            difficultyCost = { 150 },
            postSpawnedFuncs = { neverStale },
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
