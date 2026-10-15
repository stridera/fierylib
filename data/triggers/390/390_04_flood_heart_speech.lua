-- Trigger: flood_heart_speech
-- Zone: 390, ID: 4
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #39004
--
-- Object: heart-ocean. When the Envoy stands in one of the eight Great
-- Waters and says the activation phrase, summon the local water spirit.
--
-- TODO: the legacy vnum ranges below (2800-2910, 10314-10335, 17802-17867,
-- 36200-36231, 41100-41243, 53438-53482, 56402-56431, 58511-58519, 37072)
-- can't be mapped to (zone, id) without per-water-body zone IDs. Replace
-- with explicit zone+id checks once the destination zones are confirmed.
-- The current code uses `room.id` (local id only), which will mis-trigger
-- in any zone whose local IDs overlap these ranges.
-- TODO: the mecho calls at the bottom still use DG variable expansion
-- (`%spirit%`, `color%`) and won't work as written. They need to be
-- rewritten to fetch the spawned spirit and have it speak.

if cmd ~= "say" then
    return true
end
-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Legacy `return 0` ahead of the wait: the player's `say` goes ahead and the script carries on.
allow_command()
wait(0.2)
if actor:get_quest_stage("flood") == 1 then
    local room = actor.room
    local zone = room.id  -- TODO: should be a (zone_id, local_id) tuple
    if string.find(arg, "the Arabel ocean calls for aid") or string.find(arg, "spirit I have returned") or string.find(arg, "spirit, I have returned") then
        -- 
        -- for Blue-Fog River and Lake
        -- 
        if (room.zone_id == 28 and zone <= 110) then
            local color = "<blue>"
            local spirit = mobiles.template(390, 13).name
            if world.count_mobiles(390, 13) == 0 and not actor:get_quest_var("flood:water1") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 13)
                self.room:send(tostring(color) .. "A misty blue spirit rises from the water.</>")
            end
            -- 
            -- for Phoenix Feather Hot Springs
            -- 
        elseif (room.zone_id == 103 and zone == 14) or (room.zone_id == 103 and zone == 16) or (room.zone_id == 103 and zone >= 18 and zone <= 35) then
            local color = "<cyan>"
            local spirit = mobiles.template(390, 14).name
            if world.count_mobiles(390, 14) == 0 and not actor:get_quest_var("flood:water2") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 14)
                self.room:send(tostring(color) .. "A shining watery bird rises from the water.</>")
            end
            -- 
            -- for Canyon - multiple lines because one is too long
            -- 
        elseif (room.zone_id == 178 and zone == 2) or (room.zone_id == 178 and zone >= 11 and zone <= 13) or (room.zone_id == 178 and zone == 16) or (room.zone_id == 178 and zone == 17) or (room.zone_id == 178 and zone >= 23 and zone <= 27) then
            local color = "<b:blue>"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif (room.zone_id == 178 and zone == 34) or (room.zone_id == 178 and zone >= 39 and zone <= 41) or (room.zone_id == 178 and zone == 47) or (room.zone_id == 178 and zone == 50) or (room.zone_id == 178 and zone >= 53 and zone <= 56) then
            local color = "<b:blue>"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif (room.zone_id == 178 and zone == 62) or (room.zone_id == 178 and zone == 67) then
            local color = "<b:blue>"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
            -- 
            -- for Greengreen Sea
            -- 
        elseif (room.zone_id == 362 and zone <= 31) then
            local color = "<green>"
            local spirit = mobiles.template(390, 16).name
            if world.count_mobiles(390, 16) == 0 and not actor:get_quest_var("flood:water4") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 16)
                self.room:send(tostring(color) .. "A hideous creature with distended mouth and belly rises from the water.</>")
            end
            -- 
            -- for SeaWitch
            -- 
        elseif (room.zone_id == 411 and zone <= 142) then
            local color = "<b:blue>"
            local spirit = mobiles.template(390, 17).name
            actor:send("Watery song whispers in your ear, " .. tostring(color) .. "'The Sea Witch must be removed before I may</>")
            actor:send("</>" .. tostring(color) .. "speak to thee...  Call to me from the bottom of the sea...'</>")
        elseif (room.zone_id == 411 and zone == 143) then
            local color = "<b:blue>"
            local spirit = mobiles.template(390, 17).name
            if world.count_mobiles(411, 19) == 0 then
                if world.count_mobiles(390, 17) == 0 and not actor:get_quest_var("flood:water5") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 17)
                    self.room:send(tostring(color) .. "The sea's currents noticeably ripple and flux in response.</>")
                end
            else
                actor:send(tostring(color) .. "Watery song whispers in your ear, 'The Sea Witch must be removed before I may</>")
                actor:send("</>" .. tostring(color) .. "speak to thee...'</>")
            end
            -- 
            -- for Frost Valley - two lines
            -- 
        elseif (room.zone_id == 534 and zone >= 38 and zone <= 40) or (room.zone_id == 534 and zone >= 45 and zone <= 49) or (room.zone_id == 534 and zone == 52) or (room.zone_id == 534 and zone == 55) or (room.zone_id == 534 and zone == 56) or (room.zone_id == 534 and zone == 64) then
            local color = "<b:white>"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and not actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy white woman rises from the lake.</>")
            end
        elseif (room.zone_id == 534 and zone == 67) or (room.zone_id == 534 and zone == 68) or (room.zone_id == 534 and zone >= 72 and zone <= 75) or (room.zone_id == 534 and zone == 81) or (room.zone_id == 534 and zone == 82) then
            local color = "<b:white>"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy icy white woman rises from the lake.</>")
            end
            -- 
            -- for Black Lake
            -- 
        elseif (room.zone_id == 564 and zone >= 2 and zone <= 4) or (room.zone_id == 564 and zone >= 6 and zone <= 31) or (room.zone_id == 370 and zone == 72) then
            local color = "<b:black>"
            local spirit = mobiles.template(390, 19).name
            if world.count_mobiles(390, 19) == 0 and not actor:get_quest_var("flood:water7") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 19)
                self.room:send(tostring(color) .. "An inky black shade rises from the depths.</>")
            end
            -- 
            -- for KoD
            -- 
        elseif (room.zone_id == 584 and zone >= 111 and zone <= 119) then
            local color = "<b:cyan>"
            local spirit = mobiles.template(390, 20).name
            if time.hour > 19 or time.hour < 5 then
                if world.count_mobiles(390, 20) == 0 and not actor:get_quest_var("flood:water8") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 20)
                    self.room:send(tostring(color) .. "In a spray of moon-lit iridescent mist, a beautiful translucent blue woman emerges from the stream.</>")
                end
            else
                self.room:send("A giggling voice says, " .. tostring(color) .. "'None dream while the sun shines.'</>")
            end
        end
        wait(1)
        if string.find(arg, "the arabel ocean calls for aid") then
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Why does the ocean call for aid?'")
        else
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Do you have what I asked for?'")
        end
    end
end
return true