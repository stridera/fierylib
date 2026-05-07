-- Trigger: blur_winds_greet
-- Zone: 18, ID: 29
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #1829

-- Converted from DG Script #1829: blur_winds_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("blur") == 4 and self.zone_id == 18 then
    if self.local_id == 19 then  -- North Wind
        self.room:send("A mighty chill blows through the temple.")
        wait(2)
        self:say("So you come to test your speed against me?")
    elseif self.local_id == 20 then  -- South Wind
        self.room:send("The sound of rustling leaves coheres into the sounds of words.")
        wait(2)
        self:say("You wish to race me?")
    elseif self.local_id == 21 then  -- East Wind
        self.room:send("A thin willowy voice moans in pain.")
        wait(1)
        self:say("Have you come to challenge me?")
    elseif self.local_id == 22 then  -- West Wind
        self.room:send("The wind whistles by your ears!")
        wait(3)
        self:say("So you want to race huh?")
    end
end
return true