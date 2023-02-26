PERK.PrintName = "Weakest Enemy"
PERK.Description = "Cheat death upon receiving fatal damage, \ncleansing all debuffs, healing for {1} health, \nand gaining invulnerability for {3} seconds. {6} second cooldown."
PERK.Icon = "materials/perks/shinobi/weakest_enemy.png"
PERK.Params = {
    [1] = {value = 20},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 2},
	[4] = {value = 0.01, percent = true},
	[5] = {value = 0.08, percent = true},
	[6] = {value = 10},
	[7] = {value = 0.01, percent = true},
	[8] = {value = 0.04, percent = true},
	[9] = {value = 2},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_4_2" then
	
local id = ply:SteamID()
		
 net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Gravity_Vacuum, 8)
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
            net.WriteUInt(HORDE.Status_Gravity_Vacuum, 8)
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
	local damage = dmg:GetDamage()
	local health = ply:Health() / 2
	--bonus.block = bonus.block + 10
--	bonus.resistance = bonus.resistance + 0.25
	
	if ply.Horde_Has_Nine_Lives and ply:Horde_GetPerk("shinobi_4_2") then
        if damage >= health then
            -- Play sound effect
            ply:EmitSound("sound/player/breathe1.wav", 100, 100)
            dmg:SetDamage(0)
			for debuff, buildup in pairs(ply.Horde_Debuff_Buildup) do
			ply:Horde_RemoveDebuff(debuff)
			ply:Horde_ReduceDebuffBuildup(debuff, buildup)
			end
			HORDE:SelfHeal(ply, 20)
            ply.Horde_Has_Nine_Lives = nil
            ply.Horde_Nine_Lives_Active = true
 net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Gravity_Vacuum, 8)
            net.WriteUInt(0, 3)
        net.Send(ply)
			ply:ScreenFade(SCREENFADE.STAYOUT, Color(60, 60, 200, 50), 0.2, 5)
            timer.Simple(2, function ()
                ply.Horde_Nine_Lives_Active = nil
				ply:ScreenFade(SCREENFADE.PURGE, Color(60, 60, 200, 0), 0.1, 0.1)
            end)
			timer.Create("Shinobi_DeathRegen" .. id, 10, 1, function ()
 net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Gravity_Vacuum, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
        ply.Horde_Has_Nine_Lives = true
        ply.Horde_Nine_Lives_Active = nil
		ply:EmitSound("sound/common/warning.wav", 100, 100)
            end)
        end
    end
end
