-- Trigger: flameball_speech_power
-- Zone: 52, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5210
--
-- "power"/"worth"/"prove"/"how" speech follow-up to #5209. On stage 1
-- advances to stage 2 and explains the three-flames task; later stages
-- get a stage-appropriate prod.

if not percent_chance(1) then
    return true
end

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "power") or string.find(speech_lower, "worth")
        or string.find(speech_lower, "prove") or string.find(speech_lower, "how")) then
    return true
end

wait(2)
if actor:get_quest_stage("emmath_flameball") == 1 then
    actor:advance_quest("emmath_flameball")
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