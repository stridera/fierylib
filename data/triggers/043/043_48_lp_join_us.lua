-- Trigger: LP_join_us
-- Zone: 43, ID: 48
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4348

-- Converted from DG Script #4348: LP_join_us
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if random(1, 3) == 1 then
    self:emote("croons gently, 'Join us, leave your fields to flower...'")
end
-- switch on actor:get_quest_stage("bard_subclass")
if actor:get_quest_stage("bard_subclass") == 1 or actor:get_quest_stage("bard_subclass") == 2 or actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Ready to continue your audition?'")
else
    if string.find(actor.class, "Rogue") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- break
        wait(1)
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'The guardians of splendor are calling out your name, " .. tostring(actor.name) .. ".  Do you want to know what they're saying?'")
        end
    end  -- auto-close block
end  -- auto-close block