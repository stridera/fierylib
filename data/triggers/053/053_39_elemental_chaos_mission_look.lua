-- Trigger: Elemental Chaos mission look
-- Zone: 53, ID: 39
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #5339

-- Converted from DG Script #5339: Elemental Chaos mission look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
if self.id == 5320 then
    local stage = 1
    local victim1 = "an imp"
elseif self.id == 5321 then
    local stage = 2
    local victim1 = "the Leading Player"
elseif self.id == 5322 then
    local stage = 3
    local victim1 = "the Chaos"
elseif self.id == 5323 then
    local stage = 4
    local victim1 = "whatever waits at the end of the shaman's vision quest"
elseif self.id == 5324 then
    local stage = 5
    local victim1 = "the shaman Fang of Yeenoghu"
    local victim2 = "the necromancer Fang of Yeenoghu"
    local victim3 = "the diabolist Fang of Yeenoghu"
elseif self.id == 5325 then
    local stage = 6
    local victim1 = "the fire elemental lord"
elseif self.id == 5326 then
    local stage = 7
    local victim1 = "an acolyte of Betrayal"
elseif self.id == 5327 then
    local stage = 8
    local victim1 = "Cyprianum the Reaper"
elseif self.id == 5328 then
    local stage = 9
    local victim1 = "a Chaos Demon"
elseif self.id == 5329 then
    local stage = 10
    local victim1 = "the Norhamen"
end
_return_value = false
if stage == 5 then
    actor:send("This is a mission to defeat " .. tostring(victim1) .. ", " .. tostring(victim2) .. ", and " .. tostring(victim3) .. ".")
else
    actor:send("This is a mission to defeat " .. tostring(victim1) .. ".")
end
if actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send("You have completed the mission.")
    actor:send("Return it to Hakujo!")
elseif stage == 5 then
    if actor:get_quest_var("elemental_chaos:target1") then
        actor:send("You have scratched " .. tostring(victim1) .. " off the list.")
    end
    if actor:get_quest_var("elemental_chaos:target2") then
        actor:send("You have scratched " .. tostring(victim2) .. " off the list.")
    end
    if actor:get_quest_var("elemental_chaos:target3") then
        actor:send("You have scratched " .. tostring(victim3) .. " off the list.")
    end
end
return _return_value