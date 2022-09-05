PERK.PrintName = "Kinton"
PERK.Description = "{2} speed boost. \n{3} chance to spawn a Flare upon killing non-elites."
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

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus)
    if not ply:Horde_GetPerk("shinobi_1_2") then return end
    bonus.walkspd = bonus.walkspd * 1.25
    bonus.sprintspd = bonus.sprintspd * 1.25
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, inflictor)
    if not killer:Horde_GetPerk("shinobi_1_2") then return end
    if inflictor:IsNPC() then return end -- Prevent infinite chains
	if victim:GetVar("is_elite") then return end
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