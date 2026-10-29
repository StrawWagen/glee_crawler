AddCSLuaFile()

if not terminator_Extras or not terminator_Extras.glee_Carrying then return end

DEFINE_BASECLASS( "glee_backpackable_base" )

SWEP.Base = "glee_backpackable_base"

SWEP.PrintName = "Weird Egg"
SWEP.Purpose = "It's warm. Something inside is moving."
SWEP.Instructions = "Reload to place it down.\nIt's extremely valuable, surely."
SWEP.Slot = 4

if CLIENT then
    terminator_Extras.glee_CL_SetupSwep( SWEP, "glee_backpackable_weirdegg", "materials/entities/glee_backpackable_weirdegg.png" )

end

SWEP.CarryEntClass = "glee_weird_egg"

-- starting points, needs tuning in game
SWEP.HeldModelPos, SWEP.HeldModelAng = terminator_Extras.glee_Carrying.SCKToLocal( Vector( 3, 6, 4 ), Angle( 0, 0, 0 ) )
SWEP.HeldModelScale = 0.4

SWEP.WorldModelHandPos, SWEP.WorldModelHandAng = terminator_Extras.glee_Carrying.SCKToLocal( Vector( 2, 10.5, -6 ), Angle( 0, 0, 0 ) )
SWEP.WorldModelHandScale = 0.6

SWEP.WorldModelBackPos = Vector( 2, -8, 0 )
SWEP.WorldModelBackAng = Angle( 0, 0, 0 )
SWEP.WorldModelBackScale = 0.6

SWEP.PlacedSound = {
    pitch = 110,
    sounds = {
        { path = "physics/flesh/flesh_squishy_impact_hard1.wav" },
        { path = "physics/flesh/flesh_squishy_impact_hard2.wav" },
        { path = "physics/flesh/flesh_squishy_impact_hard3.wav" },
    },
}

if SERVER then
    -- For the egg, as it hatches. Let go of where it is, and this weapon's gone
    function SWEP:ReleaseForHatch()
        local owner = self:GetOwner()
        self:StopCarrying()

        if IsValid( owner ) and owner:GetActiveWeapon() == self then
            local previous = owner:GetPreviousWeapon()
            if IsValid( previous ) and previous:IsWeapon() and previous ~= self then
                owner:SelectWeapon( previous:GetClass() )

            end
        end

        SafeRemoveEntity( self )

    end
end

if not CLIENT then return end

-- the base copies the carried entity's model and skin, not the material the egg sets on it
function SWEP:EnsureHeldModel( vm )
    local held = BaseClass.EnsureHeldModel( self, vm )
    if not held then return end

    held:SetMaterial( self:GetCarriedEnt():GetMaterial() )

    return held

end

function SWEP:UpdatePlacementGhost()
    BaseClass.UpdatePlacementGhost( self )

    local ghost = self.glee_PlacementGhost
    if not IsValid( ghost ) then return end

    ghost:SetMaterial( self:GetCarriedEnt():GetMaterial() )

end
