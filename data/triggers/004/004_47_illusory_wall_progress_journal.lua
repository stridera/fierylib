-- Trigger: Illusory Wall progress journal
-- Zone: 4, ID: 47
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--   Refactored: Replaced 90+ if-statements with data-driven region table
--
-- Original DG Script: #447

-- Converted from DG Script #447: Illusory Wall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%

-- Load shared region data
local REGIONS = require("shared.illusory_wall_regions")

--- Display completed regions for the actor
local function display_completed_regions(actor)
    for _, region in ipairs(REGIONS) do
        if actor:get_quest_var("illusory_wall:" .. region.key) then
            actor:send("- <blue>" .. region.display .. "</>")
        end
    end
end

local _return_value = true  -- Default: allow action

if string.find(arg, "illusory") or string.find(arg, "illusory wall") or string.find(arg, "illusory_wall") then
    if (string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard")) and actor.level >= 50 then
        _return_value = false
        local stage = actor:get_quest_stage("illusory_wall")
        local master = mobiles.template(364, 2).name
        actor:send("<b:green>&uIllusory Wall</>")
        actor:send("Minimum Level: 57")

        local status
        if actor:get_has_completed("illusory_wall") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")

        if stage > 0 and not actor:get_has_completed("illusory_wall") then
            actor:send("Quest Master: " .. tostring(master))

            if stage == 1 then
                -- Stage 1: Collect items for magical spectacles
                local item1 = actor:get_quest_var("illusory_wall:10307")
                local item2 = actor:get_quest_var("illusory_wall:18511")
                local item3 = actor:get_quest_var("illusory_wall:41005")
                local item4 = actor:get_quest_var("illusory_wall:51017")
                actor:send("You're looking for things to make magical spectacles.")

                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("</>You have already brought me:")
                    if item1 then
                        actor:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
                    end
                    if item2 then
                        actor:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
                    end
                    if item3 then
                        actor:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
                    end
                    if item4 then
                        actor:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
                    end
                end

                actor:send("</>")
                actor:send("You still need to find:")
                if not item1 and not item2 then
                    actor:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
                end
                if not item3 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
                end
                if not item4 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
                end

            elseif stage == 2 then
                -- Stage 2: Study doors in 20 regions
                actor:send("Complete your study of doors in 20 regions.")
                actor:send("</>")
                local doors = actor:get_quest_var("illusory_wall:total")
                actor:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")

                display_completed_regions(actor)

                actor:send("</>")
                local remaining = (20 - doors)
                actor:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
                actor:send("</>")
                actor:send("If you need new lenses return to " .. tostring(master) .. " and say, <b:magenta>\"I need new glasses\"</>.")
            end
        end
    end
end

return _return_value
