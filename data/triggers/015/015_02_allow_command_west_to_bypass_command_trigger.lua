-- Trigger: Allow command "west" to bypass command trigger
-- Zone: 15, ID: 2
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1502
--
-- Pass-through: ensures `we`/`west` is not consumed by other COMMAND
-- triggers in this room. Returning true lets the engine continue normal
-- command resolution (movement handled by the PREENTRY trigger #1501).

if cmd == "we" then
    return true
end
return true
