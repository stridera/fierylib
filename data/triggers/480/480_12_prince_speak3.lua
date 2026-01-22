-- Trigger: prince_speak3
-- Zone: 480, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48012

-- Converted from DG Script #48012: prince_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: failed?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "failed?")) then
    return true  -- No matching keywords
end
if actor.alignment > 350 then
    wait(2)
    self:say("Yes.  I was too confident and his dark infidel champion overcame me.")
    self:command("grumble")
    wait(1)
    self:say("As a punishment, the King brought me back to life, and now I am compelled to do his bidding.")
    self:command("frown")
    if actor.level >80 then
        self:say("But you might be powerful enough to destroy him.")
    else
        self:say("It is a shame you will not be powerful enough to destroy him.")
    end
end