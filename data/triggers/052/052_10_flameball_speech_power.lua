-- Trigger: flameball_speech_power
-- Zone: 52, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5210

-- Converted from DG Script #5210: flameball_speech_power
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: power power? worth worth? prove prove? how how?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "power") or string.find(string.lower(speech), "power?") or string.find(string.lower(speech), "worth") or string.find(string.lower(speech), "worth?") or string.find(string.lower(speech), "prove") or string.find(string.lower(speech), "prove?") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "how?")) then
    return true  -- No matching keywords
end
wait(2)
-- switch on actor:get_quest_stage("emmath_flameball")
if actor:get_quest_stage("emmath_flameball") == 1 then
    actor.name:advance_quest("emmath_flameball")
    actor:send(tostring(self.name) .. " says, 'Yes, you would need to show mastery over the fire.'")
    self:emote("pulls out his well-used thinking cap, and begins to think.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bring me the three parts of flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.  I think we can talk again then.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Ask about your <b:red>[quest progress]</> if you need.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'Well? Go on, then!'")
elseif actor:get_quest_stage("emmath_flameball") == 2 then
    self:command("mutter " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'I told you, not until you bring me all three flames!'")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    self:command("peer " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Didn't we talk about this already?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Bring me the renegade flame!'")
end