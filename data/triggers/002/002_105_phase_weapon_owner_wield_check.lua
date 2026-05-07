-- Trigger: phase weapon owner wield check
-- Zone: 2, ID: 105
-- Type: OBJECT, Flags: WEAR
--
-- Wear-time gate for phase wands/staves (300-339) and phase maces (340-349).
-- A wand/staff at level L (per the item template) requires the wielder to
-- be at quest stage (L/10) + 2 in the matching <type>_wand quest; a phase
-- mace requires (L/10) + 1 in phase_mace. The very first item in each
-- range (300/310/320/330 wands, 340 mace) auto-starts the quest if the
-- player has not begun yet.
local _return_value = true  -- Default: allow action

if self.id >= 300 and self.id <= 339 then
    local energy
    if self.id <= 309 then
        energy = "air"
    elseif self.id <= 319 then
        energy = "fire"
    elseif self.id <= 329 then
        energy = "ice"
    else
        energy = "acid"
    end
    local quest = energy .. "_wand"
    local stage = actor:get_quest_stage(quest)
    if not stage and (self.id == 300 or self.id == 310 or self.id == 320 or self.id == 330) then
        actor:start_quest(quest)
        stage = 0
    end
    if (stage or 0) < (self.level / 10) + 2 then
        actor:send("This weapon is bound to someone else!")
    end
elseif self.id >= 340 and self.id <= 349 then
    local stage = actor:get_quest_stage("phase_mace")
    if not stage and self.id == 340 then
        actor:start_quest("phase_mace")
        stage = 0
    end
    if (stage or 0) < (self.level / 10) + 1 then
        actor:send("This weapon is bound to someone else!")
    end
end
return _return_value
