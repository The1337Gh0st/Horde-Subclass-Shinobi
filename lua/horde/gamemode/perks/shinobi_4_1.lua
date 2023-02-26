PERK.PrintName = "Envenom"
PERK.Description = "{1} increased crit chance. \n{2} of melee damage builds up Break."
PERK.Icon = "materials/perks/cellular_implosion.png"
PERK.Params = {
    [1] = {value = 0.1, percent = true},
    [2] = {value = 0.5, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_4_1") then
        crit_bonus.add = crit_bonus.add + 0.1
    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_4_1") then return end
    if HORDE:IsMeleeDamage(dmginfo) then
        npc:Horde_AddDebuffBuildup(HORDE.Status_Break, dmginfo:GetDamage() * 0.5, ply, dmginfo:GetDamagePosition())
    end
end