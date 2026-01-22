-- Trigger: academy_cleric_command_spell
-- Zone: 519, ID: 38
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51938

-- Converted from DG Script #51938: academy_cleric_command_spell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: spells
if not (cmd == "spells") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "sp" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("spell")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Spells are divided up by Circle.")
    actor:send("For now, you only have access to Circle 1 spells.")
    actor:send("You gain access to a new Circle every 8 levels.")
    actor:send("You can find out what a spell does by checking the <b:cyan>HELP</> file.")
    actor:send("</>")
    actor:send("Unlike many other MUDs, FieryMUD does not use a mana system.")
    actor:send("You can cast any spell from your list as long as you have available <b:cyan>SPELL SLOTS</> of the same level or higher.")
    actor:send("</>")
    actor:send("At level 1, you have only one Circle 1 spell slot.")
    actor:send("You can use that spell slot to <b:cyan>CAST</> any Circle 1 spell.")
    actor:send("You gain more spells slots as you increase in level.")
    actor:send("</>")
    actor:send("When you <b:cyan>CAST</> a spell, if you don't have any spell slots of the spell's Circle, you will automatically use a spell slot of the next highest Circle, if any.")
    actor:send("When you run out of higher Circle spell slots, the spell will fail to cast.")
    actor:send("If you use a higher Circle spell slot, there is no additional benefit or bonus to the spell cast.")
    actor:send("You cannot stop spells from using higher Circle slots or specify what Circle slot to consume.")
    actor:send("So be careful with your spell management!")
    actor:send("</>")
    actor:send("The syntax to cast is <b:cyan>(c)ast '[spell]' [target]</>.")
    actor:send("</>")
    actor:send("FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
    actor:send("If a spell name has more than one word, you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around the spell name.")
    actor:send("</>")
    actor:send("Spellcasting is not instaneous either.")
    actor:send("Each spell has a base length to cast.")
    actor:send("The <b:cyan>QUICK CHANT</> skill will help reduce casting time.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> the Cure Light spell, your most basic healing spell, on me.")
    actor:send("</>Type <b:green>cast 'cure light' professor</>.'")
end
_return_value = false
return _return_value