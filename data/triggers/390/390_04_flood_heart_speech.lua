-- Trigger: flood_heart_speech
-- Zone: 390, ID: 4
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 8896 chars
--
-- Original DG Script: #39004

-- Converted from DG Script #39004: flood_heart_speech
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: say
if not (cmd == "say") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(2)
if actor:get_quest_stage("flood") == 1 then
    local room = actor.room
    local zone = room.id
    if string.find(arg, "the") Arabel ocean calls for aid or string.find(arg, "spirit") I have returned or string.find(arg, "spirit"), I have returned then
        -- 
        -- for Blue-Fog River and Lake
        -- 
        if zone >= 2800 and zone <= 2910 then
            local color = "&4"
            local spirit = mobiles.template(390, 13).name
            if world.count_mobiles("39013") == 0 and not actor:get_quest_var("flood:water1") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 13)
                self.room:send(tostring(color) .. "A misty blue spirit rises from the water.</>")
            end
            -- 
            -- for Phoenix Feather Hot Springs
            -- 
        elseif zone == 10314 or zone == 10316 or zone >= 10318 and zone <= 10335 then
            local color = "&6"
            local spirit = mobiles.template(390, 14).name
            if world.count_mobiles("39014") == 0 and not actor:get_quest_var("flood:water2") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 14)
                self.room:send(tostring(color) .. "A shining watery bird rises from the water.</>")
            end
            -- 
            -- for Canyon - multiple lines because one is too long
            -- 
        elseif zone == 17802 or (zone >= 17811 and zone <= 17813) or zone == 17816 or zone == 17817 or (zone >= 17823 and zone <= 17827) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles("39015") == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif zone == 17834 or (zone >= 17839 and zone <= 17841 or zone == 17847 or zone == 17850 or (zone >= 17853 and zone <= 17856) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles("39015") == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif zone == 17862 or zone == 17867 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles("39015") == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
            -- 
            -- for Greengreen Sea
            -- 
        elseif zone >= 36200 and zone <= 36231 then
            local color = "&2"
            local spirit = mobiles.template(390, 16).name
            if world.count_mobiles("39016") == 0 and not actor:get_quest_var("flood:water4") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 16)
                self.room:send(tostring(color) .. "A hideous creature with distended mouth and belly rises from the water.</>")
            end
            -- 
            -- for SeaWitch
            -- 
        elseif zone >= 41100 and zone <= 41242 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            actor:send("Watery song whispers in your ear, " .. tostring(color) .. "'The Sea Witch must be removed before I may</>")
            actor:send("</>" .. tostring(color) .. "speak to thee...  Call to me from the bottom of the sea...'</>")
        elseif zone == 41243 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            if world.count_mobiles("41119") == 0 then
                if world.count_mobiles("39017") == 0 and not actor:get_quest_var("flood:water5") then
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
        elseif zone >= 53438 and zone <= 53440 or zone >= 53445 and zone <= 53449 or zone == 53452 or zone == 53455 or zone == 53456 or zone == 53464 then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles("39018") == 0 and not actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy white woman rises from the lake.</>")
            end
        elseif zone == 53467 or zone == 53468 or zone >= 53472 and zone <= 53475 or zone == 53481 or zone == 53482 then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles("39018") == 0 and actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy icy white woman rises from the lake.</>")
            end
            -- 
            -- for Black Lake
            -- 
        elseif (zone >= 56402 and zone <= 56404) or (zone >= 56406 and zone <= 56431) or zone == 37072 then
            local color = "&9&b"
            local spirit = mobiles.template(390, 19).name
            if world.count_mobiles("39019") == 0 and not actor:get_quest_var("flood:water7") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 19)
                self.room:send(tostring(color) .. "An inky black shade rises from the depths.</>")
            end
            -- 
            -- for KoD
            -- 
        elseif zone >= 58511 and zone <= 58519 then
            local color = "&6&b"
            local spirit = mobiles.template(390, 20).name
            if time.hour > 19 or time.hour < 5 then
                if world.count_mobiles("39020") == 0 and not actor:get_quest_var("flood:water8") then
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
        if string.find(arg, "the") arabel ocean calls for aid then
            self.room:find_actor("spirit"):command("mecho %spirit% says, %color%'Why does the ocean call for aid?'&0")
        else
            self.room:find_actor("spirit"):command("mecho %spirit% says, %color%'Do you have what I asked for?'&0")
        end
    end
end
return _return_value