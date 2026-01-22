-- Trigger: academy_cleric_command_stand
-- Zone: 519, ID: 43
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51943

-- Converted from DG Script #51943: academy_cleric_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 6 then
    actor:set_quest_var("school", "fight", 7)
    actor:command("stand")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
    actor:send("Gaining experience is how you go up in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.")
    actor:send("This includes casting offensive spells at other players.")
    actor:send("</>")
    actor:send("</>Before you strike, take a moment to size up your opponent.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
    actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
    actor:send("Also keep in mind most of a cleric's strength is support.")
    actor:send("It will be harder for you to kill creatures alone.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
end
_return_value = false
return _return_value