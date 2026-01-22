-- Trigger: lord-realm-spawn
-- Zone: 484, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48404

-- Converted from DG Script #48404: lord-realm-spawn
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- This is for room 47658: The Heart of the Realm.
if not lord_loaded then
    local lord_loaded = 1
    globals.lord_loaded = globals.lord_loaded or true
    wait(1)
    self.room:send("Before your eyes, a nondescript boulder molds itself into the image of a man of gigantic proportions.")
    self.room:spawn_mobile(484, 6)
    wait(1)
    self.room:send("When the transformation is complete, the elemental flexes his thick stone fingers fluidly.")
    self.room:find_actor("lord-realm"):spawn_object(484, 2)
    self.room:find_actor("lord-realm"):command("mat 1100 hold staff-justice")
    self.room:find_actor("lord-realm"):shout("It has been long since I have taken this form! Beware--this time I will be the victorious one!")
end