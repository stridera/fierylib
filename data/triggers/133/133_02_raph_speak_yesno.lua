-- Trigger: raph_speak_yesno
-- Zone: 133, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13302

-- Converted from DG Script #13302: raph_speak_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

local speech_lower = string.lower(speech)

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if string.find(speech_lower, "yes") then
        self:say("So you want to help me do you? Well that is useful, maybe I will survive.")
        actor:start_quest("get_raph_food")
        self:command("smile")
        self:say("Please go get me some grain, I am very hungry and may pass on at any time.")
    end
    if string.find(speech_lower, "no") then
        self:say("Fine, let me die get out!")
        self:command("spit " .. tostring(actor.name))
        wait(1)
        actor:send("Raph taps his wrists together and you are covered in smoke!")
        self.room:send_except(actor, "Raph glares at " .. tostring(actor.name) .. " and sends him elsewhere!")
        actor:teleport(get_room(133, 1))
    end
end