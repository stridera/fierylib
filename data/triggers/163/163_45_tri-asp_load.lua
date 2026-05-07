-- Trigger: tri-asp_load
-- Zone: 163, ID: 45
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #16345
--
-- When a moonwell-quest druid (stage 4) approaches the tri-asp, swap the
-- mob's plain flask for the quest version (Eleweiss' Flask, 163/56) so it
-- can be looted on kill.
--
-- TODO(parity): firing on every GREET means the quest flask respawns each
-- time the actor enters; legacy DG had the same shape. Consider gating with
-- a one-shot global if this proves exploitable.

if actor:get_quest_stage("moonwell_spell_quest") == 4 then
    self:destroy_item("flask")
    self.room:spawn_object(163, 56)
end
