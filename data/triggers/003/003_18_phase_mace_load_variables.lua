-- Trigger: Phase mace load variables
-- Zone: 3, ID: 18
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #318

-- Converted from DG Script #318: Phase mace load variables
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- switch on self.id
if self.id == 3025 then
    local maceitem2 = 55577
    local maceitem3 = 55211
    local maceitem4 = 13614
    local maceitem5 = 58809
    local macestep = 1
elseif self.id == 18502 then
    local maceitem2 = 55593
    local maceitem3 = 18522
    local maceitem4 = 18523
    local maceitem5 = 18524
    local maceitem6 = 18525
    local macestep = 2
elseif self.id == 10000 then
    local maceitem2 = 55604
    local maceitem3 = 32409
    local maceitem4 = 59022
    local maceitem5 = 2327
    local maceattack = 150
    local macestep = 3
elseif self.id == 6218 then
    local maceitem2 = 55631
    local maceitem3 = 16030
    local maceitem4 = 47002
    local maceitem5 = 5211
    local macestep = 4
elseif self.id == 8501 then
    local maceitem2 = 55660
    local maceitem3 = 43007
    local maceitem4 = 59012
    local maceitem5 = 17308
    local macestep = 5
elseif self.id == 18581 then
    local macestep = 6
    local maceitem2 = 55681
    local maceitem3 = 23824
    local maceitem4 = 53016
    local maceitem5 = 16201
elseif self.id == 6007 then
    local maceitem2 = 55708
    local maceitem3 = 49502
    local maceitem4 = 4008
    local maceitem5 = 47017
    local maceattack = 350
    local macestep = 7
elseif self.id == 48412 then
    local maceitem2 = 55737
    local maceitem3 = 53305
    local maceitem4 = 12307
    local maceitem5 = 51073
    local macestep = 8
elseif self.id == 3021 then
    local maceitem2 = 55738
    local maceitem3 = 48002
    local maceitem4 = 52010
    local maceitem5 = 3218
    local macestep = 9
end
local maceattack = macestep * 50
local macevnum = macestep + 339
local reward_mace = macevnum + 1
globals.maceitem2 = globals.maceitem2 or true; globals.maceitem3 = globals.maceitem3 or true; globals.maceitem4 = globals.maceitem4 or true; globals.maceitem5 = globals.maceitem5 or true; globals.maceattack = globals.maceattack or true; globals.macestep = globals.macestep or true; globals.macevnum = globals.macevnum or true; globals.reward_mace = globals.reward_mace or true
if maceitem6 then
    globals.maceitem6 = globals.maceitem6 or true
end