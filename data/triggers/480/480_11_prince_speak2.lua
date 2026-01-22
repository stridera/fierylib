-- Trigger: prince_speak2
-- Zone: 480, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48011

-- Converted from DG Script #48011: prince_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: destroy?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "destroy?")) then
    return true  -- No matching keywords
end
if actor.alignment > 350 then
    if actor.level > 80 then
        wait(2)
        self:say("Yes.  He is still alive due to his magic arts, and so he can still be killed.")
        wait(1)
        self:say("He is a coward, however, and I have heard that when the tides of battle turn against him, he is quick to disappear.")
        self:say("I may have something to help you with that if you are willing to... trade.")
    else
        wait(2)
        self:say("Sadly yes, you have come too soon.  If you are able to return once you are stronger, perhaps you can be of great assistance then.")
    end
end