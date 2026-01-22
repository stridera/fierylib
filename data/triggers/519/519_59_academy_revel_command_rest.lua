-- Trigger: academy_revel_command_rest
-- Zone: 519, ID: 59
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51959

-- Converted from DG Script #51959: academy_revel_command_rest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rest
if not (cmd == "rest") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if not actor:get_quest_var("school:rest") then
    actor:set_quest_var("school", "rest", 1)
    actor:command("rest")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Yeah, that's it!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'If you want to speed things up even more, you can lay down and go to <b:cyan>SLEEP</>.")
    actor:send("There're some risks with sleeping.")
    actor:send("You won't be able to hear or see the world around you, so you won't know if danger is approaching.")
    actor:send("You won't be able to use <b:cyan>SAY</> or <b:cyan>SHOUT</>, or do anything most people can't normally do in their sleep.")
    actor:send("You can still <b:cyan>GOSSIP</>, <b:cyan>TELL</>, and check your <b:cyan>INVENTORY</> or <b:cyan>EQUIPMENT</> though!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Take a quick nap!")
    actor:send("Type <b:green>sleep</> to lay down.'")
end
_return_value = false
return _return_value