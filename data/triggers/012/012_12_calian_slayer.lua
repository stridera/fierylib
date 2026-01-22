-- Trigger: calian_slayer
-- Zone: 12, ID: 12
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #1212

-- Converted from DG Script #1212: calian_slayer
-- Original: OBJECT trigger, flags: GET, WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.quest_variable[quest_items:self.vnum] then
    _return_value = true
    self.room:send_except(actor, "A &9<blue>black <white>haze </>surrounds " .. tostring(actor.name) .. ", obscuring " .. tostring(actor.object) .. " from view.")
    actor:send("A &9<blue>black <white>haze </>surrounds you, momentarily obscuring your view.")
else
    _return_value = false
    actor:send("You do not feel worthy enough to wield " .. tostring(self.shortdesc) .. "!")
end
return _return_value