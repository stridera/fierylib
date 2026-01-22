-- Trigger: SilentOneRRTrig
-- Zone: 125, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #12520

-- Converted from DG Script #12520: SilentOneRRTrig
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: brother Brother
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "brother") or string.find(string.lower(speech), "brother")) then
    return true  -- No matching keywords
end
local stage = 1
local person = actor
local cap = 4
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("krisenna_quest") < cap then
            local run = "yes"
            if person:get_quest_stage("krisenna_quest") == "stage" then
                person.name:advance_quest("krisenna_quest")
                person:send("<b:white>You have furthered the quest!</>")
            end
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if run then
    run_room_trigger(12518)
end