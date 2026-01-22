-- Trigger: academy_revel_command_sleep
-- Zone: 519, ID: 60
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51960

-- Converted from DG Script #51960: academy_revel_command_sleep
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:rest") == 1 then
    actor:set_quest_var("school", "rest", 2)
    actor:command("sleep")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Sweet dreams!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Remember, you may want to enter commands every now and then to update your display and see how close you are to full health and movement.")
    actor:send("The display won't update on its own.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>WAKE</> command makes you stop sleeping and sit up.")
    actor:send("When you wake up, you'll automatically go to a sitting <b:cyan>REST</> position.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'So type <b:green>wake</> and get up!'</>")
end
_return_value = false
return _return_value