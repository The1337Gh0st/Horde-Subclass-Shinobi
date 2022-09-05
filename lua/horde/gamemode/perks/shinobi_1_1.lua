PERK.PrintName = "Chiburui"
PERK.Description = "Gain {1} damage boost if your health is equal or above your drain limit. \nIf your health is at {3}, gain {1} additional damage. \n{1} increased crit chance."
PERK.Icon = "materials/perks/samurai/blade_dance.png"
PERK.Params = {
    [1] = {value = 0.25, percent = true},
    [2] = {value = 0.20, percent = true},
	[3] = {value = 1},
}

PERK.Hooks = {}


PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_1_1") then
        crit_bonus.add = crit_bonus.add + 0.25
    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_1_1")  then return end
	local s = ply:Horde_GetLevel("Shinobi")
	local half = ply:GetMaxHealth() * (0.25 + s) 
	local full = ply:Health() >= half
	if  full and HORDE:IsMeleeDamage(dmginfo) then
        bonus.increase = bonus.increase + 0.25
    end
	if (ply:Health() == 1) and HORDE:IsMeleeDamage(dmginfo) then
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