-- Trigger: Phase Armor - Init - Dia Phase 3
-- Zone: 557, ID: 19
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55719

-- Converted from DG Script #55719: Phase Armor - Init - Dia Phase 3
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Diabolist"
local phase = 3
-- gem variables
local feet_gem = 55683
local head_gem = 55705
local hands_gem = 55672
local arms_gem = 55716
local legs_gem = 55727
local body_gem = 55738
local wrist_gem = 55694
-- armor variables
local feet_armor = 55360
local head_armor = 55368
local hands_armor = 55356
local arms_armor = 55372
local legs_armor = 55376
local body_armor = 55380
local wrist_armor = 55364
-- reward variables
local feet_reward = 55549
local head_reward = 55545
local hands_reward = 55551
local arms_reward = 55546
local legs_reward = 55548
local body_reward = 55547
local wrist_reward = 55550
-- name variables
local feet_name = "boots"
local head_name = "helm"
local hands_name = "gauntlets"
local arms_name = "vambraces"
local legs_name = "greaves"
local body_name = "guard"
local wrist_name = "bracer"
-- promote locals to globals so per-class speech triggers can read them
globals.classes = classes; globals.phase = phase
globals.feet_gem = feet_gem; globals.head_gem = head_gem; globals.hands_gem = hands_gem; globals.arms_gem = arms_gem; globals.legs_gem = legs_gem; globals.body_gem = body_gem; globals.wrist_gem = wrist_gem
globals.feet_armor = feet_armor; globals.head_armor = head_armor; globals.hands_armor = hands_armor; globals.arms_armor = arms_armor; globals.legs_armor = legs_armor; globals.body_armor = body_armor; globals.wrist_armor = wrist_armor
globals.feet_reward = feet_reward; globals.head_reward = head_reward; globals.hands_reward = hands_reward; globals.arms_reward = arms_reward; globals.legs_reward = legs_reward; globals.body_reward = body_reward; globals.wrist_reward = wrist_reward
globals.feet_name = feet_name; globals.head_name = head_name; globals.hands_name = hands_name; globals.arms_name = arms_name; globals.legs_name = legs_name; globals.body_name = body_name; globals.wrist_name = wrist_name