-- Trigger: pyromancer_quest_spell_hints_and_supernova_start
-- Zone: 62, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--   Complex nesting: 7 if statements
--   Large script: 5079 chars
--
-- Original DG Script: #6204

-- Converted from DG Script #6204: pyromancer_quest_spell_hints_and_supernova_start
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: supernova supernova? super super? nova nova? meteorswarm meteorswarm? meteor meteor? swarm swarm?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "supernova") or string.find(string.lower(speech), "supernova?") or string.find(string.lower(speech), "super") or string.find(string.lower(speech), "super?") or string.find(string.lower(speech), "nova") or string.find(string.lower(speech), "nova?") or string.find(string.lower(speech), "meteorswarm") or string.find(string.lower(speech), "meteorswarm?") or string.find(string.lower(speech), "meteor") or string.find(string.lower(speech), "meteor?") or string.find(string.lower(speech), "swarm") or string.find(string.lower(speech), "swarm?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "pyromancer") then
    if string.find(actor.class, "Pyromancer") then
        if actor.level > 88 then
            if actor:get_quest_stage("supernova") == 0 then
                if speech == "super" or speech == "super?" or speech == "nova" or speech == "nova?" or speech == "supernova" or speech == "supernova?" then
                    actor.name:start_quest("supernova")
                    self.room:send(tostring(self.name) .. " says, 'Supernova is really only taught by one person:")
                    self.room:send("</>Phayla, daughter of the Sun.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, 'Phayla is one of the most powerful sorceresses in")
                    self.room:send("</>existence.  Beings from all across the universe have sought her out for just a")
                    self.room:send("</>chance to study under her.  Most fail to find her.  She has agreed to teach")
                    self.room:send("</>even fewer.'")
                    wait(5)
                    self.room:send(tostring(self.name) .. " says, 'She resides in a demiplane of her own creation.")
                    self.room:send("</>It's constantly shifting and changing, so it's impossible for anyone but Phayla")
                    self.room:send("</>to know where it is or how to access it without help.'")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'However, she likes to leave clues to accessing it")
                    self.room:send("</>scattered throughout the world.'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " says, 'On their own, the clues are illegible and")
                    self.room:send("</>unintelligible.  The keys to reading them are lamps Phayla gives to her most")
                    self.room:send("</>ardent and formidable followers.'")
                    wait(4)
                    self:say("If you find one I may be able to help you more.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'You can check in with me about your <b:white>[progress]</>")
                    self.room:send("</>toward learning Supernova at any time.'")
                    -- (empty room echo)
                    self.room:send(tostring(self.name) .. " says, 'If you want to know about your armor quests, ask")
                    self.room:send("</>me about your <white></>[status]</> instead.'")
                end
            else
                self.room:send(tostring(self.name) .. " says, 'You're not ready to be asking about such an")
                self.room:send("</>awesome spell.  We can do a follow-up visit after you gain some more")
                self.room:send("</>experience.'")
            end
        else
            self:say("Supernova is beyond your discipline.")
        end
    else
        self:say("Supernova is far outside our discipline.")
    end
    if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") then
    elseif speech == "meteor" or speech == "meteor?" or speech == "swarm" or speech == "swarm?" or speech == "meteorswarm" or speech == "meteorswarm?" then
        self.room:send(tostring(self.name) .. " says, 'Crazy old McCabe the Elementalist has developed")
        self.room:send("</>such a spell. If you can find him, you might be able to persuade him to teach")
        self.room:send("</>you <b:red>Meteorswarm</>.'")
        -- (empty room echo)
        self.room:send("</>He likes the devastating effects of volcanoes.'")
    elseif string.find(self.class, "diabolist") then
        self.room:send(tostring(self.name) .. " says, 'We too call flaming rocks from the sky, but through")
        self.room:send("</>different powers.'")
    else
        self.room:send(tostring(self.name) .. " says, 'I'm afraid I can't help you with that particular")
        self.room:send("</>spell.'")
    end
else
    _return_value = false
end
return _return_value