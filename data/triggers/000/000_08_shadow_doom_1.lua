-- Trigger: Shadow Doom 1
-- Zone: 0, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8

-- Converted from DG Script #8: Shadow Doom 1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if direction == "east" then
        self.room:spawn_object(90, 36)
        self:command("give badge " .. tostring(actor.name) .. "%")
        self:command("close gate east")
        self:command("lock gate east")
    end
end  -- auto-close block