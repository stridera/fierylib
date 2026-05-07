-- Trigger: Frost elf remove blade
-- Zone: 534, ID: 103
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53503

-- Converted from DG Script #53503: Frost elf remove blade
-- Original: MOB trigger, flags: RANDOM, probability: 100%
-- Sheathe the blade roughly a minute after trigger 53502 drew it.
if globals.wielded then
    local now = timestamp()
    -- TODO(parity): legacy `now - 1 > wielded` used DG ticks; with timestamp()
    -- returning seconds, 60 seconds is a reasonable equivalent. Verify against
    -- the original DG game-tick length.
    if now - 60 > globals.wielded then
        self:command("scan")
        wait(1)
        self:command("rem blade")
        self:command("wear blade belt")
        self:emote("returns to a more relaxed posture, watching the vicinity carefully.")
        globals.wielded = nil
    end
end