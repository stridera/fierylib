-- Trigger: Infernal Weaponry progress journal
-- Zone: 4, ID: 86
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 27 if statements
--   Large script: 7103 chars
--
-- Original DG Script: #486

-- Converted from DG Script #486: Infernal Weaponry progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "trident") or string.find(arg, "hell_trident") or string.find(arg, "hell_trident") or string.find(arg, "infernal_weaponry") or string.find(arg, "infernal") or string.find(arg, "weaponry") or string.find(arg, "infernal_weaponry") then
    if string.find(actor.class, "Diabolist") then
        _return_value = false
        actor:send("<b:green>&uInfernal Weaponry</>")
        actor:send("Weapons of the lower realms await a diabolist dedicated enough to claim them.")
        local hellstage = actor:get_quest_stage("hell_trident")
        if not hellstage then
            local minlevel = 35
        elseif hellstage == 1 then
            local minlevel = 65
        elseif hellstage == 2 then
            local minlevel = 90
        end
        if not actor:get_has_completed("hell_trident") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("hell_trident") then
            local status = "Completed!"
        elseif hellstage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("hell_trident") then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            -- switch on hellstage
            if hellstage == 1 then
                local master = mobiles.template(60, 32).name
                local gem = 55662
                local pl_word = "angels"
                local word = "angel"
                local spell2 = "Banish"
                local spell1 = "Hellfire and Brimstone"
                local task6 = "assisted Vilekka Kar'Shezden"
                local task6do = "&3&bAssist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.&0"
            elseif hellstage == 2 then
                local master = mobiles.template(125, 26).name
                local gem = 55739
                local pl_word = "ghaeles, solars, or seraphs"
                local word = "ghaele, solar, or seraph"
                local spell1 = "Resurrect"
                local spell2 = "Hell Gate"
                local task6 = "Defeated the Undead Prince"
                local task6do = "find one long-buried and branded an infidel.  &3&bFinish his undying duel for him&0 as a sacrifice of honor."
            else
                if not actor:get_has_completed("hell_trident") then
                    actor:send("Only someone mighty enough to claim the ancient truthstone and present it unto the leader of chaos may be given the dark powers of hell.  These diabolists will be rewarded for their unquenchable devotion by the dark gods themselves!")
                    return _return_value
                end
            end
            if actor.level >= minlevel then
                actor:send("Quest Master: " .. tostring(master))
                if not actor:get_quest_var("hell_trident:greet") then
                    actor:send("Speak with " .. tostring(master) .. ".")
                    return _return_value
                else
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("You have done the following:")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send("Give " .. tostring(master) .. " your trident to finalize the pact.")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - actor:get_quest_var("hell_trident:attack_counter")
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - actor:get_quest_var("hell_trident:celestials")
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - actor:get_quest_var("hell_trident:gems")
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
                            end
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            end
        end
    end
end
return _return_value