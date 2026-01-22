-- Trigger: ice_shards_khysan_receive6
-- Zone: 103, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: zone
--
-- Original DG Script: #10323

-- Converted from DG Script #10323: ice_shards_khysan_receive6
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("ice_shards")
if stage == 8 then
    wait(2)
    actor.name:advance_quest("ice_shards")
    self.room:send("Khysan carefully opens " .. tostring(object.shortdesc) .. " and starts to read.")
    wait(2)
    self.room:send("<b:yellow>Letters and images float up out of " .. tostring(object.shortdesc) .. " and begin to dance around Khysan.</>")
    self:destroy_item("book")
    wait(3)
    self.room:send("Khysan's eyes glaze over and his jaw goes slack.")
    -- UNCONVERTED: zone
    wait(5)
    self.room:send("Khysan shakes his head and snaps back into reality.")
    wait(2)
    self:say("Here's what it says: The gods were so afraid of the sheer amount of mystical knowledge in Shiran they tried to destroy it.")
    wait(3)
    self:say("Only it turns out, by then the library was so magically defended even the gods couldn't just obliterate it.")
    wait(2)
    self:say("So instead, they ripped open the time stream and tossed the library into it, causing the Time Cataclysm that destroyed Shiran and loosed the Time Elementals on Ethilien!")
    wait(6)
    self:say("But according to the book, the people trapped in the library were eventually able to create a sort of \"time key\".  They convinced a mighty Time Elemental Lord to bring it to our epoch where, in theory, it should still be!  By bringing the key to the ruins of the tower and somehow activating it, one can traverse between the ages!!")
    wait(9)
    self:say("WHAT?!")
    self:command("bounce")
    wait(2)
    self:say("This is AMAZING!!")
    wait(3)
    self:say("Well, I guess that means there's one more place to go!  Find that key, travel into the past, find a copy of Ice Shards, and bring it back to the future!")
    wait(2)
    self:command("salute " .. tostring(actor.name))
    self:say("Good luck my friend!")
end