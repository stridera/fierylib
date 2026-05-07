-- Trigger: Eldoria Quartermasters load
-- Zone: 55, ID: 24
-- Type: MOB, Flags: LOAD
-- Status: TODO(parity)
--
-- TODO(parity): The converter truncated the original DG load script
-- (note the "Fragment (possible truncation)" comments) and the
-- `globals.X = globals.X or true` chains preserve only the variable
-- *names* -- the actual gem/reward IDs were dropped. As a result this
-- trigger does nothing useful: it sets a long list of globals to the
-- boolean `true` and exits. Whatever the original load script did
-- (likely populating shared lookup tables consumed by 055_03/055_04
-- and 055_07/055_08) needs to be reconstructed from the legacy DG
-- source before it can be ported, and the gem 5-digit vnums need
-- (zone, local_id) re-mapping at the same time.
--
-- Original DG Script: #5524

-- Converted from DG Script #5524: Eldoria Quartermasters load
-- Original: MOB trigger, flags: LOAD, probability: 100%
if self.id == 5512 then
    local id_trophy1 = 5504
    local id_trophy2 = 5506
    local id_trophy3 = 5508
    local id_trophy4 = 5510
    local id_trophy5 = 5512
    local id_trophy6 = 5514
    local id_trophy7 = 5516
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_gloves = 55574
    local id_gem_3bl_jerkin = 55575
    local id_gem_3bl_robe = 55589
    local id_gem_3bl_belt = 55576
    local id_gem_3bl_legs = 55577
    local id_gem_3bl_boots = 55578
    local id_gem_3bl_mask = 55579
    local id_gem_3bl_symbol = 55580
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_shiv = 55585
    local id_gem_3bl_lsword = 55586
    local id_gem_3bl_smace = 55587
    local id_gem_3bl_light = 55588
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    local id_3bl_cap = 5517
    local id_3bl_neck = 5519
    local id_3bl_arm = 5521
    local id_3bl_wrist = 5523
    local id_3bl_gloves = 5525
    local id_3bl_jerkin = 5527
    globals.id_gem_3bl_cap = globals.id_gem_3bl_cap or true; globals.id_gem_3bl_neck = globals.id_gem_3bl_neck or true; globals.id_gem_3bl_arm = globals.id_gem_3bl_arm or true; globals.id_gem_3bl_wrist = globals.id_gem_3bl_wrist or true; globals.id_gem_3bl_gloves = globals.id_gem_3bl_gloves or true; globals.id_gem_3bl_jerkin = globals.id_gem_3bl_jerkin or true; globals.id_gem_3bl_robe = globals.id_gem_3bl_robe or true; globals.id_gem_3bl_belt = globals.id_gem_3bl_belt or true; globals.id_gem_3bl_legs = globals.id_gem_3bl_legs or true; globals.id_gem_3bl_boots = globals.id_gem_3bl_boots or true; globals.id_gem_3bl_mask = globals.id_gem_3bl_mask or true; globals.id_gem_3bl_symbol = globals.id_gem_3bl_symbol or true; globals.id_gem_3bl_staff = globals.id_gem_3bl_staff or true; globals.id_gem_3bl_ssword = globals.id_gem_3bl_ssword or true; globals.id_gem_3bl_whammer = globals.id_gem_3bl_whammer or true; globals.id_gem_3bl_flail = globals.id_gem_3bl_flail or true; globals.id_gem_3bl_shiv = globals.id_gem_3bl_shiv or true; globals.id_gem_3bl_lsword = globals.id_gem_3bl_lsword or true; globals.id_gem_3bl_smace = globals.id_gem_3bl_smace or true; globals.id_gem_3bl_light = globals.id_gem_3bl_light or true; globals.id_gem_3bl_food = globals.id_gem_3bl_food or true; globals.id_gem_3bl_drink = globals.id_gem_3bl_drink or true; globals.id_3bl_cap = globals.id_3bl_cap or true; globals.id_3bl_neck = globals.id_3bl_neck or true; globals.id_3bl_arm = globals.id_3bl_arm or true; globals.id_3bl_wrist = globals.id_3bl_wrist or true; globals.id_3bl_gloves = globals.id_3bl_gloves or true; globals.id_3bl_jerkin = globals.id_3bl_jerkin or true
    -- Fragment (possible truncation): num_3bl_belt id_3bl_legs id_3bl_boots id_3bl_mask id_3bl_robe id_3bl_symbol id_3bl_staff id_3bl_ssword id_3bl_whammer id_3bl_flail id_3bl_shiv id_3bl_lsword id_3bl_smace id_3bl_light id_3bl_food id_3bl_drink
