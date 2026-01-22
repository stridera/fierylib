-- Trigger: Sunbird_speech1_bow
-- Zone: 581, ID: 7
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #58107

-- Converted from DG Script #58107: Sunbird_speech1_bow
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- switch on cmd
if cmd == "b" then
    return _return_value
end
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