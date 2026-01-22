-- Trigger: Rogue cloak search
-- Zone: 53, ID: 29
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--
-- Original DG Script: #5329

-- Converted from DG Script #5329: Rogue cloak search
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "se" then
    _return_value = false
    return _return_value
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
-- switch on self.id
if actor.room == 13660 and cloakstage == 1 then
    if self.id == 380 then
        local continue = "yes"
    end
    if actor.room == 18549 and cloakstage == 2 then
    elseif self.id == 381 then
        local continue = "yes"
    end
    if (actor.room == 59080 or actor.room == 59081) and cloakstage == 3 then
    elseif self.id == 382 then
        local continue = "yes"
    end
    if actor.room == 12626 and cloakstage == 4 then
    elseif self.id == 383 then
        local continue = "yes"
    end
    if actor.room == 16068 and cloakstage == 5 then
    elseif self.id == 384 then
        local continue = "yes"
    end
    if (actor.room == 16215 or actor.room == 16220) and cloakstage == 6 then
    elseif self.id == 385 then
        local continue = "yes"
    end
    if actor.room == 37062 and cloakstage == 7 then
    elseif self.id == 386 then
        local continue = "yes"
    end
    if actor.room == 53103 and cloakstage == 8 then
    elseif self.id == 387 then
        local continue = "yes"
    end
    if actor.room == 48083 and cloakstage == 9 then
    elseif self.id == 388 then
        local continue = "yes"
    end
end
if continue == "yes" then
    actor:command("search")
    actor:send("<b:yellow>You have found your target!</>")
    actor:set_quest_var("rogue_cloak", "cloaktask4", 1)
else
    _return_value = false
end
return _return_value