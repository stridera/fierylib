-- Trigger: shapeshift
-- Zone: 188, ID: 25
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18825

-- Converted from DG Script #18825: shapeshift
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: shapeshift
if not (cmd == "shapeshift") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "sh" or cmd == "sha" then
    _return_value = false
    return _return_value
end
-- switch on actor.id
if actor.id == 18820 then
    local mob_vnum = 18822
    local mob_name = "pryrian-duclia"
    local shape_name = "the shape of a gargantuan black dragon"
    local obj_vnum = 18826
elseif actor.id == 18821 then
    local mob_vnum = 18823
    local mob_name = "eralshar-duclia"
    local shape_name = "the shape of a sinewy golden dragon"
    local obj_vnum = 18827
elseif actor.id == 18822 then
    local mob_vnum = 18820
    local mob_name = "human-pryrian"
    local shape_name = "human form"
    local obj_vnum = 18820
elseif actor.id == 18823 then
    local mob_vnum = 18821
    local mob_name = "human-eralshar"
    local shape_name = "human form"
    local obj_vnum = 18825
else
    _return_value = false
    return _return_value
end
self.room:send("The cracks of bones reforming are heard as " .. tostring(actor.name) .. " takes " .. tostring(shape_name) .. ".")
self.room:spawn_mobile(vnum_to_zone(mob_vnum), vnum_to_local(mob_vnum))
mob_name:spawn_object(vnum_to_zone(obj_vnum), vnum_to_local(obj_vnum))
actor:send("Loaded " .. tostring(mob_name) .. "; ready to be switched into.")
world.destroy(actor)
world.destroy(self)
return _return_value