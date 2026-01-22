-- Trigger: Intercept doorbash command
-- Zone: 615, ID: 41
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61541

-- Converted from DG Script #61541: Intercept doorbash command
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: doorbash
if not (cmd == "doorbash") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "do" then
    _return_value = false
    return _return_value
end
if web_present == 1 then
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " charges at the web, but just bounces off.")
    actor:send("You charge into the springy web and are tossed back.")
else
    _return_value = false
end
return _return_value