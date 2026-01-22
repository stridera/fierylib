-- Trigger: kill_rana
-- Zone: 510, ID: 12
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #51012

-- Converted from DG Script #51012: kill_rana
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.id == 51010 then
    wait(1)
    self.room:send("An large image of a face appears in the room.")
    self.room:find_actor("rana"):say("I'll kill you Luchiaans, but slowly")
    self.room:send(tostring(actor.name) .. " waves the petrified magic defiantly.")
    self.room:find_actor("rana"):say("This will protect me against you.")
    wait(5)
    self.room:send("The aparition laughs and says a couple of words.")
    actor:damage(10000)  -- type: physical
    self.room:send("The aparition chuckles and says, 'Well, HE underestimated my power bigtime.'")
    wait(5)
    self.room:send("The aparition fades.")
end