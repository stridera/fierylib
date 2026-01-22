-- Trigger: jade_got
-- Zone: 163, ID: 47
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #16347

-- Converted from DG Script #16347: jade_got
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 8 then
    actor.name:advance_quest("moonwell_spell_quest")
    self.room:send(tostring(self.shortdesc) .. " begins to glow mysteriously.")
end