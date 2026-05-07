-- Trigger: phase wand questmaster setup load
-- Zone: 2, ID: 111
-- Type: MOB, Flags: LOAD
--
-- On load, identifies which wand-quest stage this mob represents (by zone_id +
-- local_id) and exports the matching crafting parameters via globals so the
-- companion greet/speech/receive triggers can read them as `globals.wandstep`,
-- `globals.wandgem`, `globals.wandtask3`, `globals.wandtask4`, `globals.wand_id`,
-- `globals.type`, `globals.weapon`, and `globals.wandattack`.
local type, wandgem, wandstep, wandtask3, wandtask4, wand_id, place
local z, lid = self.zone_id, self.local_id

-- switch on self identity (zone_id, local_id)
if z == 185 and lid == 0 then
    type = "air"
    wandgem = 55591
    wandstep = 3
    wandtask3 = 23750
    wand_id = 301
elseif z == 41 and lid == 26 then
    type = "fire"
    wandgem = 55590
    wandstep = 3
    wandtask3 = 23752
    wand_id = 311
elseif z == 178 and lid == 6 then
    type = "ice"
    wandgem = 55592
    wandstep = 3
    wandtask3 = 23753
    wand_id = 321
elseif z == 100 and lid == 56 then
    type = "acid"
    wandgem = 55593
    wandstep = 3
    wandtask3 = 23751
    wand_id = 331
elseif z == 586 and lid == 1 then
    type = "air"
    wandgem = 55605
    wandstep = 4
    wandtask3 = 2330
    wandtask4 = 37006
    wand_id = 302
elseif z == 103 and lid == 6 then
    type = "fire"
    wandgem = 55612
    wandstep = 4
    wandtask3 = 2331
    wandtask4 = 37006
    wand_id = 312
elseif z == 23 and lid == 37 then
    type = "ice"
    wandgem = 55607
    wandstep = 4
    wandtask3 = 2333
    wandtask4 = 37006
    wand_id = 322
elseif z == 625 and lid == 4 then
    type = "acid"
    wandgem = 55606
    wandstep = 4
    wandtask3 = 2332
    wandtask4 = 37006
    wand_id = 332
elseif z == 123 and lid == 5 then
    type = "air"
    wandgem = 55644
    wandstep = 5
    wandtask3 = 12509
    wandtask4 = "&7&bthe icy ledge outside Technitzitlan&0"
    wand_id = 303
elseif z == 123 and lid == 4 then
    type = "fire"
    wandgem = 55639
    wandstep = 5
    wandtask3 = 12526
    wandtask4 = "&1&bthe Lava Tunnels&0"
    wand_id = 313
elseif z == 550 and lid == 13 then
    type = "ice"
    wandgem = 55640
    wandstep = 5
    wandtask3 = 58018
    wandtask4 = "&6&bthe Arabel Ocean&0"
    wand_id = 323
elseif z == 625 and lid == 3 then
    type = "acid"
    wandgem = 55647
    wandstep = 5
    wandtask3 = 16303
    wandtask4 = "&9&bthe Northern Swamps&0"
    wand_id = 333
elseif z == 123 and lid == 2 then
    type = "air"
    wandgem = 55665
    wandstep = 6
    wandtask3 = 23800
    wandtask4 = 59040
    wand_id = 304
elseif z == 238 and lid == 11 then
    type = "fire"
    wandgem = 55662
    wandstep = 6
    wandtask3 = 5201
    wandtask4 = 32412
    wand_id = 314
elseif z == 238 and lid == 2 then
    type = "ice"
    wandgem = 55666
    wandstep = 6
    wandtask3 = 49011
    wandtask4 = 17309
    wand_id = 324
elseif z == 470 and lid == 75 then
    type = "acid"
    wandgem = 55663
    wandstep = 6
    wandtask3 = 55020
    wandtask4 = 16107
    wand_id = 334
elseif z == 490 and lid == 3 then
    type = "air"
    wandgem = 55682
    wandstep = 7
    wandtask3 = 51014
    wandtask4 = 23710
    wand_id = 305
elseif z == 481 and lid == 5 then
    type = "fire"
    wandgem = 55689
    wandstep = 7
    wandtask3 = 43018
    wandtask4 = 11705
    wand_id = 315
elseif z == 533 and lid == 16 then
    type = "ice"
    wandgem = 55684
    wandstep = 7
    wandtask3 = 55016
    wandtask4 = 23815
    wand_id = 325
elseif z == 40 and lid == 17 then
    type = "acid"
    wandgem = 55683
    wandstep = 7
    wandtask3 = 16305
    wandtask4 = 37082
    wand_id = 335
elseif z == 85 and lid == 15 then
    type = "air"
    wandgem = 55721
    wandstep = 8
    wandtask3 = 11799
    wandtask4 = 53454
    place = 49007
    wand_id = 306
elseif z == 481 and lid == 150 then
    type = "fire"
    wandgem = 55716
    wandstep = 8
    wandtask3 = 53000
    wandtask4 = 53456
    place = 5272
    wand_id = 316
elseif z == 103 and lid == 0 then
    type = "ice"
    wandgem = 55717
    wandstep = 8
    wandtask3 = 23847
    wandtask4 = 53457
    place = 55105
    wand_id = 326
elseif z == 480 and lid == 29 then
    type = "acid"
    wandgem = 55724
    wandstep = 8
    wandtask3 = 58414
    wandtask4 = 53453
    place = 16355
    wand_id = 336
elseif z == 62 and lid == 16 then
    type = "air"
    wandgem = 55742
    wandstep = 9
    wandtask3 = 49019
    wandtask4 = 23803
    wand_id = 307
elseif z == 484 and lid == 12 then
    type = "fire"
    wandgem = 55739
    wandstep = 9
    wandtask3 = 48126
    wandtask4 = 4013
    wand_id = 317
elseif z == 100 and lid == 12 then
    type = "ice"
    wandgem = 55743
    wandstep = 9
    wandtask3 = 48018
    wandtask4 = 53300
    wand_id = 327
elseif z == 35 and lid == 49 then
    type = "acid"
    wandgem = 55740
    wandstep = 9
    wandtask3 = 47006
    wandtask4 = 52018
    wand_id = 337
elseif z == 185 and lid == 81 then
    type = "air"
    wandgem = 11811
    wandstep = 10
    wandtask3 = 52001
    wandtask4 = 48862
    wand_id = 308
elseif z == 52 and lid == 30 then
    type = "fire"
    wandgem = 23822
    wandstep = 10
    wandtask3 = 52002
    wandtask4 = 47800
    wand_id = 318
elseif z == 550 and lid == 20 then
    type = "ice"
    wandgem = 53314
    wandstep = 10
    wandtask3 = 52005
    wandtask4 = 47708
    wand_id = 328
elseif z == 163 and lid == 15 then
    type = "acid"
    wandgem = 52031
    wandstep = 10
    wandtask3 = 52007
    wandtask4 = 47672
    wand_id = 338
end

if not wandstep then return end

local weapon
if wandstep < 8 then
    weapon = "wand"
else
    weapon = "staff"
end
local wandattack = (wandstep - 1) * 50

globals.wandattack = wandattack
globals.weapon = weapon
globals.type = type
globals.wandgem = wandgem
globals.wandstep = wandstep
globals.wandtask3 = wandtask3
globals.wand_id = wand_id
if wandtask4 then
    globals.wandtask4 = wandtask4
end
