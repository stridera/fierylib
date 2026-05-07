-- Trigger: common_child_rand1
-- Zone: 510, ID: 27
-- Type: MOB, Flags: RANDOM
--
-- Original DG Script: #51027
-- 50% per random tick: the two-headed child squabbles over which
-- head learned the decode-phrase first.

if not percent_chance(50) then
    return true
end
self.room:send("One head looks at the other and says, 'So how do you know the phrase is kafit, and I don't?'")
self.room:send("The second head smirks disturbingly, its eyes flat and lifeless.")
self.room:send("The second head responds, 'Because I was awake before you when he had to decode his final spell.'")