-- Trigger: ice_shards_khysan_speech1
-- Zone: 103, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10310
-- Word-boundary speech match (DG narg 1) on "spell"/"powerful"/
-- "ever". Khysan teases the player with a fragment of cryomantic
-- lore about Ice Shards. Cryomancer-only.

local s = string.lower(speech)
if not (string.find(s, "spell") or string.find(s, "powerful") or string.find(s, "ever")) then
    return true
end
if not string.find(actor.class, "Cryomancer") then
    return true
end

wait(2)
self.room:send(self.name .. " says, 'The spell was called Ice Shards.  Supreme cryomancers")
self.room:send("</>could conjure a multitude of glistening ice fragments to annihilate their")
self.room:send("</>foes.'")
wait(2)
self:say("But that magic is lost to us now.")