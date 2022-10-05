PERK.PrintName = "Kinton"
PERK.Description = "{2} speed boost. \n+{2} crit chance. \n{3} chance to spawn a Flare on kill."
PERK.Icon = "materials/perks/specops/flare.png"
PERK.Params = {
    [1] = {value = 1, percent = true},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 0.5, percent = true},
}

PERK.Hooks = {}

	
--PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
   -- if not ply:Horde_GetPerk("shinobi_1_2")  then return end
	--if ply:Horde_GetSmokescreen() == 1 and HORDE:IsMeleeDamage(dmginfo) then
  --      bonus.increase = bonus.increase + 0.25
  --  end
--end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
    if not ply:Horde_GetPerk("shinobi_1_2") then return end
    bonus_walk.increase = bonus_walk.increase + 0.25
    bonus_run.increase = bonus_run.increase + 0.25
end

PERK.Hooks.Horde_OnPlayerCriticalCheck = function (ply, npc, bonus, hitgroup, dmginfo, crit_bonus)
    if ply:Horde_GetPerk("shinobi_1_2") then
        crit_bonus.add = crit_bonus.add + 0.25
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, inflictor)
    if not killer:Horde_GetPerk("shinobi_1_2") then return end
    if inflictor:IsNPC() then return end -- Prevent infinite chains
    local p = math.random()
    if p <= 0.5 then
        local ent = ents.Create("projectile_horde_flare")
        ent:SetPos(victim:GetPos())
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
        timer.Simple(3, function() if ent:IsValid() then ent:StopSound(ent.IdleSound1) ent:Remove()  end end)
    end
end