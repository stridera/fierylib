-- Trigger: quest_banter_magistrate2
-- Zone: 30, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3028

-- Converted from DG Script #3028: quest_banter_magistrate2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"attack", "attacks"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes yes..  That accursed Demon Lord who holds")
actor:send("</>dominion over the northern fortress of Mystwatch, and his fat headed general")
actor:send("</>too.'")
self:command("sigh")
wait(0.2)
actor:send(tostring(self.name) .. " says to you, 'If only we could be rid of them once and for")
actor:send("</>all, maybe these attacks would stop.  Will you help rid us of this curse?'")