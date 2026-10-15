-- Trigger: Injured halfling help
-- Zone: 125, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12545

-- Converted from DG Script #12545: Injured halfling help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
local instruct = false
for _, person in ipairs(actor.group) do
    if person.room == self.room then
        if person:get_quest_stage("krisenna_quest") < 2 then
            instruct = true
            if person:get_quest_stage("krisenna_quest") == 0 then
                person:start_quest("krisenna_quest")
                person:send("<b:white>You have now begun the Tower in the Wastes quest!</>")
            end
        end
    end
end
if instruct then
    self.room:send(tostring(self.name) .. "'s eyes brighten.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you find him, tell him his brother is looking for him.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you need an update, you can check your <b:cyan>[progress]</> with me.'")
end