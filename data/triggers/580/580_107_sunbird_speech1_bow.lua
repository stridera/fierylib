-- Trigger: Sunbird_speech1_bow
-- Zone: 580, ID: 107
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- When a player bows to the Sunbird, replays the same Kannon cinematic
-- as the speech1 keyword trigger.
--
-- TODO: the original DG checked the command argument (`%arg%`) to make
-- sure the bow targeted the Sunbird specifically. The converter dropped
-- it as `string.find(self.name, "arg")` -- a literal search for the
-- string "arg" in the mob's name, which is never true, so the body is
-- dead code. Replace with a check that `arg` matches one of the
-- Sunbird's keywords (e.g. self:keyword_match(arg)).
-- TODO: dead `if cmd == "b"` clause sits inside an outer `cmd == "bow"`
-- guard -- can never be true. Drop it once the arg fix lands.

-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Dead branch (see TODO): cmd == "b" cannot occur after the bow filter.
if cmd == "b" then
    return _return_value
end
-- Broken target check (see TODO): always false.
if string.find(self.name, "arg") then
    wait(7)
    self:say("Through her holy benevolence, I once protected this entire island.")
    self.room:send("The Sunbird spreads its wings and begins to radiate a <b:white>glowing</> <blue><black>l</><b:white>i<b:yellow>g</><b:white>h</><blue><black>t.</>")
    wait(15)
    self.room:send("<b:white>The light grows...</>")
    wait(15)
    self.room:send("The light suddenly <b:white>FL</><b:yellow>AR</><b:white>ES!</>")
    wait(7)
    self.room:send("The Sunbird falters and stumbles before the altar.")
    wait(8)
    self:say("But now her divine presence has waned.")
    self:say("I can only shelter this small space near her shrine.")
    self:say("I fear something terrible has happened to her...")
end
return _return_value