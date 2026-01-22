-- Trigger: blur_winds_preentry
-- Zone: 18, ID: 33
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1833

-- Converted from DG Script #1833: blur_winds_preentry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("blur") == 4 then
    -- switch on self.id
    if self.id == 10001 then
        local direction = "north"
        local mob = 1819
    elseif self.id == 2460 then
        local direction = "south"
        local mob = 1820
    elseif self.id == 48223 then
        local direction = "east"
        local mob = 1821
    elseif self.id == 20379 then
        local direction = "west"
        local mob = 1822
    else
        _return_value = false
    end
    if actor.quest_variable[blur:direction] == 0 and get.mob_count[mob] == 0 then
        self.room:spawn_mobile(vnum_to_zone(mob), vnum_to_local(mob))
    end
end
return _return_value