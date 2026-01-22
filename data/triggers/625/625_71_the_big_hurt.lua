-- Trigger: the BIG hurt
-- Zone: 625, ID: 71
-- Type: OBJECT, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--   Large script: 12247 chars
--
-- Original DG Script: #62571

-- Converted from DG Script #62571: the BIG hurt
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
local wielder = self.worn_by
local rm = wielder.room
local target = wielder.is_fighting
if target then
    -- switch on wielder.size
    if wielder.size == "medium" then
        return _return_value
        -- switch on target.size
        if target.size == "large" then
            return _return_value
        elseif target.size == "huge" then
            return _return_value
        elseif target.size == "giant" then
            return _return_value
        elseif target.size == "gargantuan" then
            return _return_value
        elseif target.size == "colossal" then
            return _return_value
        elseif target.size == "titanic" then
            return _return_value
        elseif target.size == "mountainous" then
            return _return_value
        end
        -- switch on target.size
        if target.size == "huge" then
            return _return_value
        elseif target.size == "giant" then
            return _return_value
        elseif target.size == "gargantuan" then
            return _return_value
        elseif target.size == "colossal" then
            return _return_value
        elseif target.size == "titanic" then
            return _return_value
        elseif target.size == "mountainous" then
            return _return_value
        end
        -- switch on target.size
        if target.size == "giant" then
            return _return_value
        elseif target.size == "gargantuan" then
            return _return_value
        elseif target.size == "colossal" then
            return _return_value
        elseif target.size == "titanic" then
            return _return_value
        elseif target.size == "mountainous" then
            return _return_value
        end
        -- switch on target.size
        if target.size == "gargantuan" then
            return _return_value
        elseif target.size == "colossal" then
            return _return_value
        elseif target.size == "titanic" then
            return _return_value
        elseif target.size == "mountainous" then
            return _return_value
        end
        -- switch on random(1, 16)
        if rm:get_down("room") == -1 or rm:get_down("room") == 0 or target.flags /= not bash then
            if random(1, 16) == 1 then
                local dam = 150 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                wielder:send("Your smash sends " .. tostring(target.name) .. " sprawling! (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, tostring(wielder) .. "'s smash sends " .. tostring(target.name) .. " spawling! (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            else
                local dam = 250 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                target:teleport(get_room(vnum_to_zone(rm.down), vnum_to_local(rm.down)))
                wielder:send("<b:green>Your smash sends " .. tostring(target.name) .. " sailing down!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, "<b:green>" .. tostring(wielder.name) .. "'s blow sends " .. tostring(target.name) .. " sailing down!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            end
            if rm:get_north("room") == -1 or rm:get_north("room") == 0 or target.flags /= not bash then
            elseif random(1, 16) == 2 then
                local dam = 150 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                wielder:send("Your smash sends " .. tostring(target.name) .. " into a rock! (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, tostring(wielder) .. "'s smash sends " .. tostring(target.name) .. " flying head first into a rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            else
                local dam = 250 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                target:teleport(get_room(vnum_to_zone(rm.north), vnum_to_local(rm.north)))
                wielder:send("<b:green>Your smash sends " .. tostring(target.name) .. " sailing north!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, "<b:green>" .. tostring(wielder.name) .. "'s blow sends " .. tostring(target.name) .. " sailing north!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            end
            if rm:get_south("room") == -1 or rm:get_south("room") == 0 or target.flags /= not bash then
            elseif random(1, 16) == 3 then
                local dam = 150 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                wielder:send("Your smash sends " .. tostring(target.name) .. " into a rock! (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, tostring(wielder) .. "'s smash sends " .. tostring(target.name) .. " flying head first into a rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            else
                local dam = 250 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                target:teleport(get_room(vnum_to_zone(rm.south), vnum_to_local(rm.south)))
                wielder:send("<b:green>Your smash sends " .. tostring(target.name) .. " sailing south!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, "<b:green>" .. tostring(wielder.name) .. "'s blow sends " .. tostring(target.name) .. " sailing south!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            end
            if rm:get_east("room") == -1 or rm:get_east("room") == 0 or target.flags /= not bash then
            elseif random(1, 16) == 4 then
                local dam = 150 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                wielder:send("Your smash sends " .. tostring(target.name) .. " into a rock! (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, tostring(wielder) .. "'s smash sends " .. tostring(target.name) .. " flying head first into a rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            else
                local dam = 250 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                target:teleport(get_room(vnum_to_zone(rm.east), vnum_to_local(rm.east)))
                wielder:send("<b:green>Your smash sends " .. tostring(target.name) .. " sailing east!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, "<b:green>" .. tostring(wielder.name) .. "'s blow sends " .. tostring(target.name) .. " sailing east!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            end
            if rm:get_west("room") == -1 or rm:get_west("room") == 0 or target.flags /= not bash then
            elseif random(1, 16) == 5 then
                local dam = 150 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                wielder:send("Your smash sends " .. tostring(target.name) .. " into a rock! (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, tostring(wielder) .. "'s smash sends " .. tostring(target.name) .. " flying head first into a rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            else
                local dam = 250 +random(1, 100)
                local damage_dealt = target:damage(dam)  -- type: crush
                target:teleport(get_room(vnum_to_zone(rm.west), vnum_to_local(rm.west)))
                wielder:send("<b:green>Your smash sends " .. tostring(target.name) .. " sailing west!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(wielder, "<b:green>" .. tostring(wielder.name) .. "'s blow sends " .. tostring(target.name) .. " sailing west!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                target:command("abort")
            end
        elseif random(1, 16) == 6 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: crush
            wielder:send("You send " .. tostring(target.name) .. " skidding on " .. tostring(target.possessive) .. " back, with your power-swing from " .. tostring(self.shortdesc) .. "! (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, tostring(target.name) .. " goes skidding on " .. tostring(target.possessive) .. " back after a powerful blow from " .. tostring(wielder.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 7 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: pierce
            wielder:send("A branch of your oak tree catches " .. tostring(target.name) .. ", goring him! (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, "A branch of " .. tostring(wielder.name) .. "'s oak tree catches " .. tostring(target.name) .. ", goring him! (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 8 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: crush
            wielder:send("Your blow catches " .. tostring(target.name) .. " in the back of the head! (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " in the back of the head! (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 9 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: crush
            wielder:send("Your blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 10 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: crush
            wielder:send("You stand " .. tostring(self.shortdesc) .. " on end directly on top of " .. tostring(target.name) .. "'s little body. (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, tostring(wielder.name) .. " brings " .. tostring(self.shortdesc) .. " down end-first on top of " .. tostring(target.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 11 then
            local dam = 150 +random(1, 100)
            local damage_dealt = target:damage(dam)  -- type: pierce
            wielder:send("You jab " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ", puncturing " .. tostring(target.possessive) .. " side. (<yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(wielder, tostring(wielder.name) .. " jabs " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
            target:command("abort")
        elseif random(1, 16) == 12 or random(1, 16) == 13 or random(1, 16) == 14 or random(1, 16) == 15 or random(1, 16) == 16 then
        end
    end
end  -- auto-close block