-- Trigger: dryad_moonwell_again
-- Zone: 163, ID: 41
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16341
--
-- Created by Acerite Oct, 2004.
-- Druid asks "what druid?" / "promising?" / "again?" — the dryad tells her
-- backstory and offers to teach the moonwell ritual. Stores the asker's name
-- in globals.moon_name so the yes/no follow-up (16342) only honors the same
-- player.

local sl = string.lower(speech)
if not (string.find(sl, "druid?") or string.find(sl, "promising?") or string.find(sl, "again?")) then
    return true
end

if actor.class ~= "druid" or actor.level < 73 then
    return true
end

globals.moon_name = actor.name

wait(5)
self:command("sigh")
wait(10)
actor:send(tostring(self.name) .. " tells you, 'Yes, well...'")
self.room:send_except(actor, tostring(self.name) .. " tells something to " .. tostring(actor.name) .. ".")
wait(5)
self.room:send(tostring(self.name) .. " starts to reminisce about her past.")
wait(5)
actor:send(tostring(self.name) .. " tells you, 'You see, I was not always like this.  Many years ago I\n"
    .. "</>too was a young mortal druid.  But while on my journeys I made a grave error in\n"
    .. "</>judgement.'")
wait(3)
actor:send(tostring(self.name) .. " tells you, 'I rediscovered powerful magics that allowed me to travel\n"
    .. "</>the world on a whim.'")
wait(3)
actor:send(tostring(self.name) .. " tells you, 'But I squandered that magic on frivolous desires and\n"
    .. "</>furthering my own ambitions, rather than using it to better perform my sworn\n"
    .. "</>duties.'")
wait(4)
actor:send(tostring(self.name) .. " tells you, 'Thus the great goddess Mielikki punished me by binding me\n"
    .. "</>to this tree as a dryad so I might never travel again.'")
wait(4)
actor:send(tostring(self.name) .. " tells you, 'Now, if I do not perform my duties properly, I ensure my\n"
    .. "</>own death.'")
self.room:send_except(actor, tostring(self.name) .. " tells her story to " .. tostring(actor.name) .. ".")
wait(7)
self:command("sigh")
wait(5)
self:command("ponder")
wait(5)
actor:send(tostring(self.name) .. " tells you, 'But perhaps if I repent by teaching you these ancient\n"
    .. "</>magics, the goddess will release me from this place!'")
wait(4)
actor:send(tostring(self.name) .. " tells you, 'Yes, if you are willing I will teach you the power of\n"
    .. "</>druidic travel.'")
self.room:send_except(actor, tostring(self.name) .. " seems excited while telling something to " .. tostring(actor.name) .. ".")
wait(4)
actor:send(tostring(self.name) .. " tells you, 'Are you willing to learn?'")
