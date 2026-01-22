-- Trigger: Treasure Hunter order look
-- Zone: 53, ID: 27
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #5327

-- Converted from DG Script #5327: Treasure Hunter order look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
-- switch on self.id
if self.id == 5310 then
    local stage = 1
    local treasure1 = "a singing chain"
elseif self.id == 5311 then
    local stage = 2
    local treasure1 = "a true fire ring"
elseif self.id == 5312 then
    local stage = 3
    local treasure1 = "a sandstone ring"
elseif self.id == 5313 then
    local stage = 4
    local treasure1 = "a crimson-tinged electrum hoop"
elseif self.id == 5314 then
    local stage = 5
    local treasure1 = "a Rainbow Shell"
elseif self.id == 5315 then
    local stage = 6
    local treasure1 = "the Stormshield"
elseif self.id == 5316 then
    local stage = 7
    local treasure1 = "the Snow Leopard Cloak"
elseif self.id == 5317 then
    local stage = 8
    local treasure1 = "a coiled rope ladder"
elseif self.id == 5318 then
    local stage = 9
    local treasure1 = "a glowing phoenix feather"
elseif self.id == 5319 then
    local stage = 10
    local treasure1 = "a piece of sleet armor"
end
actor:send("This is an order to find " .. tostring(treasure1) .. ".")
if actor:get_quest_var("treasure_hunter:hunt") == "found" and actor:get_quest_stage("treasure_hunter") == "stage" then
    actor:send("You have found the treasure.")
    actor:send("Return it and this order to Honus for your reward!")
end
return _return_value