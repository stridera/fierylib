-- Trigger: flood_lady_heart_replacement
-- Zone: 390, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39016

-- Converted from DG Script #39016: flood_lady_heart_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I lost the heart
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "heart")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("flood") then
    self:command("scream")
    wait(2)
    self.room:send(tostring(self.name) .. " shrieks, 'HOW DARE YOU!!!'")
    wait(1)
    actor:damage(400)  -- type: physical
    actor:send(tostring(self.name) .. " fills your lungs with water! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(self.name) .. " fills " .. tostring(actor.name) .. "'s lungs with water! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
    wait(2)
    self:emote("holds her hands in front of her.")
    wait(1)
    self.room:send("Water flows up " .. tostring(self.name) .. "'s body and swirls around her arms.")
    wait(1)
    self.room:send("The water coalesces into a shimmering jewel in the Lady's outstreched hands.")
    wait(1)
    self.room:spawn_object(390, 0)
    self:command("give heart " .. tostring(actor))
    self:say("Do not make this mistake again, Envoy.")
end