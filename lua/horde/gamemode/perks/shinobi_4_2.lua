PERK.PrintName = "Weakest Enemy"
PERK.Description = "Gain +{1} damage block and {2} global damage resist. Set your health to {3}. \nCheat death, gaining invulnerability for 3 seconds with a 8 second cooldown. \nCrits deal {4} of an enemy's health as bonus damage."
PERK.Icon = "materials/perks/decapitate.png"
PERK.Params = {
    [1] = {value = 10},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 1},
	[4] = {value = 0.01, percent = true},
	[5] = {value = 0.08, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_4_2" then
        ply:SetMaxHealth(1)
        ply:SetHealth(ply:GetMaxHealth())
		
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
        ply:SetMaxHealth(100)
        ply:SetHealth(ply:GetMaxHealth())
		
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
	bonus.block = bonus.block + 10
	bonus.resistance = bonus.resistance + 0.25
	
	if ply.Horde_Has_Nine_Lives and ply:Horde_GetPerk("shinobi_4_2") then
        if dmg:GetDamage() >= 1 then
            -- Play sound effect
            ply:EmitSound("sound/player/breathe1.wav", 100, 100)
            dmg:SetDamage(0)
            ply:SetHealth(1)
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
			timer.Create("Shinobi_DeathRegen" .. id, 8, 1, function ()
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
      bonus.post_add = npc:Health() * math.min(0.01, dmginfo:GetDamage() / 2000)
   end
end