-- Trigger: Spark pixy makes an offer
-- Zone: 615, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61505

-- Converted from DG Script #61505: Spark pixy makes an offer
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
if globals.greeted_someone == 1 and actor.name == globals.person_to_help and globals.heart_inplace ~= 1 then
    wait(1)
    self:say("Well, sometimes the dark fliers put something very bright on this menhir,")
    self:say("which burns away the fog.")
    wait(3)
    self:command("giggle")
    wait(1)
    self:say("Whatever it is, its heat and light makes the poor dears whimper so piteously...")
    wait(3)
    self:whisper(actor.name, "I think there's a secret tunnel hidden somewhere up to north.")
    self:whisper(actor.name, "But it's hard to find in all that fog.")
    wait(3)
    self:say("I'm not sure what it is, exactly, but if you bring me something bright,")
    self:say("I'll put it up on top of the menhir.  Then we'll see what happens!")
    wait(1)
end