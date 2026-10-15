-- Trigger: Ill-subclass: Tell Gannigan no
-- Zone: 172, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player tells Gannigan "no" (does not remember the incantation). At
-- stage 4 he reminds them of "where the dough ever rises". At 5 he
-- decides he will see about their loyalty. Other stages get an eyebrow.
--
-- Original DG Script: #17208

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"no"}) do
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
        actor:send(tostring(self.name) .. " says, 'Of course.  Here is the incantation: <b:cyan>\"where the dough ever rises\"</>.'")
        wait(4)
        self:say("Now get yourself quickly across the waterfall - The townspeople are almost upon us!")
    elseif tonumber(_sw1) == 5 then
        self:say("We'll see about that.")
    else
        self:command("peer " .. tostring(actor.name))
        wait(2)
        self:command("eyebrow")
    end
end