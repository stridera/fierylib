-- Trigger: ice_shards_khysan_receive4
-- Zone: 103, ID: 21
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10321

-- Converted from DG Script #10321: ice_shards_khysan_receive4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("ice_shards")
if stage == 6 then
    wait(2)
    actor.name:advance_quest("ice_shards")
    self:destroy_item("map")
    self:say("Incredible, you found it!")
    self:emote("excitedly lays out the map.")
    wait(1)
    self:emote("scours every tiny detail of the map.")
    wait(3)
    self:say("Let me compare...")
    -- (empty room echo)
    self:emote("opens to a passage in the Codex of War.")
    self:emote("glances between the Codex and the map.")
    wait(4)
    self:say("And in Thraja's journal...")
    self:emote("compares a passage in Thraja's journal.")
    wait(3)
    self:say("The Codex mentions a site of incredible significance in the middle of Frost Lake, and both the map and Thraja's journal point to the remains of a tower of some kind on an island in the lake.")
    wait(6)
    self:say("The map indicates the edges of a huge city that once overlooked the plateau at the west edge of the valley.  Thraja notes a man named Ysgarran built some kind of fortification over a preexisting structure out there...")
    wait(7)
    self:say("Go check it out.  Assuming that was Shiran, maybe there's a clue there?  Bring back anything you find, especially if you find any written records of the region.")
end