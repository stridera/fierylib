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
    _return_value = true
    return _return_value
end
-- switch on actor.id
local mob_id, mob_name, shape_name, obj_id
if actor.id == 18820 then
    mob_id = 22
    mob_name = "pryrian-duclia"
    shape_name = "the shape of a gargantuan black dragon"
    obj_id = 26
elseif actor.id == 18821 then
    mob_id = 23
    mob_name = "eralshar-duclia"
    shape_name = "the shape of a sinewy golden dragon"
    obj_id = 27
elseif actor.id == 18822 then
    mob_id = 20
    mob_name = "human-pryrian"
    shape_name = "human form"
    obj_id = 20
elseif actor.id == 18823 then
    mob_id = 21
    mob_name = "human-eralshar"
    shape_name = "human form"
    obj_id = 25
else
    _return_value = true
    return _return_value
end
self.room:send("The cracks of bones reforming are heard as " .. tostring(actor.name) .. " takes " .. tostring(shape_name) .. ".")
self.room:spawn_mobile(188, mob_id)
-- Equip the freshly-spawned shapeshift mob with its matching object.
local shifted = self.room:find_actor(mob_name)
if shifted then
    shifted:spawn_object(188, obj_id)
end
actor:send("Loaded " .. tostring(mob_name) .. "; ready to be switched into.")
world.destroy(actor)
world.destroy(self)
return _return_value