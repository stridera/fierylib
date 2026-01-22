-- Trigger: supernova clue 2
-- Zone: 62, ID: 16
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #6216

-- Converted from DG Script #6216: supernova clue 2
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
        if actor:get_quest_stage("supernova") >= 5 then
            -- switch on actor:get_quest_var("supernova:step5")
            if actor:get_quest_var("supernova:step5") == 53219 then
                local clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
                -- Lizard King's throne room, Sunken
            elseif actor:get_quest_var("supernova:step5") == 47343 then
                local clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
                -- Kryzanthor, Graveyard
            elseif actor:get_quest_var("supernova:step5") == 16278 then
                local clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
                -- Imanhotep, Pyramid
            end
            -- end clue3 switch
            actor:send("History is so fascinating!")
            actor:send(tostring(clue3))
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