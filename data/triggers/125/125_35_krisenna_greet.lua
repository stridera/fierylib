-- Trigger: Krisenna greet
-- Zone: 125, ID: 35
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #12535

-- Converted from DG Script #12535: Krisenna greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor:get_quest_stage("hell_trident") == 2 then
    if actor.level >= 90 then
        wait(2)
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("resurrection_quest") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hell_gate") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if actor:get_quest_var("hell_trident:greet") == 1 then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Your soul is ready to strike a pact.  Give me the trident to seal it.'")
            else
                actor:send(tostring(self.name) .. " says, 'Have you returned to meet my demands?'")
            end
        end
    end
end