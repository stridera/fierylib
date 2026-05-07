-- Trigger: TD AB Capture
-- Zone: 49, ID: 4
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #4904
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- The armband identifies its bearer's team. When the player types "capture",
-- this trigger relays to the pylon as "xcapture T<team>T" so the pylon
-- (049_07) can apply per-team logic. If the armband has no team assigned
-- yet, the command falls through.
--
-- TODO(converter): the legacy DG check `if %team% != ""` referenced the
-- object's `team` global. The Rust runtime stores object script state on
-- self.state; confirm that this is where ObjectFlags.AntiClass-style team
-- assignment is written by the spawn/wear hook. If not, this trigger is a
-- no-op and team assignment must be wired in elsewhere.

if not percent_chance(1) then
    return true
end

if cmd ~= "capture" then
    return true
end

local team = self.state and self.state.team
if team and team ~= "" then
    actor:command("xcapture T" .. tostring(team) .. "T")
    return false  -- consume the player's command
end

return true
