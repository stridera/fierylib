-- Trigger: quest_details_silania
-- Zone: 185, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18504

-- Converted from DG Script #18504: quest_details_silania
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: quest quest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "quest?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("pri_pal_subclass") == 1 then
    actor.name:advance_quest("pri_pal_subclass")
    actor:send(tostring(self.name) .. " says, 'At this abbey we have always permitted any person to wander freely.'")
    wait(1)
    self:command("ponder")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Well, not if they are evily aligned, but otherwise...'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'One of our guests made off with our most sacred bronze chalice.'")
    self:command("steam")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We have reason to believe it was a ruse by the filthy diabolists to try and weaken us.  Our Prior has offered to try and retrieve it for us, but...'")
    wait(2)
    self:command("think")
    actor:send(tostring(self.name) .. " says, 'I think perhaps that would be a bad idea and that you should find it instead.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck, your quest has begun!'")
    self:command("bow")
end