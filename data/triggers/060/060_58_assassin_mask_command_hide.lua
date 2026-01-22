-- Trigger: Assassin mask command hide
-- Zone: 60, ID: 58
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Complex nesting: 14 if statements
--
-- Original DG Script: #6058

-- Converted from DG Script #6058: Assassin mask command hide
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: hide
if not (cmd == "hide") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "h" or cmd == "hi" then
    _return_value = false
    return _return_value
end
local maskstage = actor:get_quest_stage("assassin_mask")
-- switch on self.id
if (actor.room >= 5436 and actor.room <= 5440) and maskstage == 1 then
    if self.id == 350 then
        local continue = "yes"
    end
    if (actor.room >= 16165 and actor.room <= 16173) and maskstage == 2 then
    elseif self.id == 351 then
        local continue = "yes"
    end
    if (actor.room >= 23711 and actor.room <= 23715) and maskstage == 3 then
    elseif self.id == 352 then
        local continue = "yes"
    end
    if actor.room == 16087 and maskstage == 4 then
    elseif self.id == 353 then
        local continue = "yes"
    end
    if actor.room == 51023 and maskstage == 5 then
    elseif self.id == 354 then
        local continue = "yes"
    end
    if ((actor.room >= 48191 and actor.room <= 48196) or (actor.room >= 48225 and actor.room <= 48232)) and maskstage == 6 then
    elseif self.id == 355 then
        local continue = "yes"
    end
    if actor.room == 4064 and maskstage == 7 then
    elseif self.id == 356 then
        local continue = "yes"
    end
    if actor.room == 48045 and maskstage == 8 then
    elseif self.id == 357 then
        local continue = "yes"
    end
    if actor.room == 52046 and maskstage == 9 then
    elseif self.id == 358 then
        local continue = "yes"
    end
end
if continue == "yes" then
    actor:command("hide")
    wait(2)
    actor:send("&9<blue>" .. tostring(self.shortdesc) .. " seems to absorb the shadowy darkness around you!")
    actor:set_quest_var("assassin_mask", "masktask4", 1)
else
    _return_value = false
end
return _return_value