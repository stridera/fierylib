-- Trigger: supernova clue 3
-- Zone: 62, ID: 17
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--   Complex nesting: 9 if statements
--
-- Original DG Script: #6217

-- Converted from DG Script #6217: supernova clue 3
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
        if actor:get_quest_stage("supernova") >= 6 then
            local step7 = actor:get_quest_var("supernova:step7")
            -- switch on actor:get_quest_var("supernova:step6")
            if actor:get_quest_var("supernova:step6") == 58657 then
                -- A Hummock of Grass in the Beachhead
                if step7 == 1 then
                    local clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
                elseif step7 == 2 then
                    local clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
                elseif step7 == 3 then
                    local clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
                end
            elseif actor:get_quest_var("supernova:step6") == 35119 then
                -- A Pile of Stones in the Brush Lands
                if step7 == 1 then
                    local clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
                elseif step7 == 2 then
                    local clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
                elseif step7 == 3 then
                    local clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
                end
            elseif actor:get_quest_var("supernova:step6") == 55422 then
                -- The Trail Overlooking the Falls in the dark mountains
                if step7 == 1 then
                    local clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
                elseif step7 == 2 then
                    local clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
                elseif step7 == 3 then
                    local clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
                end
            end
            -- end clue4 switch
            -- switch on step7
            if step7 == 1 then
                local clue5 = "What disappears as soon as you say its name?"
                -- Answer: Silence
            elseif step7 == 2 then
                local clue5 = "The more there is, the less you see. What am I?"
                -- Answer: Darkness
            elseif step7 == 3 then
                local clue5 = "What word becomes shorter when you add two to it?"
                -- Answer: Short
            end
            -- end clue 5 switch
            actor:send("I know you're following me.  Answer this:")
            actor:send("\"" .. tostring(clue5) .. "\"")
            actor:send("With the answer you can find the gate to my home here:")
            actor:send(tostring(clue4))
            actor:send("</>")
            actor:send("You will need additional solar energy to power the gate.")
            actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
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