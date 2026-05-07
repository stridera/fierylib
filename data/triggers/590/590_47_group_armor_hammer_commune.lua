-- Trigger: group_armor_hammer_commune
-- Zone: 590, ID: 47
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59047

-- Converted from DG Script #59047: group_armor_hammer_commune
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: commune
if not (cmd == "commune") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- The original DG also early-returned for the partial-prefix forms of
-- "commune" ("c", "co", "com", "comm"), but the engine no longer routes
-- those to this trigger's filter so the check is now dead code.
local target_room = get_room(133, 58)
if actor:get_quest_stage("group_armor") == 3 and self.room == target_room then
    actor:advance_quest("group_armor")
    self.room:send("Holding " .. tostring(self.shortdesc) .. " up to the shaft of light, it begins to hum!")
    wait(3)
    self.room:send("The hammer grows warm.")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " begins emitting a soft glowing light!")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " becomes as light as a feather but remains as solid as iron.")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " floats in the air for a moment before sinking to the ground.")
    wait(2)
    self.room:send("The humming ceases, leaving the hammer glowing with a faint, ethereal light.")
    self.room:spawn_object(590, 39)
    actor:command("get mystic-forging-hammer")
    wait(2)
    world.destroy(self)
else
    _return_value = true
end
return _return_value