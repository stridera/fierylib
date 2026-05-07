-- Trigger: dragons_health_thelriki_jerajai_death
-- Zone: 586, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #58606
-- Attached to both Thelriki and Jerajai. When the dragon dies, mark the kill
-- on the player's dragons_health quest using the dragon's lower-cased name as
-- the variable key (e.g. "thelriki", "jerajai") so the receive trigger and
-- status checker can detect each kill independently.
--
-- TODO: legacy script credited every group member in the room; the Lua actor
-- API does not yet expose group iteration, so for now only the actor that
-- triggered the death (the killer) is credited. Restore group crediting when
-- group_size / group_members bindings exist.

if actor and actor:get_quest_stage("dragons_health") == 3 then
    local key = string.lower(tostring(self.name))
    actor:set_quest_var("dragons_health", key, 1)
end
