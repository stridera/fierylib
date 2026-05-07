-- Trigger: Frost elf wield blade
-- Zone: 534, ID: 102
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #53502

-- Converted from DG Script #53502: Frost elf wield blade
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- On first hit, draw the blade and mark the time so trigger 53503 knows when
-- to sheathe it again.
if not globals.wielded then
    if self:has_equipped(534, 20) then
        self:emote("whispers, 'Trespassers!'")
        self:command("rem elven-blade")
        self:command("wield elven-blade")
        globals.wielded = timestamp()
    end
end