-- Trigger: Phase Armor - Init - Ant Phase 2
-- Zone: 557, ID: 25
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55725

-- Converted from DG Script #55725: Phase Armor - Init - Ant Phase 2
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Anti-Paladin"
local phase = 2
-- gem variables
local feet_gem = 55605
local head_gem = 55627
local hands_gem = 55594
local arms_gem = 55638
local legs_gem = 55649
local body_gem = 55660
local wrist_gem = 55616
-- armor variables
local feet_armor = 55332
local head_armor = 55340
local hands_armor = 55328
local arms_armor = 55344
local legs_armor = 55348
local body_armor = 55352
local wrist_armor = 55336
-- reward variables
local feet_reward = 55430
local head_reward = 55426
local hands_reward = 55432
local arms_reward = 55427
local legs_reward = 55429
local body_reward = 55428
local wrist_reward = 55431
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