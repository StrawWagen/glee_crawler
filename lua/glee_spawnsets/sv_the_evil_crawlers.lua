local set = {
    name = "the_evil_crawlers", -- unique name
    prettyName = "The Crawlers",
    description = "They hunger...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.15,
    chanceToBeVotableIfHard = 3,

    roundStartSound = "common/null.wav",

    -- FAR AWAY FROM THE PLAYER
    maxSpawnDist = 10000,
    minSpawnDist = 5000,

    resourcesAdded = { "3818771209" },

    spawns = {
        {
            name = "a_crawler",
            prettyName = "A Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            countClass = "evil_crawler",
            maxCount = 12,  -- this one does not check :Health
            difficultyCost = { 10 },
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
