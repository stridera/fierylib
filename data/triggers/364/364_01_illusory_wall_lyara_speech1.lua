-- Trigger: illusory_wall_lyara_speech1
-- Zone: 364, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Lyara introduces herself when an Illusionist/Bard >56 says "guard" or
-- "reinforcements", revealing she is Post Commander Ruzhana Lyara and
-- specialises in illusory walls.
--
-- Original DG Script: #36401

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reinforcements", "reinforcements?", "guard", "guard?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Yes, they still send requests for reinforcements")
    self.room:send("</>from time to time.'")
    wait(4)
    self:say("Wait, do you not know who I am?")
    wait(4)
    self:command("laugh")
    self:say("The name's Lyara.  Post Commander Ruzhana Lyara.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I served with the Eldorian Guard for many years as")
    self.room:send("</>Post Commander, the master of fortifications.  My speciality is magical walls")
    self.room:send("</>and barriers, particularly <b:magenta>I<cyan>l<magenta>l<cyan>u<magenta>s<cyan>o<magenta>r<cyan>y <magenta>W<cyan>a<magenta>l<cyan>l</>.  Even after my retirement, many have")
    self.room:send("</>sought me out asking me to teach them.'")
end