-- Trigger: supernova clue 3
-- Zone: 62, ID: 17
-- Type: OBJECT, Flags: LOOK
--
-- Final supernova clue scroll. Readable only by a stage 6+ supernova questor
-- carrying/wearing Phayla's lamp (489, 17). Reveals a riddle (clue5) and the
-- ciphered location of the gateway (clue4) keyed to step6/step7.
--
-- Original DG Script: #6217

local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 6 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step6 = actor:get_quest_var("supernova:step6")
    local step7 = actor:get_quest_var("supernova:step7")
    local clue4
    if step6 == 58657 then
        -- A Hummock of Grass in the Beachhead
        if step7 == 1 then clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
        elseif step7 == 2 then clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
        elseif step7 == 3 then clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
        end
    elseif step6 == 35119 then
        -- A Pile of Stones in the Brush Lands
        if step7 == 1 then clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
        elseif step7 == 2 then clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
        elseif step7 == 3 then clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
        end
    elseif step6 == 55422 then
        -- The Trail Overlooking the Falls in the dark mountains
        if step7 == 1 then clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
        elseif step7 == 2 then clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
        elseif step7 == 3 then clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
        end
    end

    local clue5
    if step7 == 1 then clue5 = "What disappears as soon as you say its name?"          -- Silence
    elseif step7 == 2 then clue5 = "The more there is, the less you see. What am I?"   -- Darkness
    elseif step7 == 3 then clue5 = "What word becomes shorter when you add two to it?" -- Short
    end

    actor:send("I know you're following me.  Answer this:")
    actor:send("\"" .. tostring(clue5) .. "\"")
    actor:send("With the answer you can find the gate to my home here:")
    actor:send(tostring(clue4))
    actor:send("</>")
    actor:send("You will need additional solar energy to power the gate.")
    actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true