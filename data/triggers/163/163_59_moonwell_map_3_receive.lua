-- Trigger: Moonwell Map 3 Receive
-- Zone: 163, ID: 59
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16359

-- Converted from DG Script #16359: Moonwell Map 3 Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 9 then
    if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
        actor.name:advance_quest("moonwell_spell_quest")
        actor.name:set_quest_var("moonwell_spell_quest", "map", 0)
        wait(2)
        self:destroy_item("map")
        wait(15)
        self.room:spawn_object(163, 54)
        self.room:send(tostring(self.name) .. " quickly marks another check on the bark map.")
        wait(15)
        self:command("give map " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'Okay, there are two items left.  This next might seem")
        actor:send("</>odd, but we need a single item of evil and chaos to mislead forces that wish to")
        actor:send("</>harm us while traveling through the well.'")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'There is an orb that will serve this function well.  But")
        actor:send("</>as with so many such powerful relics, it is guarded by a great dragon hidden in")
        actor:send("</>a hellish labyrinth.'")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'Get this orb that we might protect ourselves!'")
    else
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    end
end
return _return_value