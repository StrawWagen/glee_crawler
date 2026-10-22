
local crawler = scripted_ents.GetStored( "evil_crawler" )
if not crawler then return end

local set = {
    name = "crawl_with_me", -- unique name
}

if SERVER then
    local hasFungus = scripted_ents.GetStored( "evil_fungus" )

    -- it barely moves and has no GetEnemy, so the spawner's stale check would cull it within a couple minutes
    local function neverStale( _, fungus )
        fungus.glee_NoEnemyToRemove = math.huge

    end

    local setSv = {
        prettyName = "crawl with me",
        description = "crawl with me",
        maxSpawnCount = 20, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableWhenHard = 2,

        genericSpawnerRate = 2, -- less item spawns

        roundStartSound = "common/null.wav",

        -- FAR AWAY FROM THE PLAYER
        maxSpawnDist = 10000,
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
                maxCount = 1,  -- this one does not check :Health
                difficultyCost = { 10 },
            },
            {
                name = "a_crawler_EXTRA",
                prettyName = "A Crawler",
                class = "evil_crawler",
                spawnType = "hunter",
                scaryAsATerminator = true,
                countClass = "evil_crawler",
                maxCount = 6,  -- this one does not check :Health
                difficultyCost = { 100 },
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
    hook.Add( "PlayerSay", "glee_crawlwithme_secret", function( sender, text )
        if text ~= "crawl with me" then return end
        if GAMEMODE:GetSpawnSet() == "crawl_with_me" then return end

        sender.glee_SaidCrawlWithMe = true

        local humans = player.GetHumans()
        for _, ply in ipairs( humans ) do
            if not ply.glee_SaidCrawlWithMe then return end

        end
        for _, ply in ipairs( humans ) do
            ply.glee_SaidCrawlWithMe = nil

        end
        RunConsoleCommand( "huntersglee_spawnset", "crawl_with_me" )

    end )
end

-- put the spawnset IN the global table to be gobbled
table.insert( GLEE_SPAWNSETS, set )
