local set = {
    name = "the_evil_crawler", -- unique name
}

if SERVER then
    local setSv = {
        prettyName = "The Crawler",
        description = "It... Crawls...",
        maxSpawnCount = 1, -- hard cap on count
        startingSpawnCount = 1,
        chanceToBeVotable = 0.25,
        chanceToBeVotableIfHard = 1,

        roundStartSound = "common/null.wav",

        -- FAR AWAY FROM THE PLAYER
        maxSpawnDist = 10000,
        minSpawnDist = 5000,

        resourcesAdded = { "3818771209" },

        spawns = {
            {
                name = "the_crawler",
                prettyName = "The Crawler",
                class = "evil_crawler",
                spawnType = "hunter",
                difficultyCost = { 10 },
                countClass = "evil_crawler",
                maxCount = 1,
                isBoss = true,
            },
        },
    }
    table.Merge( set, setSv )

end

function set:Activate()
    GAMEMODE.setHelpers.makeHardcore( self )

end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
