-- Trigger: Doom Entrance progress journal
-- Zone: 4, ID: 20
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #420

-- Converted from DG Script #420: Doom Entrance progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "doom") entrance or string.find(arg, "the") planes of doom or string.find(arg, "planes") of doom or string.find(arg, "doom_entrance") or string.find(arg, "the_planes_of_doom") or string.find(arg, "planes_of_doom") or string.find(arg, "planes") then
    if actor.level >= 85 then
        _return_value = false
        local stage = actor:get_quest_stage("doom_entrance")
        actor:send("<b:green>&uThe Planes of Doom</>")
        actor:send("Minimum Level: 85")
        actor:send("- This quest begins a storyline intended for characters of level 95+")
        if actor:get_has_completed("doom_entrance") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("doom_entrance") then
            -- switch on stage
            if stage == 1 then
                local master = mobiles.template(484, 11).name
                local task = "Track down the White Hart in the Eldorian Foothills and hold the bloody rag in its presence"
            elseif stage == 2 then
                local master = mobiles.template(484, 11).name
                local task = Slay the White Hart and bring its antlers to master
            elseif stage == 3 then
                local master = mobiles.template(484, 10).name
                local task = "Slay Rhalean's Evil Sister, trapped deep underground"
            elseif stage == 4 then
                local master = mobiles.template(484, 10).name
                local task = Return to master
            elseif stage == 5 then
                local master = mobiles.template(484, 12).name
                local task = "Drop the vial of sunlight before a mockery of the sun in a place steeped in darkness"
            elseif stage == 6 then
                local master = mobiles.template(484, 12).name
                local task = Return to master
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            actor:send(tostring(task) .. ".")
        end
    end
end
return _return_value