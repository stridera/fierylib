-- Trigger: academy_cleric_command_skill
-- Zone: 519, ID: 37
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51937

-- Converted from DG Script #51937: academy_cleric_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The percentage next to each skill name shows how well you know it.")
    actor:send("<b:cyan>The word in parentheses is your rank, starting at \"novice\" and growing as the percentage does.</>")
    actor:send("</>")
    actor:send("Your most important skills are the <b:cyan>spheres</>.")
    actor:send("These are a measure of your proficiency in a type of magic.")
    actor:send("They increase whenever you <b:cyan>CAST</> a spell.")
    actor:send("The spheres are not spells or attacks themselves.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are four steps to using divine magic:'")
    actor:send("1. <b:cyan>(R)EST</>")
    actor:send("2. <b:cyan>(MED)ITATE</>")
    actor:send("3. <b:cyan>(PR)AY</>")
    actor:send("4. <b:cyan>(C)AST</></>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To see what spells you actually know type <b:green>spell</>.'")
end
_return_value = true
return _return_value