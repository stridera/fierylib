-- Trigger: Phase Armor - Init - Mon Phase 2
-- Zone: 557, ID: 31
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55731

-- Converted from DG Script #55731: Phase Armor - Init - Mon Phase 2
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Monk"
local phase = 2
-- gem variables
local feet_gem = 55608
local head_gem = 55630
local hands_gem = 55597
local arms_gem = 55641
local legs_gem = 55652
local body_gem = 55663
local wrist_gem = 55619
-- armor variables
local feet_armor = 55334
local head_armor = 55342
local hands_armor = 55330
local arms_armor = 55346
local legs_armor = 55350
local body_armor = 55354
local wrist_armor = 55338
-- reward variables
local feet_reward = 55465
local head_reward = 55461
local hands_reward = 55467
local arms_reward = 55462
local legs_reward = 55464
local body_reward = 55463
local wrist_reward = 55466
-- name variables
local feet_name = "boots"
local head_name = "cap"
local hands_name = "fistwraps"
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