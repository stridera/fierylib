-- Trigger: fountain_whisper
-- Zone: 18, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1803

-- Converted from DG Script #1803: fountain_whisper
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
if random(1, 100) > 75 then
    self.room:send("The wind whispers, 'Please... help us!'")
end
return _return_value