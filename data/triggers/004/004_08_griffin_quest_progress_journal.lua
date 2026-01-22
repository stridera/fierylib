-- Trigger: Griffin quest progress journal
-- Zone: 4, ID: 8
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #408

-- Converted from DG Script #408: Griffin quest progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "griffin") or string.find(arg, "destroy") or string.find(arg, "cult") or string.find(arg, "destroy_the_cult_of_the_griffin") or string.find(arg, "griffin_quest") or string.find(arg, "griffin_island_quest") or string.find(arg, "griffin_island") or string.find(arg, "griffin_island_quest") then
    if actor.level >= 45 then
        _return_value = false
        local stage = actor:get_quest_stage("griffin_quest")
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uDestroy the Cult of the Griffin</>")
        actor:send("Recommended Level: 60")
        if actor:get_has_completed("griffin_quest") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("griffin_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(490, 8).name))
            actor:send("</>")
            actor:send(tostring(mobiles.template(490, 8).name) .. " has told you:")
            -- switch on stage
            if stage == 1 then
                actor:send("The sword used to cut the oak is also critical.  Bring the eldest druid the mystic sword from the wreck of the St. Marvin.")
            elseif stage == 2 then
                actor:send("You'll need oracular guidance.  Go to the Seer and say <b:white>\"Earle sends me\"</>.")
            elseif stage == 3 then
                actor:send("Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.")
            elseif stage == 4 then
                actor:send("The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta again and ask her to move the boulder.")
            elseif stage == 5 then
                actor:send("Find the cult's altar and destroy it.  Go into the cave Derceta unearthed and drop the sapling at the cult's altar.")
            elseif stage == 6 then
                actor:send("It is time to destroy the cult!  Slay Dagon!")
            elseif stage == 7 then
                actor:send("Now you can strike the final blow and destroy the essence of the god of the cult itself.  Give the griffin skin to Awura, then seek out the hidden entrance to the other realms and destroy Adramalech.")
            end
        elseif not stage then
            actor:send("Find the wreck of the St. Marvin and bring the cutting of the sacred oak to the eldest druid.")
        end
    end
end
return _return_value