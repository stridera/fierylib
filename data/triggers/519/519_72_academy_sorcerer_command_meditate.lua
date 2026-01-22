-- Trigger: academy_sorcerer_command_meditate
-- Zone: 519, ID: 72
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51972

-- Converted from DG Script #51972: academy_sorcerer_command_meditate
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 11 then
    actor:set_quest_var("school", "fight", 12)
    actor:command("meditate")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'It will take a while to finish recovering your spell slots.")
    actor:send("You will receive a notification each time you recover a spell slot and when you recover them all.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You do not gain a bonus to <b:cyan>FOCUS</> when sleeping or just resting.")
    actor:send("If you <b:cyan>(ST)AND</> or <b:cyan>(SL)EEP</> you'll immediately stop meditating.")
    actor:send("Don't worry, your spell slots will still recover at their normal rate.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you're done, type <b:green>stand</> so I know you're ready to continue.'")
end
_return_value = false
return _return_value