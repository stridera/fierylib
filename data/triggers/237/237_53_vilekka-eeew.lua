-- Trigger: vilekka-eeew
-- Zone: 237, ID: 53
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23753

-- Converted from DG Script #23753: vilekka-eeew
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: disgusting disgusting?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "disgusting") or string.find(string.lower(speech), "disgusting?")) then
    return true  -- No matching keywords
end
-- OK, this is in response to 23752, the returning of the Drider King's
-- head. (Why is she questioning? Check 23754 part 2..her goddess
-- is requiring that she eat the head and heart the player returns to her.
wait(2)
if (actor.id == -1) and (actor:get_quest_stage("vilekka_stew") == 5) then
    self:emote("looks shrewdly around the room.")
    wait(2)
    self:say("It is not that I question the will of my Goddess...")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'But perhaps it can be made easier.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'The Spider Queen requires of me that I eat this head and this heart.'")
    wait(4)
    self:say("But she did not say I should eat them plain.")
    self:emote("gets a wicked expression on her face.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'You!  " .. tostring(actor.name) .. "!  Bring me the ten finest herbs and spices from the realm!  I do not care where you get them from, but make sure they are the finest!'")
    wait(5)
    self:say("Return them to me and I will surely reward you.")
    self:command("wink " .. tostring(actor.name))
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Ask for a reminder of your <b:white>[progress]</> if you need.'")
    self.room:send("<b:white>Quest credit will only be awarded individually</>.")
end