-- Trigger: **UNUSED** (legacy: catch bare `k` to prevent kneel-abbrev)
-- Zone: 185, ID: 67
-- Type: WORLD, Flags: COMMAND
--
-- Reserved slot. The legacy DG #18567 caught the single-letter `k`
-- abbreviation so it would not match the kneel command in 185_66
-- via abbreviation rules. The rs runtime does its own command parsing
-- so this is a no-op.
if cmd == "k" then
    return true
end
return true
