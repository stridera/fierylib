-- Trigger: academy_warrior_command_consider
-- Zone: 519, ID: 31
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51931

-- Converted from DG Script #51931: academy_warrior_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "c" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("consider " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You need to take your combat <b:cyan>(SK)ILLS</> into consideration as well.")
    actor:send("Warriors have a wide variety of special <b:cyan>SKILLS</>.")
    actor:send("Type <b:green>skill</> to see what they are.'")
end
_return_value = false
return _return_value