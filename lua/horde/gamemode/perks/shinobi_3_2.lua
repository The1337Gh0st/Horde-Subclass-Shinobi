PERK.PrintName = "Koppojutsu"
PERK.Description = "Gain {1} crit chance. \nLeech {2} health upon dealing a crit. \nGain immunity to Bleeding."
PERK.Icon = "materials/perks/bushido.png"
PERK.Params = {
    [1] = {value = 0.2, percent = true},
    [2] = {value = 10},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_3_2") then
        crit_bonus.add = crit_bonus.add + 0.2
    end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_3_2") then
        HORDE:SelfHeal(ply, 10)
    end
end

PERK.Hooks.Horde_OnPlayerDebuffApply = function (ply, debuff, bonus)
    if ply:Horde_GetPerk("shinobi_3_2") and debuff == HORDE.Status_Bleeding then
        bonus.apply = 0
        return true
    end
end
