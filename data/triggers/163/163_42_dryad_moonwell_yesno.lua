-- Trigger: dryad_moonwell_yesno
-- Zone: 163, ID: 42
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16342
--
-- Created by Acerite Oct, 2004.
-- Yes/no follow-up to the dryad's offer in 16341. Only honors the same player
-- who asked (globals.moon_name). On "yes", starts the moonwell_spell_quest and
-- sends them to fetch the Vine of Mielikki.

local sl = string.lower(speech)
if not (string.find(sl, "yes") or string.find(sl, "no")) then
    return true
end

if actor.name ~= globals.moon_name then
    return true
end

globals.moon_name = nil

if string.find(sl, "no") then
    self:command("frown")
    actor:send(tostring(self.name) .. " tells you, 'Very well, that is your choice.'")
    self.room:send_except(actor, tostring(self.name) .. " seems disappointed as she says something to " .. tostring(actor.name) .. ".")
    return true
end

if string.find(sl, "yes") then
    self.room:send(tostring(self.name) .. " smiles with a slight twinkle in her eye.")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Very well, I will teach you what I know.'")
    self.room:send_except(actor, tostring(self.name) .. " seems pleased as she speaks with " .. tostring(actor.name) .. ".")
    wait(20)
    actor:send(tostring(self.name) .. " tells you 'I will guide you through the proper performance of a\n"
        .. "</>complex ceremony to create a well of moonlight.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'This ceremony requires several powerful symbols and\n"
        .. "</>materials.  You must attain these materials since I cannot leave this place.'")
    self.room:send_except(actor, tostring(self.name) .. " excitedly tells " .. tostring(actor.name) .. " something.")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'First we need something to mark the well's outline.'")
    self.room:send_except(actor, tostring(self.name) .. " begins telling something to " .. tostring(actor.name) .. ".")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Long ago during the Rift Wars, the goddess Mielikki was\n"
        .. "</>injured by another god, and one of the vines that surround her body was cut\n"
        .. "</>off.  As this was more than a mere plant but rather part of Her divine body, it\n"
        .. "</>survived.'")
    wait(6)
    actor:send(tostring(self.name) .. " tells you, 'I have heard tell this vine has proliferated near molten\n"
        .. "</>mountains, but is guarded by fearsome fiery beasts.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'Go, recover part of this vine and bring it back safely!'")
    self.room:send_except(actor, tostring(self.name) .. " pleads with " .. tostring(actor.name) .. " desperately.")
    actor:start_quest("moonwell_spell_quest")
end
