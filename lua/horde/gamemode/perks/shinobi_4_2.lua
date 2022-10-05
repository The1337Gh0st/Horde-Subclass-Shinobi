PERK.PrintName = "Weakest Enemy"
PERK.Description = "Damage that exceeds your current health is converted into Necrosis. \nNecrosis gain from excess damage is capped at {1}. \nCrits deal {7} to {8} of an enemy's health as bonus damage."
PERK.Icon = "materials/perks/decapitate.png"
PERK.Params = {
    [1] = {value = 0.75, percent = true},
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

PERK.Hooks.Horde_OnPlayerDamageTakenPost = function (ply, dmginfo, bonus)
	if not ply:Horde_GetPerk("shinobi_4_2") then return end
	if dmginfo:GetDamage() >= ply:Health() then
    ply:Horde_AddDebuffBuildup(HORDE.Status_Necrosis, math.min(75, dmginfo:GetDamage() * 2), dmginfo:GetAttacker())
    dmginfo:SetDamage(0)
	end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_4_2") then
      bonus.post_add = npc:Health() * math.min(0.04, dmginfo:GetDamage() / 2000)
   end
end