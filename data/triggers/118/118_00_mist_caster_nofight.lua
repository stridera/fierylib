-- Trigger: mist_caster_nofight
-- Zone: 118, ID: 0
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #11800

-- Converted from DG Script #11800: mist_caster_nofight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local _return_value = true  -- Default: allow action
self.room:spawn_object(118, 0)
_return_value = false
self.room:send("The mist begins to fall apart...")
self:command("drop ball")
self.room:send("The violent magic has dispersed the mist temporarily.")
world.destroy(self.room:find_actor("no-kill"))
return _return_value