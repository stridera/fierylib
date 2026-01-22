-- Trigger: Eldoria variable load
-- Zone: 4, ID: 99
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Large script: 6905 chars
--
-- Original DG Script: #499

-- Converted from DG Script #499: Eldoria variable load
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local vnum_gem_3bl_cap = 55570
local vnum_gem_3bl_neck = 55571
local vnum_gem_3bl_arm = 55572
local vnum_gem_3bl_wrist = 55573
local vnum_gem_3bl_gloves = 55574
local vnum_gem_3bl_jerkin = 55575
local vnum_gem_3bl_robe = 55589
local vnum_gem_3bl_belt = 55576
local vnum_gem_3bl_legs = 55577
local vnum_gem_3bl_boots = 55578
local vnum_gem_3bl_mask = 55579
local vnum_gem_3bl_symbol = 55580
local vnum_gem_3bl_staff = 55581
local vnum_gem_3bl_ssword = 55582
local vnum_gem_3bl_whammer = 55583
local vnum_gem_3bl_flail = 55584
local vnum_gem_3bl_shiv = 55585
local vnum_gem_3bl_lsword = 55586
local vnum_gem_3bl_smace = 55587
local vnum_gem_3bl_light = 55588
local vnum_gem_3bl_food = 55566
local vnum_gem_3bl_drink = 55567
local vnum_3bl_cap = 5517
local vnum_3bl_neck = 5519
local vnum_3bl_arm = 5521
local vnum_3bl_wrist = 5523
local vnum_3bl_gloves = 5525
local vnum_3bl_jerkin = 5527
local vnum_3bl_belt = 5529
local vnum_3bl_legs = 5531
local vnum_3bl_boots = 5533
local vnum_3bl_mask = 5535
local vnum_3bl_robe = 5537
local vnum_3bl_symbol = 5515
local vnum_3bl_staff = 5539
local vnum_3bl_ssword = 5540
local vnum_3bl_whammer = 5541
local vnum_3bl_flail = 5542
local vnum_3bl_shiv = 5543
local vnum_3bl_lsword = 5544
local vnum_3bl_smace = 5545
local vnum_3bl_light = 5553
local vnum_3bl_food = 5555
local vnum_3bl_drink = 5557
globals.vnum_gem_3bl_cap = globals.vnum_gem_3bl_cap or true; globals.vnum_gem_3bl_neck = globals.vnum_gem_3bl_neck or true; globals.vnum_gem_3bl_arm = globals.vnum_gem_3bl_arm or true; globals.vnum_gem_3bl_wrist = globals.vnum_gem_3bl_wrist or true; globals.vnum_gem_3bl_gloves = globals.vnum_gem_3bl_gloves or true; globals.vnum_gem_3bl_jerkin = globals.vnum_gem_3bl_jerkin or true; globals.vnum_gem_3bl_robe = globals.vnum_gem_3bl_robe or true; globals.vnum_gem_3bl_belt = globals.vnum_gem_3bl_belt or true; globals.vnum_gem_3bl_legs = globals.vnum_gem_3bl_legs or true; globals.vnum_gem_3bl_boots = globals.vnum_gem_3bl_boots or true; globals.vnum_gem_3bl_mask = globals.vnum_gem_3bl_mask or true; globals.vnum_gem_3bl_symbol = globals.vnum_gem_3bl_symbol or true; globals.vnum_gem_3bl_staff = globals.vnum_gem_3bl_staff or true; globals.vnum_gem_3bl_ssword = globals.vnum_gem_3bl_ssword or true; globals.vnum_gem_3bl_whammer = globals.vnum_gem_3bl_whammer or true; globals.vnum_gem_3bl_flail = globals.vnum_gem_3bl_flail or true; globals.vnum_gem_3bl_shiv = globals.vnum_gem_3bl_shiv or true; globals.vnum_gem_3bl_lsword = globals.vnum_gem_3bl_lsword or true; globals.vnum_gem_3bl_smace = globals.vnum_gem_3bl_smace or true; globals.vnum_gem_3bl_light = globals.vnum_gem_3bl_light or true; globals.vnum_gem_3bl_food = globals.vnum_gem_3bl_food or true; globals.vnum_gem_3bl_drink = globals.vnum_gem_3bl_drink or true; globals.vnum_3bl_cap = globals.vnum_3bl_cap or true; globals.vnum_3bl_neck = globals.vnum_3bl_neck or true; globals.vnum_3bl_arm = globals.vnum_3bl_arm or true; globals.vnum_3bl_wrist = globals.vnum_3bl_wrist or true; globals.vnum_3bl_gloves = globals.vnum_3bl_gloves or true; globals.vnum_3bl_jerkin = globals.vnum_3bl_jerkin or true; globals.vn = globals.vn or true
-- Fragment (possible truncation): m_3bl_belt vnum_3bl_legs vnum_3bl_boots vnum_3bl_mask vnum_3bl_robe vnum_3bl_symbol vnum_3bl_staff vnum_3bl_ssword vnum_3bl_whammer vnum_3bl_flail vnum_3bl_shiv vnum_3bl_lsword vnum_3bl_smace vnum_3bl_light vnum_3bl_food vnum_3bl_drink
local vnum_gem_3eg_cap = 55570
local vnum_gem_3eg_neck = 55571
local vnum_gem_3eg_arm = 55572
local vnum_gem_3eg_wrist = 55573
local vnum_gem_3eg_gloves = 55574
local vnum_gem_3eg_jerkin = 55575
local vnum_gem_3eg_robe = 55589
local vnum_gem_3eg_belt = 55576
local vnum_gem_3eg_legs = 55577
local vnum_gem_3eg_boots = 55578
local vnum_gem_3eg_mask = 55579
local vnum_gem_3eg_symbol = 55580
local vnum_gem_3eg_staff = 55581
local vnum_gem_3eg_ssword = 55582
local vnum_gem_3eg_whammer = 55583
local vnum_gem_3eg_flail = 55584
local vnum_gem_3eg_shiv = 55585
local vnum_gem_3eg_lsword = 55586
local vnum_gem_3eg_smace = 55587
local vnum_gem_3eg_light = 55588
local vnum_gem_3eg_food = 55566
local vnum_gem_3eg_drink = 55567
local vnum_3eg_cap = 5518
local vnum_3eg_neck = 5520
local vnum_3eg_arm = 5522
local vnum_3eg_wrist = 5524
local vnum_3eg_gloves = 5526
local vnum_3eg_jerkin = 5528
local vnum_3eg_belt = 5530
local vnum_3eg_legs = 5532
local vnum_3eg_boots = 5534
local vnum_3eg_mask = 5536
local vnum_3eg_robe = 5538
local vnum_3eg_symbol = 5516
local vnum_3eg_staff = 5546
local vnum_3eg_ssword = 5547
local vnum_3eg_whammer = 5548
local vnum_3eg_flail = 5549
local vnum_3eg_shiv = 5550
local vnum_3eg_lsword = 5551
local vnum_3eg_smace = 5552
local vnum_3eg_light = 5554
local vnum_3eg_food = 5556
local vnum_3eg_drink = 5558
globals.vnum_gem_3eg_cap = globals.vnum_gem_3eg_cap or true; globals.vnum_gem_3eg_neck = globals.vnum_gem_3eg_neck or true; globals.vnum_gem_3eg_arm = globals.vnum_gem_3eg_arm or true; globals.vnum_gem_3eg_wrist = globals.vnum_gem_3eg_wrist or true; globals.vnum_gem_3eg_gloves = globals.vnum_gem_3eg_gloves or true; globals.vnum_gem_3eg_jerkin = globals.vnum_gem_3eg_jerkin or true; globals.vnum_gem_3eg_robe = globals.vnum_gem_3eg_robe or true; globals.vnum_gem_3eg_belt = globals.vnum_gem_3eg_belt or true; globals.vnum_gem_3eg_legs = globals.vnum_gem_3eg_legs or true; globals.vnum_gem_3eg_boots = globals.vnum_gem_3eg_boots or true; globals.vnum_gem_3eg_mask = globals.vnum_gem_3eg_mask or true; globals.vnum_gem_3eg_symbol = globals.vnum_gem_3eg_symbol or true; globals.vnum_gem_3eg_staff = globals.vnum_gem_3eg_staff or true; globals.vnum_gem_3eg_ssword = globals.vnum_gem_3eg_ssword or true; globals.vnum_gem_3eg_whammer = globals.vnum_gem_3eg_whammer or true; globals.vnum_gem_3eg_flail = globals.vnum_gem_3eg_flail or true; globals.vnum_gem_3eg_shiv = globals.vnum_gem_3eg_shiv or true; globals.vnum_gem_3eg_lsword = globals.vnum_gem_3eg_lsword or true; globals.vnum_gem_3eg_smace = globals.vnum_gem_3eg_smace or true; globals.vnum_gem_3eg_light = globals.vnum_gem_3eg_light or true; globals.vnum_gem_3eg_food = globals.vnum_gem_3eg_food or true; globals.vnum_gem_3eg_drink = globals.vnum_gem_3eg_drink or true; globals.vnum_3eg_cap = globals.vnum_3eg_cap or true; globals.vnum_3eg_neck = globals.vnum_3eg_neck or true; globals.vnum_3eg_arm = globals.vnum_3eg_arm or true; globals.vnum_3eg_wrist = globals.vnum_3eg_wrist or true; globals.vnum_3eg_gloves = globals.vnum_3eg_gloves or true; globals.vnum_3eg_jerkin = globals.vnum_3eg_jerkin or true; globals.vn = globals.vn or true
-- Fragment (possible truncation): m_3eg_belt vnum_3eg_legs vnum_3eg_boots vnum_3eg_mask vnum_3eg_robe vnum_3eg_symbol vnum_3eg_staff vnum_3eg_ssword vnum_3eg_whammer vnum_3eg_flail vnum_3eg_shiv vnum_3eg_lsword vnum_3eg_smace vnum_3eg_light vnum_3eg_food vnum_3eg_drink