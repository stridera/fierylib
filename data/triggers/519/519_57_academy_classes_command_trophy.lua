-- Trigger: academy_classes_command_trophy
-- Zone: 519, ID: 57
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51957

-- Converted from DG Script #51957: academy_classes_command_trophy
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: trophy
if not (cmd == "trophy") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "t" or cmd == "tr" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:loot") == 4 then
    actor:set_quest_var("school", "loot", "complete")
    actor:advance_quest("school")
    actor:command("trophy")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Your most recent kills appear at the top.")
    actor:send("</>")
    actor:send("You earn 1.00 share of each monster you kill solo.")
    actor:send("If you're in a group, that share is evenly divided among all group members present for the kill.")
    actor:send("</>")
    actor:send("At <b:yellow>5.00</>, you earn less experience per kill.")
    actor:send("At <b:red>10.00</>, you earn far less experience per kill.")
    actor:send("</>")
    actor:send("You can clear out your trophy list by killing creatures in a different area.")
    actor:send("Creatures move down the list as you kill new monsters.")
    actor:send("After 24 new monsters, they disappear completely.")
    actor:send("Your trophy list is also cleared when you die.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Looks like you're ready for some rest!")
    actor:send("Head <b:green>east</> to the banquet hall.'")
end
_return_value = false
return _return_value