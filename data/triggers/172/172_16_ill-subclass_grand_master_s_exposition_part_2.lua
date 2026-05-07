-- Trigger: Ill-subclass: Grand Master's exposition, part 2
-- Zone: 172, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player says 'continue' after part 1 of the exposition. Eligible
-- sorcerers (level 10-45, quest not yet started) get the rest of the
-- briefing - vial-drop strategy, disguise plan, etc. Mid-quest players
-- get a confused nudge back to 'restart'.
--
-- Original DG Script: #17216

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "continue") then
    return true  -- keyword not heard
end

local stage = actor:get_quest_stage("illusionist_subclass")

if string.find(actor.class, "Sorcerer")
    and actor.level >= 10 and actor.level <= 45
    and stage == 0 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'This is where you come in.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I would like you to enter the hideout in disguise and take back the choker.  But beware: it is well hidden.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Somehow that brutish fool has engaged the services of an illusionist... I would like to know who helped him... but no matter.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'I will enchant you to resemble dear Cestia when the smugglers look upon you.  Their leader will no doubt welcome you with open arms.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'But we must ensure that he will reveal its hiding place to you.  For that, we will make it appear as if the guards of Mielikki have discovered their hideout.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'It is my hope that the leader will hide you - Cestia - for safekeeping, in his most secure location.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'There, perhaps, you will find the choker.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I will give you a vial of disturbance.  Drop it and once you find their leader Gannigan sounds of shouting and fighting will resonate throughout the area.  It will convince the smugglers that they are under attack.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'You must take care to drop it out of sight of any smugglers, or they may become suspicious.  Then go immediately to the leader, and stall him until you hear the sounds of invasion.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'Well, what say you?  Are you up for it?  Say <b:cyan>'begin'</> if you are ready!'")
    return true
end

if stage > 0 and not actor:get_has_completed("illusionist_subclass") then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Continue what?  Why aren't you infiltrating the hideout?'")
    wait(3)
    self:command("ponder " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'restart'</> if you've gotten stuck.'")
end