-- Trigger: DemonHorn
-- Zone: 125, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12528

-- Converted from DG Script #12528: DemonHorn
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"horn", "horns"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor:advance_quest("krisenna_quest")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Well, I suppose I must honor my obligations, and you have")
    self.room:send("</>certainly earned it.'")
    wait(1)
    self:emote("grasps a horn with both hands, grunts, and breaks it off.")
    wait(1)
    self:say("Not as painful as I thought.")
    wait(2)
    self.room:spawn_object(125, 54)
    self:command("drop horn")
end