-- Trigger: Ranger Trophy command forage
-- Zone: 53, ID: 18
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--
-- Original DG Script: #5318

-- Converted from DG Script #5318: Ranger Trophy command forage
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: forage
if not (cmd == "forage") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "f" or cmd == "fo" or cmd == "for" then
    _return_value = false
    return _return_value
end
local trophystage = actor:get_quest_stage("ranger_trophy")
-- switch on self.id
if actor.room == 8614 and trophystage == 1 then
    if self.id == 370 then
        local continue = "yes"
    end
    if (actor.room >= 20352 and actor.room <= 20354) and trophystage == 2 then
    elseif self.id == 371 then
        local continue = "yes"
    end
    if (actor.room == 2392 or actor.room == 2410) and trophystage == 3 then
    elseif self.id == 372 then
        local continue = "yes"
    end
    if actor.room == 46244 and trophystage == 4 then
    elseif self.id == 373 then
        local continue = "yes"
    end
    if actor.room == 12429 and trophystage == 5 then
    elseif self.id == 374 then
        local continue = "yes"
    end
    if actor.room == 53568 and trophystage == 6 then
    elseif self.id == 375 then
        local continue = "yes"
    end
    if actor.room == 49094 and trophystage == 7 then
    elseif self.id == 376 then
        local continue = "yes"
    end
    if actor.room == 48080 and trophystage == 8 then
    elseif self.id == 377 then
        local continue = "yes"
    end
    if actor.room == 23892 and trophystage == 9 then
    elseif self.id == 378 then
        local continue = "yes"
    end
end
if continue == "yes" then
    actor:send("You forage through the lair.")
    wait(2)
    actor:send("<b:green>Your connection to " .. tostring(self.shortdesc) .. " takes on new meaning!</>")
    actor:set_quest_var("ranger_trophy", "trophytask4", 1)
else
    _return_value = false
end
return _return_value