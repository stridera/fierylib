-- Trigger: **UNUSED**
-- Zone: 18, ID: 16
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1816

-- Converted from DG Script #1816: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
if actor.id == -1 then
    self.room:send_except(actor.name, "The thorn monster blocks " .. tostring(actor.name) .. "'s path to the well!")
    actor.name:send("The thorn monster pushes you back from the well!")
    self:whisper(actor.name, "You're not getting away that easily!")
end