PERK.PrintName = "Envenom"
PERK.Description = "{1} increased crit chance. Crits build up Bleeding and Stun. \nMelee damage ignores enemy resistances."
PERK.Icon = "materials/perks/cellular_implosion.png"
PERK.Params = {
    [1] = {value = 0.1, percent = true},
    [2] = {value = 0.25, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_4_1") then
        crit_bonus.add = crit_bonus.add + 0.1
    end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_4_1") then
  --    npc:Horde_AddDebuffBuildup(HORDE.Status_Freeze, dmginfo:GetDamage() / 1.5, ply, dmginfo:GetDamagePosition())
	  npc:Horde_AddDebuffBuildup(HORDE.Status_Bleeding, dmginfo:GetDamage() / 1.5, ply, dmginfo:GetDamagePosition())
	  --npc:Horde_AddDebuffBuildup(HORDE.Status_Shock, dmginfo:GetDamage() / 1.5, ply, dmginfo:GetDamagePosition())
	  npc:Horde_AddStun(dmginfo:GetDamage())
   end
end

PERK.Hooks.Horde_OnPlayerDamagePost = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_4_1")  then return end
	
	if HORDE:IsMeleeDamage(dmginfo) and not (dmginfo:GetDamageType() == DMG_DIRECT) then
    dmginfo:SetDamageType(DMG_DIRECT)
	end
end