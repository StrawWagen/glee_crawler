
local crawler = scripted_ents.GetStored( "evil_crawler" )
if not crawler then return end

local set = {
    name = "the_evil_crawlers", -- unique name
    prettyName = "The Crawlers",
    description = "They hunger...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 15,

    roundStartSound = "common/null.wav",

    maxSpawnDist = "default*1.5",
    minSpawnDist = "default",

    resourcesAdded = { "3818771209" },

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
            name = "a_crawler_EXTRA", -- and some more later as difficulty goes up
            prettyName = "A Crawler",
            class = "evil_crawler",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_crawler",
            maxCount = 6,  -- this one does not check :Health
            difficultyCost = { 50, 100 },
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
    } )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
