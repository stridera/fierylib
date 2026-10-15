-- Trigger: priestess_speech3
-- Zone: 123, ID: 3
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12303

-- Converted from DG Script #12303: priestess_speech3
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"old", "why?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "old gods") or string.find(speech, "old gods?") or string.find(speech, "why?") then
    wait(0.2)
    self:say("You see, when the Nine Hells cracked open to vomit forth Sagece on Templace, the putrid rift she crawled through so corrupted the world around it, many of the Old Gods found their holy sites defiled and their physical access to Ethilien severed.")
    wait(6)
    self:say("The Great Mother was one such unfortunate victim.")
    wait(3)
    self:say("She is cast adrift in the Deep Dreaming, lost in that birthplace and graveyard of primordial stars.  The near-total annihilation of the elven race, constant assault on our world by demons, gods turning on each other in bloody slaughter...")
    self.room:send("</>")
    self.room:send(tostring(self.name) .. " says, 'All these calamities along with centuries of unearned exile are weakening Her bond with our world.  Our Mother is still capable of gifting us her divine magic, but She is <b:cyan>slipping away</> from us.'")
end