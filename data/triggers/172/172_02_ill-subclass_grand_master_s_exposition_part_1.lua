-- Trigger: Ill-subclass: Grand Master's exposition, part 1
-- Zone: 172, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player asks the Grand Master to begin the illusionist quest. He launches
-- into the backstory of Cestia and the choker, and instructs the player to
-- say 'continue' for part 2.
--
-- Original DG Script: #17202

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "ok") or string.find(speech_lower, "okay") or string.find(speech_lower, "sure") or string.find(speech_lower, "favor") or string.find(speech_lower, "what")) then
    return true  -- keyword not heard
end

-- Only sorcerers in the right level band get the story; everyone else gets
-- a brief brushoff.
if not string.find(actor.class, "Sorcerer") then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Nope, not a sorcerer, can't help.'")
    return true
end

if actor.level < 10 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You're not ready to have your mind blown!'")
    return true
elseif actor.level > 45 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It's okay, you're too late to care.'")
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says, 'Are you ready to hear the story?  Well, here it comes!'")
wait(4)
actor:send(tostring(self.name) .. " says, 'When you feel that you're ready, you can say <b:cyan>'begin'</>.  Then I'll outfit you for this quest.  But for now, listen carefully.'")
wait(5)
actor:send(tostring(self.name) .. " says, 'This is what I need you to do...'")
wait(3)
actor:send(tostring(self.name) .. " says, 'That ruffian in the smuggler's hideout once stole a woman from me, on the very eve of our betrothal announcement.  Or my pride, perhaps.  It appears that she was his from the very beginning.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'She has departed, she is lost, my dear Cestia...  She boarded a ship for the southern seas and never returned.  I fear she is dead.  But she may have survived, and on that fact this plan hinges.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'I gave her a valuable onyx choker as a betrothal gift.  She took it in her deceit.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'The smuggler leader took the choker, and keeps it as a prize.  To humiliate me, perhaps.  And now he has raised defenses that even I cannot penetrate.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'He knows my fatal weakness: hay fever.'")
wait(3)
actor:send(tostring(self.name) .. " says, 'So he has placed flowers, to reveal me should I enter his home in disguise.'")
wait(5)
self:emote("pauses for breath.")
wait(4)
actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'continue'</> when you're ready to hear the rest.'")