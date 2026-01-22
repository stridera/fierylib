-- Trigger: Violin music
-- Zone: 615, ID: 45
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61545

-- Converted from DG Script #61545: Violin music
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: throw
if not (cmd == "throw") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "t" or cmd == "th" or cmd == "thr" or cmd == "thro" then
    _return_value = false
    return _return_value
end
self.room:send("I'm throwing!")
return _return_value