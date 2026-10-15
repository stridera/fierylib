-- Trigger: wizard_eye_apothecary_speech
-- Zone: 550, ID: 38
-- Type: MOB, Flags: SPEECH
--
-- The Green Woman (Anduin apothecary) gives the player the recipe for
-- the rose-and-cinnamon scrying incense, advancing the wizard_eye quest
-- from stage 6 -> 7.
--
-- Original DG Script: #55038

-- Converted from DG Script #55038: wizard_eye_apothecary_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wizard", "shaman", "crystal"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if string.find(speech, "wizard eye") or string.find(speech, "the shaman sent me") or string.find(speech, "crystal ball") then
    if actor:get_quest_stage("wizard_eye") == 6 then
        actor:advance_quest("wizard_eye")
        self:command("grin")
        actor:send(tostring(self.name) .. " says, 'Well then that's a different sort of brew!'")
        wait(1)
        self:command("peer " .. tostring(actor))
        wait(3)
        actor:send(tostring(self.name) .. " says, 'No, not a brew...  But perhaps... a smell?'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Yes, that should do it!  Incense to increase your psychic reach is what you need.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Two things that work very well together are <red>roses</> and <red>cinnamon</>.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Cinnamon is fairly straight-forward.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Roses, on the other hand, may be more tricky...'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'You need three varieties.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Two varieties of roses grow in Mielikki, one <red>red</> and one <b:black>black</>.  Bring back one of each.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'A third kind is carried by serpents in Dargentan's sky tower.  Even though it's <b:blue>made of sapphire</> which is not the best for divination, it'll lend extra potency to the attunement process.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'Bring me these ingredients and I'll make you a lovely incense.'")
    end
end