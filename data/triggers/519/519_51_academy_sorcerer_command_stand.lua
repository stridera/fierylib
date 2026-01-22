-- Trigger: academy_sorcerer_command_stand
-- Zone: 519, ID: 51
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51951

-- Converted from DG Script #51951: academy_sorcerer_command_stand
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
    actor:send(tostring(self.name) .. " tells you, 'With the spell scribed you can <b:cyan>CAST</> it.")
    actor:send("Unlike many other MUDs, <red>FieryMUD does not use mana.</>")
    actor:send("You can cast any spell from your list as long as you have available <b:cyan>SPELL SLOTS</> of the same level or higher.")
    actor:send("</>")
    actor:send("At level 1, you have only one Circle 1 spell slot.")
    actor:send("You can use that spell slot to <b:cyan>CAST</> any Circle 1 spell.")
    actor:send("You gain more spells slots as you increase in level.'")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
    actor:send("Gaining experience is how you go up in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.")
    actor:send("This includes casting offensive spells at other players.")
    actor:send("</>")
    actor:send("</>Before you strike, take a moment to size up your opponent.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
    actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
elseif actor:get_quest_var("school:fight") == 12 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:command("stand")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Next I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = false
return _return_value