-- Trigger: Minor Life Restore
-- Zone: 0, ID: 40
-- Type: OBJECT, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #40
-- On player death: shatter this item, restoring 20% of max HP.

local heal = actor.maxhit / 5
trigger_log(tostring(actor.name) .. " would have died. " .. tostring(self.name) .. " broke to restore 20% hp. " .. tostring(heal) .. " hp healed.")
actor:heal(heal)
self.room:send("Your " .. tostring(self.shortdesc) .. " shatters and heals you for " .. tostring(heal) .. " hp.")
world.destroy(self)
