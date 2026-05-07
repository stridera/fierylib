-- Trigger: SilentOneRRTrig
-- Zone: 125, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12520

-- Converted from DG Script #12520: SilentOneRRTrig
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: brother Brother
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "brother") then
    return true  -- No matching keywords
end
local stage = 1
local cap = 4
local run = false
for _, person in ipairs(actor.group) do
    if person.room == self.room then
        if person:get_quest_stage("krisenna_quest") < cap then
            run = true
            if person:get_quest_stage("krisenna_quest") == stage then
                person:advance_quest("krisenna_quest")
                person:send("<b:white>You have furthered the quest!</>")
            end
        end
    end
end
if run then
    run_room_trigger(125, 18)
end