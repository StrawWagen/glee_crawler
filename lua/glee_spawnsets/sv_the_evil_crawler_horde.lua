
local crawler = scripted_ents.GetStored( "evil_crawler" )
if not crawler then return end

local set = {
    name = "the_evil_crawler_horde", -- unique name
    prettyName = "The Great Crawler Migration",
    description = "they crawl through here every season...",
    startingSpawnCount = { 5, 10 },
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.05,
    chanceToBeVotableWhenHard = 1,

    roundStartSound = "common/null.wav",

    maxSpawnDist = "default*1.5",
    minSpawnDist = "default",

    resourcesAdded = { "3818771209" },

    spawns = {
        {
            name = "a_crawler",
            prettyName = "A Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_crawler",
            difficultyCost = { 2 }, -- startingBudget 20 has to afford all 10 of the first wave
        },
    },
}

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
