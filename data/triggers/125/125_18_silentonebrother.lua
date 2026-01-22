-- Trigger: SilentOneBrother
-- Zone: 125, ID: 18
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12518

-- Converted from DG Script #12518: SilentOneBrother
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:send("The Silent One's voice cracks as he starts to speak.")
wait(2)
self.room:find_actor("silent"):emote("says in a ragged voice, 'My brother... sent you?'")
wait(1)
self.room:send("The Silent One's eyes brighten.")
wait(1)
self.room:send("The Silent One says, 'Our grandfather's warhammer was stolen by Krisenna, the")
self.room:send("</> demon lord.  The portal to his realm is nearby, but a stone to activate it is")
self.room:send("</> missing.'")
wait(3)
self.room:find_actor("silent"):say("Please, find it, and return the hammer to my brother.")
wait(3)
self.room:find_actor("silent"):emote("clutches his wounds as his eyes roll back, and he collapses.")
actor:damage(20000, true)  -- silent damage