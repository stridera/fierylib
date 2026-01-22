-- Trigger: Beast_50
-- Zone: 17, ID: 96
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1796

-- Converted from DG Script #1796: Beast_50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if not done50 then
    self.room:send(tostring(self.name) .. " writhes in pain, slamming its enormous claws on the ground!")
    self.room:send("-     -    -   -  - -----BANG----- -  -   -    -     -")
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
    self.room:spawn_mobile(28, 1)
    self.room:find_actor("ripples"):command("kill " .. actor.name)
end
local done50 = "yes"
globals.done50 = globals.done50 or true