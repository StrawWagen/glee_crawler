
local newEvent = {
    defaultPercentChancePerMin = 0.1,
    secret = {
        keyword = "spread with me",
        chanceIncrease = 5,
    },

    navmeshEvent = true,
    variants = {
        {
            variantName = "theFungus",
            getIsReadyFunc = nil,
            unspawnedStuff = {
                {
                    class = "evil_fungus",
                    spawnAlgo = "steppedRandomRadius",
                    -- no GetEnemy, so the event never sees it meet anyone, this is what ends the event if nobody kills it
                    timeout = true,

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
        },
    },
}

terminator_Extras.RegisterEvent( newEvent, "glee_the_evil_fungus" )
