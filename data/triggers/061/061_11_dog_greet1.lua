-- Trigger: dog_greet1
-- Zone: 61, ID: 11
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #6111

-- Converted from DG Script #6111: dog_greet1
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
if actor.id == -1 then
    self:emote("stops scratching itself and looks up at " .. tostring(actor.name))
    if actor.alignment > 349 then
        self:command("lick " .. tostring(actor.name))
    else
        self:command("growl " .. tostring(actor.name))
        self:command("bark")
        self:command("bite " .. tostring(actor.name))
    end
end