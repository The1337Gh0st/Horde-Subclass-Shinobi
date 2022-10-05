PERK.PrintName = "Weakest Enemy"
PERK.Description = "Drain health until you get to {1}. Kenjutsu disables drain. \nCheat death, gaining invulnerability for {9} seconds with a {1} second cooldown. \nCrits deal {7} to {8} of an enemy's health as bonus damage."
PERK.Icon = "materials/perks/decapitate.png"
PERK.Params = {
    [1] = {value = 10},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 1},
	[4] = {value = 0.01, percent = true},
	[5] = {value = 0.08, percent = true},
	[6] = {value = 5},
	[7] = {value = 0.01, percent = true},
	[8] = {value = 0.04, percent = true},
	[9] = {value = 3},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_4_2" then
	
local id = ply:SteamID()
	
	timer.Create("Horde_Shinobi_Drain" .. id, 1, 0, function ()
        if not ply:IsValid() then timer.Remove("Horde_Shinobi_Drain" .. id) return end
        local half = ply:GetMaxHealth() * (0.1)
        if ply:Health() > half and not ply:Horde_GetPerk("shinobi_3_1") then
            ply:SetHealth(ply:Health() - 2)
        elseif ply:Health() < half and ply:Horde_GetPerk("shinobi_4_2") then
            ply:SetHealth(ply:Health() + 0)
		 end
		 end)
		
		net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Nine_Lives, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
        ply.Horde_Has_Nine_Lives = true
        ply.Horde_Nine_Lives_Active = nil
		timer.Stop( "Shinobi_DeathRegen" )
		ply:ScreenFade(SCREENFADE.PURGE, Color(60, 60, 200, 0), 0.1, 0.1)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_4_2" then
		
		local id = ply:SteamID()
    timer.Remove("Horde_Shinobi_Drain" .. id)
	
		net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Nine_Lives, 8)
            net.WriteUInt(0, 3)
        net.Send(ply)
        ply.Horde_Has_Nine_Lives = nil
        ply.Horde_Nine_Lives_Active = nil
		timer.Stop( "Shinobi_DeathRegen" )
		ply:ScreenFade(SCREENFADE.PURGE, Color(60, 60, 200, 0), 0.1, 0.1)
    end
end


PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmg, bonus)
    if not ply:Horde_GetPerk("shinobi_4_2") then return end
	local id = ply:SteamID()
	--bonus.block = bonus.block + 10
--	bonus.resistance = bonus.resistance + 0.25
	
	if ply.Horde_Has_Nine_Lives and ply:Horde_GetPerk("shinobi_4_2") then
        if dmg:GetDamage() >= ply:Health() then
            -- Play sound effect
            ply:EmitSound("sound/player/breathe1.wav", 100, 100)
            dmg:SetDamage(0)
     --       ply:SetHealth(100)
            ply.Horde_Has_Nine_Lives = nil
            ply.Horde_Nine_Lives_Active = true
            net.Start("Horde_SyncActivePerk")
                net.WriteUInt(HORDE.Status_Nine_Lives, 8)
                net.WriteUInt(0, 3)
            net.Send(ply)
			ply:ScreenFade(SCREENFADE.STAYOUT, Color(60, 60, 200, 50), 0.2, 5)
            timer.Simple(3, function ()
                ply.Horde_Nine_Lives_Active = nil
				ply:ScreenFade(SCREENFADE.PURGE, Color(60, 60, 200, 0), 0.1, 0.1)
            end)
			timer.Create("Shinobi_DeathRegen" .. id, 13, 1, function ()
                net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Nine_Lives, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
        ply.Horde_Has_Nine_Lives = true
        ply.Horde_Nine_Lives_Active = nil
		ply:EmitSound("sound/common/warning.wav", 100, 100)
            end)
        end
    end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_4_2") then
      bonus.post_add = npc:Health() * math.min(0.04, dmginfo:GetDamage() / 2000)
   end
end