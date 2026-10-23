
local crawler = scripted_ents.GetStored( "evil_crawler" )
if not crawler then return end

local set = {
    name = "the_evil_crawlers", -- unique name
    prettyName = "The Crawlers",
    description = "They hunger...",
    maxSpawnCount = 20, -- hard cap on count , this one checks :Health
    chanceToBeVotable = 0.5,
    chanceToBeVotableWhenHard = 10,

    roundStartSound = "common/null.wav",

    -- FAR AWAY FROM THE PLAYER
    maxSpawnDist = 10000,
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
            difficultyCost = { 150 },
        },
    },
}

if scripted_ents.GetStored( "evil_fungus" ) then
    -- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
    local function neverStale( _, fungus )
        fungus.glee_NoEnemyToRemove = math.huge

    end
    -- hunters spawn 20 up and fall, but the fungus seeds where it stands and only grows along a surface
    local function seedOnFloor( _, fungus, spawnPos )
        local tr = util.TraceLine( { start = spawnPos, endpos = spawnPos - Vector( 0, 0, 64 ), mask = MASK_SOLID_BRUSHONLY } )
        if not tr.Hit or tr.StartSolid then return end
        fungus.SpawnAt = tr.HitPos
        fungus.SpawnUp = tr.HitNormal

    end

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
        preSpawnedFuncs = { seedOnFloor },
        postSpawnedFuncs = { neverStale },
    } )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
