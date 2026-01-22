-- Trigger: Guard Trigger
-- Zone: 18, ID: 12
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1812

-- Converted from DG Script #1812: Guard Trigger
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
if actor.id == -1 then
    self.room:send_except(actor.name, "The thorn monster blocks " .. tostring(actor.name) .. "'s path!")
    actor.name:send("The thorn monster pushes you back!")
    self:whisper(actor.name, "Try that again, and I will have to slay you for my mistress.")
end