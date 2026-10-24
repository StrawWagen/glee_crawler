
local snake = scripted_ents.GetStored( "evil_snake" )
if not snake then return end

local set = {
    name = "slither_with_me", -- unique name
}

if SERVER then
    local hasFungus = scripted_ents.GetStored( "evil_fungus" )

    local neverStale = GAMEMODE.setHelpers.postSpawnedNeverStale
    local seedFungus = GAMEMODE.setHelpers.preSpawnedSeedFungus

    local setSv = {
        prettyName = "slither with me",
        description = "slither with me",
        maxSpawnCount = 20, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableWhenHard = 2,

        genericSpawnerRate = 2, -- less item spawns

        roundStartSound = "common/null.wav",

        -- FAR AWAY FROM THE PLAYER
        maxSpawnDist = "default",
        minSpawnDist = "default",

        resourcesAdded = { "3823748254" },

        spawns = {
            {
                name = "a_snake",
                prettyName = "A Snake",
                class = "evil_snake",
                spawnType = "hunter",
                preferredEFlags = GAMEMODE.NavEFlags.UNDER_SKY,
                scaryAsATerminator = true,
                countClass = "evil_snake",
                maxCount = 2,  -- this one does not check :Health
                difficultyCost = { 10 },
            },
            {
                name = "a_snake_EXTRA",
                prettyName = "A Snake",
                class = "evil_snake",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_snake",
                maxCount = 8,  -- this one does not check :Health
                difficultyCost = { 50, 100 },
            },
        },
    }
    if hasFungus then
        table.insert( setSv.resourcesAdded, "3821991353" )
        table.insert( setSv.spawns, {
            name = "a_fungus",
            prettyName = "The Fungus",
            class = "evil_fungus",
            spawnType = "hunter",
            scaryAsATerminator = true,
            countClass = "evil_fungus",
            maxCount = 2,
            difficultyCost = { 50 },
            difficultyNeeded = { 50, 500 }, -- rerolled each round, early in some, late in others
            preSpawnedFuncs = { seedFungus },
            postSpawnedFuncs = { neverStale },
        } )
    end
    table.Merge( set, setSv )

end

function set:Activate()
    GAMEMODE.setHelpers.makeHardcore( self )
    GAMEMODE.setHelpers.addDefaultWeapon( self, "weapon_glee_crapvidcam" )

end

if SERVER then
    hook.Add( "PlayerSay", "glee_slitherwithme_secret", function( sender, text )
        if text ~= "slither with me" then return end
        if GAMEMODE:GetSpawnSet() == "slither_with_me" then return end

        sender.glee_SaidSlitherWithMe = true

        local humans = player.GetHumans()
        for _, ply in ipairs( humans ) do
            if not ply.glee_SaidSlitherWithMe then return end

        end
        for _, ply in ipairs( humans ) do
            ply.glee_SaidSlitherWithMe = nil

        end
        RunConsoleCommand( "huntersglee_misery", "slither_with_me" )

    end, HOOK_MONITOR_LOW )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
