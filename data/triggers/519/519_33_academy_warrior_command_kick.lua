-- Trigger: academy_warrior_command_kick
-- Zone: 519, ID: 33
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51933

-- Converted from DG Script #51933: academy_warrior_command_kick
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kick
if not (cmd == "kick") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:fight") == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("kick " .. tostring(arg))
    wait(2)
    world.destroy(self.room:find_actor("monster"))
    self.room:send(tostring(self.name) .. " rushes in to break up the fight!")
    wait(1)
    self.room:spawn_mobile(519, 0)
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Excellent job!")
    actor:send("You're ready to try out your other important skill, <b:cyan>BASH</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " takes a wooden shield off a rack.")
    self.room:spawn_object(11, 50)
    self:command("give shield " .. tostring(actor))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Equip that with <b:green>wear shield</>.'")
end
_return_value = false
return _return_value