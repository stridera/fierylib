-- Trigger: glazed-stiletto-wield
-- Zone: 237, ID: 81
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #23781

-- Converted from DG Script #23781: glazed-stiletto-wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.quest_variable[quest_items:self.vnum] then
    _return_value = true
    actor:send("You flip out the blade of " .. tostring(self.shortdesc) .. ".")
    self.room:send_except(actor, tostring(actor.name) .. " flips the blade out of " .. tostring(self.shortdesc) .. ".")
else
    _return_value = false
    actor:send("You try to wield " .. tostring(self.shortdesc) .. ", but can't figure out how to open it.")
end
return _return_value