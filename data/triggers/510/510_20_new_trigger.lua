-- Trigger: new trigger
-- Zone: 510, ID: 20
-- Type: WORLD, Flags: SPEECH
--
-- Original DG Script: #51020
-- A leftover developer test trigger ("run test"). It used DG's
-- `wait until 00:00` to demonstrate clock-aligned waits. Kept for
-- parity but the body is intentionally a no-op until/unless a
-- production use case appears.
--
-- TODO(parity): The Lua runtime exposes `wait(N)` (tick-based) but
-- no `wait_until(hour, minute)` clock-aligned sleep. If this trigger
-- is ever wired to real content, port the wait_until behaviour.

if not (string.find(string.lower(speech or ""), "run") and
        string.find(string.lower(speech or ""), "test")) then
    return true
end

self.room:send("trigger running")
self.room:send("trigger over")
