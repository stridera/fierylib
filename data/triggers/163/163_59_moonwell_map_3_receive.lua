-- Trigger: Moonwell Map 3 Receive
-- Zone: 163, ID: 59
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16359
--
-- Dryad receives bark map at stage 9 after the jade ring. Marks the map,
-- advances stage 9 -> 10, hands map back, and sends player after the Chaos
-- Orb.

if actor:get_quest_stage("moonwell_spell_quest") ~= 9 then
    return true
end

if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(2)
    self:destroy_item("map")
    wait(15)
    self.room:spawn_object(163, 54)
    self.room:send(tostring(self.name) .. " quickly marks another check on the bark map.")
    wait(15)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Okay, there are two items left.  This next might seem\n"
        .. "</>odd, but we need a single item of evil and chaos to mislead forces that wish to\n"
        .. "</>harm us while traveling through the well.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'There is an orb that will serve this function well.  But\n"
        .. "</>as with so many such powerful relics, it is guarded by a great dragon hidden in\n"
        .. "</>a hellish labyrinth.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Get this orb that we might protect ourselves!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
end
return true