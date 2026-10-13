-- Trigger: Phase Armor - Init - Sor/Cry/Pyr/Nec/Ill Phase 1
-- Zone: 557, ID: 10
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55710

-- Converted from DG Script #55710: Phase Armor - Init - Sor/Cry/Pyr/Nec/Ill Phase 1
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Sorcerer, Cryomancer, Pyromancer, Illusionist, and Necromancer"
local phase = 1
-- gem variables
local feet_gem = 55571
local head_gem = 55579
local hands_gem = 55567
local arms_gem = 55583
local legs_gem = 55587
local body_gem = 55591
local wrist_gem = 55575
-- armor variables
local feet_armor = 55306
local head_armor = 55314
local hands_armor = 55302
local arms_armor = 55318
local legs_armor = 55322
local body_armor = 55326
local wrist_armor = 55310
-- reward variables
local feet_reward = 55402
local head_reward = 55398
local hands_reward = 55404
local arms_reward = 55399
local legs_reward = 55401
local body_reward = 55400
local wrist_reward = 55403
-- name variables
local feet_name = "sandals"
local head_name = "turban"
local hands_name = "gloves"
local arms_name = "sleeves"
local legs_name = "pants"
local body_name = "tunic"
local wrist_name = "bracelet"
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