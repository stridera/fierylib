-- Trigger: dark_elf_open1
-- Zone: 520, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52013
-- Intercepts `open chest` and the dark elf attacks. Legacy probability of 0
-- in DG meant "always fire when filter matches" for COMMAND triggers - the
-- numeric probability slot was reused as a flag, not a roll.

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
if arg and string.find(arg, "chest") then
    actor:send("A dark elf stops you from opening a chest!")
    self.room:send_except(actor, "A dark elf jumps in " .. tostring(actor.name) .. "'s way, keeping them from the chest!")
    self:say("Insolent fools!  Such blatant thievery.")
    self:command("close panel west")
    combat.engage(actor)
end