-- Trigger: Phase mace load variables
-- Zone: 2, ID: 118
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #318

-- Converted from DG Script #318: Phase mace load variables
-- Original: MOB trigger, flags: LOAD, probability: 100%
local maceitem2, maceitem3, maceitem4, maceitem5, maceitem6, maceattack, macestep
local z, lid = self.zone_id, self.local_id

-- switch on self identity (zone_id, local_id)
if z == 30 and lid == 25 then
    maceitem2 = 55577
    maceitem3 = 55211
    maceitem4 = 13614
    maceitem5 = 58809
    macestep = 1
elseif z == 185 and lid == 2 then
    maceitem2 = 55593
    maceitem3 = 18522
    maceitem4 = 18523
    maceitem5 = 18524
    maceitem6 = 18525
    macestep = 2
elseif z == 100 and lid == 0 then
    maceitem2 = 55604
    maceitem3 = 32409
    maceitem4 = 59022
    maceitem5 = 2327
    maceattack = 150
    macestep = 3
elseif z == 62 and lid == 18 then
    maceitem2 = 55631
    maceitem3 = 16030
    maceitem4 = 47002
    maceitem5 = 5211
    macestep = 4
elseif z == 85 and lid == 1 then
    maceitem2 = 55660
    maceitem3 = 43007
    maceitem4 = 59012
    maceitem5 = 17308
    macestep = 5
elseif z == 185 and lid == 81 then
    macestep = 6
    maceitem2 = 55681
    maceitem3 = 23824
    maceitem4 = 53016
    maceitem5 = 16201
elseif z == 60 and lid == 7 then
    maceitem2 = 55708
    maceitem3 = 49502
    maceitem4 = 4008
    maceitem5 = 47017
    maceattack = 350
    macestep = 7
elseif z == 484 and lid == 12 then
    maceitem2 = 55737
    maceitem3 = 53305
    maceitem4 = 12307
    maceitem5 = 51073
    macestep = 8
elseif z == 30 and lid == 21 then
    maceitem2 = 55738
    maceitem3 = 48002
    maceitem4 = 52010
    maceitem5 = 3218
    macestep = 9
end

if not macestep then return end

maceattack = macestep * 50
local mace_id = macestep + 339
local reward_mace = mace_id + 1

globals.maceitem2 = maceitem2
globals.maceitem3 = maceitem3
globals.maceitem4 = maceitem4
globals.maceitem5 = maceitem5
globals.maceattack = maceattack
globals.macestep = macestep
globals.mace_id = mace_id
globals.reward_mace = reward_mace
if maceitem6 then
    globals.maceitem6 = maceitem6
end
