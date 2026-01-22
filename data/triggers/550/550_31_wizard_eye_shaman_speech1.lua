-- Trigger: wizard_eye_shaman_speech1
-- Zone: 550, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55031

-- Converted from DG Script #55031: wizard_eye_shaman_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: eye scrying divination ball yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "scrying") or string.find(string.lower(speech), "divination") or string.find(string.lower(speech), "ball") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("wizard_eye")
if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist") then
    if actor.level > 80 then
        if stage == 0 then
            actor:send(tostring(self.name) .. " says, 'Ah, so you wish to gain the Sight of the Great Snow Leopard.'")
            self:command("nod")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Yes, I can teach you this spell.  But casting it is much more complicated than simple words and gestures.  You will need a uniquely attuned crystal ball to scry upon.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'There are four other master diviners in the world. You will need to visit each one to figure out which items are best attuned to you.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Let us start with the one furthest away.  There is a <b:cyan>gypsy witch who dwells in South Caelia</>.  Find her and <b:cyan>ask what you will need for Wizard Eye</>.'")
            actor.name:start_quest("wizard_eye")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'You may return to me and check your <b:cyan>[spell progress]</> at any time.'")
        elseif stage == 2 or stage == 5 or stage == 8 then
            actor:send(tostring(self.name) .. " says, 'Give it to me then, please.'")
        end
    else
        self:command("shake")
        actor:send(tostring(self.name) .. " says, 'You are not ready to learn such advanced magics.  Meddling with divinations you are not prepared to handle can rip your mind apart!  I will not be responsible for such a thing again...'")
    end
else
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'That spell is outside your ability to cast.'")
end