-- Trigger: Shards_of_glass_hurt
-- Zone: 16, ID: 52
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #1652

-- Converted from DG Script #1652: Shards_of_glass_hurt
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
local var1 = random(1, 10)
local damage = 10 + var1
local damage_dealt = actor:damage(damage)  -- type: slash
if damage_dealt == 0 then
    actor:send("You pick up a few shards, but find nothing interesting and drop them again.")
    self.room:send_except(actor, tostring(actor.name) .. " grabs some shards of glass, but drops them again.")
else
    actor:send("The shards of glass fall through your fingers, leaving large slices in your hands! (<red>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " curses as some shards of glass fall through " .. tostring(actor.possessive) .. " fingers. (<red>" .. tostring(damage_dealt) .. "</>)")
end
_return_value = false
return _return_value