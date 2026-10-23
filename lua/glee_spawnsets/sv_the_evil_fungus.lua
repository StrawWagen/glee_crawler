
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

-- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
local function neverStale( _, spawned )
    spawned.glee_NoEnemyToRemove = math.huge

end
-- hunters spawn 20 up and fall, but the fungus seeds where it stands and only grows along a surface
local function seedOnFloor( _, spawned, spawnPos )
    local tr = util.TraceLine( { start = spawnPos, endpos = spawnPos - Vector( 0, 0, 64 ), mask = MASK_SOLID_BRUSHONLY } )
    if not tr.Hit or tr.StartSolid then return end
    spawned.SpawnAt = tr.HitPos
    spawned.SpawnUp = tr.HitNormal

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
            maxCount = 3,  -- this one does not check :Health
            difficultyCost = { 10 },
            preSpawnedFuncs = { seedOnFloor },
            postSpawnedFuncs = { neverStale },
        },
        {
            name = "a_fungus_EXTRA", -- and some more later as difficulty goes up
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 8,  -- this one does not check :Health
            difficultyCost = { 150 },
            preSpawnedFuncs = { seedOnFloor },
            postSpawnedFuncs = { neverStale },
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
