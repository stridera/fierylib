-- Trigger: ice_shards_khysan_receive7
-- Zone: 103, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10324
-- Stage 10 turn-in: handing Khysan the rescued spell book (legacy
-- 10325 → (103, 25)) closes the quest and grants the player the
-- Ice Shards skill.

if actor:get_quest_stage("ice_shards") == 10 then
    wait(2)
    self:destroy_item("book")
    self:command("hug " .. actor.name)
    self:say("I don't know how I can ever express my gratitude to you for bringing this to me.  The Sunfire clan will be sure this knowledge is never lost again.")
    wait(4)
    self:say("Come, let's read this together.")
    self:emote("opens the book and flips forward a few pages.")
    wait(3)
    self:emote("points to a page.")
    self:say("Here it is!")
    wait(2)
    actor:send("Although the spell is written in ancient Elvish, the intent and meaning are clear enough to replicate it!")
    actor:complete_quest("ice_shards")
    skills.set_level(actor, "ice shards", 100)
    actor:send("<b:cyan>You have learned Ice Shards!</>")
end