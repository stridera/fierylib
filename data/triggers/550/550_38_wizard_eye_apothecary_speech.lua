-- Trigger: wizard_eye_apothecary_speech
-- Zone: 550, ID: 38
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55038

-- Converted from DG Script #55038: wizard_eye_apothecary_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: wizard shaman crystal
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wizard") or string.find(string.lower(speech), "shaman") or string.find(string.lower(speech), "crystal")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(speech, "wizard eye") or string.find(speech, "the shaman sent me") or string.find(speech, "crystal ball") then
    if actor:get_quest_stage("wizard_eye") == 6 then
        actor.name:advance_quest("wizard_eye")
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
        actor:send(tostring(self.name) .. " says, 'Two varieties of roses grow in Mielikki, one <red>red</> and one &9<blue>black</>.  Bring back one of each.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'A third kind is carried by serpents in Dargentan's sky tower.  Even though it's <b:blue>made of sapphire</> which is not the best for divination, it'll lend extra potency to the attunement process.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'Bring me these ingredients and I'll make you a lovely incense.'")
    end
end