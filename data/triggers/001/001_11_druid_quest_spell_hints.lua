-- Trigger: Druid Quest Spell Hints
-- Zone: 1, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: PARTIAL
--
-- TODO(parity): converter produced an empty `if class-match then` branch
-- followed by `elseif speech == ...` for the moonwell hint. The speech replies
-- only fire when the speaker class does NOT match. Needs DG source review.
--
-- Original DG Script: #111

-- Converted from DG Script #111: Druid Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"creeping", "creeping?", "doom", "doom?", "moon", "moon?", "well", "well?", "moonwell", "moonwell?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = string.lower(tostring(speech or ""))
    if _sw1 == "creeping" or _sw1 == "creeping?" or _sw1 == "doom" or _sw1 == "doom?" then
        if string.find(self.class, "druid") then
            self:say("The rage of the fair folk can summon a carpet of")
            self.room:send("'living death.'")
            -- (empty room echo)
            self.room:send("'Seek out the weakest-seeming of faeries and sprites to learn <b:green>Creeping Doom</>.'")
        else
            self:say("Invoking the wrath of nature is exclusive to the")
            self.room:send("'Druid Guild.'")
        end
    elseif _sw1 == "moonwell" or _sw1 == "moonwell?" or _sw1 == "well" or _sw1 == "well?" or _sw1 == "moon" or _sw1 == "moon?" then
        if string.find(self.class, "diabolist") then
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
        _return_value = true
    end
end
return _return_value