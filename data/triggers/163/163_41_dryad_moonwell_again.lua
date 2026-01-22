-- Trigger: dryad_moonwell_again
-- Zone: 163, ID: 41
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #16341

-- Converted from DG Script #16341: dryad_moonwell_again
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: druid? promising? again?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "druid?") or string.find(string.lower(speech), "promising?") or string.find(string.lower(speech), "again?")) then
    return true  -- No matching keywords
end
-- 
-- Created by Acerite Oct, 2004
-- Check to see if Actor is eligible, then set their name in the global moon_name for future trigger.
-- 
if actor.class == "druid" then
    if actor.level >= 73 then
        local moon_name = actor.name
        globals.moon_name = globals.moon_name or true
        wait(5)
        self:command("sigh")
        wait(10)
        actor:send(tostring(self.name) .. " tells you, 'Yes, well...'")
        self.room:send_except(actor, tostring(self.name) .. " tells something to " .. tostring(actor.name) .. ".")
        wait(5)
        self.room:send(tostring(self.name) .. " starts to reminisce about her past.")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'You see, I was not always like this.  Many years ago I")
        actor:send("</>too was a young mortal druid.  But while on my journeys I made a grave error in")
        actor:send("</>judgement.'")
        wait(3)
        actor:send(tostring(self.name) .. " tells you, 'I rediscovered powerful magics that allowed me to travel")
        actor:send("</>the world on a whim.'")
        wait(3)
        actor:send(tostring(self.name) .. " tells you, 'But I squandered that magic on frivolous desires and")
        actor:send("</>furthering my own ambitions, rather than using it to better perform my sworn")
        actor:send("</>duties.'")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'Thus the great goddess Mielikki punished me by binding me")
        actor:send("</>to this tree as a dryad so I might never travel again.'")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'Now, if I do not perform my duties properly, I ensure my")
        actor:send("</>own death.'")
        self.room:send_except(actor, tostring(self.name) .. " tells her story to " .. tostring(actor.name) .. ".")
        wait(7)
        self:command("sigh")
        wait(5)
        self:command("ponder")
        wait(5)
        actor:send(tostring(self.name) .. " tells you, 'But perhaps if I repent by teaching you these ancient")
        actor:send("</>magics, the goddess will release me from this place!'")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'Yes, if you are willing I will teach you the power of")
        actor:send("</>druidic travel.'")
        self.room:send_except(actor, tostring(self.name) .. " seems excited while telling something to " .. tostring(actor.name) .. ".")
        wait(4)
        actor:send(tostring(self.name) .. " tells you, 'Are you willing to learn?'")
    end
end