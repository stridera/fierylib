-- Trigger: Moonwell Map 4 Receive
-- Zone: 163, ID: 61
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16361

-- Converted from DG Script #16361: Moonwell Map 4 Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 10 then
    if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
        actor.name:advance_quest("moonwell_spell_quest")
        actor.name:set_quest_var("moonwell_spell_quest", "map", 0)
        wait(2)
        self:destroy_item("map")
        wait(15)
        self.room:spawn_object(163, 55)
        self.room:send(tostring(self.name) .. " marks something on the bark map.")
        wait(15)
        self:command("give map " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'Lastly, we need the item for the Earth.  There is a ring")
        actor:send("</>made of mundane stone kept in a large temple hidden in a mountain.  Obtain this")
        actor:send("</>final ring and we can finish this ceremony.'")
    else
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
    end
end
return _return_value