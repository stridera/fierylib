-- Trigger: rylee_wield
-- Zone: 590, ID: 16
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #59016

-- Converted from DG Script #59016: rylee_wield
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if wie_dagger ~= 2 then
    wait(2)
    self.room:send_except(self, tostring(self.name) .. " reaches under her robe and pulls a dagger from a sheath strapped to her leg.")
    wait(1)
    self.room:spawn_object(590, 12)
    self:command("wie radiant-dagger")
    wait(2)
    self:say("Lets see if you can defend against this.")
    wait(2)
    spells.cast(self, "divine bolt", actor.name)
    local wie_dagger = 2
    globals.wie_dagger = globals.wie_dagger or true
end