elseif self.id == 5524 then
    local id_trophy1 = 5503
    local id_trophy2 = 5505
    local id_trophy3 = 5507
    local id_trophy4 = 5509
    local id_trophy5 = 5511
    local id_trophy6 = 5513
    local id_trophy7 = 5515
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_gloves = 55574
    local id_gem_3eg_jerkin = 55575
    local id_gem_3eg_robe = 55589
    local id_gem_3eg_belt = 55576
    local id_gem_3eg_legs = 55577
    local id_gem_3eg_boots = 55578
    local id_gem_3eg_mask = 55579
    local id_gem_3eg_symbol = 55580
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_shiv = 55585
    local id_gem_3eg_lsword = 55586
    local id_gem_3eg_smace = 55587
    local id_gem_3eg_light = 55588
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    local id_3eg_cap = 5518
    local id_3eg_neck = 5520
    local id_3eg_arm = 5522
    local id_3eg_wrist = 5524
    local id_3eg_gloves = 5526
    local id_3eg_jerkin = 5528
    globals.id_gem_3eg_cap = globals.id_gem_3eg_cap or true; globals.id_gem_3eg_neck = globals.id_gem_3eg_neck or true; globals.id_gem_3eg_arm = globals.id_gem_3eg_arm or true; globals.id_gem_3eg_wrist = globals.id_gem_3eg_wrist or true; globals.id_gem_3eg_gloves = globals.id_gem_3eg_gloves or true; globals.id_gem_3eg_jerkin = globals.id_gem_3eg_jerkin or true; globals.id_gem_3eg_robe = globals.id_gem_3eg_robe or true; globals.id_gem_3eg_belt = globals.id_gem_3eg_belt or true; globals.id_gem_3eg_legs = globals.id_gem_3eg_legs or true; globals.id_gem_3eg_boots = globals.id_gem_3eg_boots or true; globals.id_gem_3eg_mask = globals.id_gem_3eg_mask or true; globals.id_gem_3eg_symbol = globals.id_gem_3eg_symbol or true; globals.id_gem_3eg_staff = globals.id_gem_3eg_staff or true; globals.id_gem_3eg_ssword = globals.id_gem_3eg_ssword or true; globals.id_gem_3eg_whammer = globals.id_gem_3eg_whammer or true; globals.id_gem_3eg_flail = globals.id_gem_3eg_flail or true; globals.id_gem_3eg_shiv = globals.id_gem_3eg_shiv or true; globals.id_gem_3eg_lsword = globals.id_gem_3eg_lsword or true; globals.id_gem_3eg_smace = globals.id_gem_3eg_smace or true; globals.id_gem_3eg_light = globals.id_gem_3eg_light or true; globals.id_gem_3eg_food = globals.id_gem_3eg_food or true; globals.id_gem_3eg_drink = globals.id_gem_3eg_drink or true; globals.id_3eg_cap = globals.id_3eg_cap or true; globals.id_3eg_neck = globals.id_3eg_neck or true; globals.id_3eg_arm = globals.id_3eg_arm or true; globals.id_3eg_wrist = globals.id_3eg_wrist or true; globals.id_3eg_gloves = globals.id_3eg_gloves or true; globals.id_3eg_jerkin = globals.id_3eg_jerkin or true
    -- Fragment (possible truncation): num_3eg_belt id_3eg_legs id_3eg_boots id_3eg_mask id_3eg_robe id_3eg_symbol id_3eg_staff id_3eg_ssword id_3eg_whammer id_3eg_flail id_3eg_shiv id_3eg_lsword id_3eg_smace id_3eg_light id_3eg_food id_3eg_drink
end
globals.id_trophy1 = globals.id_trophy1 or true; globals.id_trophy2 = globals.id_trophy2 or true; globals.id_trophy3 = globals.id_trophy3 or true; globals.id_trophy4 = globals.id_trophy4 or true; globals.id_trophy5 = globals.id_trophy5 or true; globals.id_trophy6 = globals.id_trophy6 or true; globals.id_trophy7 = globals.id_trophy7 or true