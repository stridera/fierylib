-- Trigger: supernova clue 1
-- Zone: 62, ID: 8
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #6208

-- Converted from DG Script #6208: supernova clue 1
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
local stage = actor:get_quest_stage("supernova")
-- 
-- Is the person on the quest?
-- 
if stage > 0 then
    -- 
    -- Do they have the lamp?
    -- 
    if actor:has_item("48917") or actor:has_equipped("48917") then
        if actor:get_quest_stage("supernova") >= 4 then
            -- switch on actor:get_quest_var("supernova:step4")
            if actor:get_quest_var("supernova:step4") == 18577 then
                local clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
                -- The Abbey, the rising sun room
            elseif actor:get_quest_var("supernova:step4") == 17277 then
                local clue2 = "Atop a tower I visit a master who waits to give his final examination."
                -- Citadel of Testing
            elseif actor:get_quest_var("supernova:step4") == 8561 then
                local clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
                -- Cathedral of Betrayal near Norisent
            end
            actor:send("Learning is a life-long process.")
            actor:send(tostring(clue2))
        else
            local read = "no"
        end
        -- ends the stage check
    else
        local read = "no"
    end
    -- ends the lamp check
else
    local read = "no"
end
-- ends the quest check
if read == "no" then
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return _return_value