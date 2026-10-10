-- Trigger: Sunbird_speech1_bow
-- Zone: 580, ID: 107
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- When a player bows to the Sunbird, replays the same Kannon cinematic
-- as the speech1 keyword trigger.
--
-- Legacy `return 0` comes first, so every bow goes ahead; the cinematic runs only when the
-- bow targets the Sunbird (DG `%self.name% /= %arg%`: the argument is part of its name).

-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true  -- legacy `return 0` before anything else
allow_command()
local target = string.lower(arg or "")
if target ~= "" and string.find(string.lower(self.name), target, 1, true) then
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