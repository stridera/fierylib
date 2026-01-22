-- Trigger: The Great Rite progress journal
-- Zone: 4, ID: 31
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 28 if statements
--   Large script: 8917 chars
--
-- Original DG Script: #431

-- Converted from DG Script #431: The Great Rite progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "great") or string.find(arg, "rite") or string.find(arg, "the_great_rite") or string.find(arg, "megalith") or string.find(arg, "megalith_quest") or string.find(arg, "the_great_rite") or string.find(arg, "sacred_megalith_quest") or string.find(arg, "sacred_megalith_quest") or string.find(arg, "sacred_megalith") then
    if actor.level >= 50 then
        _return_value = false
        local stage = actor:get_quest_stage("megalith_quest")
        local job1 = actor:get_quest_var("megalith_quest:item1")
        local job2 = actor:get_quest_var("megalith_quest:item2")
        local job3 = actor:get_quest_var("megalith_quest:item3")
        local job4 = actor:get_quest_var("megalith_quest:item4")
        actor:send("<b:green>&uThe Great Invocation</>")
        actor:send("A group of witches has uncovered a powerful set of massive standing stones.")
        actor:send("Help them with their mystic ritual.")
        actor:send("Recommended Level: 70")
        actor:send("- This quest can be started at any level but requires level 70 to finish.")
        if actor:get_has_completed("megalith_quest") then
            local status = "Completed!"
        elseif actor:get_has_failed("megalith_quest") then
            local status = "Failed"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if (stage > 0 and not actor:get_has_completed("megalith_quest")) or actor:get_has_failed("megalith_quest") then
            local master = mobiles.template(123, 1).name
            -- switch on stage
            if stage == 1 then
                local task = "Replace the sacred prophetic implements."
                -- salt 23756
                local item1 = "salt"
                -- Goblet or chalice 41110 or 41111 or 18512
                local item2 = "a goblet or chalice"
                -- censer 8507 or 17300
                local item3 = "a censer"
                -- candles 8612 or 58809
                local item4 = "candles"
                -- give to the priestess
            elseif stage == 2 then
                -- 
                -- Must be done East South West North
                -- 
                -- thin sheet of cloud to Keeper of the East
                local receive1 = mobiles.template(123, 5).name
                local item1 = objects.template(83, 1).name
                -- the fiery eye to Keeper of the South
                local receive2 = mobiles.template(123, 4).name
                local item2 = objects.template(481, 9).name
                -- water from room 12463 to Keeper of the West
                local receive3 = mobiles.template(123, 6).name
                local item3 = "water from " .. objects.template(123, 52).name
                -- granite ring to Keeper of the North
                local receive4 = mobiles.template(123, 3).name
                local item4 = objects.template(550, 20).name
                if job1 and job2 and job3 and job4 then
                    local task = "Finish calling the elements!  Return to " .. mobiles.template(123, 1).name .. " and say \"&7&bUnder the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!&0\""
                else
                    local task = "Visit the Keepers and call the elements"
                    master = nil
                    local master = "The Keepers of East, South, West, and North"
                end
            elseif stage == 3 then
                local task = "Locate three holy reliquaries."
                local item1 = "a holy prayer bowl"
                local item2 = "a piece of a goddess's regalia"
                local item3 = "a faerie relic from the land of the Reverie made manifest"
            elseif stage == 4 then
                local prayer = actor:get_quest_var("megalith_quest:prayer")
                local summon = actor:get_quest_var("megalith_quest:summon")
                local invoke = actor:get_quest_var("megalith_quest:invoke")
                if prayer == 1 then
                    local task = "Return to " .. tostring(master) .. " and say, \"&7&bGreat Lady of the Stars, hear our prayer!&0\""
                elseif summon == 1 or summon == 2 or summon == 3 then
                    local task = "Return to " .. tostring(master) .. " and say, \"&7&bWe summon and stir thee!&0\""
                elseif invoke == 1 or invoke == 2 or invoke == 3 then
                    local task = "Return to " .. tostring(master) .. " and say, \"&7&bWe invoke thee!&0\""
                end
            elseif stage == 5 then
                local task = "Kneel before the High Mother to receive Her blessing."
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            if actor:get_has_failed("megalith_quest") then
                actor:send("Return to " .. tostring(master) .. " and ask to try again.")
                return _return_value
            else
                actor:send(tostring(task))
            end
            if stage < 4 then
                -- list items already given
                if job1 or job2 or job3 or job4 then
                    actor:send("</>")
                    actor:send("You have already retrieved:")
                    if job1 then
                        actor:send("- <b:white>" .. tostring(item1) .. "</>")
                    end
                    if job2 then
                        actor:send("- <b:white>" .. tostring(item2) .. "</>")
                    end
                    if job3 then
                        actor:send("- <b:white>" .. tostring(item3) .. "</>")
                    end
                    if job4 then
                        actor:send("- <b:white>" .. tostring(item4) .. "</>")
                    end
                end
                -- list items to be returned
                actor:send("</>")
                if stage == 2 then
                    if not job1 then
                        actor:send("Assist <b:white>" .. tostring(receive1) .. "</>.")
                        if actor:get_quest_var("megalith_quest:east") then
                            actor:send("She needs " .. tostring(item1) .. ".  Help her first.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job2 then
                        actor:send("Assist <b:red>" .. tostring(receive2) .. "</>.")
                        if actor:get_quest_var("megalith_quest:south") then
                            actor:send("She needs " .. tostring(item2) .. ".  Help her second.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job3 then
                        actor:send("Assist <b:cyan>" .. tostring(receive3) .. "</>.")
                        if actor:get_quest_var("megalith_quest:west") then
                            actor:send("She needs " .. tostring(item3) .. ".  Help her third.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job4 then
                        actor:send("Assist <b:green>" .. tostring(receive4) .. "</>.")
                        if actor:get_quest_var("megalith_quest:north") then
                            actor:send("She needs " .. tostring(item4) .. ".  Help her last.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                else
                    actor:send("You still need to retrieve:")
                    if not job1 then
                        actor:send("- <b:white>" .. tostring(item1) .. "</>")
                    end
                    if not job2 then
                        actor:send("- <b:white>" .. tostring(item2) .. "</>")
                    end
                    if not job3 then
                        actor:send("- <b:white>" .. tostring(item3) .. "</>")
                    end
                    if stage == 1 then
                        if not job4 then
                            actor:send("- <b:white>" .. tostring(item4) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value