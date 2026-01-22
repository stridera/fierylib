-- Trigger: dark_elf_open1
-- Zone: 520, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52013

-- Converted from DG Script #52013: dark_elf_open1
-- Original: MOB trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
if string.find(arg, "chest") then
    actor:send("A dark elf stops you from opening a chest!")
    self.room:send_except(actor, "A dark elf jumps in " .. tostring(actor.name) .. "'s way, keeping them from the chest!")
    self:say("Insolent fools!  Such blatant thievery.")
    self:command("close panel west")
    combat.engage(self, actor.name)
end