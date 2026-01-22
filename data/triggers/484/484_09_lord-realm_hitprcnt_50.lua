-- Trigger: lord-realm hitprcnt 50
-- Zone: 484, ID: 9
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #48409

-- Converted from DG Script #48409: lord-realm hitprcnt 50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
if not (self:has_effect(Effect.Blind)) and not (self:has_effect(Effect.Blur)) then
    wait(2)
    self.room:spawn_object(11, 59)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff blur
    end)
    self.room:send(tostring(self.name) .. "'s rock formation cracks slightly...")
    self:emote("composes " .. tostring(self.object) .. "self and " .. tostring(self.possessive) .. " quickness seems to increase!")
    local has_blur = 1
    globals.has_blur = globals.has_blur or true
end