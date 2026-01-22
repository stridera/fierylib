-- Trigger: thorn_trigger
-- Zone: 18, ID: 9
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #1809

-- Converted from DG Script #1809: thorn_trigger
-- Original: OBJECT trigger, flags: GET, probability: 7%

-- 7% chance to trigger
if not percent_chance(7) then
    return true
end
actor.name:damage(20)  -- type: poison
if damage_dealt > 0 then
    self.room:send_except(actor.name, tostring(actor.name) .. " cries out in pain! (<green>" .. tostring(damage_dealt) .. "</>)")
    actor.name:send("You prick your finger on the poisoned thorn as you pick it up! (<green>" .. tostring(damage_dealt) .. "</>)")
end