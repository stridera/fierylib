-- Trigger: North_Ker_road_bandit_fight
-- Zone: 324, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN (reviewed 2026-01-22)
--
-- Original DG Script: #32401

-- Converted from DG Script #32401: North_Ker_road_bandit_fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- This trigger is the fight trigger that transforms
-- a poor lil ole lil female merchant into...
-- The Bandit leader! HA!
self.room:send("</>A <b:magenta>feeble merchant</> tears off her cloak, revealing")
self.room:send("her true nature as the <blue>&9bandit leader</>!")
self:teleport(get_room(324, 36))
self:command("rem brooch")
self:command("give brooch bledq")
self.room:find_actor("leader"):command("hold brooch")
self.room:find_actor("leader"):teleport(get_room(324, 35))
self.room:find_actor("bandit"):teleport(get_room(324, 35))
self.room:find_actor("bandit"):teleport(get_room(324, 35))
self.room:find_actor("bandit"):teleport(get_room(324, 35))
get_room(324, 35):at(function()
    self.room:find_actor("leader"):shout("Come on out! We got us some killin to do!")
end)
get_room(324, 35):at(function()
    self.room:send("</><b:green>The surrounding foilage errupts into movement as</>")
end)
get_room(324, 35):at(function()
    self.room:send("</><b:green>three bandits jump out to assist their leader!</>")
end)
get_room(324, 35):at(function()
    self.room:find_actor("leader"):command("kill " .. tostring(actor.name))
end)
get_room(324, 35):at(function()
    self.room:find_actor("bandit"):command("kill " .. tostring(actor.name))
end)
get_room(324, 35):at(function()
    self.room:find_actor("2.bandit"):command("kill " .. tostring(actor.name))
end)
get_room(324, 35):at(function()
    self.room:find_actor("3.bandit"):command("kill " .. tostring(actor.name))
end)