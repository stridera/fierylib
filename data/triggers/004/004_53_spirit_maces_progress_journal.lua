-- Trigger: Spirit Maces progress journal
-- Zone: 4, ID: 53
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 26 if statements
--   Large script: 9263 chars
--
-- Original DG Script: #453

-- Converted from DG Script #453: Spirit Maces progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "spirit") and (string.find(arg, "mace") or string.find(arg, "maces"))) or string.find(arg, "phase_mace") or string.find(arg, "spirit_mace") then
    if string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") then
        _return_value = false
        local stage = actor:get_quest_stage("phase_mace")
        local minlevel = stage * 10
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:green>&uSpirit Maces</>")
        if not actor:get_has_completed("phase_mace") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("phase_mace") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("phase_mace") then
            local job1 = actor:get_quest_var("phase_mace:macetask1")
            local job2 = actor:get_quest_var("phase_mace:macetask2")
            local job3 = actor:get_quest_var("phase_mace:macetask3")
            local job4 = actor:get_quest_var("phase_mace:macetask4")
            local job5 = actor:get_quest_var("phase_mace:macetask5")
            local job6 = actor:get_quest_var("phase_mace:macetask6")
            local attack = stage * 50
            local remaining = ((attack) - actor:get_quest_var("phase_mace:attack_counter"))
            -- switch on stage
            if stage == 1 then
                local master = mobiles.template(30, 25).name
                local maceitem2 = 55577
                local maceitem3 = 55211
                local maceitem4 = 13614
                local maceitem5 = 58809
                local hint = "The Holy Templar Magistrate is a master of spiritual combat.  Perhaps he knows more."
            elseif stage == 2 then
                local master = mobiles.template(185, 2).name
                local maceitem2 = 55593
                local maceitem3 = 18522
                local maceitem4 = 18523
                local maceitem5 = 18524
                local maceitem6 = 18525
                local hint = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki."
            elseif stage == 3 then
                local master = mobiles.template(100, 0).name
                local maceitem2 = 55604
                local maceitem3 = 32409
                local maceitem4 = 59022
                local maceitem5 = 2327
                local hint = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you."
            elseif stage == 4 then
                local master = mobiles.template(62, 18).name
                local maceitem2 = 55631
                local maceitem3 = 16030
                local maceitem4 = 47002
                local maceitem5 = 5211
                local hint = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin."
            elseif stage == 5 then
                local master = mobiles.template(85, 1).name
                local maceitem2 = 55660
                local maceitem3 = 43007
                local maceitem4 = 59012
                local maceitem5 = 17308
                local hint = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal."
            elseif stage == 6 then
                local master = mobiles.template(185, 81).name
                local maceitem2 = 55681
                local maceitem3 = 23824
                local maceitem4 = 53016
                local maceitem5 = 16201
                local hint = "Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further."
            elseif stage == 7 then
                local master = mobiles.template(60, 7).name
                local maceitem2 = 55708
                local maceitem3 = 49502
                local maceitem4 = 4008
                local maceitem5 = 47017
                local hint = "Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators."
            elseif stage == 8 then
                local master = mobiles.template(484, 12).name
                local maceitem2 = 55737
                local maceitem3 = 53305
                local maceitem4 = 12307
                local maceitem5 = 51073
                local hint = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin."
            elseif stage == 9 then
                local master = mobiles.template(30, 21).name
                local maceitem2 = 55738
                local maceitem3 = 48002
                local maceitem4 = 52010
                local maceitem5 = 3218
                local hint = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do."
            end
            if actor.level >= minlevel then
                if actor:get_quest_var("phase_mace:greet") == 0 then
                    actor:send("Find the next master crafter and tell them why you have come.")
                    actor:send(tostring(hint))
                    return _return_value
                else
                    actor:send("Quest Master: " .. tostring(master))
                    actor:send("</>")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("</>")
                        actor:send("You've done the following:")
                        if job1 then
                            actor:send("- attacked " .. tostring(attack) .. " times")
                        end
                        if job2 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem2%]%")
                        end
                        if job3 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem3%]%")
                        end
                        if job4 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem4%]%")
                        end
                        if job5 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem5%]%")
                        end
                        if job6 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem6%]%")
                        end
                    end
                    actor:send("</>")
                    actor:send("You need to:")
                    if job1 and job2 and job3 and job4 and job5 then
                        if macestep ~= 2 then
                            actor:send("Bring " .. tostring(master) .. " your mace.")
                            return _return_value
                        else
                            if job6 then
                                actor:send("Bring " .. tostring(master) .. " your mace.")
                                return _return_value
                            end
                        end
                    end
                    if not job1 then
                        if remaining > 1 then
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
                        else
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
                        end
                    end
                    if not job2 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem2%]%</>")
                    end
                    if not job3 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem3%]%</>")
                    end
                    if not job4 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem4%]%</>")
                    end
                    if not job5 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem5%]%</>")
                    end
                    if stage == 2 then
                        if not job6 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem6%]%</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value