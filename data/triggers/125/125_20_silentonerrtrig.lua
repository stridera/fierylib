-- Trigger: SilentOneRRTrig
-- Zone: 125, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12520

-- Converted from DG Script #12520: SilentOneRRTrig
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"brother"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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