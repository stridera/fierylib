-- Trigger: Phase Armor - Init - Rog/Mer/Ass/Thi Phase 1
-- Zone: 557, ID: 33
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55733

-- Converted from DG Script #55733: Phase Armor - Init - Rog/Mer/Ass/Thi Phase 1
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Rogue, Mercenary, Assassin, Thief, and Bard"
local phase = 1
-- gem variables
local feet_gem = 55572
local head_gem = 55580
local hands_gem = 55568
local arms_gem = 55584
local legs_gem = 55588
local body_gem = 55592
local wrist_gem = 55576
-- armor variables
local feet_armor = 55305
local head_armor = 55313
local hands_armor = 55301
local arms_armor = 55317
local legs_armor = 55321
local body_armor = 55325
local wrist_armor = 55309
-- reward variables
local feet_reward = 55409
local head_reward = 55405
local hands_reward = 55411
local arms_reward = 55406
local legs_reward = 55408
local body_reward = 55407
local wrist_reward = 55410
-- name variables
local feet_name = "boots"
local head_name = "coif"
local hands_name = "gloves"
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