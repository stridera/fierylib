-- Trigger: Supernova progress journal
-- Zone: 4, ID: 28
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 8145 chars
--
-- Original DG Script: #428

-- Converted from DG Script #428: Supernova progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "supernova") or string.find(arg, "nova") then
    if actor.level >= 85 and string.find(actor.class, "Pyromancer") then
        _return_value = false
        local stage = actor:get_quest_stage("supernova")
        actor:send("<b:green>&uSupernova</>")
        actor:send("Minimum Level: 89")
        if actor:get_has_completed("supernova") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("supernova") then
            actor:send("Quest Master: the pyromancer guildmasters")
            actor:send("</>")
            actor:send("Your task is to:")
            -- switch on stage
            if stage == 1 then
                actor:send("Find one of Phayla's lamps.")
            elseif stage == 2 then
                actor:send("Return to a pyromancer guildmaster with Phayla's lamp and ask about Supernova.")
            elseif stage == 3 then
                actor:send("Find clues to Phayla's whereabouts.")
                actor:send("</>")
                actor:send("She likes to visit the material plane to engage in her favorite leisure activities.")
                local clue = actor:get_quest_var("supernova:step3")
                -- switch on clue
                if clue == 4318 then
                    actor:send("Recently, she was spotted in Anduin, taking in a show from the best seat in the house.")
                elseif clue == 10316 then
                    actor:send("I understand she frequents the hottest spring at the popular resort up north.")
                elseif clue == 58062 then
                    actor:send("She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.")
                end
                actor:send("Find further clues to Phayla's whereabouts.")
                actor:send("</>")
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
                -- end clue2 switch
                actor:send("Find yet another clue to Phayla's whereabouts.")
                actor:send("</>")
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
                actor:send("Solve the riddle to deduce the location of the gateway to Phayla's realm.")
                actor:send("</>")
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
                actor:send("Talk to Phayla.")
                return _return_value
                -- ends the stage switch
                if stage > 3 then
                    if actor:has_item("48917") or actor:has_equipped("48917") then
                        if stage == 4 then
                            actor:send("Learning is a life-long process.")
                            actor:send(tostring(clue2))
                        elseif stage == 5 then
                            actor:send("History is so fascinating!")
                            actor:send(tostring(clue3))
                        elseif stage == 6 then
                            actor:send("I know you're following me.  Answer this:")
                            actor:send("\"" .. tostring(clue5) .. "\"")
                            actor:send("With the answer you can find the gate to my home here:")
                            actor:send(tostring(clue4))
                            actor:send("</>")
                            actor:send("You will need additional solar energy to power the gate.")
                            actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
                        end
                    else
                        actor:send("Your notes are a jumble of unintelligible squiggles.")
                        actor:send("You must have " .. tostring(objects.template(489, 17).name) .. " to read them!")
                    end
                end
            end
        end
    end
end  -- auto-close block
return _return_value