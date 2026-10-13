-- Trigger: Monk Chants command meditate
-- Zone: 53, ID: 47
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `visionstage`/`chantstage`/`level`/
-- `place`/`mark`/`text1`/`text2`/`chant`. Outer condition
-- `actor:get_quest_stage("monk_chants") == "chantstage"` compares int
-- to literal string. Inner `actor.room == "place"` compares room object
-- to literal "place". `skills.set_level(actor, "%chant%", 100)` passes
-- the literal `%chant%` instead of the variable. `actor:has_equipped(
-- "393")` etc. pass 5-digit string vnums — API needs `(zone, id)`.
-- Full rewrite from DG #5347.
--
-- Original DG Script: #5347

-- Converted from DG Script #5347: Monk Chants command meditate
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
-- switch on self.id
local visionstage, level, mark, text1, text2
if (self.zone_id == 18 and self.id == 7) then
    visionstage = 3
    local chantstage = 1
    level = 30
    local place = 3205
    if actor:has_equipped(2, 193) or actor:has_equipped(2, 194) or actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&3The power of the earth begins to flow through your fists!&0"
    text2 = "&3You have learned Tremors of Saint Augustine.&0"
    local chant = "tremors of saint augustine"
elseif (self.zone_id == 125 and self.id == 8) then
    visionstage = 4
    local chantstage = 2
    level = 40
    local place = 4752
    if actor:has_equipped(2, 194) or actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&4&bThe power of the storm begins to flow through your fists!&0"
    text2 = "&4&bYou have learned Tempest of Saint Augustine.&0"
    local chant = "tempest of saint augustine"
elseif (self.zone_id == 550 and self.id == 3) then
    visionstage = 5
    local chantstage = 3
    level = 50
    local place = 11837
    if actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&6&bThe power of ice begins to flow through your fists!&0"
    text2 = "&6&bYou have learned Blizzards of Saint Augustine.&0"
    local chant = "blizzards of saint augustine"
elseif (self.zone_id == 550 and self.id == 4) then
    visionstage = 6
    local chantstage = 4
    level = 60
    local place = 2786
    if actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&bReverberating from the walls are the discordant words of power!&0"
    text2 = "&bYou have learned Aria of Dissonance.&0"
    local chant = "aria of dissonance"
elseif (self.zone_id == 490 and self.id == 66) then
    visionstage = 7
    local chantstage = 5
    level = 75
    local place = 16057
    if actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&5The roaring of the dead forms into a chant!&0"
    text2 = "&5You have learned Apocalyptic Anthem.&0"
    local chant = "apocalyptic anthem"
elseif (self.zone_id == 238 and self.id == 26) then
    visionstage = 8
    local chantstage = 6
    level = 80
    local place = 5272
    if actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&1&bThe power of fire begins to flow through your fists!&0"
    text2 = "&1&bYou have learned Fires of Saint Augustine.&0"
    local chant = "fires of saint augustine"
elseif (self.zone_id == 480 and self.id == 37) then
    visionstage = 9
    local chantstage = 7
    level = 99
    local place = 48913
    if actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&9&bThe chant to engender catastrophe echoes from the altar!&0"
    text2 = "&9&bYou have learned Seed of Destruction.&0"
    local chant = "seed of destruction"
end
if actor:get_quest_stage("monk_vision") > visionstage and actor:get_quest_stage("monk_chants") == "chantstage" and actor.level >= level and actor.room == "place" then
    if mark then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send(tostring(text1))
            actor:send(tostring(text2))
            skills.set_level(actor, "%chant%", 1000)
            if actor:get_quest_stage("monk_chants") < 7 then
                actor:advance_quest("monk_chants")
            else
                actor:complete_quest("monk_chants")
            end
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value