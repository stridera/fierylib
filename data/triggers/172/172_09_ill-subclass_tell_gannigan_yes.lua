-- Trigger: Ill-subclass: Tell Gannigan yes
-- Zone: 172, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player tells Gannigan "yes" (remembers the incantation). At stage 4 he
-- urges them to escape across the falls. At 5 he condemns their
-- treachery. Other stages get a glare.
--
-- Original DG Script: #17209

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
wait(0.6)
-- switch on actor:get_quest_stage("illusionist_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("illusionist_subclass") or ""))
    if tonumber(_sw1) == 4 then
        self:say("I thought you might.  Hurry off to the safe room!")
        wait(4)
        self:say("Please, Cestia!  I'll not have you clubbed by the filthy Mielikki militia!")
    elseif tonumber(_sw1) == 5 then
        self:command("snort")
        wait(3)
        self:say("I had no doubt of it.  You never knew loyalty.  I should have seen it when you hurt that illusionist so cavalierly.")
    else
        self:command("glare " .. tostring(actor.name))
        wait(2)
        self:command("ponder")
    end
end