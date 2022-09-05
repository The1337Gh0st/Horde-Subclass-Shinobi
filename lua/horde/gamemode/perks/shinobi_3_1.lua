PERK.PrintName = "Kenjutsu"
PERK.Description = "Regenerate {1} health per second while health is under the drain limit. \nHeadshots inflict Skewered, increasing crit chance by {2} when attacked by players. \nIncreases headshot damage by {3}."
PERK.Icon = "materials/perks/berserk.png"
PERK.Params = {
    [1] = {value = 5},
    [2] = {value = 0.15, percent = true},
	[3] = {value = 0.5, percent = true},
	[4] = {value = 25},
}

PERK.Hooks = {}


	
	
	PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if ply:Horde_GetPerk("shinobi_3_1") and hitgroup == HITGROUP_HEAD then
        npc.Horde_Skewered = true
    end

    if npc.Horde_Skewered and not ply:Horde_GetPerk("shinobi_base") then
        local p = math.random()
        if p <= 0.1 then
            bonus.more = bonus.more * 1.5
            hook.Run("Horde_OnPlayerCritical", ply, npc, bonus, hitgroup, dmginfo)
            sound.Play("horde/player/crit.ogg", ply:GetPos())
        end
    end
end

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if npc.Horde_Skewered then
        crit_bonus.add = crit_bonus.add + 0.15
    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not hitgroup == HITGROUP_HEAD then return end
	if not ply:Horde_GetPerk("shinobi_3_1")  then return end
    if HORDE:IsMeleeDamage(dmginfo) then
        bonus.increase = bonus.increase + 0.5
    end
end
