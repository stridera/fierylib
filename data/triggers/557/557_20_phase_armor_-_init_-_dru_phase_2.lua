-- Trigger: Phase Armor - Init - Dru Phase 2
-- Zone: 557, ID: 20
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55720

-- Converted from DG Script #55720: Phase Armor - Init - Dru Phase 2
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Druid"
local phase = 2
-- gem variables
local feet_gem = 55607
local head_gem = 55629
local hands_gem = 55596
local arms_gem = 55640
local legs_gem = 55651
local body_gem = 55662
local wrist_gem = 55618
-- armor variables
local feet_armor = 55334
local head_armor = 55342
local hands_armor = 55330
local arms_armor = 55346
local legs_armor = 55350
local body_armor = 55354
local wrist_armor = 55338
-- reward variables
local feet_reward = 55451
local head_reward = 55447
local hands_reward = 55453
local arms_reward = 55448
local legs_reward = 55450
local body_reward = 55449
local wrist_reward = 55452
-- name variables
local feet_name = "boots"
local head_name = "cap"
local hands_name = "gloves"
local arms_name = "sleeves"
local legs_name = "pants"
local body_name = "jerkin"
local wrist_name = "bracer"
-- promote locals to globals so per-class speech triggers can read them
globals.classes = classes; globals.phase = phase
globals.feet_gem = feet_gem; globals.head_gem = head_gem; globals.hands_gem = hands_gem; globals.arms_gem = arms_gem; globals.legs_gem = legs_gem; globals.body_gem = body_gem; globals.wrist_gem = wrist_gem
globals.feet_armor = feet_armor; globals.head_armor = head_armor; globals.hands_armor = hands_armor; globals.arms_armor = arms_armor; globals.legs_armor = legs_armor; globals.body_armor = body_armor; globals.wrist_armor = wrist_armor
globals.feet_reward = feet_reward; globals.head_reward = head_reward; globals.hands_reward = hands_reward; globals.arms_reward = arms_reward; globals.legs_reward = legs_reward; globals.body_reward = body_reward; globals.wrist_reward = wrist_reward
globals.feet_name = feet_name; globals.head_name = head_name; globals.hands_name = hands_name; globals.arms_name = arms_name; globals.legs_name = legs_name; globals.body_name = body_name; globals.wrist_name = wrist_name