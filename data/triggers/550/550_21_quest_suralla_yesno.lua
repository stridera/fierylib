-- Trigger: quest_suralla_yesno
-- Zone: 550, ID: 21
-- Type: MOB, Flags: SPEECH
--
-- Suralla's yes/no response when offering the cryomancer subclass quest.
-- "yes" starts the quest (level 10-45 sorcerers only); "no" boots the
-- player back to room (550, 15) with a flash of light.
--
-- Original DG Script: #55021

-- Converted from DG Script #55021: quest_suralla_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true  -- No matching keywords
end
if not string.find(string.lower(actor.class), "sorcerer") then
    return true
end
wait(2)
if string.find(speech_lower, "yes") then
    if actor.race == "dragonborn_fire" or actor.race == "arborean" then
        actor:send("<red>Your race cannot subclass to cryomancer.</>")
    elseif actor.level >= 10 and actor.level <= 45 then
        actor:start_quest("cryomancer_subclass", "Cry")
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'At any time you may check your <b:cyan>[subclass progress]</>.'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
    elseif actor.level > 45 then
        actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
    end
else
    actor:send(tostring(self.name) .. " says, 'Very well, begone.  I feel like I have wasted time now thanks to you.'")
    self:command("sigh")
    actor:send("Suralla blinks several times at you, then it becomes very bright indeed!")
    self.room:send_except(actor, "Suralla begins blinking at " .. tostring(actor.name) .. " who is suddenly taken away in a flash of light.")
    actor:teleport(get_room(550, 15))
end