-- Trigger: Get_Book
-- Zone: 125, ID: 6
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #12506

-- Converted from DG Script #12506: Get_Book
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
actor:damage(100)  -- type: slash
if damage_dealt == 0 then
    _return_value = true
else
    _return_value = false
    actor:send("As you grab the book, blades rip through your hand - it must have been trapped! (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " grabs the green book, and screams in pain as blades rip through " .. tostring(actor.possessive) .. " hand. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value