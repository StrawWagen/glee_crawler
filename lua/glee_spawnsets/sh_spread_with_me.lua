
local fungus = scripted_ents.GetStored( "evil_fungus" )
if not fungus then return end

local set = {
    name = "spread_with_me", -- unique name
}

if SERVER then
    local neverStale = GAMEMODE.setHelpers.postSpawnedNeverStale
    local seedFungus = GAMEMODE.setHelpers.preSpawnedSeedFungus

    local setSv = {
        prettyName = "spread with me",
        description = "spread with me",
        maxSpawnCount = 40, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableWhenHard = 3,

        genericSpawnerRate = 2, -- less item spawns

        waveInterval = "default*0.25",

        roundStartSound = "common/null.wav",

        maxSpawnDist = "default",
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
                preSpawnedFuncs = { seedFungus },
                postSpawnedFuncs = { neverStale },
                removeAfterStillSeconds = 30,
            },
            {
                name = "a_fungus_EXTRA",
                prettyName = "The Fungus",
                class = "evil_fungus",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_fungus",
                maxCount = 15,  -- this one does not check :Health
                difficultyCost = { 50, 100 },
                preSpawnedFuncs = { seedFungus },
                postSpawnedFuncs = { neverStale },
                removeAfterStillSeconds = 30,
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
        RunConsoleCommand( "huntersglee_misery", "spread_with_me" )

    end, HOOK_MONITOR_LOW )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
