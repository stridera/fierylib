-- Trigger: charm_person_hinazuru_speech1
-- Zone: 580, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58003

-- Converted from DG Script #58003: charm_person_hinazuru_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: specialty services yes like what? services? speciality?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "specialty") or string.find(string.lower(speech), "services") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "like") or string.find(string.lower(speech), "what?") or string.find(string.lower(speech), "services?") or string.find(string.lower(speech), "speciality?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard") then
    if actor.level > 88 then
        if actor:get_quest_stage("charm_person") == 0 then
            wait(2)
            self:say("I am not only a master of conversational and social arts, I am also highly trained in the mystic arts. Sorcerers and illusionists come from all across the world to learn my signature spell for charming others.")
            wait(2)
            self:say("If you are interested, I could teach you.  For a price.  100 platinum, at once, in advance, is my fee.")
        elseif actor:get_quest_stage("charm_person") == 1 then
            self:say("Marvelous!")
            wait(1)
            self:say("If you would be so kind as to give it to me, I can demonstrate its power.")
        end
    else
        self:say("Your determination is admirable, but I fear you still have some learning to do before I can teach you.")
    end
end