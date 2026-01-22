-- Trigger: Frost elf remove blade
-- Zone: 535, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53503

-- Converted from DG Script #53503: Frost elf remove blade
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if wielded then
    local now = time.stamp
    if now - 1 > wielded then
        self:command("scan")
        wait(1)
        self:command("rem blade")
        self:command("wear blade belt")
        self:emote("returns to a more relaxed posture, watching the vicinity carefully.")
        local wielded = 0
        globals.wielded = globals.wielded or true
    end
end