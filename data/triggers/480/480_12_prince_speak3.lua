-- Trigger: prince_speak3
-- Zone: 480, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48012

-- Converted from DG Script #48012: prince_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"failed?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 then
    wait(2)
    self:say("Yes.  I was too confident and his dark infidel champion overcame me.")
    self:command("grumble")
    wait(1)
    self:say("As a punishment, the King brought me back to life, and now I am compelled to do his bidding.")
    self:command("frown")
    if actor.level >80 then
        self:say("But you might be powerful enough to destroy him.")
    else
        self:say("It is a shame you will not be powerful enough to destroy him.")
    end
end