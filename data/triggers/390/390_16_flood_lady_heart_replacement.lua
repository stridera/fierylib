-- Trigger: flood_lady_heart_replacement
-- Zone: 390, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39016
--
-- Recovery for an Envoy who lost the heart-ocean. The Lady screams,
-- punishes them with 400 hp of drowning damage, then conjures a new
-- heart-ocean (390:0) from the sea and hands it back.
--
-- Match must be the full phrase "I lost the heart" (the legacy keyword
-- list "I lost the heart" was tokenized into individual words by the
-- DG-script parser, which is why the converter produced a too-loose
-- check). The 0% probability in the legacy header was the DG way of
-- saying "exact-phrase only", so we don't gate on percent_chance here.

if string.lower(speech) ~= "i lost the heart" then
    return true
end
if not actor:get_quest_stage("flood") then
    return true
end

wait(2)
self:command("scream")
wait(2)
self.room:send(self.name .. " shrieks, 'HOW DARE YOU!!!'")
wait(1)
local dealt = actor:damage(400)  -- physical drowning
actor:send(self.name .. " fills your lungs with water! (<b:blue>" .. tostring(dealt) .. "</>)")
self.room:send_except(actor, self.name .. " fills " .. actor.name .. "'s lungs with water! (<b:blue>" .. tostring(dealt) .. "</>)")
wait(2)
self:emote("holds her hands in front of her.")
wait(1)
self.room:send("Water flows up " .. self.name .. "'s body and swirls around her arms.")
wait(1)
self.room:send("The water coalesces into a shimmering jewel in the Lady's outstretched hands.")
wait(1)
self.room:spawn_object(390, 0)
self:command("give heart " .. actor.name)
self:say("Do not make this mistake again, Envoy.")