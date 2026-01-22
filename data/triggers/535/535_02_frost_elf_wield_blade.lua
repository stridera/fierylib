-- Trigger: Frost elf wield blade
-- Zone: 535, ID: 2
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #53502

-- Converted from DG Script #53502: Frost elf wield blade
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if not wielded then
    if self:has_equipped("53420") then
        self:emote("whispers, 'Trespassers!'")
        self:command("rem elven-blade")
        self:command("wield elven-blade")
        local wielded = time.stamp
        globals.wielded = globals.wielded or true
    end
end