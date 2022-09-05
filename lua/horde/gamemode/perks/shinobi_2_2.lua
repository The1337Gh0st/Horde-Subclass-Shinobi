PERK.PrintName = "Inton-jutsu"
PERK.Description = "Reduces Smoke Bomb cooldown to {1} seconds. \nGain Foresight, which will absorb a single hit and reflect its damage to the attacker."
PERK.Icon = "materials/perks/samurai/foresight.png"
PERK.Params = {
    [1] = {value = 6},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_2_2" then
       ply:Horde_SetForesightEnabled(true)
        ply:Horde_AddForesight()
	   ply:Horde_SetPerkCooldown(6)
    end
end
 
PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "shinobi_2_2" then
        ply:Horde_SetForesightEnabled(nil)
        ply:Horde_RemoveForesight()
        timer.Remove("Horde_RestockForesight" .. ply:SteamID())
		ply:Horde_SetPerkCooldown(8)
    end
end

