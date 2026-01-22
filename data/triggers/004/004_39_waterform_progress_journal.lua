-- Trigger: Waterform progress journal
-- Zone: 4, ID: 39
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 25 if statements
--   Large script: 6284 chars
--
-- Original DG Script: #439

-- Converted from DG Script #439: Waterform progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "waterform") then
    if string.find(actor.class, "Cryomancer") and actor.level >= 65 then
        _return_value = false
        local stage = actor:get_quest_stage("waterform")
        actor:send("<b:green>&uWaterform</>")
        actor:send("Minimum Level: 73")
        if actor:get_has_completed("waterform") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("waterform") then
            local master = mobiles.template(28, 10).name
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Find a piece of armor made of water to serve as the basis of your new form.")
            elseif stage == 2 then
                actor:send("You need a special vessel to gather water in.  Kill Tri-Aszp and get a large bone from her.")
            elseif stage == 3 then
                actor:send("You need a special vessel to gather water in.  Give " .. tostring(master) .. " the large bone from a grown white dragon so it can make you one.")
            elseif stage == 4 then
                local region1 = actor:get_quest_var("waterform:region1")
                local region2 = actor:get_quest_var("waterform:region2")
                local region3 = actor:get_quest_var("waterform:region3")
                local region4 = actor:get_quest_var("waterform:region4")
                local region5 = actor:get_quest_var("waterform:region5")
                actor:send("Collect samples of living water from four different regions.")
                if region1 or region2 or region3 or region4 or region5 then
                    actor:send("</>")
                    actor:send("You already have samples from:")
                    if region1 then
                        actor:send("- <blue>The Blue Fog trails and waters</>")
                    end
                    if region2 then
                        actor:send("- <blue>Nordus</>")
                    end
                    if region3 then
                        actor:send("- <blue>Layveran Labyrinth</>")
                    end
                    if region4 then
                        actor:send("- <blue>The Elemental Plane of Water</>")
                    end
                    if region5 then
                        actor:send("- <blue>The sunken castle</>")
                    end
                end
                actor:send("</>")
                local samples = 4 - (region1 + region2 + region3 + region4 + region5)
                actor:send("You need <b:blue>" .. tostring(samples) .. "</> more.")
            elseif stage == 5 then
                actor:send("Give " .. tostring(master) .. " the cup so it can see the samples.")
            elseif stage == 6 then
                local water1 = actor:get_quest_var("waterform:3296")
                local water2 = actor:get_quest_var("waterform:58405")
                local water3 = actor:get_quest_var("waterform:53319")
                local water4 = actor:get_quest_var("waterform:55804")
                local water5 = actor:get_quest_var("waterform:58701")
                local water6 = actor:get_quest_var("waterform:37014")
                actor:send("You are looking for six unique sources of water.")
                if water1 or water2 or water3 or water4 or water5 or water6 then
                    actor:send("</>")
                    actor:send("You have already analyzed water from:")
                    if water1 then
                        actor:send("- <blue>a granite pool in the village of Mielikki</>")
                    end
                    if water2 then
                        actor:send("- <blue>a sparkling artesian well in the Realm of the King of Dreams</>")
                    end
                    if water3 then
                        actor:send("- <blue>a crystal clear fountain in the caverns of the Ice Cult</>")
                    end
                    if water4 then
                        actor:send("- <blue>the creek in the Eldorian Foothills</>")
                    end
                    if water5 then
                        actor:send("- <blue>the wishing well at the Dancing Dolphin in South Caelia</>")
                    end
                    if water6 then
                        actor:send("- <blue>an underground brook in the Minithawkin Mines</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need to analyze water from:")
                if not water1 then
                    actor:send("- <b:cyan>a granite pool in the village of Mielikki</>")
                end
                if not water2 then
                    actor:send("- <b:cyan>a sparkling artesian well in the Realm of the King of Dreams</>")
                end
                if not water3 then
                    actor:send("- <b:cyan>a crystal clear fountain in the caverns of the Ice Cult</>")
                end
                if not water4 then
                    actor:send("- <b:cyan>the creek in the Eldorian Foothills</>")
                end
                if not water5 then
                    actor:send("- <b:cyan>the wishing well at the Dancing Dolphin in South Caelia</>")
                end
                if not water6 then
                    actor:send("- <b:cyan>an underground brook in the Minithawkin Mines</>")
                end
            elseif stage == 7 then
                actor:send("Just return the cup to " .. tostring(master) .. " and you're done!")
            end
            if stage > 3 then
                actor:send("</>")
                actor:send("If you need a new cup, return to " .. tostring(master) .. " and say \"<b:yellow>I need a new cup</>\".")
            end
        end
    end
end
return _return_value