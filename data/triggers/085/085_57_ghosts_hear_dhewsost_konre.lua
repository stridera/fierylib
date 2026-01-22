-- Trigger: ghosts hear Dhewsost Konre
-- Zone: 85, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8557

-- Converted from DG Script #8557: ghosts hear Dhewsost Konre
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: dhewsost konre
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "dhewsost") or string.find(string.lower(speech), "konre")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("resurrection_quest") > 0 then
    self.room:send_except(actor, "<b:cyan>" .. tostring(self.name) .. " is shaken by " .. tostring(actor.name) .. "'s powerful utterance!</>")
    actor:send("<b:cyan>" .. tostring(self.name) .. " is shaken by your powerful utterance!</>")
    local quester = actor.name
    globals.quester = globals.quester or true
end