-- Trigger: death_of_tree
-- Zone: 520, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #52007

-- Converted from DG Script #52007: death_of_tree
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- The Tree of Life dies. It drops a fresh branch (520:34) for the hydra
-- fight (cauterises severed necks, see grow_hydra_head 520:1) and whispers
-- a final relieved line.
self.room:spawn_object(520, 34)
self:emote("whispers 'Ah, the relief...'")
return true