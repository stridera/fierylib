-- Trigger: Paladin pendant command pray
-- Zone: 30, ID: 88
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--
-- Original DG Script: #3088

-- Converted from DG Script #3088: Paladin pendant command pray
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" then
    _return_value = false
    return _return_value
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
-- switch on self.id
if actor.room == 5479 and pendantstage == 1 then
    if self.id == 360 then
        local continue = "yes"
    end
    if (actor.room == 17345 or actor.room == 17346 or actor.room == 17351 or actor.room == 17352) and pendantstage == 2 then
    elseif self.id == 361 then
        local continue = "yes"
    end
    if actor.room == 49516 and pendantstage == 3 then
    elseif self.id == 362 then
        local continue = "yes"
    end
    if actor.room == 2408 and pendantstage == 4 then
    elseif self.id == 363 then
        local continue = "yes"
    end
    if actor.room == 55105 and pendantstage == 5 then
    elseif self.id == 364 then
        local continue = "yes"
    end
    if actor.room == 53159 and pendantstage == 6 then
    elseif self.id == 365 then
        local continue = "yes"
    end
    if actor.room == 58424 and pendantstage == 7 then
    elseif self.id == 366 then
        local continue = "yes"
    end
    if actor.room == 48032 and pendantstage == 8 then
    elseif self.id == 367 then
        local continue = "yes"
    end
    if actor.room == 48880 and pendantstage == 9 then
    elseif self.id == 368 then
        local continue = "yes"
    end
end
if continue == "yes" then
    actor:command("pray")
    wait(2)
    if actor.class == "Paladin" then
        actor:send("<b:yellow>You have gained new insights on your righteous cause!</>")
    elseif actor.class == "anti" then
        actor:send("<b:red>You have gained new insights on your ruinouse cause!</>")
    end
    actor:set_quest_var("paladin_pendant", "necklacetask4", 1)
else
    _return_value = false
end
return _return_value