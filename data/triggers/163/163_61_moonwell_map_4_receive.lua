-- Trigger: Moonwell Map 4 Receive
-- Zone: 163, ID: 61
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16361
--
-- Dryad receives bark map at stage 10 after the Chaos Orb. Marks the map,
-- advances stage 10 -> 11, hands map back, and sends player after the
-- granite ring (final element).

if actor:get_quest_stage("moonwell_spell_quest") ~= 10 then
    return true
end

if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(2)
    self:destroy_item("map")
    wait(15)
    self.room:spawn_object(163, 55)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(15)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Lastly, we need the item for the Earth.  There is a ring\n"
        .. "</>made of mundane stone kept in a large temple hidden in a mountain.  Obtain this\n"
        .. "</>final ring and we can finish this ceremony.'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
end
return true