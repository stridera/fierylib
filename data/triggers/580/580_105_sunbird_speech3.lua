-- Trigger: Sunbird_speech3
-- Zone: 580, ID: 105
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player accepts the Sunbird's request to investigate. Sunbird spawns
-- and gives them the tea master's key (object 580/109), the lead-in
-- to the Chajin / Yajiro arc.

-- Speech keywords: yes
if not string.find(string.lower(speech), "yes") then
    return true  -- No matching keywords
end
wait(1)
self:emote("beams with joy.")
wait(5)
self:say("The tea master recently left this here")
self:say("after offering prayers to Kannon for forgiveness.")
self:say("He muttered something about a ceremony with Yajiro.")
wait(3)
self.room:spawn_object(580, 109)
self:command("give key " .. tostring(actor))
self:say("Perhaps he holds some kind of key to the conspiracy.")