-- Trigger: find_key
-- Zone: 590, ID: 13
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59013

-- Converted from DG Script #59013: find_key
-- Original: WORLD trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: move
if not (cmd == "move") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == "stones" then
    _return_value = true
    actor:send("You move the stone from the wall, and a bent key falls to the ground.")
    self.room:send_except(actor, tostring(actor.name) .. " moves a stone from the wall, and a bent key falls to the ground.")
    self.room:spawn_object(590, 27)
    if actor:get_quest_var("sacred_haven:find_key") == 1 then
        actor.name:set_quest_var("sacred_haven", "find_key", 2)
    end
else
    _return_value = false
end
return _return_value