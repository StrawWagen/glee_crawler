local set = {
    name = "the_evil_crawler", -- unique name
    prettyName = "The Crawler",
    description = "It... Crawls...",
    maxSpawnCount = 10, -- hard cap on count , this one checks :Health
    startingSpawnCount = 1,
    chanceToBeVotable = 0.25,
    chanceToBeVotableIfHard = 6,

    roundStartSound = "common/null.wav",

    -- FAR AWAY FROM THE PLAYER
    maxSpawnDist = 10000,
    minSpawnDist = "default",

    resourcesAdded = { "3818771209" },

    spawns = {
        {
            name = "the_crawler",
            prettyName = "The Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            difficultyCost = { 10 },
            countClass = "evil_crawler",
            maxCount = 1, -- this one does not check :Health
            isBoss = true,
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
