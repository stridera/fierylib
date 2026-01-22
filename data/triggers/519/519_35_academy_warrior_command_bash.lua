-- Trigger: academy_warrior_command_bash
-- Zone: 519, ID: 35
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51935

-- Converted from DG Script #51935: academy_warrior_command_bash
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bash
if not (cmd == "bash") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "b" or cmd == "ba" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:fight") == 4 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("bash %arg%")
    wait(2)
    world.destroy(self.room:find_actor("monster"))
    wait(2)
    self.room:send(tostring(self.name) .. " breaks up the fight.")
    actor:send(tostring(self.name) .. " tells you, 'Good attempt!'")
    self.room:spawn_mobile(519, 0)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("</>")
    actor:send("You have to be standing to fight though and you probably fell down after trying to bash.")
    actor:send("Type <b:cyan>(ST)AND</> to get back up.")
    actor:send("Then type <b:green>kill monster</> to start fighting.")
    self:command("point monster")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned to kill this monster.")
    actor:send("Be careful not to get locked by skill stun though!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = false
return _return_value