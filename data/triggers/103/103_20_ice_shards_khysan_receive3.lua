-- Trigger: ice_shards_khysan_receive3
-- Zone: 103, ID: 20
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10320

-- Converted from DG Script #10320: ice_shards_khysan_receive3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("ice_shards")
if stage == 3 then
    wait(2)
    actor.name:advance_quest("ice_shards")
    self:destroy_item("book")
    self:emote("sits down and reads through Commander Thraja's journal.")
    wait(3)
    self:say("There is quite a lot of detail about the Frost Elves and their general movements, but it doesn't look like Thraja ever figured out where they were coming from.  She also notes the elves don't seem to be invading so much as patrolling the area.")
    wait(3)
    self:emote("flips a few more pages.")
    wait(3)
    self:say("Thraja also notes maps of the region are unreliable as the terrain can subtly shift, almost like the valley is changing somehow.")
    wait(3)
    self:say("She says the best map she ever had of the region was a slightly magical one she received from Kara-Sithri but it was stolen by someone called \"The Butcher of Anduin.\"")
    wait(6)
    self:emote("looks up from the journal.")
    self:say("Oh my, that's not a subtle name at all is it?")
    wait(3)
    self:say("Apparently some kind of serial killer, the Butcher may have wanted the map to expand his reign of terror into the region around Ickle.  Or he may have just been looking for some valuables to pawn near his hideout.")
    wait(6)
    self:say("Thraja hasn't seen the map since.")
    wait(4)
    self:emote("closes the journal.")
    wait(3)
    self:say("Well if this map really was some kind of ancient magical device, it might help us determine where Shiran was.")
    wait(4)
    self:say("I guess you could ask around the pawnshop in Anduin, see if you can figure out what the Butcher did with the map.")
end