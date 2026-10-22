
local newEvent = {
    defaultPercentChancePerMin = 0.1,

    navmeshEvent = true,
    variants = {
        {
            variantName = "theSnake",
            getIsReadyFunc = nil,
            unspawnedStuff = {
                {
                    class = "evil_snake",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = nil,  -- no timeout since this will dissapear even if someone finds

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
            concludeOnMeet = true,
        },
    },
}

terminator_Extras.RegisterEvent( newEvent, "glee_the_evil_snake" )
