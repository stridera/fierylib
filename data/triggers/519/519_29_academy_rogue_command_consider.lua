-- Trigger: academy_rogue_command_consider
-- Zone: 519, ID: 29
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51929

-- Converted from DG Script #51929: academy_rogue_command_consider
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
if actor:get_quest_var("school:fight") == 2 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("consider " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("But as a rogue, you have a special opening attack!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(B)ACKSTAB</> command has a chance to do extreme damage.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>backstab monster</> to start fighting.")
    -- (empty send to actor)
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("But if you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!'</>")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = false
return _return_value