-- Trigger: Dragons Health Progress journal
-- Zone: 4, ID: 34
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 5519 chars
--
-- Original DG Script: #434

-- Converted from DG Script #434: Dragons Health Progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "dragons") or string.find(arg, "dragon's") or string.find(arg, "health") or string.find(arg, "dragons_health") or string.find(arg, "dragon's_health") then
    if actor.level >= 85 and string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        _return_value = false
        local stage = actor:get_quest_stage("dragons_health")
        actor:send("<b:green>&uDragons Health</>")
        actor:send("Minimum Level: 89")
        if actor:get_has_completed("dragons_health") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("dragons_health") then
            actor:send("Quest Master: " .. tostring(mobiles.template(586, 10).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local dragon = "the blue dragon in the Tower in the Wastes"
                local treasure = "its crystal"
            elseif stage == 2 then
                local dragon = "Tri-Aszp"
                local treasure = "one of her scales"
            elseif stage == 3 then
                local dragon = "Thelriki and Jerajai"
                local treasure = "the jewel in their hoard"
            elseif stage == 4 then
                local dragon = "Sagece"
                local treasure = "her skins and shields"
            elseif stage == 5 then
                local total = 10000000 - actor:get_quest_var("dragons_health:hoard")
                local plat = total / 1000
                local gold = total / 100 - plat * 10
                local silv = total / 10 - plat * 100 - gold * 10
                local copp = total  - plat * 1000 - gold * 100 - silv * 10
                -- now the price can be reported
                actor:send("The new hatchling's hoard needs enriching._")
                actor:send("</><b:yellow>" .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper</>_")
                actor:send("</>more in treasure or coins ought to do it.")
                return _return_value
            end
            actor:send("You are trying to:")
            actor:send("- kill " .. tostring(dragon) .. " and return with " .. tostring(treasure) .. ".")
            if stage == 3 then
                local thelriki = actor:get_quest_var("dragons_health:thelriki")
                local jerajai = actor:get_quest_var("dragons_health:jerajai")
                if thelriki or jerajai then
                    actor:send("</>")
                    actor:send("You have slain:")
                    if thelriki then
                        actor:send("- Thelriki")
                    end
                    if jerajai then
                        actor:send("- Jerajai")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not thelriki then
                    actor:send("- kill Thelriki")
                end
                if not jerajai then
                    actor:send("- kill Jerajai")
                end
                actor:send("- bring the jewel in their hoard")
            elseif stage == 4 then
                local item1 = actor:get_quest_var("dragons_health:52016")
                local item2 = actor:get_quest_var("dragons_health:52017")
                local item3 = actor:get_quest_var("dragons_health:52022")
                local item4 = actor:get_quest_var("dragons_health:52023")
                local sagece = actor:get_quest_var("dragons_health:sagece")
                if item1 or item2 or item3 or item4 or sagece then
                    actor:send("</>")
                    actor:send("You have already:")
                    if sagece then
                        actor:send("- slain Sagece of Raymif")
                    end
                    if item1 then
                        actor:send("- brought Sagece's skin")
                    end
                    if item2 then
                        actor:send("- brought Sagece's shield")
                    end
                    if item3 then
                        actor:send("- brought the skin from Sagece's hoard")
                    end
                    if item4 then
                        actor:send("- brought the shield from Sagece's hoard")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not sagece then
                    actor:send("- kill Sagece of Raymif")
                end
                if not item1 then
                    actor:send("- bring Sagece's skin")
                end
                if not item2 then
                    actor:send("- bring Sagece's shield")
                end
                if not item3 then
                    actor:send("- find the skin in Sagece's hoard")
                end
                if not item4 then
                    actor:send("- find the shield in Sagece's hoard")
                end
            end
        end
    end
end
return _return_value