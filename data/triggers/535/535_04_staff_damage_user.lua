-- Trigger: Staff damage user
-- Zone: 535, ID: 4
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53504

-- Converted from DG Script #53504: Staff damage user
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: use
if not (cmd == "use") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- switch on cmd
if cmd == "u" then
    return _return_value
end
local aliases = "elaborately-chiseled-staff deep-brown-maple-staff"
if self.val2 and (arg ~= "") and (string.find(aliases, "arg")) and (actor:has_equipped("53504")) then
    local damage = 480 + random(1, 50)
    local damage_dealt = actor:damage(damage)  -- type: physical
    actor:send("You double over in pain as " .. tostring(self.shortdesc) .. " touches the ground! (<b:red>" .. tostring(damage) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " doubles over in pain as " .. tostring(self.shortdesc) .. " touches the ground! (<blue>" .. tostring(damage) .. "</>)")
end
return _return_value