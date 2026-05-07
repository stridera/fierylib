-- Trigger: pyromancer_quest_spell_hints_and_supernova_start
-- Zone: 62, ID: 4
-- Type: MOB, Flags: SPEECH
--
-- Pyromancer guildmaster: starts the supernova quest for qualifying
-- Pyromancers (level 89+) on the "supernova"/"super"/"nova" keyword, and gives
-- generic flavor hints for related fire spells (Meteorswarm) to other classes.
--
-- Original DG Script: #6204

-- TODO(parity): Original DG branching for non-supernova hints (meteorswarm,
-- diabolist response, fallback) is ambiguous after conversion (empty inner if
-- + dangling elseif). Pyromancers fall through to spell-specific hints below;
-- verify against DG #6204 source if this is wrong.

if not (string.find(string.lower(speech), "supernova")
        or string.find(string.lower(speech), "super")
        or string.find(string.lower(speech), "nova")
        or string.find(string.lower(speech), "meteor")
        or string.find(string.lower(speech), "swarm")) then
    return true
end
wait(2)
if string.find(self.class, "pyromancer") then
    -- Supernova quest entrypoint, Pyromancer asker only
    if speech == "super" or speech == "super?" or speech == "nova" or speech == "nova?" or speech == "supernova" or speech == "supernova?" then
        if string.find(actor.class, "Pyromancer") then
            if actor.level > 88 then
                if actor:get_quest_stage("supernova") == 0 then
                    actor:start_quest("supernova")
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
                    self.room:send(tostring(self.name) .. " says, 'If you want to know about your armor quests, ask")
                    self.room:send("</>me about your <white></>[status]</> instead.'")
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
    elseif speech == "meteor" or speech == "meteor?" or speech == "swarm" or speech == "swarm?" or speech == "meteorswarm" or speech == "meteorswarm?" then
        self.room:send(tostring(self.name) .. " says, 'Crazy old McCabe the Elementalist has developed")
        self.room:send("</>such a spell. If you can find him, you might be able to persuade him to teach")
        self.room:send("</>you <b:red>Meteorswarm</>.'")
        self.room:send("</>He likes the devastating effects of volcanoes.'")
    else
        self.room:send(tostring(self.name) .. " says, 'I'm afraid I can't help you with that particular")
        self.room:send("</>spell.'")
    end
end
return true