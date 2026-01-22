-- Trigger: timer_on_recall
-- Zone: 480, ID: 1
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48001

-- Converted from DG Script #48001: timer_on_recall
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send_except(actor, "As " .. tostring(actor.name) .. " grabs the stone you feel a lurch in your stomach.")
actor:send("You feel the stone burn against your hand for a second and it is gone!")
self.room:teleport_all(get_room(480, 80))
self.room:find_actor("all"):command("look")
return _return_value