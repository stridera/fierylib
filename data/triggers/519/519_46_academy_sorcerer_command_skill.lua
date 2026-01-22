-- Trigger: academy_sorcerer_command_skill
-- Zone: 519, ID: 46
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51946

-- Converted from DG Script #51946: academy_sorcerer_command_skill
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
    actor:send("<b:cyan>2. How close you are to overall maximum skill for your class and race, indicated by the \"*\" sign.</>")
    actor:send("</>")
    actor:send("Your most important skills are the <b:cyan>spheres</>.")
    actor:send("These indicate of your proficiency in a type of magic.")
    actor:send("They increase whenever you <b:cyan>CAST</> a spell.")
    actor:send("The spheres are not spells or attacks themselves.")
    actor:send("</>")
    actor:send("As a sorcerer you need extensive notes to cast correctly.")
    actor:send("This means always carrying your <b:cyan>SPELLBOOK</> with you so you can refer to and <b:cyan>(ME)MORIZE</> your notes.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are five steps to casting:'")
    actor:send("1. <b:magenta>(R)EST</>")
    actor:send("2. <b:magenta>SCRIBE</>")
    actor:send("3. <b:magenta>(MED)ITATE</>")
    actor:send("4. <b:magenta>(ME)MORIZE</>")
    actor:send("5. <b:magenta>(C)AST</></>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I'll walk you through that process now.")
    actor:send("</>First, you have to get comfortable.  Type <b:green>rest</> to take a seat and settle down.'")
end
_return_value = false
return _return_value