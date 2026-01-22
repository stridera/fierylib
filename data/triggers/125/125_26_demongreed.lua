-- Trigger: DemonGreed
-- Zone: 125, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12526

-- Converted from DG Script #12526: DemonGreed
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: greed money pouch  wergeld wergild
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "greed") or string.find(string.lower(speech), "money") or string.find(string.lower(speech), "pouch") or string.find(string.lower(speech), "wergeld") or string.find(string.lower(speech), "wergild")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor.name:advance_quest("krisenna_quest")
    wait(1)
    self:say("Ahh yes, the sin of sins.  Very well, I will give you my coins.")
    wait(2)
    self:say("But, you must promise to not let others know about us.")
    wait(1)
    self:say("Saving ourselves the trouble would be worth it.")
    wait(2)
    self:emote("stops using a pouch full of money.")
    self.room:spawn_object(125, 44)
    self:command("drop pouch")
    self:say("Now...")
    wait(2)
    self:say("BEGONE!")
end