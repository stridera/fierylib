-- Trigger: charm_person_hinazuru_speech1
-- Zone: 580, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Hinazuru pitches her Charm Person training to qualifying casters
-- (Sorcerer/Illusionist/Bard, level > 88) when they ask about her
-- specialty services. Quotes a 100 platinum bribe; payment routes
-- through the BRIBE trigger (580_04).
--
-- TODO: original DG probability was 1%. The keyword-gated speech
-- trigger probably wants 100% (the 1% would make the offer effectively
-- undiscoverable). Confirm intent before changing.

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"specialty", "services", "yes", "like", "what?", "services?", "speciality?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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