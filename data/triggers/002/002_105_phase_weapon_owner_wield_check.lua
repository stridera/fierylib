-- Trigger: phase weapon owner wield check
-- Zone: 2, ID: 105
-- Type: OBJECT, Flags: WEAR
--
-- Wear-time gate for phase wands/staves (legacy vnums 300-339 = objects 2:100-2:139) and phase
-- maces (340-349 = 2:140-2:149). A wand/staff at level L needs the wearer to be at stage
-- (L / 10) + 2 of the matching <type>_wand quest; a mace needs (L / 10) + 1 of phase_mace.
-- The first item of each line (300/310/320/330 wands, 340 mace) starts the quest when the
-- wearer has not begun it, and is never "bound": it is the entry point.
-- The engine does not read a WEAR body's return value, so the warning is informational.
local dg = require("dg")
local _return_value = true  -- Default: allow action

local vnum = dg.to_vnum(self.zone_id, self.id)
if vnum >= 300 and vnum <= 339 then
    local energy
    if vnum <= 309 then
        energy = "air"
    elseif vnum <= 319 then
        energy = "fire"
    elseif vnum <= 329 then
        energy = "ice"
    else
        energy = "acid"
    end
    local quest = energy .. "_wand"
    local stage = actor:get_quest_stage(quest)
    if vnum == 300 or vnum == 310 or vnum == 320 or vnum == 330 then
        if stage == 0 then
            actor:start_quest(quest)
        end
    elseif stage < (self.level // 10) + 2 then
        actor:send("This weapon is bound to someone else!")
    end
elseif vnum >= 340 and vnum <= 349 then
    local stage = actor:get_quest_stage("phase_mace")
    if vnum == 340 then
        if stage == 0 then
            actor:start_quest("phase_mace")
        end
    elseif stage < (self.level // 10) + 1 then
        actor:send("This weapon is bound to someone else!")
    end
end
return _return_value
