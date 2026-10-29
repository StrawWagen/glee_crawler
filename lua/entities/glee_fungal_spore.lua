AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName   = "Fungal Spore"
ENT.Author      = "StrawWagen"
ENT.Purpose     = "Grows into a fungus when shot, or left alone"
ENT.Spawnable   = false
ENT.Category    = "Hunter's Glee"
ENT.Model       = "models/weapons/w_bugbait.mdl"
ENT.HatchAfter  = 30

if CLIENT and terminator_Extras and terminator_Extras.glee_CL_SetupSent then
    terminator_Extras.glee_CL_SetupSent( ENT, "glee_fungal_spore", "materials/killicons/evil_fungus.png" )

end

function ENT:Initialize()
    self:SetModel( self.Model )

    if not SERVER then return end

    self:SetUseType( SIMPLE_USE )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:Wake()
        phys:SetMaterial( "Watermelon" )

    end

    self.hatchAt = CurTime() + self.HatchAfter

end

function ENT:Think()
    if not SERVER then return end
    if CurTime() < self.hatchAt then return end
    self:Hatch()

end

function ENT:OnTakeDamage()
    self:Hatch()

end

function ENT:Hatch()
    -- removal waits for the end of the tick, more damage can land before then
    if self.hatched then return end
    self.hatched = true

    local pos = self:WorldSpaceCenter()
    -- the fungus only grows along world brushes
    local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 512 ), mask = MASK_SOLID_BRUSHONLY } )
    if tr.HitWorld and not tr.HitSky and not tr.StartSolid then
        EvilFungus.Plant( tr.HitPos, tr.HitNormal, nil, nil, self:GetCreator() )

    end

    self:EmitSound( "npc/antlion_grub/squashed.wav", 80, math.random( 70, 90 ), 1, CHAN_STATIC )
    sound.Play( "physics/flesh/flesh_squishy_impact_hard4.wav", pos, 75, math.random( 60, 70 ) )

    SafeRemoveEntity( self )

end

function ENT:Use( user )
    if not user:IsPlayer() then return end
    if user:Health() <= 0 then return end
    if user:IsPlayerHolding() then
        DropObject( self )

    else
        user:PickupObject( self )

    end
end
