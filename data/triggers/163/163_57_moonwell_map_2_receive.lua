-- Trigger: Moonwell Map 2 Receive
-- Zone: 163, ID: 57
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16357
--
-- Dryad receives bark map at stage 7 after the Orb of Winds. Marks the map,
-- advances stage 7 -> 8, hands map back, and sends player after the jade
-- ring.

if actor:get_quest_stage("moonwell_spell_quest") ~= 7 then
    return true
end

if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(15)
    self:destroy_item("map")
    self.room:spawn_object(163, 53)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(15)
    self:command("give map " .. tostring(actor.name))
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Okay, the third element in this ritual is Water.  In\n"
        .. "</>magic, water is often represented by jade.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'I know of a jade ring held by a wood nymph on an island\n"
        .. "</>where other members of our Order are beset by beasts.'")
    wait(4)
    actor:send("</>But be careful, for 'tis a dangerous place for the unprepared!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
end
return true