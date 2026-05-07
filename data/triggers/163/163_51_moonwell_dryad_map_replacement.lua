-- Trigger: moonwell_dryad_map_replacement
-- Zone: 163, ID: 51
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16351
-- Probability: 0% in source (likely a builder bug — this is referenced by
-- 16350 as the recovery path for a lost map). Data-layer probability gate
-- handles activation.
--
-- Player says "I lost my map" — dryad redraws a fresh stage-appropriate map
-- and hands it over.

if not string.find(string.lower(speech), "i lost my map") then
    return true
end

wait(2)
local stage = actor:get_quest_stage("moonwell_spell_quest")
if stage <= 6 then
    return true
end

self:command("sigh")
self:say("It will be difficult to complete this ritual without it.")
wait(1)
self:emote("begins to draw a new map.")
wait(2)
self:emote("continues to draw...")
wait(2)
self:emote("continues to draw...")
wait(4)
self:say("There!  All set!")
wait(1)

if stage == 8 then
    self.room:spawn_object(163, 52)
elseif stage == 9 or stage == 10 then
    self.room:spawn_object(163, 53)
elseif stage == 11 then
    self.room:spawn_object(163, 54)
elseif stage == 12 then
    self.room:spawn_object(163, 55)
elseif stage == 7 then
    -- Stage 7: no map yet — dryad's redraw wouldn't have anything to mark.
    self.room:spawn_object(163, 51)
else
    self.room:spawn_object(163, 51)
end
self:command("give map " .. tostring(actor.name))
