PERK.PrintName = "Shinobi Base"
PERK.Description =
[[
Shinobi is a subclass of Berserker that focuses on dodge and high damage output with critical hits, but its health passively drains.
Best used as a glass cannon.
COMPLEXITY: HIGH
    
Press Shift + E to release a Smoke Bomb at your feet that gives you and nearby teammates {3} evasion. {9} second cooldown.


{5} increased Global damage resistance. ({4} base, {6} per level, up to {7}).
{1} increased Evasion. ({3} base, {6} per level, up to {2}).
{8} increased critical chance. ({7} base, {6} per level, up to {3}).
Passively drains 2 health per second, up to {8} of your health. ({7} base, {6} per level, up to {3}
]]
PERK.Icon = "materials/subclasses/employee.png"
PERK.Params = {
    [1] = {percent = true, base = 0.5, level = 0.01, max = 0.75, classname = "Shinobi"},
	[2] = {value = 0.75, percent = true},
	[3] = {value = 0.5, percent = true},
	[4] = {value = 0, percent = true},
    [5] = {percent = true, base = 0, level = 0.01, max = 0.25, classname = "Shinobi"},
    [6] = {value = 0.01, percent = true},
    [7] = {value = 0.25, percent = true},
	[8] = {percent = true, base = 0.25, level = 0.01, max = 0.5, classname = "Shinobi"},
	[9] = {value = 8},
}
--Immune to poison damage and debuffs that directly lower health. Includes Break, Bleeding, and Necrosis.
--{5} increased Global damage resistance. ({4} base, {6} per level, up to {7}).
PERK.Hooks = {}

PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("shinobi_base", math.min(0.25, 0.01 * ply:Horde_GetLevel("Shinobi")))
    end
end

PERK.Hooks.Horde_OnPlayerDamageTaken = function(ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("shinobi_base")  then return end
    bonus.resistance = bonus.resistance + ply:Horde_GetPerkLevelBonus("shinobi_base")
	bonus.evasion = bonus.evasion + (0.5 + ply:Horde_GetPerkLevelBonus("shinobi_base"))
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if ply:Horde_GetPerk("shinobi_base") then
        local crit_rate = (0.25 + ply:Horde_GetPerkLevelBonus("shinobi"))
        local crit_bonus = { increase = 0, more = 1, add = 0 }
        hook.Run("Horde_OnPlayerCriticalCheck", ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
        crit_rate = (crit_rate + crit_bonus.add) * (1 + crit_bonus.increase) * crit_bonus.more
        local p = math.random()
        if p <= crit_rate then
            bonus.more = bonus.more * 1.5
            hook.Run("Horde_OnPlayerCritical", ply, npc, bonus, hitgroup, dmginfo)
            sound.Play("horde/player/crit.ogg", ply:GetPos())
        end
    end
end


PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
local s = ply:Horde_GetLevel("Shinobi")
local id = ply:SteamID()
    if SERVER and perk == "shinobi_base" then
        if ply:Horde_GetPerk("shinobi_2_2") then
           ply:Horde_SetPerkCooldown(6)
        else
            ply:Horde_SetPerkCooldown(8)
        end
		
		timer.Create("Horde_Shinobi_Drain" .. id, 1, 0, function ()
        if not ply:IsValid() then timer.Remove("Horde_Shinobi_Drain" .. id) return end
        local half = ply:GetMaxHealth() * (0.25 + s)
		if ply:Horde_GetPerk("shinobi_4_2") and ply:Health() >= 1 then
		ply:SetMaxHealth(1)
		ply:SetHealth(1)
		end
		if ply:Health() <= 1 and ply:Horde_GetPerk("shinobi_4_2") then return end
        if ply:Health() > half then
            ply:SetHealth(ply:Health() - 2)
        elseif ply:Health() < half and ply:Horde_GetPerk("shinobi_3_1") then
            ply:SetHealth(ply:Health() + 5)
		 end
		 end)
	--	ply:SetMaxHealth(50 + (s * 10))
    --    ply:SetHealth(ply:GetMaxHealth())

        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
    end
	
	
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_base" then
	
	local id = ply:SteamID()
    timer.Remove("Horde_Shinobi_Drain" .. id)
		
        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(0, 3)
        net.Send(ply)
    end
end

PERK.Hooks.Horde_UseActivePerk = function (ply)
    if not ply:Horde_GetPerk("shinobi_base") then return end

    local rocket = ents.Create("projectile_horde_smokescreen")
    local vel = 0
    local ang = ply:EyeAngles()

    local src = ply:GetPos() + Vector(0,0,0) + ply:GetEyeTrace().Normal * 5

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. rocket) return end

    local rocketAng = Angle(ang.p, ang.y, ang.r)

    rocket:SetAngles(rocketAng)
    rocket:SetPos(src)

    rocket:SetOwner(ply)
    rocket.Owner = ply
    rocket.Inflictor = rocket

    local RealVelocity = ang:Forward() * vel / 1
    rocket.CurVel = RealVelocity -- for non-physical projectiles that move themselves

    rocket:Spawn()
    rocket:Activate()
    if !rocket.NoPhys and rocket:GetPhysicsObject():IsValid() then
        rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)
        rocket:GetPhysicsObject():SetVelocityInstantaneous(RealVelocity)
    end

    if rocket.Launch and rocket.SetState then
        rocket:SetState(1)
        rocket:Launch()
    end

    --sound.Play("weapons/physcannon/superphys_launch1.wav", ply:GetPos())
end