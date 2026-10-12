-- Trigger: chapman_rosa
-- Zone: 43, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4310

-- Converted from DG Script #4310: chapman_rosa
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: You best step off! (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "you best step off!", 1, true) then
    return true  -- Not the phrase
end
if actor.zone_id == 43 and actor.local_id == 5 then
    self:emote("puts his hand up in a player's face.")
    wait(3)
    self:say("Oh yes I di' Rosa!")
    wait(3)
    self:say("You don' get ta tell me what ta do!")
    self:emote("puts one hand on his hip and flails the other hand around.")
end