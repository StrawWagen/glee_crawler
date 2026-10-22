
local crawler = scripted_ents.GetStored( "evil_crawler" )
if not crawler then return end
local snake = scripted_ents.GetStored( "evil_snake" )
if not snake then return end
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

-- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
local function neverStale( _, spawned )
    spawned.glee_NoEnemyToRemove = math.huge

end

local set = {
    name = "the_evil_everything", -- unique name
    prettyName = "The Nest",
    description = "They crawl... They slither... It spreads...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.02, -- very very rare, and no WhenHard so it stays that way

    roundStartSound = "common/null.wav",

    -- FAR AWAY FROM THE PLAYER
    maxSpawnDist = 10000,
    minSpawnDist = "default",

    resourcesAdded = { "3818771209", "3823748254", "3821991353" },

    spawns = {
        {
            name = "a_crawler", -- spawn 1 crawler at the start
            prettyName = "A Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_crawler",
            maxCount = 1,  -- this one does not check :Health
            difficultyCost = { 10 },
        },
        {
            name = "a_snake", -- and 1 snake
            prettyName = "A Snake",
            class = "evil_snake",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_snake",
            maxCount = 1,  -- this one does not check :Health
            difficultyCost = { 10 },
        },
        {
            name = "a_crawler_EXTRA", -- and some more later as difficulty goes up
            prettyName = "A Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_crawler",
            maxCount = 4,  -- this one does not check :Health
            difficultyCost = { 120, 180 }, -- the pricier _EXTRA gets picked first, so let the dearer one swap between rounds
        },
        {
            name = "a_snake_EXTRA",
            prettyName = "A Snake",
            class = "evil_snake",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_snake",
            maxCount = 4,  -- this one does not check :Health
            difficultyCost = { 120, 180 },
        },
        {
            name = "a_fungus",
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 3,
            difficultyCost = { 50 },
            difficultyNeeded = { 50, 500 }, -- rerolled each round, early in some, late in others
            postSpawnedFuncs = { neverStale },
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
