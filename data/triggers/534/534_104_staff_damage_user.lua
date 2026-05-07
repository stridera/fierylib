-- Trigger: Staff damage user
-- Zone: 534, ID: 104
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53504

-- Converted from DG Script #53504: Staff damage user
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: use
if not (cmd == "use") then
    return true  -- Not our command
end
local aliases = "elaborately-chiseled-staff deep-brown-maple-staff"
-- self.val2 holds remaining charges. When the staff is used, deal heavy
-- physical damage to the wielder (cursed staff). 53504 = zone 534/id 104
-- (the staff item itself).
if self.val2 and (arg ~= nil and arg ~= "") and string.find(aliases, arg) and actor:has_equipped(534, 104) then
    local damage = 480 + random(1, 50)
    actor:damage(damage)  -- type: physical
    actor:send("You double over in pain as " .. tostring(self.shortdesc) .. " touches the ground! (<b:red>" .. tostring(damage) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " doubles over in pain as " .. tostring(self.shortdesc) .. " touches the ground! (<blue>" .. tostring(damage) .. "</>)")
end
return true