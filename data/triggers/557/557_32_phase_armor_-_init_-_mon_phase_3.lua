-- Trigger: Phase Armor - Init - Mon Phase 3
-- Zone: 557, ID: 32
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #55732

-- Converted from DG Script #55732: Phase Armor - Init - Mon Phase 3
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- global variables
local classes = "Monk"
local phase = 3
-- gem variables
local feet_gem = 55685
local head_gem = 55707
local hands_gem = 55674
local arms_gem = 55718
local legs_gem = 55729
local body_gem = 55740
local wrist_gem = 55696
-- armor variables
local feet_armor = 55362
local head_armor = 55370
local hands_armor = 55358
local arms_armor = 55374
local legs_armor = 55378
local body_armor = 55382
local wrist_armor = 55366
-- reward variables
local feet_reward = 55542
local head_reward = 55538
local hands_reward = 55544
local arms_reward = 55539
local legs_reward = 55541
local body_reward = 55540
local wrist_reward = 55543
-- name variables
local feet_name = "slippers"
local head_name = "circlet"
local hands_name = "fistwraps"
local arms_name = "sleeves"
local legs_name = "leggings"
local body_name = "tunic"
local wrist_name = "guard"
-- promote locals to globals so per-class speech triggers can read them
globals.classes = classes; globals.phase = phase
globals.feet_gem = feet_gem; globals.head_gem = head_gem; globals.hands_gem = hands_gem; globals.arms_gem = arms_gem; globals.legs_gem = legs_gem; globals.body_gem = body_gem; globals.wrist_gem = wrist_gem
globals.feet_armor = feet_armor; globals.head_armor = head_armor; globals.hands_armor = hands_armor; globals.arms_armor = arms_armor; globals.legs_armor = legs_armor; globals.body_armor = body_armor; globals.wrist_armor = wrist_armor
globals.feet_reward = feet_reward; globals.head_reward = head_reward; globals.hands_reward = hands_reward; globals.arms_reward = arms_reward; globals.legs_reward = legs_reward; globals.body_reward = body_reward; globals.wrist_reward = wrist_reward
globals.feet_name = feet_name; globals.head_name = head_name; globals.hands_name = hands_name; globals.arms_name = arms_name; globals.legs_name = legs_name; globals.body_name = body_name; globals.wrist_name = wrist_name