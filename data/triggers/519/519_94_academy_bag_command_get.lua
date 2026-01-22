-- Trigger: academy_bag_command_get
-- Zone: 519, ID: 94
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51994

-- Converted from DG Script #51994: academy_bag_command_get
-- Original: OBJECT trigger, flags: COMMAND, probability: 7%

-- 7% chance to trigger
if not percent_chance(7) then
    return true
end

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:gear") == 15 and string.find(arg, "stick") then
    -- switch on arg
    if arg == "b" or arg == "ba" or arg == "bag" then
        actor:set_quest_var("school", "gear", 16)
        actor:command("get stick bag")
        wait(2)
        self:command("cheer")
        actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Congratulations, you mastered equipment management!")
        actor:send("Would you like to review?")
        actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
    end
end
_return_value = false
return _return_value