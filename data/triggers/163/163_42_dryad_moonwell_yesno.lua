-- Trigger: dryad_moonwell_yesno
-- Zone: 163, ID: 42
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16342

-- Converted from DG Script #16342: dryad_moonwell_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
-- 
-- Created By Acerite Oct, 2004
-- Okay we check to see if the same person that we've been talking to is the one responding
-- Then we free the variable
-- 
if actor.name == moon_name then
    moon_name = nil
    if string.find(speech_lower, "no") then
        self:command("frown")
        actor:send(tostring(self.name) .. " tells you, 'Very well, that is your choice.'")
        self.room:send_except(actor, tostring(self.name) .. " seems disappointed as she says something to " .. tostring(actor.name) .. ".")
    end
    if string.find(speech, "yes") then
        self.room:send(tostring(self.name) .. " smiles with a slight twinkle in her eye.")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'Very well, I will teach you what I know.'")
        self.room:send_except(actor, tostring(self.name) .. " seems pleased as she speaks with " .. tostring(actor.name) .. ".")
        wait(20)
        actor:send(tostring(self.name) .. " tells you 'I will guide you through the proper performance of a")
        actor:send("</>complex ceremony to create a well of moonlight.'")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'This ceremony requires several powerful symbols and")
        actor:send("</>materials.  You must attain these materials since I cannot leave this place.'")
        self.room:send_except(actor, tostring(self.name) .. " excitedly tells " .. tostring(actor.name) .. " something.")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'First we need something to mark the well's outline.'")
        self.room:send_except(actor, tostring(self.name) .. " begins telling something to " .. tostring(actor.name) .. ".")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'Long ago during the Rift Wars, the goddess Mielikki was")
        actor:send("</>injured by another god, and one of the vines that surround her body was cut")
        actor:send("</>off.  As this was more than a mere plant but rather part of Her divine body, it")
        actor:send("</>survived.'")
        wait(6)
        actor:send(tostring(self.name) .. " tells you, 'I have heard tell this vine has proliferated near molten")
        actor:send("</>mountains, but is guarded by fearsome fiery beasts.'")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'Go, recover part of this vine and bring it back safely!'")
        self.room:send_except(actor, tostring(self.name) .. " pleads with " .. tostring(actor.name) .. " desperately.")
        actor.name:start_quest("moonwell_spell_quest")
    end
end