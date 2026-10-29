
local shopHelpers = GAMEMODE.shopHelpers

local items = {}

if scripted_ents.GetStored( "evil_crawler" ) then
    local eggWeapon = "glee_backpackable_weirdegg"

    -- see glee_weird_egg, it hatches on a timer whether it's carried or not
    items["weirdegg"] = {
        name = "Weird Egg.",
        desc = "A big, warm egg.\nSomething inside is moving.\nIt's probably harmless..." .. GAMEMODE.glee_BargainDescrip,
        shCost = -200,
        markup = 0.25,
        cooldown = math.huge,
        tags = { "MUTATIONS", "Debuff", "Bargain", "RareBargain" },
        purchaseTimes = {
            GAMEMODE.ROUND_INACTIVE,
            GAMEMODE.ROUND_ACTIVE,
        },
        weight = -90,
        shPurchaseCheck = { shopHelpers.aliveCheck, function( purchaser )
            return terminator_Extras.glee_Carrying.HasRoomFor( purchaser, eggWeapon )

        end },
        svOnPurchaseFunc = function( purchaser )
            if not terminator_Extras.glee_Carrying.GiveNewCarryable( purchaser, eggWeapon ) then return end

            shopHelpers.loadoutConfirm( purchaser, 1 )

        end,
    }
end

if scripted_ents.GetStored( "evil_fungus" ) then
    if SERVER then
        local growInterval = {
            min = 60 * 3,
            max = 60 * 6,
        }
        local deathDropAliveFor = 60 * 3

        GAMEMODE:RegisterStatusEffect( "fungal_host",
            function( self, owner ) -- setup func
                -- networked so the swep can show it clientside
                function self:GetHeld()
                    return owner:GetNW2Int( "glee_fungalhost_held", 0 )

                end
                function self:SetHeld( held )
                    owner:SetNW2Int( "glee_fungalhost_held", held )

                end

                function self:ScheduleGrowth()
                    self.nextGrowth = CurTime() + math.Rand( growInterval.min, growInterval.max )

                end

                function self:Plant( pos, normal )
                    EvilFungus.Plant( pos, normal, nil, nil, owner )
                    sound.Play( "npc/barnacle/barnacle_crunch2.wav", pos, 75, math.random( 70, 80 ) )
                    sound.Play( "physics/flesh/flesh_squishy_impact_hard4.wav", pos, 75, math.random( 60, 70 ) )

                end

                -- the fungus only grows along world brushes
                function self:PlantUnder( pos )
                    local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 512 ), mask = MASK_SOLID_BRUSHONLY } )
                    if not tr.HitWorld or tr.HitSky or tr.StartSolid then return false end
                    self:Plant( tr.HitPos, tr.HitNormal )
                    return true

                end

                function self:Grow()
                    self:ScheduleGrowth()
                    if self:GetHeld() < 1 then
                        self:SetHeld( 1 )
                        owner:EmitSound( "ambient/levels/canals/toxic_slime_gurgle5.wav", 65, 60, 1, CHAN_STATIC )
                        huntersGlee_Announce( { owner }, 50, 6, "You're a host now...\nLet it out, before it grows." )
                        return

                    end

                    -- already holding one, it gets out on its own and the new one takes its place
                    if not self:PlantUnder( owner:WorldSpaceCenter() ) then return end
                    GAMEMODE:Bleed( owner, 20 )
                    GAMEMODE:GivePanic( owner, 40 )
                    owner:ViewPunch( Angle( 10, 0, 0 ) )
                    huntersGlee_Announce( { owner }, 50, 6, "The Fungus has broken out of you..." )

                end

                self.aliveSince = CurTime()
                self:SetHeld( 1 )
                self:ScheduleGrowth()

                self:Hook( "glee_true_PlayerSpawn", function( spawned )
                    if spawned ~= owner then return end
                    self.aliveSince = CurTime()
                    self:ScheduleGrowth()

                end )

                self:Hook( "PlayerDeath", function( victim )
                    if victim ~= owner then return end
                    self:SetHeld( 0 )
                    if CurTime() - self.aliveSince < deathDropAliveFor then return end
                    self:PlantUnder( victim:WorldSpaceCenter() )

                end )

                self:Timer( "fungal_host_grow", 0.1, 0, function()
                    if owner:Health() <= 0 then return end

                    if not IsValid( owner:GetWeapon( "glee_fungalhost" ) ) then
                        owner:Give( "glee_fungalhost" )

                    end

                    if CurTime() < self.nextGrowth then return end
                    self:Grow()

                end )
            end,
            function( self, owner ) -- teardown func
                self:SetHeld( 0 )
                owner:StripWeapon( "glee_fungalhost" )

            end
        )
    end

    items["fungalhost"] = {
        name = "Fungal Host.",
        desc = "Something takes root inside you.\nIt wants out." .. GAMEMODE.glee_BargainDescrip,
        shCost = -200,
        markup = 0.25,
        cooldown = math.huge,
        tags = { "MUTATIONS", "Debuff", "Bargain", "RareBargain" },
        purchaseTimes = {
            GAMEMODE.ROUND_INACTIVE,
            GAMEMODE.ROUND_ACTIVE,
        },
        weight = -90,
        shPurchaseCheck = { shopHelpers.aliveCheck, },
        svOnPurchaseFunc = function( ply )
            ply:GiveStatusEffect( "fungal_host" )

        end,
    }
end

GAMEMODE:GobbleShopItems( items )
