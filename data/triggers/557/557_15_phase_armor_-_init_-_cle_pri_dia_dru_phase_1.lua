-- Trigger: Phase Armor - Init - Cle/Pri/Dia/Dru Phase 1
-- Zone: 557, ID: 15
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55715

-- Converted from DG Script #55715: Phase Armor - Init - Cle/Pri/Dia/Dru Phase 1
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Cleric, Priest, Druid, and Diabolist"
local phase = 1
-- gem variables
local feet_gem = 55570
local head_gem = 55578
local hands_gem = 55566
local arms_gem = 55582
local legs_gem = 55586
local body_gem = 55590
local wrist_gem = 55574
-- armor variables
local feet_armor = 55304
local head_armor = 55312
local hands_armor = 55300
local arms_armor = 55316
local legs_armor = 55320
local body_armor = 55324
local wrist_armor = 55308
-- reward variables
local feet_reward = 55395
local head_reward = 55391
local hands_reward = 55397
local arms_reward = 55392
local legs_reward = 55394
local body_reward = 55393
local wrist_reward = 55396
-- name variables
local feet_name = "boots"
local head_name = "helm"
local hands_name = "gauntlets"
local arms_name = "vambraces"
local legs_name = "greaves"
local body_name = "plate"
local wrist_name = "bracer"
-- promote locals to globals so per-class speech triggers can read them
globals.classes = classes; globals.phase = phase
globals.feet_gem = feet_gem; globals.head_gem = head_gem; globals.hands_gem = hands_gem; globals.arms_gem = arms_gem; globals.legs_gem = legs_gem; globals.body_gem = body_gem; globals.wrist_gem = wrist_gem
globals.feet_armor = feet_armor; globals.head_armor = head_armor; globals.hands_armor = hands_armor; globals.arms_armor = arms_armor; globals.legs_armor = legs_armor; globals.body_armor = body_armor; globals.wrist_armor = wrist_armor
globals.feet_reward = feet_reward; globals.head_reward = head_reward; globals.hands_reward = hands_reward; globals.arms_reward = arms_reward; globals.legs_reward = legs_reward; globals.body_reward = body_reward; globals.wrist_reward = wrist_reward
globals.feet_name = feet_name; globals.head_name = head_name; globals.hands_name = hands_name; globals.arms_name = arms_name; globals.legs_name = legs_name; globals.body_name = body_name; globals.wrist_name = wrist_name