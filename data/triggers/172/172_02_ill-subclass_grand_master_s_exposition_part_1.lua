-- Trigger: Ill-subclass: Grand Master's exposition, part 1
-- Zone: 172, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17202

-- Converted from DG Script #17202: Ill-subclass: Grand Master's exposition, part 1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes y ok okay sure favor? what? favor what
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "y") or string.find(string.lower(speech), "ok") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "favor?") or string.find(string.lower(speech), "what?") or string.find(string.lower(speech), "favor") or string.find(string.lower(speech), "what")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("illusionist_subclass")
if string.find(actor.class, "Sorcerer") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 45
    -- msend %actor% &1%Your race may not subclass to illusionist.&0
    -- endif
    -- break
    wait(1)
    if actor.level >= 10 and actor.level <= 45 then
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
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You're not ready to have your mind blown!'")
    else
        actor:send(tostring(self.name) .. " says, 'It's okay, you're too late to care.'")
    end
else
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Nope, not a sorcerer, can't help.'")
end
wait(1)
actor:send(tostring(self.name) .. " says, 'Well?  Take the <b:yellow>vial</> to the smuggler's hideout.  <b:cyan>Drop it</>, and go see the leader.'")
wait(1)
actor:send(tostring(self.name) .. " says, 'Ah, foolish one.  You must be quick, once the smugglers are up in arms.  If you want another vial to try again say <b:cyan>'begin'</>.'")
actor.name:restart_quest("illusionist_subclass")
wait(1)
actor:send(tostring(self.name) .. " says, 'Good work!  Do you have the choker?  Please give it to me.'")