-- Trigger: Emmath staff receive
-- Zone: 52, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   TODO: entire trigger is the type_wand crafting-quest receive handler,
--         which references undefined DG globals (`step`, `type`, `weapon`,
--         `task4`) and `%type%_wand` percent-substituted quest names. It
--         also calls `get.room[task4]` (a DG accessor that doesn't exist
--         in Lua). Disabled until the type_wand quest schema is defined.
--
-- Original DG Script: #5215
--
-- Intent: when a player gives Emmath their staff at the right stage with
-- all sub-tasks complete, prime the staff and direct them to imbue it on
-- the elemental plane matching their `type`. Otherwise refuse with the
-- specific outstanding-task message (attacks left, gem missing, mob to
-- slay).

return true
