-- Trigger: LP_bard_subclass_speech2
-- Zone: 43, ID: 55
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4355

-- Converted from DG Script #4355: LP_bard_subclass_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"audition", "audition?", "process", "process?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    do
        if actor:get_quest_stage("bard_subclass") == 0 then
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'We're looking for someone who can sing and dance and act - a real triple threat.  It'll earn you a place in the spotlight and the Bard Guild.  You'll be a real professional!'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Whadda ya say kid?  You wanna give it a shot?'")
        end
    end
end