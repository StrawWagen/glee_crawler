
local set = {
    name = "the_evil_crawlers", -- unique name
    prettyName = "The Evil Crawlers",
    description = "They... Crawl...",
    maxSpawnCount = 5, -- hard cap on count
    chanceToBeVotable = 0.15,
    chanceToBeVotableIfHard = 0.5,

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
            difficultyCost = { 10 },
            isBoss = true,
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
