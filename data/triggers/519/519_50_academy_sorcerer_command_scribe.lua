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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sc" then
        _return_value = true
        return _return_value
    end
end
-- switch on arg
do
    local _sw2 = string.lower(tostring(arg or ""))
    if _sw2 == "magic m" or _sw2 == "magic mi" or _sw2 == "magic mis" or _sw2 == "magic miss" or _sw2 == "magic missi" or _sw2 == "magic missil" or _sw2 == "magic missile" then
        if (actor:get_quest_var("school:fight") or 0) == 5 then
            actor:set_quest_var("school", "fight", 6)
            actor:command("scribe magic missile")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'This will take some time.")
            actor:send("When you're done writing, <b:green>stand</> so I know you're ready to continue.'")
        end
    end
end
_return_value = true
return _return_value