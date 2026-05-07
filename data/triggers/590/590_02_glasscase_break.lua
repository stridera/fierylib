-- Trigger: glasscase_break
-- Zone: 590, ID: 2
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59002

-- Converted from DG Script #59002: glasscase_break
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: break
if not (cmd == "break") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- you must break glass to get reset sword out
if arg == "glass" or arg == "case" then
    _return_value = false
    -- check to see what PC can break case with
    local item = nil
    if actor:get_worn("shield") then
        item = actor:get_worn("shield")
    elseif actor:get_worn("wield2h") then
        item = actor:get_worn("wield2h")
    elseif actor:get_worn("wield") then
        item = actor:get_worn("wield")
    elseif actor:get_worn("wield2") then
        item = actor:get_worn("wield2")
    elseif actor:get_worn("held") then
        item = actor:get_worn("held")
    elseif actor:get_worn("held2") then
        item = actor:get_worn("held2")
    end
    -- break case with item or hands
    if item then
        actor:send("You smash the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
        self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
    else
        actor:damage(150)  -- type: slash
        if damage_dealt ~= 0 then
            actor:send("You smash the glass with your bare hands, shattering the glass and slicing your hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands, shattering the glass and slicing deep grooves into " .. tostring(actor.possessive) .. " hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
        else
            actor:send("You smash the glass with your bare hands.")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands.")
        end
    end
    wait(1)
    self.room:send("A pristine iridescent sword falls out of the broken case, landing on the ground.")
    -- destroy case and load it in rm 59091 to prevent it from loading here again, as it is a reset item
    -- TODO(parity): both spawn calls reference (590, 24); original DG comment says one should
    -- spawn the iridescent sword in this room while the other respawns the glass case into 590/91.
    -- Verify the correct object IDs and target rooms before using in production.
    self.room:spawn_object(590, 24)
    world.destroy(self.room:find_object("dusty-glass-case"))
    self.room:spawn_object(590, 24)
else
    _return_value = true
end
return _return_value