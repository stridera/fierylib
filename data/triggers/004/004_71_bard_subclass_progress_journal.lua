-- Trigger: Bard Subclass progress journal
-- Zone: 4, ID: 71
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #471

-- Converted from DG Script #471: Bard Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local bardraces = "none"
    if string.find(arg, "Bard") and string.find(actor.class, "rogue") and actor.level <= 25 and not (string.find(bardraces, actor.race)) then
        _return_value = true
        actor:send("<b:magenta>Bard</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(43, 98).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("bard_subclass") > 0 then
            -- switch on actor:get_quest_stage("bard_subclass")
            do
                local _sw1 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Go to the audition room and sing for " .. tostring(mobiles.template(43, 98).name) .. ".")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Go to the audition room and dance for " .. tostring(mobiles.template(43, 98).name) .. ".")
                elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                    actor:send("You were looking for an old script in Morgan Hill.")
                    actor:send("Give it to " .. tostring(mobiles.template(43, 98).name) .. " when you find it.")
                elseif tonumber(_sw1) == 5 then
                    actor:send(tostring(mobiles.template(43, 98).name) .. " said to you:")
                    actor:send("Time to gimme some dialogue work.")
                    actor:send("I sure hope you're off book!_")
                    actor:send("That means \"memorized\" in the business.")
                end
            end
        end
    end
end
return _return_value