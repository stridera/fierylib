-- Trigger: Moonwell Map 1 Receive
-- Zone: 163, ID: 55
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16355
--
-- Dryad receives bark map at stage 6 after ruby ring (the per-quest map flag
-- is set by 16354). Marks the map, advances stage 6 -> 7, hands map back,
-- and sends player after the Orb of Winds.

if actor:get_quest_stage("moonwell_spell_quest") ~= 6 then
    return true
end

if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(2)
    self:destroy_item("map")
    self.room:spawn_object(163, 52)
    wait(15)
    self.room:send(tostring(self.name) .. " quickly marks something on the bark map.")
    self:command("give map " .. tostring(actor.name))
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'There you go!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
end
return true