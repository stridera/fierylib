-- Trigger: corpse disin
-- Zone: 200, ID: 39
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #20039

-- Converted from DG Script #20039: corpse disin
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    _return_value = false
    wait(1)
    actor:send("As you grab the corpse from the coffin, it disintigrates in your hands!")
    self.room:send_except(actor, tostring(actor.name) .. " grabs the corpse and it disintigrates in " .. tostring(actor.possessive) .. " hands!")
    world.destroy(self.room:find_object("corpse"))
end
return _return_value