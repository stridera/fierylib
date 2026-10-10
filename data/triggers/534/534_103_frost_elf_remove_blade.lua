-- Trigger: Frost elf remove blade
-- Zone: 534, ID: 103
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53503

-- Converted from DG Script #53503: Frost elf remove blade
-- Original: MOB trigger, flags: RANDOM, probability: 100%
-- Sheathe the blade roughly a game hour after trigger 53502 drew it.
if globals.wielded then
    local now = timestamp()
    -- timestamp() counts game hours, as legacy `time.stamp` did.
    if now - 1 > globals.wielded then
        self:command("scan")
        wait(1)
        self:command("rem blade")
        self:command("wear blade belt")
        self:emote("returns to a more relaxed posture, watching the vicinity carefully.")
        globals.wielded = nil
    end
end