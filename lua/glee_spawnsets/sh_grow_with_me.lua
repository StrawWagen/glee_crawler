
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

local set = {
    name = "grow_with_me", -- unique name
}

if SERVER then
    -- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
    local function neverStale( _, spawned )
        spawned.glee_NoEnemyToRemove = math.huge

    end

    local setSv = {
        prettyName = "grow with me",
        description = "grow with me",
        maxSpawnCount = 20, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableWhenHard = 2,

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
                maxCount = 1,  -- this one does not check :Health
                difficultyCost = { 10 },
                postSpawnedFuncs = { neverStale },
            },
            {
                name = "a_fungus_EXTRA",
                prettyName = "The Fungus",
                class = "evil_fungus",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_fungus",
                maxCount = 3,  -- this one does not check :Health
                difficultyCost = { 100 },
                postSpawnedFuncs = { neverStale },
            },
        },
    }
    table.Merge( set, setSv )

end

function set:Activate()
    GAMEMODE.setHelpers.makeHardcore( self )
    GAMEMODE.setHelpers.addDefaultWeapon( self, "weapon_glee_crapvidcam" )

end

if SERVER then
    hook.Add( "PlayerSay", "glee_growwithme_secret", function( sender, text )
        if text ~= "grow with me" then return end
        if GAMEMODE:GetSpawnSet() == "grow_with_me" then return end

        sender.glee_SaidGrowWithMe = true

        local humans = player.GetHumans()
        for _, ply in ipairs( humans ) do
            if not ply.glee_SaidGrowWithMe then return end

        end
        for _, ply in ipairs( humans ) do
            ply.glee_SaidGrowWithMe = nil

        end
        RunConsoleCommand( "huntersglee_spawnset", "grow_with_me" )

    end )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
