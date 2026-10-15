-- Trigger: ice_shards_khysan_speech1
-- Zone: 103, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10310
-- Word-boundary speech match (DG narg 1) on "spell"/"powerful"/
-- "ever". Khysan teases the player with a fragment of cryomantic
-- lore about Ice Shards. Cryomancer-only.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"spell", "spell?", "powerful", "powerful?", "ever", "ever?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not string.find(actor.class, "cryomancer") then
    return true
end

wait(0.2)
self.room:send(self.name .. " says, 'The spell was called Ice Shards.  Supreme cryomancers")
self.room:send("</>could conjure a multitude of glistening ice fragments to annihilate their")
self.room:send("</>foes.'")
wait(2)
self:say("But that magic is lost to us now.")