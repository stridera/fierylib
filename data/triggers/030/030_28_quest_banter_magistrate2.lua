-- Trigger: quest_banter_magistrate2
-- Zone: 30, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3028

-- Converted from DG Script #3028: quest_banter_magistrate2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: attack attacks
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "attack") or string.find(string.lower(speech), "attacks")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes yes..  That accursed Demon Lord who holds")
actor:send("</>dominion over the northern fortress of Mystwatch, and his fat headed general")
actor:send("</>too.'")
self:command("sigh")
wait(2)
actor:send(tostring(self.name) .. " says to you, 'If only we could be rid of them once and for")
actor:send("</>all, maybe these attacks would stop.  Will you help rid us of this curse?'")