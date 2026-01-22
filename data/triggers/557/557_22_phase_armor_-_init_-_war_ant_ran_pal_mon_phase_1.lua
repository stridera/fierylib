-- Trigger: Phase Armor - Init - War/Ant/Ran/Pal/Mon Phase 1
-- Zone: 557, ID: 22
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55722

-- Converted from DG Script #55722: Phase Armor - Init - War/Ant/Ran/Pal/Mon Phase 1
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Warrior, Anti-Paladin, Ranger, Paladin, Monk, and Berserker"
local phase = 1
-- gem variables
local feet_gem = 55573
local head_gem = 55581
local hands_gem = 55569
local arms_gem = 55585
local legs_gem = 55589
local body_gem = 55593
local wrist_gem = 55577
-- armor variables
local feet_armor = 55304
local head_armor = 55312
local hands_armor = 55300
local arms_armor = 55316
local legs_armor = 55320
local body_armor = 55324
local wrist_armor = 55308
-- reward variables
local feet_reward = 55388
local head_reward = 55384
local hands_reward = 55390
local arms_reward = 55385
local legs_reward = 55387
local body_reward = 55386
local wrist_reward = 55389
-- name variables
local feet_name = "boots"
local head_name = "helm"
local hands_name = "gauntlets"
local arms_name = "vambraces"
local legs_name = "greaves"
local body_name = "plate"
local wrist_name = "bracer"
-- globalize everything
globals.classes = globals.classes or true; globals.phase = globals.phase or true
globals.feet_gem = globals.feet_gem or true; globals.head_gem = globals.head_gem or true; globals.hands_gem = globals.hands_gem or true; globals.arms_gem = globals.arms_gem or true; globals.legs_gem = globals.legs_gem or true; globals.body_gem = globals.body_gem or true; globals.wrist_gem = globals.wrist_gem or true
globals.feet_armor = globals.feet_armor or true; globals.head_armor = globals.head_armor or true; globals.hands_armor = globals.hands_armor or true; globals.arms_armor = globals.arms_armor or true; globals.legs_armor = globals.legs_armor or true; globals.body_armor = globals.body_armor or true; globals.wrist_armor = globals.wrist_armor or true
globals.feet_reward = globals.feet_reward or true; globals.head_reward = globals.head_reward or true; globals.hands_reward = globals.hands_reward or true; globals.arms_reward = globals.arms_reward or true; globals.legs_reward = globals.legs_reward or true; globals.body_reward = globals.body_reward or true; globals.wrist_reward = globals.wrist_reward or true
globals.feet_name = globals.feet_name or true; globals.head_name = globals.head_name or true; globals.hands_name = globals.hands_name or true; globals.arms_name = globals.arms_name or true; globals.legs_name = globals.legs_name or true; globals.body_name = globals.body_name or true; globals.wrist_name = globals.wrist_name or true