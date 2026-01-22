-- Trigger: academy_warrior_command_skill
-- Zone: 519, ID: 32
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51932

-- Converted from DG Script #51932: academy_warrior_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("skill")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The meter next to the skill name shows you two things:")
    actor:send("<b:cyan>1. How close you are to maximum skill for your level, indicated by the \"=\" sign</>")
    actor:send("<b:cyan>2. How close you are to overall maximum skill for your class and race, indicated by the \"*\" sign.</>")
    actor:send("</>")
    actor:send("One of your most basic skills is <b:cyan>KICK</>.")
    actor:send("It's an extra attack that delivers some bonus damage.")
    actor:send("There is a short stun after you <b:cyan>KICK</>.")
    actor:send("So be very, very careful about spamming the skill.")
    actor:send("</>")
    actor:send("You probably won't land a kick for many levels, but keep trying.")
    actor:send("Practice makes perfect.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Give it a try!")
    actor:send("Type <b:green>kick monster</>.'")
end
_return_value = false
return _return_value