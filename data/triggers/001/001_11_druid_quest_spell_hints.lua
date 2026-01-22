-- Trigger: Druid Quest Spell Hints
-- Zone: 1, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #111

-- Converted from DG Script #111: Druid Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: creeping creeping? doom doom? moon moon? well well? moonwell moonwell?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "creeping") or string.find(string.lower(speech), "creeping?") or string.find(string.lower(speech), "doom") or string.find(string.lower(speech), "doom?") or string.find(string.lower(speech), "moon") or string.find(string.lower(speech), "moon?") or string.find(string.lower(speech), "well") or string.find(string.lower(speech), "well?") or string.find(string.lower(speech), "moonwell") or string.find(string.lower(speech), "moonwell?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "druid") then
    if speech == "creeping" or speech == "creeping?" or speech == "doom" or speech == "doom?" then
        self:say("The rage of the fair folk can summon a carpet of")
        self.room:send("'living death.'")
        -- (empty room echo)
        self.room:send("'Seek out the weakest-seeming of faeries and sprites to learn <b:green>Creeping Doom</>.'")
    else
        self:say("Invoking the wrath of nature is exclusive to the")
        self.room:send("'Druid Guild.'")
    end
    if string.find(self.class, "diabolist") then
    elseif speech == "moonwell" or speech == "moonwell?" or speech == "well" or speech == "well?" or speech == "moon" or speech == "moon?" then
        self:say("Our traditions use infernal methods of travel,")
        self.room:send("'not lunar ones.'")
    elseif string.find(self.class, "priest") then
        self:say("As much as we too revere the Moon, we're unable")
        self.room:send("'to provide you with the secrets of your Order.'")
    elseif string.find(self.class, "druid") then
        if string.find(actor.class, "druid") then
            self.room:send(tostring(self.name) .. " says, 'The ability to call <b:cyan>Moonwells</> is a gift'")
            self.room:send("'bestowed on us by the greatest powers in Nature. The western-most branch of'")
            self.room:send("'our order is well known for their lunar rites.'")
        elseif string.find(actor.class, "diabolist") then
            self:say("We move by the power of the Moon,")
            self.room:send("'not the Nine Hells.'")
        elseif string.find(actor.class, "priest") then
            self:say("We move by the power of the Moon,")
            self.room:send("'not the Will of Heaven.'")
        end
    else
        self:say("Opening gates and wells is the works of other")
        self.room:send("'magical traditions, not ours.'")
    end
else
    _return_value = false
end
return _return_value