-- Trigger: Entry prevention: members only
-- Zone: 15, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1501

-- Converted from DG Script #1501: Entry prevention: members only
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if direction == "west" then
    if actor.level > 99 or actor:has_equipped("1500") then
    else
        actor:send("You pass through the portal without seeming to go anywhere.")
        self.room:send_except(actor, tostring(actor.name) .. " walks into the portal, but stays among the waves.")
        _return_value = false
    end
end
return _return_value