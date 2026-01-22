-- Trigger: bishop room trig
-- Zone: 85, ID: 53
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #8553

-- Converted from DG Script #8553: bishop room trig
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:find_actor("bishop"):command("abort")
self.room:send(tostring(mobiles.template(85, 14).name) .. " says, 'You've done it!  Norisent must have sent you.  He has great admiration for those of us who dedicate ourselves to restoration magic.  He's sure to be pleased to hear of your involvement.'")
wait(3)
self.room:find_actor("bishop"):say("I must go now, while I have a chance.  Thank you so much!")
wait(3)
self.room:find_actor("bishop"):command("abort")
self.room:send("The bishop starts casting <b:yellow>'word of recall'</>...")
self.room:send("The bishop completes her spell.")
self.room:send("The bishop closes her eyes and utters the words, 'word of recall'.")
self.room:send("the bishop vanishes in a flash of light.")
world.destroy(self.room:find_actor("bishop"))