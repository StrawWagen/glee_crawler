AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName   = "Weird Egg"
ENT.Author      = "StrawWagen"
ENT.Purpose     = "Hatches into a crawler when broken, or left long enough"
ENT.Spawnable   = false
ENT.Category    = "Hunter's Glee"
ENT.Model       = "models/hunter/misc/sphere075x075.mdl"
ENT.Material    = "phoenix_storms/egg"
ENT.HatchAfter  = { min = 60 * 4, max = 60 * 8 } -- from when it's made, carried or not
ENT.CrackingFor = 10 -- the warning, seconds before hatching
ENT.ShellHealth = 150
ENT.ViableAfter = 0.75 -- fraction of its gestation, broken before this, nothing comes out

local glee_Carrying = terminator_Extras and terminator_Extras.glee_Carrying

if glee_Carrying then
    glee_Carrying.MakeCarryable( ENT, "glee_backpackable_weirdegg" )
    ENT.GleeUseActions = { glee_Carrying.PickUpAction }
    ENT.GleeTooHeavyToLift = true

end

if CLIENT and terminator_Extras and terminator_Extras.glee_CL_SetupSent then
    terminator_Extras.glee_CL_SetupSent( ENT, "glee_weird_egg", "materials/entities/glee_backpackable_weirdegg.png" )

end

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetMaterial( self.Material )

    if not SERVER then return end

    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:Wake()
        phys:SetMaterial( "Watermelon" )

    end

    self.shellHealth = self.ShellHealth
    self.gestation = math.Rand( self.HatchAfter.min, self.HatchAfter.max )
    self.hatchAt = CurTime() + self.gestation

end

if not SERVER then return end

local crackSounds = {
    "npc/barnacle/neck_snap1.wav",
    "npc/barnacle/neck_snap2.wav",
    "npc/barnacle/barnacle_crunch3.wav",
}

local floorReach = 256

-- On the floor under pos, as the crawler's own spawner places them. With no floor, it falls from pos
local function spawnCrawler( pos )
    local crawler = ents.Create( "evil_crawler" )
    if not IsValid( crawler ) then return end

    local up = vector_up
    local spawnPos = pos

    local floorTr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, floorReach ), mask = MASK_SOLID_BRUSHONLY } )
    if floorTr.Hit and not floorTr.StartSolid then
        up = floorTr.HitNormal

        local height = crawler.BodyHeight * EvilCrawler.Setting( "size" )
        -- under something low it starts squeezed, not stuck in the ceiling
        local roomTr = util.TraceLine( { start = floorTr.HitPos, endpos = floorTr.HitPos + up * height, mask = MASK_SOLID_BRUSHONLY } )
        if roomTr.Hit then
            height = height * roomTr.Fraction * 0.5

        end
        spawnPos = floorTr.HitPos + up * height

    end

    crawler:SetPos( spawnPos )
    crawler:SetAngles( Angle( 0, math.Rand( 0, 360 ), 0 ) )
    crawler.SpawnUp = up
    crawler:Spawn()
    crawler:Activate()

end

function ENT:Think()
    local untilHatch = self.hatchAt - CurTime()
    if untilHatch <= 0 then
        self:Hatch()
        return

    end

    if untilHatch > self.CrackingFor then return end
    self:Crack( untilHatch )

end

function ENT:Crack( untilHatch )
    if CurTime() < ( self.nextCrack or 0 ) then return end
    self.nextCrack = CurTime() + math.Remap( untilHatch, self.CrackingFor, 0, 2, 0.4 ) * math.Rand( 0.75, 1.25 )

    self:EmitSound( crackSounds[math.random( #crackSounds )], 70, math.random( 90, 110 ) )

    local carrierWep = glee_Carrying and glee_Carrying.GetCarrierWeapon( self )
    if IsValid( carrierWep ) then
        local carrier = carrierWep:GetOwner()
        if IsValid( carrier ) then
            carrier:ViewPunch( Angle( math.Rand( -2, 2 ), math.Rand( -2, 2 ), 0 ) )

        end
        return

    end

    local phys = self:GetPhysicsObject()
    if not IsValid( phys ) then return end
    phys:Wake()
    phys:AddAngleVelocity( VectorRand() * 150 )

end

function ENT:OnTakeDamage( dmgInfo )
    if self.hatched then return end

    self.shellHealth = self.shellHealth - dmgInfo:GetDamage()
    if self.shellHealth > 0 then
        self:EmitSound( crackSounds[math.random( #crackSounds )], 75, math.random( 110, 130 ) )
        return

    end

    local gestated = 1 - ( self.hatchAt - CurTime() ) / self.gestation
    if gestated < self.ViableAfter then
        self:Stillborn()

    else
        self:Hatch()

    end
end

-- true the first time, removal waits for the end of the tick, more damage can land before then
function ENT:Break()
    if self.hatched then return false end
    self.hatched = true

    local carrierWep = glee_Carrying and glee_Carrying.GetCarrierWeapon( self )
    if IsValid( carrierWep ) then
        carrierWep:ReleaseForHatch()

    end

    SafeRemoveEntity( self )
    return true

end

function ENT:Hatch()
    if not self:Break() then return end

    local pos = self:WorldSpaceCenter()
    spawnCrawler( pos )

    sound.Play( "npc/antlion_grub/squashed.wav", pos, 85, math.random( 60, 75 ) )
    sound.Play( "physics/flesh/flesh_bloody_break.wav", pos, 80, math.random( 80, 95 ) )
    sound.Play( "npc/barnacle/barnacle_tongue_pull1.wav", pos, 80, math.random( 70, 85 ) )

end

function ENT:Stillborn()
    if not self:Break() then return end

    local pos = self:WorldSpaceCenter()

    for _ = 1, 6 do
        local edata = EffectData()
        edata:SetOrigin( pos )
        edata:SetNormal( VectorRand() )
        util.Effect( "BloodImpact", edata )

    end
    for _ = 1, 8 do
        util.Decal( "Blood", pos, pos + VectorRand() * math.random( 100, 300 ), self )

    end

    sound.Play( "npc/antlion_grub/squashed.wav", pos, 80, math.random( 110, 130 ) )
    sound.Play( "physics/flesh/flesh_squishy_impact_hard2.wav", pos, 75, math.random( 70, 85 ) )

end
