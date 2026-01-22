-- Trigger: Banish progress journal
-- Zone: 4, ID: 30
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #430

-- Converted from DG Script #430: Banish progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "banish") then
    if actor.level >= 50 and (string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) then
        _return_value = false
        local stage = actor:get_quest_stage("banish")
        local master = mobiles.template(302, 16).name
        actor:send("<b:green>&uBanish</>")
        actor:send("Minimum Level: 65")
        if actor:get_has_completed("banish") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("banish") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local mob = 41119
                local place = "her chamber under the ocean waves"
                local known = "Nothing."
            elseif stage == 2 then
                local mob = 53313
                local place = "the frozen tunnels of the north"
                local known = "v"
            elseif stage == 3 then
                local mob = 37000
                local place = "a deep and ancient mine"
                local known = "vi"
            elseif stage == 4 then
                local mob = 48005
                local place = "a room filled with art in an ancient barrow"
                local known = "vib"
            elseif stage == 5 then
                local mob = 53417
                local place = "the cold valley of the far north"
                local known = "vibu"
            elseif stage == 6 then
                local mob = 23811
                local place = "a nearby fortress of clouds and crystals"
                local known = "vibug"
            elseif stage == 7 then
                actor:send("Return to " .. tostring(mobiles.template(302, 16).name) .. " and speak the prayer aloud: <b:magenta>vibugp</>")
                return _return_value
            end
            if actor:get_quest_var("banish:greet") == 1 then
                actor:send("To learn Banish you must next kill " .. "%get.mob_shortdesc[%mob%]% in %place%.")
            else
                actor:send("Return to " .. tostring(master) .. " for further instruction.")
            end
            actor:send("</>")
            actor:send("</>Your knowledge of the prayer so far: <b:cyan>" .. tostring(known) .. "</>")
        end
    end
end
return _return_value