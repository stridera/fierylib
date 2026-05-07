-- Trigger: Nukreth Spire captive load
-- Zone: 462, ID: 7
-- Type: MOB, Flags: LOAD
--
-- Original DG Script: #46207

-- Converted from DG Script #46207: Nukreth Spire captive load
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Stash this captive's path number (1..4) for downstream quest scripts
-- (462_30 uses globals.number to credit the right path on quest end).
-- TODO(parity): globals.number is zone-wide; if multiple captives are alive
-- simultaneously the value is whichever loaded last. Original DG had the
-- same flaw.
if self.local_id == 20 then
    globals.number = 1
elseif self.local_id == 21 then
    globals.number = 2
elseif self.local_id == 22 then
    globals.number = 3
elseif self.local_id == 23 then
    globals.number = 4
end