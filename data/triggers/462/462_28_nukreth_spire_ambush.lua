-- Trigger: Nukreth Spire ambush
-- Zone: 462, ID: 28
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #46228

-- Converted from DG Script #46228: Nukreth Spire ambush
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
if actor.id == 46220 or actor.id == 46221 or actor.id == 46222 or actor.id == 46223 then
    wait(2)
    self.room:find_actor("captive"):follow(self.room:find_actor("me"))
    self.room:send("Two gnoll trackers leap out of the shadows and attack!")
    self.room:send("A gnoll tracker says, 'Devour it before it escapes!!'")
    self.room:spawn_mobile(462, 1)
    self.room:spawn_mobile(462, 1)
    self.room:find_actor("captive"):say("Help me!!")
end