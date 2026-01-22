-- Trigger: bird_whistle
-- Zone: 31, ID: 12
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3112

-- Converted from DG Script #3112: bird_whistle
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: whistle
if not (cmd == "whistle") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "w" or cmd == "wh" or cmd == "whi" or cmd == "whis" then
    _return_value = false
    return _return_value
end
self.room:send_except(actor, tostring(actor.name) .. " places a bird whistle to " .. tostring(actor.possessive) .. " lips and lets out a twitter.")
actor:send("You blow on a bird whistle, making a twittering noise.")
return _return_value