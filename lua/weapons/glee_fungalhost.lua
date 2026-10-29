AddCSLuaFile()

SWEP.PrintName = "Fungal Host"
SWEP.Author = "Straw W Wagen"
SWEP.Purpose = [[Plant the fungus growing inside you. 
Left click to plant where you're looking.
Right click to burst your oldest spore.

Don't let the spores build up...]]

SWEP.Slot = 0
SWEP.SlotPos = 3

-- does nothing without the fungal_host status effect
SWEP.Spawnable = false
SWEP.Category = "Hunter's Glee"

SWEP.ViewModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = false
SWEP.Weight = 1

SWEP.HoldType = "normal"

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

if CLIENT then
    if terminator_Extras and terminator_Extras.glee_CL_SetupSwep then
        terminator_Extras.glee_CL_SetupSwep( SWEP, "glee_fungalhost", "materials/killicons/evil_fungus.png" )

    end
    function SWEP:HintPostStack()
        if self:GetHeld() >= 1 then return true, "Primary attack to drop your spore!\nIt bursts out if another grows first!" end

        local owner = self:GetOwner()
        if owner:GetNW2Bool( "glee_fungalhost_planted", false ) and not owner:GetNW2Bool( "glee_fungalhost_burst", false ) then return true, "Secondary attack to burst your spores!" end

    end
end

function SWEP:Initialize()
    self:DrawShadow( false )
    self:SetHoldType( self.HoldType )

    if not SERVER then return end
    self.Spores = {}

end

function SWEP:DrawWorldModel() end

function SWEP:GetHeld()
    local owner = self:GetOwner()
    if not IsValid( owner ) then return 0 end
    return owner:GetNW2Int( "glee_fungalhost_held", 0 )

end

function SWEP:CustomAmmoDisplay()
    self.AmmoDisplay = self.AmmoDisplay or {}
    self.AmmoDisplay.Draw = true
    self.AmmoDisplay.SecondaryAmmo = nil
    self.AmmoDisplay.PrimaryAmmo = nil
    self.AmmoDisplay.PrimaryClip = self:GetHeld()

    return self.AmmoDisplay

end

function SWEP:DoAnimEvent( event )
    timer.Simple( 0, function()
        if not IsValid( self ) then return end
        local owner = self:GetOwner()
        if not IsValid( owner ) then return end
        owner:DoAnimationEvent( event )

    end )
end

function SWEP:PunchInvalid()
    local owner = self:GetOwner()
    owner:ViewPunch( Angle( 2, 0, 0 ) )
    owner:EmitSound( "physics/flesh/flesh_impact_hard3.wav", 55, 160 )
    self:DoAnimEvent( ACT_FLINCH )

end

function SWEP:PrimaryAttack()
    if not SERVER then return end

    if ( self.nextPrimaryAttack or 0 ) > CurTime() then return end
    self.nextPrimaryAttack = CurTime() + 0.5

    local owner = self:GetOwner()
    local effect = owner.GetStatusEffect and owner:GetStatusEffect( "fungal_host" )
    if not effect or effect:GetHeld() < 1 then self:PunchInvalid() return end

    effect:SetHeld( effect:GetHeld() - 1 )
    owner:ViewPunch( Angle( -2, 0, 0 ) )
    self:DoAnimEvent( ACT_GMOD_GESTURE_ITEM_PLACE )
    owner:EmitSound( "npc/barnacle/barnacle_crunch2.wav", 75, 80 )
    GAMEMODE:Bleed( owner, 3 )

    local spore = ents.Create( "glee_fungal_spore" )
    if not IsValid( spore ) then return end
    spore:SetCreator( owner )
    spore:SetPos( owner:WorldSpaceCenter() )
    spore:SetAngles( AngleRand() )
    spore:Spawn()
    spore:Activate()

    local phys = spore:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetVelocity( owner:GetVelocity() )

    end
    spore:EmitSound( "npc/barnacle/neck_snap1.wav", 70, 100 )

    owner:SetNW2Bool( "glee_fungalhost_planted", true )
    self:PruneSpores()
    table.insert( self.Spores, spore )

end

function SWEP:PruneSpores()
    for index = #self.Spores, 1, -1 do
        if not IsValid( self.Spores[index] ) then
            table.remove( self.Spores, index )

        end
    end
end

function SWEP:SecondaryAttack()
    if not SERVER then return end

    if ( self.nextSecondaryAttack or 0 ) > CurTime() then return end
    self.nextSecondaryAttack = CurTime() + 0.1

    self:PruneSpores()
    local oldest = table.remove( self.Spores, 1 )
    if not IsValid( oldest ) then self:PunchInvalid() return end

    local owner = self:GetOwner()
    owner:ViewPunch( Angle( -2, 0, 0 ) )
    self:DoAnimEvent( ACT_GMOD_GESTURE_ITEM_PLACE )
    owner:EmitSound( "weapons/bugbait/bugbait_squeeze3.wav", 55, 140 )
    owner:SetNW2Bool( "glee_fungalhost_burst", true )

    oldest:Hatch()

end

function SWEP:ShouldDrawViewModel()
    return false

end

function SWEP:OnDrop()
    SafeRemoveEntity( self )

end

function SWEP:Holster()
    return true

end
