-- Trigger: anti-get trigger
-- Zone: 87, ID: 11
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #8711

-- Converted from DG Script #8711: anti-get trigger
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" or actor.size == "large" or actor.size == "huge" then
    _return_value = false
    actor:damage(50)  -- type: crush
    if damage_dealt ~= 0 then
        actor:send("Your back buckles and pain shoots though you joints! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        actor:send("You just can't hold that much weight!")
        self.room:send_except(actor, tostring(actor.name) .. " shouts in pain. (<blue>" .. tostring(damage_dealt) .. "</>)")
        actor:send("You drop " .. tostring(self.shortdesc) .. ".")
        self.room:send_except(actor, tostring(actor.name) .. " drops " .. tostring(self.shortdesc) .. ".")
    else
        actor:send("You can't seem to get a grip on " .. tostring(self.shortdesc) .. ".")
    end
end
return _return_value