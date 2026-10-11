-- Trigger: Elemental Chaos mission look
-- Zone: 53, ID: 39
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `stage`, `victim1`, `victim2`, `victim3`
-- (used at lines 47-63). Legacy 5-digit self.id. Full rewrite from DG
-- #5339.
--
-- Original DG Script: #5339

-- Converted from DG Script #5339: Elemental Chaos mission look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
local stage, victim1, victim2, victim3
if (self.zone_id == 53 and self.id == 20) then
    stage = 1
    victim1 = "an imp"
elseif (self.zone_id == 53 and self.id == 21) then
    stage = 2
    victim1 = "the Leading Player"
elseif (self.zone_id == 53 and self.id == 22) then
    stage = 3
    victim1 = "the Chaos"
elseif (self.zone_id == 53 and self.id == 23) then
    stage = 4
    victim1 = "whatever waits at the end of the shaman's vision quest"
elseif (self.zone_id == 53 and self.id == 24) then
    stage = 5
    victim1 = "the shaman Fang of Yeenoghu"
    victim2 = "the necromancer Fang of Yeenoghu"
    victim3 = "the diabolist Fang of Yeenoghu"
elseif (self.zone_id == 53 and self.id == 25) then
    stage = 6
    victim1 = "the fire elemental lord"
elseif (self.zone_id == 53 and self.id == 26) then
    stage = 7
    victim1 = "an acolyte of Betrayal"
elseif (self.zone_id == 53 and self.id == 27) then
    stage = 8
    victim1 = "Cyprianum the Reaper"
elseif (self.zone_id == 53 and self.id == 28) then
    stage = 9
    victim1 = "a Chaos Demon"
elseif (self.zone_id == 53 and self.id == 29) then
    stage = 10
    victim1 = "the Norhamen"
end
_return_value = true
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