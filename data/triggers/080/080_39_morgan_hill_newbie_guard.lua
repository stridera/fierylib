-- Trigger: Morgan_hill_newbie_guard
-- Zone: 80, ID: 39
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #8039
-- Blocks players under level 10 from heading south (into a dangerous
-- area). NPCs and higher-level players pass through unimpeded.

if cmd ~= "south" then
    return true  -- Not our command; let the engine handle it.
end

if actor.is_player and actor.level < 10 then
    actor:send(tostring(self.name) .. " places a hand in front of you.")
    self.room:send_except(actor, tostring(self.name) .. " places a hand up in front of " .. tostring(actor.name) .. ".")
    self:whisper(actor.name, "Hold on there!  South of here is terribly dangerous for someone of your skill.")
    wait(1)
    self:whisper(actor.name, "I suggest adventuring elsewhere for now.")
    self:command("bow " .. tostring(actor.name))
    return false  -- Block the south command.
end

return true