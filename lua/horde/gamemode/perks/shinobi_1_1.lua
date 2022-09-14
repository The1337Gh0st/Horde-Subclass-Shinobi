PERK.PrintName = "Chiburui"
PERK.Description = "Gain {1} damage boost if at full health. \n{1} increased crit damage."
PERK.Icon = "materials/perks/samurai/blade_dance.png"
PERK.Params = {
    [1] = {value = 0.25, percent = true},
    [2] = {value = 0.20, percent = true},
	[3] = {value = 1},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_1_1") then
        bonus.increase = bonus.increase + 0.25
    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_1_1")  then return end
	if HORDE:IsMeleeDamage(dmginfo) and ply:Health() >= ply:GetMaxHealth() then
        bonus.increase = bonus.increase + 0.25
    end
end

--PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
   -- if ply:Horde_GetPerk("shinobi_1_1") and (ply:Health() >= ply:GetMaxHealth()) then
  --      bonus.increase = bonus.increase + 0.25
  --  end
--end

--PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus)
   -- if not ply:Horde_GetPerk("shinobi_1_1") then return end
  --  bonus.walkspd = bonus.walkspd * 1.25
 --   bonus.sprintspd = bonus.sprintspd * 1.25
--end