-- Trigger: academy_revel_command_deposit
-- Zone: 519, ID: 65
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN (reviewed 2026-01-22)
--
-- Original DG Script: #51965

-- Converted from DG Script #51965: academy_revel_command_deposit
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: deposit
if not (cmd == "deposit") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on arg
if arg == "d" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:money") == 1 and string.find(arg, "1 gold 1 silver 1 copper") then
    actor:set_quest_var("school", "money", "complete")
    actor:command("deposit 1 gold 1 silver 1 copper")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Thank you for using Academy Bank.")
    actor:send("You can <b:cyan>WITHDRAW</> your funds at any time.'")
    wait(1)
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send(tostring(self.name) .. " says, '<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say resting</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end
_return_value = false
return _return_value