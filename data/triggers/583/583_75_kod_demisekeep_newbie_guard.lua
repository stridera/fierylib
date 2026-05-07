-- Trigger: KoD_demisekeep_newbie_guard
-- Zone: 583, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #58375

-- Converted from DG Script #58375: KoD_demisekeep_newbie_guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%
--
-- Block players under level 30 from heading east; usher mid-level players
-- (30-59) through with a warning; allow level 60+ to pass without comment.

if cmd ~= "east" then
    return true  -- Not our command
end
if not actor.is_player then
    return true
end
if actor.level < 30 then
    self:command("smile")
    self:whisper(actor.name, "I would not suggest going any further.")
    wait(1)
    self:command("grin " .. tostring(actor.name))
    self:whisper(actor.name, "It is fraught with danger above your abilities.")
    return false  -- Block the east movement
elseif actor.level < 60 then
    self:say("I will let you pass, but still be careful beyond this point.")
    self:emote("points east.")
    wait(5)
    actor:move("east")
    return false  -- We've already moved them; suppress the original command
end
return true  -- Level 60+: allow normal movement