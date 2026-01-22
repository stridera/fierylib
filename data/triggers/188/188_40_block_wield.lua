-- Trigger: block_wield
-- Zone: 188, ID: 40
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18840

-- Converted from DG Script #18840: block_wield
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: wield
if not (cmd == "wield") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "w" then
    _return_value = false
    return _return_value
end
actor:send("You cannot wield another weapon with " .. tostring(self.shortdesc) .. "!")
return _return_value