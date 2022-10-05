PERK.PrintName = "Koppojutsu"
PERK.Description = "{1} speed boost while Smoke Bomb is active. Gain {1} crit chance against elites. \nLeech {2} health upon dealing a crit. \nGain immunity to Bleeding."
PERK.Icon = "materials/perks/bushido.png"
PERK.Params = {
    [1] = {value = 0.25, percent = true},
    [2] = {value = 6},
}

PERK.Hooks = {}

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
    if not ply:Horde_GetPerk("shinobi_3_2") then return end
	if ply:Horde_GetSmokescreen() == 1 then
    bonus_walk.increase = bonus_walk.increase + 0.25
    bonus_run.increase = bonus_run.increase + 0.25
	end
end

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_3_2") and npc:GetVar("is_elite") then
        crit_bonus.add = crit_bonus.add + 0.25
    end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_3_2") then
        HORDE:SelfHeal(ply, 6)
    end
end

PERK.Hooks.Horde_OnPlayerDebuffApply = function (ply, debuff, bonus)
    if ply:Horde_GetPerk("shinobi_3_2") and debuff == HORDE.Status_Bleeding then
        bonus.apply = 0
        return true
    end
end
