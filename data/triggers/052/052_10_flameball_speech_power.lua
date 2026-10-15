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

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"power", "power?", "worth", "worth?", "prove", "prove?", "how", "how?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(0.2)
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("emmath_flameball") or ""))
    if tonumber(_sw1) == 1 then
        actor:advance_quest("emmath_flameball")
        actor:send(tostring(self.name) .. " says, 'Yes, you would need to show mastery over the fire.'")
        self:emote("pulls out his well-used thinking cap, and begins to think.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Bring me the three parts of flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.  I think we can talk again then.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Ask about your <b:red>[quest progress]</> if you need.'")
        wait(7)
        actor:send(tostring(self.name) .. " says, 'Well? Go on, then!'")
    elseif tonumber(_sw1) == 2 then
        self:command("mutter " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " says, 'I told you, not until you bring me all three flames!'")
    elseif tonumber(_sw1) == 3 then
        self:command("peer " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " says, 'Didn't we talk about this already?'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Bring me the renegade flame!'")
    end
end