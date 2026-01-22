-- Trigger: Minor Life Restore
-- Zone: 0, ID: 40
-- Type: OBJECT, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #40

-- Converted from DG Script #40: Minor Life Restore
-- Original: OBJECT trigger, flags: DEATH, probability: 100%
local heal = actor.maxhit / 5
trigger_log(actor.name .. " would have died.  " .. self.name .. " broke to restore 20% hp.  " .. tostring(heal) .. " hp healed.")
actor:heal(heal)
self.room:send("Your " .. self.shortdesc .. " shatters and heals you for " .. tostring(heal) .. " hp.")
world.destroy(self)