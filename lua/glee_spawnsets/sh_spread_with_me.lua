
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

local set = {
    name = "spread_with_me", -- unique name
}

if SERVER then
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

    local setSv = {
        prettyName = "spread with me",
        description = "spread with me",
        maxSpawnCount = 20, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableWhenHard = 3,

        genericSpawnerRate = 2, -- less item spawns

        roundStartSound = "common/null.wav",

        -- FAR AWAY FROM THE PLAYER
        maxSpawnDist = 10000,
        minSpawnDist = "default",

        resourcesAdded = { "3821991353" },

        spawns = {
            {
                name = "a_fungus",
                prettyName = "The Fungus",
                class = "evil_fungus",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_fungus",
                maxCount = 2,  -- this one does not check :Health
                difficultyCost = { 10 },
                preSpawnedFuncs = { seedOnFloor },
                postSpawnedFuncs = { neverStale },
            },
            {
                name = "a_fungus_EXTRA",
                prettyName = "The Fungus",
                class = "evil_fungus",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_fungus",
                maxCount = 6,  -- this one does not check :Health
                difficultyCost = { 50, 100 },
                preSpawnedFuncs = { seedOnFloor },
                postSpawnedFuncs = { neverStale },
            },
        },
    }
    if scripted_ents.GetStored( "evil_crawler" ) then
        table.insert( setSv.resourcesAdded, "3818771209" )
        table.insert( setSv.spawns, {
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
    table.Merge( set, setSv )

end

function set:Activate()
    GAMEMODE.setHelpers.makeHardcore( self )
    GAMEMODE.setHelpers.addDefaultWeapon( self, "weapon_glee_crapvidcam" )

end

if SERVER then
    hook.Add( "PlayerSay", "glee_spreadwithme_secret", function( sender, text )
        if text ~= "spread with me" then return end
        if GAMEMODE:GetSpawnSet() == "spread_with_me" then return end

        sender.glee_SaidSpreadWithMe = true

        local humans = player.GetHumans()
        for _, ply in ipairs( humans ) do
            if not ply.glee_SaidSpreadWithMe then return end

        end
        for _, ply in ipairs( humans ) do
            ply.glee_SaidSpreadWithMe = nil

        end
        RunConsoleCommand( "huntersglee_spawnset", "spread_with_me" )

    end, HOOK_MONITOR_LOW )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
