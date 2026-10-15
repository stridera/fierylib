-- Trigger: Griffin quest progress journal
-- Zone: 4, ID: 8
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #408

-- Converted from DG Script #408: Griffin quest progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local status
local _return_value = true  -- Default: allow action
if string.find(arg, "griffin") or string.find(arg, "destroy") or string.find(arg, "cult") or string.find(arg, "destroy_the_cult_of_the_griffin") or string.find(arg, "griffin_quest") or string.find(arg, "griffin_island_quest") or string.find(arg, "griffin_island") or string.find(arg, "griffin island quest") then
    if actor.level >= 45 then
        _return_value = true
        local stage = actor:get_quest_stage("griffin_quest")
        actor:send("<b:u:green>Destroy the Cult of the Griffin</>")
        actor:send("Recommended Level: 60")
        status = nil
        if actor:get_has_completed("griffin_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("griffin_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(490, 8).name))
            actor:send("</>")
            actor:send(tostring(mobiles.template(490, 8).name) .. " has told you:")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("The sword used to cut the oak is also critical.  Bring the eldest druid the mystic sword from the wreck of the St. Marvin.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("You'll need oracular guidance.  Go to the Seer and say <b:white>\"Earle sends me\"</>.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta again and ask her to move the boulder.")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Find the cult's altar and destroy it.  Go into the cave Derceta unearthed and drop the sapling at the cult's altar.")
                elseif tonumber(_sw1) == 6 then
                    actor:send("It is time to destroy the cult!  Slay Dagon!")
                elseif tonumber(_sw1) == 7 then
                    actor:send("Now you can strike the final blow and destroy the essence of the god of the cult itself.  Give the griffin skin to Awura, then seek out the hidden entrance to the other realms and destroy Adramalech.")
                end
            end
        elseif (stage or 0) == 0 then
            actor:send("Find the wreck of the St. Marvin and bring the cutting of the sacred oak to the eldest druid.")
        end
    end
end
return _return_value