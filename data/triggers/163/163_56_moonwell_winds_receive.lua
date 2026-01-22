-- Trigger: Moonwell Winds Receive
-- Zone: 163, ID: 56
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16356

-- Converted from DG Script #16356: Moonwell Winds Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 7 then
    wait(2)
    actor.name:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(15)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " begins to swirl like the howling winds!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'We're making good progress.'")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Now that you have obtained the second element, please let")
    actor:send("</>me mark your map.'")
    self:destroy_item("orb")
end