-- Trigger: flood_block_d_abbrev
-- Zone: 390, ID: 14
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #39014
--
-- Filters out the bare "d" abbreviation on the totem so it does not
-- accidentally fire the dance handler (390:8). Always allows the
-- command to continue to normal command processing.

if cmd ~= "d" then
    return true
end
return true
