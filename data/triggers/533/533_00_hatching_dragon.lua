-- Trigger: hatching_dragon
-- Zone: 533, ID: 0
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
-- Fixed: Converted %actor.name% to actor.name
--
-- Original DG Script: #53300

-- Converted from DG Script #53300: hatching_dragon
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
actor:send("As you touch the egg it vibrates and cracks open!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " touches the egg it hatches!")
self.room:spawn_mobile(533, 1)
self.room:find_actor("dragon"):command("consider " .. tostring(actor.name))
self.room:find_actor("dragon"):command("hit " .. tostring(actor.name))
world.destroy(self.name)
return _return_value