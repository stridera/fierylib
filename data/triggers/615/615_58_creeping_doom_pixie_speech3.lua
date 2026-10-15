-- Trigger: creeping_doom_pixie_speech3
-- Zone: 615, ID: 58
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61558

-- Converted from DG Script #61558: creeping_doom_pixie_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"nature", "majesty", "treat", "remind", "nature?", "majesty?", "treat?", "remind?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            wait(0.2)
            self.room:send(tostring(self.name) .. " says, 'They have lost their respect for Nature and us,")
            self.room:send("</>its fey emissaries.  They slaughter our families like pigs.  They burn the")
            self.room:send("</>forests and overhunt the fields.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'They no longer fear us.")
            self.room:send("</>We who come for their children in the night.")
            self.room:send("</>We who bring nightmares to generations.")
            self.room:send("</>We who dream a Dream they should pray we never awaken from.'")
            wait(2)
            self:say("They have forgotten.")
            wait(4)
            self:say("We will make them remember.")
        end
    end
end