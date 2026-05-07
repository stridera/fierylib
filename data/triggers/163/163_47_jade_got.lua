-- Trigger: jade_got
-- Zone: 163, ID: 47
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #16347
--
-- Pickup hook for the jade ring: advance moonwell_spell_quest from stage 8
-- (looking for the ring) to stage 9 (returning it).

if actor:get_quest_stage("moonwell_spell_quest") == 8 then
    actor:advance_quest("moonwell_spell_quest")
    self.room:send(tostring(self.shortdesc) .. " begins to glow mysteriously.")
end
