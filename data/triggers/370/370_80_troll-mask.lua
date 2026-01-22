-- Trigger: troll-mask
-- Zone: 370, ID: 80
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #37080

-- Converted from DG Script #37080: troll-mask
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.race, "troll") then
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " looks suddenly more fierce.")
    actor:send("You feel the strength of the Trolls in your blood!")
else
    _return_value = false
    actor:send("You cannot wear the trollish mask.")
end
return _return_value