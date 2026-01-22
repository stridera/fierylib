-- Trigger: Spark pixy makes an offer
-- Zone: 615, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61505

-- Converted from DG Script #61505: Spark pixy makes an offer
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
if greeted_someone == 1 and string.find(actor.name, "person_to_help") and heart_inplace ~= 1 then
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