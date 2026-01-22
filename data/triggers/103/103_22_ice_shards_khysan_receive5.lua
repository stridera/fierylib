-- Trigger: ice_shards_khysan_receive5
-- Zone: 103, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10322

-- Converted from DG Script #10322: ice_shards_khysan_receive5
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("ice_shards")
if stage == 7 then
    wait(2)
    actor.name:advance_quest("ice_shards")
    self:destroy_item("book")
    self.room:send(tostring(self.name) .. " reads aloud, '\"The Lost Library of Shiran\".'")
    self:say("I... can't believe it's that obvious.")
    wait(3)
    self:emote("combs through the pages of the book.")
    wait(4)
    self:say("Okay, it's not that obvious. The book does talk about the library being destroyed for being a repository of too much mystical knowledge.  But it doesn't definitively say it was in Frost Valley.")
    wait(6)
    self:say("It does say the gods destroyed the library, claiming it was out of an abundance of caution, but was really an act of jealousy.")
    wait(5)
    self:say("What's even more interesting is what happened after!  A few of the gods repented and sought to atone for their crimes against Shiran.  They chronicled stories of good and evil as parables for what they had done and wrote those stories down into something called the \"Book of Redemption.\"")
    wait(7)
    self:say("This book serves as the basis for a mystic path to salvation for wayward beings.  The writings themselves are so powerful they pose to drive the reader insane if they're unable to withstand the strain on their will.")
    wait(6)
    self:say("I hate to say it, but this sounds like a 'no stone unturned' situation.  If you can find a copy of this book, I'm willing to try to read it.")
end