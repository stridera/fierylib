-- Trigger: Blur progress journal
-- Zone: 4, ID: 43
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #443

-- Converted from DG Script #443: Blur progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "blur") then
    if string.find(actor.class, "ranger") and actor.level >= 75 then
        _return_value = true
        local east = actor:get_quest_var("blur:east")
        local etimer = actor:get_quest_var("blur:east_timer")
        local west = actor:get_quest_var("blur:west")
        local wtimer = actor:get_quest_var("blur:west_timer")
        local north = actor:get_quest_var("blur:north")
        local ntimer = actor:get_quest_var("blur:north_timer")
        local south = actor:get_quest_var("blur:south")
        local stimer = actor:get_quest_var("blur:south_timer")
        local timer = actor:get_quest_var("blur:timer")
        local stage = actor:get_quest_stage("blur")
        local master = mobiles.template(18, 18).name
        actor:send("<b:u:green>Blur</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("blur") then
            status = "Completed!"
        elseif actor:get_has_failed("blur") then
            status = "Failed"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if (stage or 0) == 0 then
            actor:send("Heal the spirits in the Forest of Shadows.")
        elseif actor:get_has_failed("blur") then
            actor:send("Find " .. tostring(master) .. " to restart the races.")
        elseif not actor:get_has_completed("blur") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Seek out the ranger of the Forest of Shadows.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Seek out and kill the Syric Warder and bring me his sword.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Give " .. tostring(master) .. " the Blade of the Forgotten Kings.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("It's time to race the four winds!")
                    if actor:get_quest_var("blur:race") ~= "go" then
                        actor:send("Return to " .. tostring(master) .. " and say \"Let's begin\" to start the race.")
                    else
                        local minutes = (timer / 60)
                        local seconds = timer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race all four winds!")
                        actor:send("</>")
                        if (north or 0) == 0 then
                            actor:send("The North Wind blows near the frozen town of Ickle.")
                        elseif (north or 0) == 1 then
                            local room = get_room("30262")
                            actor:send("Beat the North Wind to " .. tostring(room.name) .. " in Bluebonnet Pass.")
                            local minutes = (ntimer / 60)
                            local seconds = ntimer - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the North Wind!")
                        elseif (north or 0) == 2 then
                            actor:send("You have won the race against the North Wind!")
                        end
                        actor:send("</>")
                        if (south or 0) == 0 then
                            actor:send("The South Wind blows around the hidden standing stones in South Caelia.")
                        elseif (south or 0) == 1 then
                            local room = get_room("53557")
                            actor:send("Beat the South Wind to " .. tostring(room.name) .. ".")
                            local minutes = (stimer / 60)
                            local seconds = stimer - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the South Wind!")
                        elseif (south or 0) == 2 then
                            actor:send("You have won the race against the South Wind!")
                        end
                        actor:send("</>")
                        if (east or 0) == 0 then
                            actor:send("The East Wind blows through an enormous volcano in the sea.")
                        elseif (east or 0) == 1 then
                            local room = get_room("12597")
                            actor:send("Beat the East Wind to " .. tostring(room.name) .. ".")
                            local minutes = (etimer / 60)
                            local seconds = etimer - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the East Wind!")
                        elseif (east or 0) == 2 then
                            actor:send("You have won the race against the East Wind!")
                        end
                        actor:send("</>")
                        if (west or 0) == 0 then
                            actor:send("The West Wind blows through ruins across the vast Gothra plains.")
                        elseif (west or 0) == 1 then
                            local room = get_room("4236")
                            actor:send("Beat the West Wind to " .. tostring(room.name) .. ".")
                            local minutes = (wtimer / 60)
                            local seconds = wtimer - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the West Wind!")
                        elseif (west or 0) == 2 then
                            actor:send("You have won the race against the West Wind!")
                        end
                    end
                end
            end
        end
    end
end
return _return_value