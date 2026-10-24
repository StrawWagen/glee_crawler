
local setHelpers = ( GM or GAMEMODE ).setHelpers

local corpseSearchDistSqr = 10000^2

-- nearest ent of class no alive player can see, that hasn't already grown a fungus
local function findHiddenCorpse( class, pos, filter )
    local candidates = {}
    for _, ent in ipairs( ents.FindByClass( class ) ) do
        if ent.glee_SeededFungus then continue end
        if filter and not filter( ent ) then continue end
        local distSqr = ent:GetPos():DistToSqr( pos )
        if distSqr > corpseSearchDistSqr then continue end
        table.insert( candidates, { ent = ent, distSqr = distSqr } )

    end
    table.SortByMember( candidates, "distSqr", true )

    for _, candidate in ipairs( candidates ) do
        if not terminator_Extras.posIsInterruptingAlive( candidate.ent:WorldSpaceCenter() ) then
            return candidate.ent

        end
    end
end

-- the gamemode only sets skullSteamId on skulls dropped by a player's death
local function isPlayerDeathSkull( skull )
    return skull.skullSteamId ~= nil

end

-- the fungus only grows along a surface, so it needs the floor under pos
local function seedOnFloorUnder( fungus, pos )
    local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 64 ), mask = MASK_SOLID_BRUSHONLY } )
    if not tr.Hit or tr.StartSolid then return false end
    fungus.SpawnAt = tr.HitPos
    fungus.SpawnUp = tr.HitNormal
    return true

end

-- A .preSpawnedFuncs entry for evil_fungus. Seeds under a hidden ragdoll within 10000u, else under a hidden
-- player-death skull, each seeds once. Otherwise under spawnPos, where hunters would spawn 20 up and fall.
-- The entity still spawns at spawnPos, but it moves itself onto its seed as it settles
function setHelpers.preSpawnedSeedFungus( _, fungus, spawnPos )
    local corpse = findHiddenCorpse( "prop_ragdoll", spawnPos ) or findHiddenCorpse( "termhunt_skull_pickup", spawnPos, isPlayerDeathSkull )
    if corpse and seedOnFloorUnder( fungus, corpse:WorldSpaceCenter() ) then
        corpse.glee_SeededFungus = true
        return

    end
    seedOnFloorUnder( fungus, spawnPos )

end

-- A .postSpawnedFuncs entry. For hunters with no GetEnemy that don't close in on players, like the fungus,
-- that the spawner's stale check would cull. Pair with .removeAfterStillSeconds so stuck ones still go
function setHelpers.postSpawnedNeverStale( _, spawned )
    spawned.glee_NoEnemyToRemove = math.huge

end
