-- Trigger: phase wand questmaster setup load
-- Zone: 3, ID: 11
-- Type: MOB, Flags: LOAD
-- Status: NEEDS_REVIEW
--   Large script: 6557 chars
--
-- Original DG Script: #311

-- Converted from DG Script #311: phase wand questmaster setup load
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- switch on self.id
if self.id == 18500 then
    local type = "air"
    local wandgem = 55591
    local wandstep = 3
    local wandtask3 = 23750
    local wandvnum = 301
elseif self.id == 4126 then
    local type = "fire"
    local wandgem = 55590
    local wandstep = 3
    local wandtask3 = 23752
    local wandvnum = 311
elseif self.id == 17806 then
    local type = "ice"
    local wandgem = 55592
    local wandstep = 3
    local wandtask3 = 23753
    local wandvnum = 321
elseif self.id == 10056 then
    local type = "acid"
    local wandgem = 55593
    local wandstep = 3
    local wandtask3 = 23751
    local wandvnum = 331
elseif self.id == 58601 then
    local type = "air"
    local wandgem = 55605
    local wandstep = 4
    local wandtask3 = 2330
    local wandtask4 = 37006
    local wandvnum = 302
elseif self.id == 10306 then
    local type = "fire"
    local wandgem = 55612
    local wandstep = 4
    local wandtask3 = 2331
    local wandtask4 = 37006
    local wandvnum = 312
elseif self.id == 2337 then
    local type = "ice"
    local wandgem = 55607
    local wandstep = 4
    local wandtask3 = 2333
    local wandtask4 = 37006
    local wandvnum = 322
elseif self.id == 62504 then
    local type = "acid"
    local wandgem = 55606
    local wandstep = 4
    local wandtask3 = 2332
    local wandtask4 = 37006
    local wandvnum = 332
elseif self.id == 12305 then
    local type = "air"
    local wandgem = 55644
    local wandstep = 5
    local wandtask3 = 12509
    local wandtask4 = "&7&bthe icy ledge outside Technitzitlan&0"
    local wandvnum = 303
elseif self.id == 12304 then
    local type = "fire"
    local wandgem = 55639
    local wandstep = 5
    local wandtask3 = 12526
    local wandtask4 = "&1&bthe Lava Tunnels&0"
    local wandvnum = 313
elseif self.id == 55013 then
    local type = "ice"
    local wandgem = 55640
    local wandstep = 5
    local wandtask3 = 58018
    local wandtask4 = "&6&bthe Arabel Ocean&0"
    local wandvnum = 323
elseif self.id == 62503 then
    local type = "acid"
    local wandgem = 55647
    local wandstep = 5
    local wandtask3 = 16303
    local wandtask4 = "&9&bthe Northern Swamps&0"
    local wandvnum = 333
elseif self.id == 12302 then
    local type = "air"
    local wandgem = 55665
    local wandstep = 6
    local wandtask3 = 23800
    local wandtask4 = 59040
    local wandvnum = 304
elseif self.id == 23811 then
    local type = "fire"
    local wandgem = 55662
    local wandstep = 6
    local wandtask3 = 5201
    local wandtask4 = 32412
    local wandvnum = 314
elseif self.id == 23802 then
    local type = "ice"
    local wandgem = 55666
    local wandstep = 6
    local wandtask3 = 49011
    local wandtask4 = 17309
    local wandvnum = 324
elseif self.id == 47075 then
    local type = "acid"
    local wandgem = 55663
    local wandstep = 6
    local wandtask3 = 55020
    local wandtask4 = 16107
    local wandvnum = 334
elseif self.id == 49003 then
    local type = "air"
    local wandgem = 55682
    local wandstep = 7
    local wandtask3 = 51014
    local wandtask4 = 23710
    local wandvnum = 305
elseif self.id == 48105 then
    local type = "fire"
    local wandgem = 55689
    local wandstep = 7
    local wandtask3 = 43018
    local wandtask4 = 11705
    local wandvnum = 315
elseif self.id == 53316 then
    local type = "ice"
    local wandgem = 55684
    local wandstep = 7
    local wandtask3 = 55016
    local wandtask4 = 23815
    local wandvnum = 325
elseif self.id == 4017 then
    local type = "acid"
    local wandgem = 55683
    local wandstep = 7
    local wandtask3 = 16305
    local wandtask4 = 37082
    local wandvnum = 335
elseif self.id == 8515 then
    local type = "air"
    local wandgem = 55721
    local wandstep = 8
    local wandtask3 = 11799
    local wandtask4 = 53454
    local place = 49007
    local wandvnum = 306
elseif self.id == 48250 then
    local type = "fire"
    local wandgem = 55716
    local wandstep = 8
    local wandtask3 = 53000
    local wandtask4 = 53456
    local place = 5272
    local wandvnum = 316
elseif self.id == 10300 then
    local type = "ice"
    local wandgem = 55717
    local wandstep = 8
    local wandtask3 = 23847
    local wandtask4 = 53457
    local place = 55105
    local wandvnum = 326
elseif self.id == 48029 then
    local type = "acid"
    local wandgem = 55724
    local wandstep = 8
    local wandtask3 = 58414
    local wandtask4 = 53453
    local place = 16355
    local wandvnum = 336
elseif self.id == 6216 then
    local type = "air"
    local wandgem = 55742
    local wandstep = 9
    local wandtask3 = 49019
    local wandtask4 = 23803
    local wandvnum = 307
elseif self.id == 48412 then
    local type = "fire"
    local wandgem = 55739
    local wandstep = 9
    local wandtask3 = 48126
    local wandtask4 = 4013
    local wandvnum = 317
elseif self.id == 10012 then
    local type = "ice"
    local wandgem = 55743
    local wandstep = 9
    local wandtask3 = 48018
    local wandtask4 = 53300
    local wandvnum = 327
elseif self.id == 3549 then
    local type = "acid"
    local wandgem = 55740
    local wandstep = 9
    local wandtask3 = 47006
    local wandtask4 = 52018
    local wandvnum = 337
elseif self.id == 18581 then
    local type = "air"
    local wandgem = 11811
    local wandstep = 10
    local wandtask3 = 52001
    local wandtask4 = 48862
    local wandvnum = 308
elseif self.id == 5230 then
    local type = "fire"
    local wandgem = 23822
    local wandstep = 10
    local wandtask3 = 52002
    local wandtask4 = 47800
    local wandvnum = 318
elseif self.id == 55020 then
    local type = "ice"
    local wandgem = 53314
    local wandstep = 10
    local wandtask3 = 52005
    local wandtask4 = 47708
    local wandvnum = 328
elseif self.id == 16315 then
    local type = "acid"
    local wandgem = 52031
    local wandstep = 10
    local wandtask3 = 52007
    local wandtask4 = 47672
    local wandvnum = 338
end
if wandstep < 8 then
    local weapon = "wand"
else
    local weapon = "staff"
end
local wandattack = (wandstep - 1) * 50
globals.wandattack = globals.wandattack or true; globals.weapon = globals.weapon or true; globals.type = globals.type or true; globals.wandgem = globals.wandgem or true; globals.wandstep = globals.wandstep or true; globals.wandtask3 = globals.wandtask3 or true; globals.wandvnum = globals.wandvnum or true
if wandtask4 then
    globals.wandtask4 = globals.wandtask4 or true
end