-- Trigger: academy_instructor_command_wear
-- Zone: 519, ID: 7
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51907

-- Converted from DG Script #51907: academy_instructor_command_wear
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wear
if not (cmd == "wear") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "w" or cmd == "we" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:gear") == 2 and arg == "all" then
    actor:command("wear all")
    actor:set_quest_var("school", "gear", 3)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'That's how you do it!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(EQ)UIPMENT</> command shows what gear you're using.")
    actor:send("You are gaining active benefits from these items.")
    actor:send("They will not show up in your inventory.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>equipment</> or just <b:green>eq</> to try it out.'")
end
_return_value = false
return _return_value