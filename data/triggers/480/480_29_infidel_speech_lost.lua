-- Trigger: Infidel speech lost
-- Zone: 480, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48029

-- Converted from DG Script #48029: Infidel speech lost
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: lost?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "lost?")) then
    return true  -- No matching keywords
end
if actor.alignment < -349 then
    wait(2)
    self:command("laugh")
    self:say("Yes.  He was overconfident and reckless.  I easily snuffed him out.")
    self:command("flex")
    wait(1)
    self:say("As a punishment, the King brought him back to life, and toys with him deep in this barrow.")
    wait(1)
    self:command("frown")
    self:say("But he continues to be a thorn in my King's side...  The prince continues to try to destroy my King, even as he became Eternal in Death.")
    wait(1)
    if actor.level >80 then
        self:say("But you might be powerful enough to destroy the prince for good.")
    else
        self:say("It is a shame you will not be powerful enough to destroy the prince forever.")
    end
end