-- Trigger: academy_rogue_command_skill
-- Zone: 519, ID: 27
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51927

-- Converted from DG Script #51927: academy_rogue_command_skill
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
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("skill")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The meter next to the skill name shows you two things:")
    actor:send("<b:cyan>1. How close you are to maximum skill for your level, indicated by the \"=\" sign</>")
    actor:send("<b:cyan>2. How close you are to overall maximum skill for your class and race, indicated by the \"*\" sign.</>'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'First, I want to introduce you to <b:cyan>(HID)E</>.")
    actor:send("If you're hidden, it makes it much harder for enemies to see you.")
    actor:send("If enemies can't see you, they can't attack you.")
    actor:send("It can get you out of some nasty scrapes.")
    actor:send("But if you do anything to draw attention to yourself, you'll stop hiding.")
    actor:send("</>")
    actor:send("You automatically <b:cyan>SNEAK</> if you move while hidden.")
    actor:send("<b:cyan>SNEAK</> helps you stay hidden as you walk.")
    actor:send("</>")
    actor:send("Both of these skills rely on the <b:cyan>HIDE</> command.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Go ahead and give it a try!  Type <b:green>hide</>.'")
end
_return_value = false
return _return_value