-- Trigger: **UNUSED**
-- Zone: 133, ID: 32
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #13332
--
-- Vestigial filter for the abbreviation "commun" of the commune command.
-- The legacy DG script swallowed the abbreviation so the player had to
-- type the full word to commune with the starlight (handled by 133_31).
-- Kept as a no-op for completeness.
if cmd ~= "commun" then
    return true
end
return true
