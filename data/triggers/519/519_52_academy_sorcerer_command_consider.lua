-- Trigger: academy_sorcerer_command_consider
-- Zone: 519, ID: 52
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51952

-- Converted from DG Script #51952: academy_sorcerer_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "c" then
    _return_value = false
    return _return_value
end
local thing = "horrible-little-monster"
if actor:get_quest_var("school:fight") == 7 then
    actor:set_quest_var("school", "fight", 8)
    actor:command("consider " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Typically combat starts with the command:")
    actor:send("<b:cyan>(KIL)L [target]</>'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'As a sorcerer however, your strength comes from your magic.")
    actor:send("It's often best to start combat with an offensive spell.")
    actor:send("If you're lucky, you'll kill your opponent out-right.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To <b:cyan>CAST</> type <b:cyan>(c)ast '[spell]' [target]</>.")
    actor:send("</>")
    actor:send("</>FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
    actor:send("If a spell name has more than one word you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around it.")
    actor:send("</>")
    actor:send("</>Spellcasting is not instaneous either.")
    actor:send("Each spell has a base length to cast.")
    actor:send("Your proficiency in <b:cyan>QUICK CHANT</> will reduce casting time.'")
    wait(2)
    self:command("point monster")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> your spell at that monster.")
    actor:send("Type <b:green>cast 'magic missile' monster</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("You also cannot flee while casting a spell! Don't wait until the last second to run!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, <b:green>say recovery</> I'll teach you about <b:yellow>SPELL RECOVERY</>.'")
end
_return_value = false
return _return_value