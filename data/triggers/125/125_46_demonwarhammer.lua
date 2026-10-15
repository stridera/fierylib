-- Trigger: DemonWarhammer
-- Zone: 125, ID: 46
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12546

-- Converted from DG Script #12546: DemonWarhammer
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"brother", "vengeance", "revenge", "hammer", "warhammer", "halfling"}) do
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
    actor:send("<b:white>You have furthered the quest!</>")
    actor:send("<b:white>Group credit will not be awarded for the next step of this quest.</>")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Its owner's death was such a shame, but unavoidable nonetheless.'")
    wait(2)
    self:say("Please, return his hammer to his family.")
    wait(2)
    self:emote("stops using a large stone warhammer.")
    self.room:spawn_object(125, 2)
    self:command("drop hammer")
end