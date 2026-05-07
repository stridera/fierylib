-- Trigger: mage_receive_refuse
-- Zone: 238, ID: 8
-- Type: MOB, Flags: RECEIVE
--
-- TODO(parity): The original DG script had probability 0% (effectively disabled),
-- and the body refers to DG vars (%wandgem%, %wand_id%, %wandtask3%, %wandtask4%)
-- that were never defined locally. Likely intent: the mage refuses any object
-- that isn't one of the wand-craft quest tokens. Cannot port faithfully without
-- re-deriving those quest item ids. The 100% receive trigger that handles the
-- accept path lives in 238_15_mage_receive.lua.

return true
