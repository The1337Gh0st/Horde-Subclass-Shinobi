PERK.PrintName = "Jutai-jutsu"
PERK.Description = "If weight is lower than {1}, then increase melee damage by {2}.  \nIncrease crit damage by {2}. \nKilling elites will spawn a Smoke Bomb."
PERK.Icon = "materials/perks/haste.png"
PERK.Params = {
    [1] = {value = 8},
    [2] = {value = 0.25, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinobi_2_1")  then return end
	local percent = ply:Horde_GetWeight() >= 8
	--local percent = math.max(0, ply:Horde_GetMaxWeight() / ply:Horde_GetWeight()) 
	--local percent = ply:Horde_GetWeight() - ply:Horde_GetMaxWeight()
	

	
	if  HORDE:IsMeleeDamage(dmginfo) and percent then
        bonus.increase = bonus.increase + 0.25
    end
end

PERK.Hooks.Horde_OnPlayerCritical = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_2_1") then
        bonus.increase = bonus.increase + 0.25
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, inflictor)
    if not killer:Horde_GetPerk("shinobi_2_1") then return end
    if inflictor:IsNPC() then return end -- Prevent infinite chains
    if victim:GetVar("is_elite") then
        local ent = ents.Create("projectile_horde_smokescreen")
        ent:SetPos(killer:GetPos())
        ent:SetOwner(killer)
        ent.Owner = killer
        ent.Inflictor = victim
        ent:Spawn()
        ent:Activate()
        timer.Simple(0, function()
            if ent:IsValid() then
                ent:Detonate() ent:SetArmed(true)
            end
        end)
        if ent:GetPhysicsObject():IsValid() then
            ent:GetPhysicsObject():EnableMotion(false)
        end
        timer.Simple(3, function() if ent:IsValid() then ent:Remove() end end)
    end
end

--local function quicksilver_damage(ply, npc, bonus, hitgroup, dmginfo)
   -- local percent = ply:Horde_GetWeight() / ply:Horde_GetMaxWeight()
  --  if percent >= 0.85 then
  --      bonus.increase = bonus.increase + 0.3
  --  elseif percent >= 0.7 then
  --      bonus.increase = bonus.increase + 0.25
  --  elseif percent >= 0.6 then
 --       bonus.increase = bonus.increase + 0.15
 --   else
 --       bonus.increase = bonus.increase + 0
--    end
--end