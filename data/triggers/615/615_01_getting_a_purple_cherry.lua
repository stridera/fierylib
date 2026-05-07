-- Trigger: Getting a purple cherry
-- Zone: 615, ID: 1
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #61501

-- Converted from DG Script #61501: Getting a purple cherry
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
-- This is a trigger for taking purple cherries in the Enchanted Hollow.
-- Normally, they're up in the tree, so a player wouldn't be able to
-- reach. The preferred way to access the cherries is to tickle a
-- gnome, who will float up and grab one, then drop it.
_return_value = true
if (actor.zone_id == 615 and (actor.local_id == 50 or actor.local_id == 0)) then
    self.room:send(tostring(actor.name) .. " tries to grab a purple cherry, but accidentally knocks it down!")
    wait(1)
    self.room:send("A purple cherry falls to the ground.")
    self.room:spawn_object(615, 51)
    world.destroy(self)
else
    self.room:send_except(actor, tostring(actor.name) .. " tries to take a purple cherry, but it's out of reach.")
    actor:send("You can't reach that high!")
end
return _return_value