-- Trigger: Phase Armor - Init - Bar Phase 2
-- Zone: 557, ID: 38
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55738

-- Converted from DG Script #55738: Phase Armor - Init - Bar Phase 2
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Bard"
local phase = 2
-- gem variables
local feet_gem = 55606
local head_gem = 55630
local hands_gem = 55600
local arms_gem = 55640
local legs_gem = 55649
local body_gem = 55664
local wrist_gem = 55621
-- armor variables
local feet_armor = 55334
local head_armor = 55342
local hands_armor = 55330
local arms_armor = 55346
local legs_armor = 55350
local body_armor = 55354
local wrist_armor = 55338
-- reward variables
local feet_reward = 55785
local head_reward = 55781
local hands_reward = 55787
local arms_reward = 55782
local legs_reward = 55784
local body_reward = 55783
local wrist_reward = 55786
-- name variables
local feet_name = "boots"
local head_name = "cap"
local hands_name = "gloves"
local arms_name = "sleeves"
local legs_name = "leggings"
local body_name = "tunic"
local wrist_name = "bracelet"
-- promote locals to globals so per-class speech triggers can read them
globals.classes = classes; globals.phase = phase
globals.feet_gem = feet_gem; globals.head_gem = head_gem; globals.hands_gem = hands_gem; globals.arms_gem = arms_gem; globals.legs_gem = legs_gem; globals.body_gem = body_gem; globals.wrist_gem = wrist_gem
globals.feet_armor = feet_armor; globals.head_armor = head_armor; globals.hands_armor = hands_armor; globals.arms_armor = arms_armor; globals.legs_armor = legs_armor; globals.body_armor = body_armor; globals.wrist_armor = wrist_armor
globals.feet_reward = feet_reward; globals.head_reward = head_reward; globals.hands_reward = hands_reward; globals.arms_reward = arms_reward; globals.legs_reward = legs_reward; globals.body_reward = body_reward; globals.wrist_reward = wrist_reward
globals.feet_name = feet_name; globals.head_name = head_name; globals.hands_name = hands_name; globals.arms_name = arms_name; globals.legs_name = legs_name; globals.body_name = body_name; globals.wrist_name = wrist_name