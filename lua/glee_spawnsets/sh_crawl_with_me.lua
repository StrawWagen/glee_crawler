local set = {
    name = "crawl_with_me", -- unique name
}

if SERVER then
    local setSv = {
        prettyName = "crawl with me",
        description = "crawl with me",
        maxSpawnCount = 20, -- hard cap on count , this one checks :Health
        chanceToBeVotable = 0.15,
        chanceToBeVotableIfHard = 2,

        genericSpawnerRate = 2, -- less spawns

        roundStartSound = "common/null.wav",

        -- FAR AWAY FROM THE PLAYER
        maxSpawnDist = 10000,
        minSpawnDist = 5000,

        resourcesAdded = { "3818771209" },

        spawns = {
            {
                name = "a_crawler",
                prettyName = "A Crawler",
                class = "evil_crawler",
                spawnType = "hunter",
                countClass = "evil_crawler",
                maxCount = 12,  -- this one does not check :Health
                difficultyCost = { 100 },
            },
        },
    }
    table.Merge( set, setSv )

end

function set:Activate()
    GAMEMODE.setHelpers.makeHardcore( self )

    if SERVER then
        self:Hook( "glee_sv_validgmthink_inactive", function()
            for _, ply in ipairs( GAMEMODE:getAlivePlayers() ) do
                if IsValid( ply.glee_CrawlWithMeCam ) then continue end
                local weap = ply:GetWeapon( "weapon_glee_crapvidcam" )
                if IsValid( weap ) then
                    ply.glee_CrawlWithMeCam = weap
                    continue

                end
                ply.glee_CrawlWithMeCam = ply:Give( "weapon_glee_crapvidcam" )

            end
        end )
    end
end

if SERVER then
    hook.Add( "PlayerSay", "glee_crawlwithme_secret", function( sender, text )
        if text ~= "crawl with me" then return end
        if os.date( "*t" ).hour >= 3 then return end -- crawl with me at night
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
