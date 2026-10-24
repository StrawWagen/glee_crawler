
local setHelpers = ( GM or GAMEMODE ).setHelpers

local ragdollSearchDistSqr = 10000^2

-- nearest ragdoll no alive player can see, that hasn't already grown a fungus
local function findHiddenRagdoll( pos )
    local candidates = {}
    for _, rag in ipairs( ents.FindByClass( "prop_ragdoll" ) ) do
        if rag.glee_SeededFungus then continue end
        local distSqr = rag:GetPos():DistToSqr( pos )
        if distSqr > ragdollSearchDistSqr then continue end
        table.insert( candidates, { rag = rag, distSqr = distSqr } )

    end
    table.SortByMember( candidates, "distSqr", true )

    for _, candidate in ipairs( candidates ) do
        if not terminator_Extras.posIsInterruptingAlive( candidate.rag:WorldSpaceCenter() ) then
            return candidate.rag

        end
    end
end

-- the fungus only grows along a surface, so it needs the floor under pos
local function seedOnFloorUnder( fungus, pos )
    local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 64 ), mask = MASK_SOLID_BRUSHONLY } )
    if not tr.Hit or tr.StartSolid then return false end
    fungus.SpawnAt = tr.HitPos
    fungus.SpawnUp = tr.HitNormal
    return true

end

-- A .preSpawnedFuncs entry for evil_fungus. Seeds under a hidden ragdoll within 5000u if there is one,
-- each ragdoll seeds once. Otherwise under spawnPos, where hunters would spawn 20 up and fall.
-- The entity still spawns at spawnPos, but it moves itself onto its seed as it settles
function setHelpers.preSpawnedSeedFungus( _, fungus, spawnPos )
    local rag = findHiddenRagdoll( spawnPos )
    if rag and seedOnFloorUnder( fungus, rag:WorldSpaceCenter() ) then
        rag.glee_SeededFungus = true
        return

    end
    seedOnFloorUnder( fungus, spawnPos )

end

-- A .postSpawnedFuncs entry. For hunters that barely move and have no GetEnemy, like the fungus,
-- that the spawner's stale check would cull within a couple minutes
function setHelpers.postSpawnedNeverStale( _, spawned )
    spawned.glee_NoEnemyToRemove = math.huge

end
