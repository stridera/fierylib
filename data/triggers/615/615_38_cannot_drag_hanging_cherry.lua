-- Trigger: Cannot drag hanging cherry
-- Zone: 615, ID: 38
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61538

-- Converted from DG Script #61538: Cannot drag hanging cherry
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" then
    _return_value = false
    return _return_value
end
if string.find(arg, "purple") or string.find(arg, "cherry") then
    _return_value = true
    actor:send("You can't reach that high!")
else
    _return_value = false
end
return _return_value