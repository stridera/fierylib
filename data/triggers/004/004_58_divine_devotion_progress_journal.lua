-- Trigger: Divine Devotion progress journal
-- Zone: 4, ID: 58
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 5987 chars
--
-- Original DG Script: #458

-- Converted from DG Script #458: Divine Devotion progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "divine") or string.find(arg, "devotion") or string.find(arg, "divine_devotion") or string.find(arg, "paladin_pendant") or string.find(arg, "paladin_pendant") then
    local anti = "Anti-Paladin"
    if string.find(actor.class, "Paladin") or actor.class == "anti" then
        _return_value = false
        local huntstage = actor:get_quest_stage("dragon_slayer")
        local pendantstage = actor:get_quest_stage("paladin_pendant")
        local master = mobiles.template(30, 80).name
        local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
        local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
        local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
        local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
        actor:send("<b:green>&uDivine Devotion</>")
        if not pendantstage then
            local level = 10
        else
            local level = pendantstage * 10
        end
        if not actor:get_has_completed("paladin_pendant") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        if actor:get_has_completed("paladin_pendant") then
            local status = "Completed!"
        elseif pendantstage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if pendantstage == 0 then
                actor:send("Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.")
                return _return_value
            elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
                actor:send("Slay a few more dragons before you can receive another promotion.")
                return _return_value
            end
            -- switch on pendantstage
            if pendantstage == 1 then
                local necklace = 12003
                local gem = 55582
                local place = "The Mist Temple Altar"
                local hint = "in the Misty Caverns."
            elseif pendantstage == 2 then
                local necklace = 23708
                local gem = 55590
                local place = "Chamber of Chaos"
                local hint = "in the Temple of Chaos."
            elseif pendantstage == 3 then
                local necklace = 58005
                local gem = 55622
                local place = "Altar of Borgan"
                local hint = "in the lost city of Nymrill."
            elseif pendantstage == 4 then
                local necklace = 48123
                local gem = 55654
                local place = "A Hidden Altar Room"
                local hint = "in a cave in South Caelia's Wailing Mountains."
            elseif pendantstage == 5 then
                local necklace = 12336
                local gem = 55662
                local place = "The Altar of the Snow Leopard Order"
                local hint = "buried deep in Mt. Frostbite"
            elseif pendantstage == 6 then
                local necklace = 43019
                local gem = 55677
                local place = "Chapel Altar"
                local hint = "deep underground in a lost castle."
            elseif pendantstage == 7 then
                local necklace = 37015
                local gem = 55709
                local place = "A Cliffside Altar"
                local hint = "tucked away in the land of Dreams."
            elseif pendantstage == 8 then
                local necklace = 58429
                local gem = 55738
                local place = "Dark Altar"
                local hint = "entombed with an ancient evil king."
            elseif pendantstage == 9 then
                local necklace = 52010
                local gem = 55739
                local place = "An Altar"
                local hint = "far away in the Plane of Air."
            end
            local attack = pendantstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%necklace%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- prayed in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old necklace.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("paladin_pendant:attack_counter")
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value