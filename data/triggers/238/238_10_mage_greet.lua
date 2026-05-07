-- Trigger: mage_greet
-- Zone: 238, ID: 10
-- Type: MOB, Flags: GREET
--
-- The mage acknowledges Sunfire-crested visitors. Original DG also gated a
-- "wand-craft" upgrade hint on the type_wand quest, but the converter dropped
-- the wandstep / weapon variable bindings, so that branch is left as TODO.

-- TODO(parity): the converter lost the type_wand quest state machine. The
-- original referenced %wandstep% and %weapon% locals that don't exist here.
-- Reconstructing the upgrade-hint dialogue requires the full type_wand quest
-- spec (see 238_15_mage_receive.lua for the quest hand-in side). Disabled
-- until that quest is rebuilt.

wait(2)

-- Only greet people wearing the Sunfire crest (object 237:16)
if actor:has_equipped(237, 16) then
    wait(2)
    self:command("blink")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Far be it from me to ask how you got that crest...  But it appears you have done a service for one of my kin.")
    wait(2)
    self:say("Perhaps you can help me also in solving a riddle.")
end
