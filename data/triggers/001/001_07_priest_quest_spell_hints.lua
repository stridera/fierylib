-- Trigger: Priest Quest Spell Hints
-- Zone: 1, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 5129 chars
--
-- Original DG Script: #107

-- Converted from DG Script #107: Priest Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: banish banish? heaven heaven? heavens heavens? gate gate?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "banish") or string.find(string.lower(speech), "banish?") or string.find(string.lower(speech), "heaven") or string.find(string.lower(speech), "heaven?") or string.find(string.lower(speech), "heavens") or string.find(string.lower(speech), "heavens?") or string.find(string.lower(speech), "gate") or string.find(string.lower(speech), "gate?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "diabolist") then
    if string.find(actor.class, "diabolist") then
        if speech == "gate" then
            self:say("Our infernal lords can grant us the power to open a")
            self.room:send("'<b:red>Hell Gate</> o travel anywhere instantly via the Nine Hells.'")
            -- (empty room echo)
            self.room:send("'Places where Garl'lixxil have touched Ethilien like Templace are particularly'")
            self.room:send("'suitable for attuning to the proper energies.'")
        elseif string.find(actor.class, "priest") then
            self:say("We don't trifle with such silly things.")
            self.room:send("'Our diabolical patrons shift us through the very bowels of Hell instead!'")
        elseif string.find(actor.class, "druid") then
            self:say("Our traditions use inferal methods of travel, not lunar ones.")
        end
    elseif string.find(self.class, "priest") then
        if string.find(actor.class, "diabolist") then
            self:say("Members of priestly orders travel by the Will of")
            self.room:send("'Heaven. We do not spread the knowledge of Infernal magics.'")
        elseif string.find(actor.class, "priest") then
            self:say("The secrets to opening <b:cyan>Heavens Gate</> are")
            self.room:send("'taught by the stars themselves.'")
            -- (empty room echo)
            self.room:send("'There is a place near Anduin where starlight reaches deep into the bowels of'")
            self.room:send("'Ethilien and whispers to those who listen.'")
        elseif string.find(actor.class, "druid") then
            self:say("As much as we too revere the Moon in the Heavens,")
            self.room:send("'we're unable to provide you with the secrets of your Order.'")
        end
    elseif string.find(self.class, "druid") then
        if string.find(actor.class, "druid") then
            self.room:send(tostring(self.name) .. " says, 'The ability to call <b:cyan>Moonwells</> is a gift")
            self.room:send("'bestowed on us by the greatest powers in Nature.'")
            -- (empty room echo)
            self.room:send("'The western-most branch of our order is well known for their lunar rites.'")
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
    if string.find(self.class, "priest") or string.find(self.class, "diabolist") then
    elseif speech == "banish" or speech == "banish?" then
        self:say("There's a diabolist known to skulk about South")
        self.room:send("'Caelia who is said to be quite adept at &9<blue>Banish</>.'")
        -- (empty room echo)
        self.room:send("'They say she makes common use of it in the conflict between the military city'")
        self.room:send("'Ogakh and the paladins of Sacred Haven.'")
    else
        self:say("Unfortunately that spell is outside of our")
        self.room:send("'guild traditions.'")
    end
    if string.find(self.class, "priest") then
    elseif speech == "heaven" or speech == "heavens" or speech == "heaven?" or speech == "heavens?" then
        self:say("The secrets to opening <b:cyan>Heavens Gate</> are")
        self.room:send("'taught by the stars themselves.'")
        -- (empty room echo)
        self.room:send("'There is a place near Anduin where starlight reaches deep into the bowels of'")
        self.room:send("'Ethilien and whispers to those who listen.'")
    elseif string.find(self.class, "diabolist") then
        self:say("We don't trifle with such silly things.")
        self.room:send("'Our diabolical patrons shift us through the very bowels of of Hell instead!'")
    elseif string.find(self.class, "druid") then
        self:say("We move by the power of the Moon,")
        self.room:send("'not the Will of Heaven.'")
    else
        self:say("Apologies, I haven't the faintest clue where to begin looking.")
    end
else
    _return_value = false
end
return _return_value