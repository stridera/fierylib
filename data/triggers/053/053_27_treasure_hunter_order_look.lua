-- Trigger: Treasure Hunter order look
-- Zone: 53, ID: 27
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
-- TODO(parity): `stage`, `treasure1` are branch-scoped (used at lines
-- 44-45). `actor:get_quest_stage(...) == "stage"` is a string compare.
-- Legacy 5-digit self.id ids. Full rewrite from DG #5327.
--
-- Original DG Script: #5327

-- Converted from DG Script #5327: Treasure Hunter order look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = true
-- switch on self.id
local treasure1
if (self.zone_id == 53 and self.id == 10) then
    local stage = 1
    treasure1 = "a singing chain"
elseif (self.zone_id == 53 and self.id == 11) then
    local stage = 2
    treasure1 = "a true fire ring"
elseif (self.zone_id == 53 and self.id == 12) then
    local stage = 3
    treasure1 = "a sandstone ring"
elseif (self.zone_id == 53 and self.id == 13) then
    local stage = 4
    treasure1 = "a crimson-tinged electrum hoop"
elseif (self.zone_id == 53 and self.id == 14) then
    local stage = 5
    treasure1 = "a Rainbow Shell"
elseif (self.zone_id == 53 and self.id == 15) then
    local stage = 6
    treasure1 = "the Stormshield"
elseif (self.zone_id == 53 and self.id == 16) then
    local stage = 7
    treasure1 = "the Snow Leopard Cloak"
elseif (self.zone_id == 53 and self.id == 17) then
    local stage = 8
    treasure1 = "a coiled rope ladder"
elseif (self.zone_id == 53 and self.id == 18) then
    local stage = 9
    treasure1 = "a glowing phoenix feather"
elseif (self.zone_id == 53 and self.id == 19) then
    local stage = 10
    treasure1 = "a piece of sleet armor"
end
actor:send("This is an order to find " .. tostring(treasure1) .. ".")
if actor:get_quest_var("treasure_hunter:hunt") == "found" and actor:get_quest_stage("treasure_hunter") == "stage" then
    actor:send("You have found the treasure.")
    actor:send("Return it and this order to Honus for your reward!")
end
return _return_value