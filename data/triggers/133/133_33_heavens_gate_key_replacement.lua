-- Trigger: heavens_gate_key_replacement
-- Zone: 133, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13333

-- Converted from DG Script #13333: heavens_gate_key_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: grant me a new key
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "grant") or string.find(string.lower(speech), "me") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "key")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("heavens_gate") == 3 then
    wait(2)
    if actor:has_item("13351") then
        actor:send("<b:cyan>You already possess a Key of Heaven.</>")
    else
        self.room:send("<b:white>The stars coalesce into a shining key!</>")
        self.room:spawn_object(133, 51)
        self:command("give key-heaven " .. tostring(actor))
    end
end