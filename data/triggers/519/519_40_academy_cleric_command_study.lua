-- Trigger: academy_cleric_command_study
-- Zone: 519, ID: 40
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51940

-- Converted from DG Script #51940: academy_cleric_command_study
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: study
if not (cmd == "study") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "st" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 3 then
    actor:set_quest_var("school", "fight", 4)
    actor:command("study")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
    actor:send("I'll walk you through that process now.")
    actor:send("First, get comfortable.")
    actor:send("Type <b:green>rest</> to take a seat and settle down.'")
end
_return_value = false
return _return_value