-- Trigger: Ill-subclass: Relay to invasion illusion
-- Zone: 172, ID: 12
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #17212

-- Converted from DG Script #17212: Ill-subclass: Relay to invasion illusion
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
if actor:get_quest_stage("illusionist_subclass") == 2 or actor:get_quest_stage("illusionist_subclass") == 3 then
    get_room(363, 36):at(function()
        -- w_run_room_trig 17213
    end)
end