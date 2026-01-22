-- Trigger: academy_sorcerer_command_scribe
-- Zone: 519, ID: 50
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51950

-- Converted from DG Script #51950: academy_sorcerer_command_scribe
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: scribe
if not (cmd == "scribe") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "sc" then
    _return_value = false
    return _return_value
end
-- switch on arg
if actor:get_quest_var("school:fight") == 5 then
    if arg == "magic m" or arg == "magic mi" or arg == "magic mis" or arg == "magic miss" or arg == "magic missi" or arg == "magic missil" or arg == "magic missile" then
        actor:set_quest_var("school", "fight", 6)
        actor:command("scribe magic missile")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'This will take some time.")
        actor:send("When you're done writing, <b:green>stand</> so I know you're ready to continue.'")
    end
end
_return_value = false
return _return_value