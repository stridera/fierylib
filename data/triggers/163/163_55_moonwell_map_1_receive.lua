-- Trigger: Moonwell Map 1 Receive
-- Zone: 163, ID: 55
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16355

-- Converted from DG Script #16355: Moonwell Map 1 Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 6 then
    if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
        actor.name:advance_quest("moonwell_spell_quest")
        actor.name:set_quest_var("moonwell_spell_quest", "map", 0)
        wait(2)
        self:destroy_item("map")
        self.room:spawn_object(163, 52)
        wait(15)
        self.room:send(tostring(self.name) .. " quickly marks something on the bark map.")
        self:command("give map " .. tostring(actor.name))
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'There you go!'")
    else
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    end
end
return _return_value