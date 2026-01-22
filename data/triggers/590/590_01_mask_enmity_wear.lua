-- Trigger: mask_enmity_wear
-- Zone: 590, ID: 1
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #59001

-- Converted from DG Script #59001: mask_enmity_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.alignment > -350 then
        _return_value = false
        wait(1)
        self.room:send("The mask of enmity starts to &9<blue>smoke</> violently!")
        wait(2)
        actor:send("You feel the smoke dig into your skin and burn!")
        self.room:send_except(actor, "The smoke from the mask digs into " .. tostring(actor.name) .. "'s skin and severely burns " .. tostring(actor.object) .. ".")
        self.room:send_except(actor, tostring(actor.name) .. " rips the mask of enmity from " .. tostring(actor.possessive) .. " face.")
        actor:send("You rip the mask from your face.")
        actor:damage(50)  -- type: physical
    end
end
return _return_value