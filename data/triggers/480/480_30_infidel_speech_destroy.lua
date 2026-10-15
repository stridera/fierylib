-- Trigger: Infidel speech destroy?
-- Zone: 480, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48030

-- Converted from DG Script #48030: Infidel speech destroy?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destroy?", "destroy"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment < -349 then
    if actor.level > 80 then
        wait(0.2)
        self:say("If you bring me the prince's skull, I can reward you.")
        wait(0.1)
        self:say("He is bound by certain rules.  If you say 'the champion wishes to challenge you by proxy', he will be forced to fight you.")
        wait(0.1)
        self:command("smile")
        self:say("That way, my victory will be absolute.")
    else
        self:say("If you are able to return once you are stronger, perhaps you can be of great assistance then.")
        wait(0.1)
        self:say("Now leave.")
    end
end