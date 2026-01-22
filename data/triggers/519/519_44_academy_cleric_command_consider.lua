-- Trigger: academy_cleric_command_consider
-- Zone: 519, ID: 44
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51944

-- Converted from DG Script #51944: academy_cleric_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
local thing = "horrible-little-monster"
-- switch on cmd
if cmd == "c" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 7 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("con " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature, use the <b:cyan>(KIL)L</> command. Type <b:green>kill monster</> to start fighting.")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned.")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("You cannot flee while casting a spell either!")
    actor:send("So don't wait until the last second to run!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = false
return _return_value