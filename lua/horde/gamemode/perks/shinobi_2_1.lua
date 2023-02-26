PERK.PrintName = "Jutai-jutsu"
PERK.Description = "Set max weight to {1}. \nIncrease melee damage by {2}. "
PERK.Icon = "materials/perks/haste.png"
PERK.Params = {
    [1] = {value = 7},
    [2] = {value = 0.5, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_2_1" then
        ply:Horde_SetMaxWeight(7)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_2_1" then
        ply:Horde_SetMaxWeight(HORDE.max_weight)
    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_2_1")  then return end
	
	if  HORDE:IsMeleeDamage(dmginfo) then
        bonus.increase = bonus.increase + 0.5
    end
end