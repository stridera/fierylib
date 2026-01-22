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
-- globalify everything
globals.classes = globals.classes or true; globals.phase = globals.phase or true
globals.feet_gem = globals.feet_gem or true; globals.head_gem = globals.head_gem or true; globals.hands_gem = globals.hands_gem or true; globals.arms_gem = globals.arms_gem or true; globals.legs_gem = globals.legs_gem or true; globals.body_gem = globals.body_gem or true; globals.wrist_gem = globals.wrist_gem or true
globals.feet_armor = globals.feet_armor or true; globals.head_armor = globals.head_armor or true; globals.hands_armor = globals.hands_armor or true; globals.arms_armor = globals.arms_armor or true; globals.legs_armor = globals.legs_armor or true; globals.body_armor = globals.body_armor or true; globals.wrist_armor = globals.wrist_armor or true
globals.feet_reward = globals.feet_reward or true; globals.head_reward = globals.head_reward or true; globals.hands_reward = globals.hands_reward or true; globals.arms_reward = globals.arms_reward or true; globals.legs_reward = globals.legs_reward or true; globals.body_reward = globals.body_reward or true; globals.wrist_reward = globals.wrist_reward or true
globals.feet_name = globals.feet_name or true; globals.head_name = globals.head_name or true; globals.hands_name = globals.hands_name or true; globals.arms_name = globals.arms_name or true; globals.legs_name = globals.legs_name or true; globals.body_name = globals.body_name or true; globals.wrist_name = globals.wrist_name or true