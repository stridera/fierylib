-- Trigger: Phase Armor - Init - Ran Phase 3
-- Zone: 557, ID: 28
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55728

-- Converted from DG Script #55728: Phase Armor - Init - Ran Phase 3
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Ranger"
local phase = 3
-- gem variables
local feet_gem = 55688
local head_gem = 55710
local hands_gem = 55677
local arms_gem = 55721
local legs_gem = 55732
local body_gem = 55743
local wrist_gem = 55699
-- armor variables
local feet_armor = 55361
local head_armor = 55369
local hands_armor = 55357
local arms_armor = 55373
local legs_armor = 55377
local body_armor = 55381
local wrist_armor = 55365
-- reward variables
local feet_reward = 55521
local head_reward = 55517
local hands_reward = 55523
local arms_reward = 55518
local legs_reward = 55520
local body_reward = 55519
local wrist_reward = 55522
-- name variables
local feet_name = "boots"
local head_name = "helm"
local hands_name = "gauntlets"
local arms_name = "sleeves"
local legs_name = "leggings"
local body_name = "tunic"
local wrist_name = "bracer"
-- globalify everything
globals.classes = globals.classes or true; globals.phase = globals.phase or true
globals.feet_gem = globals.feet_gem or true; globals.head_gem = globals.head_gem or true; globals.hands_gem = globals.hands_gem or true; globals.arms_gem = globals.arms_gem or true; globals.legs_gem = globals.legs_gem or true; globals.body_gem = globals.body_gem or true; globals.wrist_gem = globals.wrist_gem or true
globals.feet_armor = globals.feet_armor or true; globals.head_armor = globals.head_armor or true; globals.hands_armor = globals.hands_armor or true; globals.arms_armor = globals.arms_armor or true; globals.legs_armor = globals.legs_armor or true; globals.body_armor = globals.body_armor or true; globals.wrist_armor = globals.wrist_armor or true
globals.feet_reward = globals.feet_reward or true; globals.head_reward = globals.head_reward or true; globals.hands_reward = globals.hands_reward or true; globals.arms_reward = globals.arms_reward or true; globals.legs_reward = globals.legs_reward or true; globals.body_reward = globals.body_reward or true; globals.wrist_reward = globals.wrist_reward or true
globals.feet_name = globals.feet_name or true; globals.head_name = globals.head_name or true; globals.hands_name = globals.hands_name or true; globals.arms_name = globals.arms_name or true; globals.legs_name = globals.legs_name or true; globals.body_name = globals.body_name or true; globals.wrist_name = globals.wrist_name or true