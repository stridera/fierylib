-- Trigger: Phase Armor - Init - Rog/Mer/Ass/Thi Phase 3
-- Zone: 557, ID: 35
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55735

-- Converted from DG Script #55735: Phase Armor - Init - Rog/Mer/Ass/Thi Phase 3
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Rogue, Mercenary, Assassin, and Thief"
local phase = 3
-- gem variables
local feet_gem = 55691
local head_gem = 55713
local hands_gem = 55680
local arms_gem = 55724
local legs_gem = 55735
local body_gem = 55746
local wrist_gem = 55702
-- armor variables
local feet_armor = 55361
local head_armor = 55369
local hands_armor = 55357
local arms_armor = 55373
local legs_armor = 55377
local body_armor = 55381
local wrist_armor = 55365
-- reward variables
local feet_reward = 55563
local head_reward = 55559
local hands_reward = 55565
local arms_reward = 55560
local legs_reward = 55562
local body_reward = 55561
local wrist_reward = 55564
-- name variables
local feet_name = "boots"
local head_name = "coif"
local hands_name = "gloves"
local arms_name = "sleeves"
local legs_name = "greaves"
local body_name = "tunic"
local wrist_name = "bracer"
-- Persist the DG `set` values on the mob (per prototype) so the speech / greet / receive
-- triggers (557:0-5) can read them with getvar; Lua locals do not outlive this LOAD run.
self:setvar("classes", classes)
self:setvar("phase", phase)
self:setvar("feet_gem", feet_gem)
self:setvar("head_gem", head_gem)
self:setvar("hands_gem", hands_gem)
self:setvar("arms_gem", arms_gem)
self:setvar("legs_gem", legs_gem)
self:setvar("body_gem", body_gem)
self:setvar("wrist_gem", wrist_gem)
self:setvar("feet_armor", feet_armor)
self:setvar("head_armor", head_armor)
self:setvar("hands_armor", hands_armor)
self:setvar("arms_armor", arms_armor)
self:setvar("legs_armor", legs_armor)
self:setvar("body_armor", body_armor)
self:setvar("wrist_armor", wrist_armor)
self:setvar("feet_reward", feet_reward)
self:setvar("head_reward", head_reward)
self:setvar("hands_reward", hands_reward)
self:setvar("arms_reward", arms_reward)
self:setvar("legs_reward", legs_reward)
self:setvar("body_reward", body_reward)
self:setvar("wrist_reward", wrist_reward)
self:setvar("feet_name", feet_name)
self:setvar("head_name", head_name)
self:setvar("hands_name", hands_name)
self:setvar("arms_name", arms_name)
self:setvar("legs_name", legs_name)
self:setvar("body_name", body_name)
self:setvar("wrist_name", wrist_name)