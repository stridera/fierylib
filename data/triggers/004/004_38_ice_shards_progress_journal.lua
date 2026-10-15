-- Trigger: Ice Shards progress journal
-- Zone: 4, ID: 38
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #438

-- Converted from DG Script #438: Ice Shards progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "ice shards") or string.find(arg, "shards") or string.find(arg, "ice_shards") then
    if string.find(actor.class, "cryomancer") and actor.level >= 85 then
        _return_value = true
        local stage = actor:get_quest_stage("ice_shards")
        actor:send("<b:green>&uIce Shards</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("ice_shards") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_shards") then
            actor:send("Quest Master: " .. tostring(mobiles.template(103, 0).name))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local book1 = actor:get_quest_var("ice_shards:16209")
                    local book2 = actor:get_quest_var("ice_shards:18505")
                    local book3 = actor:get_quest_var("ice_shards:55003")
                    local book4 = actor:get_quest_var("ice_shards:58415")
                    actor:send("You are looking for four books of mystic knowledge.")
                    if book1 or book2 or book3 or book4 then
                        actor:send("</>")
                        actor:send("You have brought me:")
                        if book1 then
                            actor:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
                        end
                        if book2 then
                            actor:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
                        end
                        if book3 then
                            actor:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
                        end
                        if book4 then
                            actor:send("- <b:yellow> " .. tostring(objects.template(584, 15).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not book1 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
                    end
                    if not book2 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
                    end
                    if not book3 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
                    end
                    if not book4 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(584, 15).name) .. "</>")
                    end
                elseif tonumber(_sw1) == 2 then
                    actor:send("Find the Codex of War.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("You are looking for any records or journals Commander Thraja keeps.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("Talk to the pawnbroker in Anduin about the Butcher of Anduin so you can find his map.")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Talk to Slevvirik in Ogakh about the Butcher of Anduin so you can find his map.")
                elseif tonumber(_sw1) == 6 then
                    actor:send("Bring the map of Ickle from the Butcher of Anduin.")
                elseif tonumber(_sw1) == 7 then
                    actor:send("You are looking for any kind of written clues about the library at Shiran in Ysgarran's Keep in Frost Valley.")
                elseif tonumber(_sw1) == 8 then
                    actor:send("You are looking for the Book of Redemption, whatever that is.")
                elseif tonumber(_sw1) == 9 then
                    actor:send("You are looking for the lost library of Shiran in Frost Valley!")
                elseif tonumber(_sw1) == 10 then
                    actor:send("Bring Aqua Mundi to Khysan!")
                end
            end
        end
    end
end
return _return_value