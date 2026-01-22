-- Trigger: academy_rogue_command_hide
-- Zone: 519, ID: 28
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51928

-- Converted from DG Script #51928: academy_rogue_command_hide
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: hide
if not (cmd == "hide") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "h" or cmd == "hi" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("hide")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Excellent job!'")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures is how you gain experience.")
    actor:send("Gaining experience is how you advance in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Before you leap out of the shadows, take a moment to size up this creature.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are against it.")
    actor:send("Bare in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> and see what happens.'")
end
_return_value = false
return _return_value