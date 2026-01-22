-- Trigger: globe_drop
-- Zone: 188, ID: 43
-- Type: OBJECT, Flags: GLOBAL, DROP
-- Status: CLEAN
--
-- Original DG Script: #18843

-- Converted from DG Script #18843: globe_drop
-- Original: OBJECT trigger, flags: GLOBAL, DROP, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = true
local owner = actor.name
globals.owner = globals.owner or true
self.room:send_except(actor, tostring(self.shortdesc) .. " hovers away from " .. tostring(actor.name) .. " slowly.")
actor:send(tostring(self.shortdesc) .. " slowly hovers away from you.")
return _return_value