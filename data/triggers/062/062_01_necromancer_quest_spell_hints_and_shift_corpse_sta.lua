-- Trigger: necromancer_quest_spell_hints_and_shift_corpse_start
-- Zone: 62, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #6201

-- Converted from DG Script #6201: necromancer_quest_spell_hints_and_shift_corpse_start
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: shift shift? corpse corpse? degeneration degeneration?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "shift") or string.find(string.lower(speech), "shift?") or string.find(string.lower(speech), "corpse") or string.find(string.lower(speech), "corpse?") or string.find(string.lower(speech), "degeneration") or string.find(string.lower(speech), "degeneration?")) then
    return true  -- No matching keywords
end
wait(2)
-- switch on speech
if string.find(self.class, "Necromancer") then
    if string.find(actor.class, "Necromancer") and actor:get_quest_stage("shift_corpse") == 0 then
        if speech == "shift" or speech == "shift?" or speech == "corpse" or speech == "corpse?" or speech == "shift corpse" or speech == "shift corpse?" then
            self:say("So you want to learn our most powerful secrets, eh?")
            self:command("peer " .. tostring(actor))
            wait(1)
            if actor.level < 97 then
                self.room:send(tostring(self.name) .. " says, 'Unfortunately you are not prepared to handle such magic.")
                self.room:send("</>There are easier ways to kill yourself.'")
            else
                self:command("nod")
                self.room:send(tostring(self.name) .. " says, 'I will teach you the words to the spell.  But the words")
                self.room:send("</>alone are meaningless.  The true power to fuel Shift Corpse cannot be")
                self.room:send("</>taught - it must be taken.'")
                wait(2)
                self:say("You must steal the power of a god.")
                actor.name:start_quest("shift_corpse")
            end
        else
            self.room:send_except(actor, tostring(self.name) .. " sneers at " .. tostring(actor.name) .. ".")
            actor:send(tostring(self.name) .. " sneers at you.")
            self:say("This magic is not for you!")
        end
    else
        self:say("That spell is far outside the realm of our Guild.")
    end
    if string.find(self.class, "Necromancer") then
    elseif speech == "degeneration" or speech == "degeneration?" then
        self.room:send(tostring(self.name) .. " says, 'Controlling negative energy to bolster the dead or")
        self.room:send("</>degenerate the living is theoretically possible.  Someone is working to")
        self.room:send("</>develop a &9<blue>Degeneration</> spell for use in the ongoing battle against")
        self.room:send("</>the Eldorian Guard.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Only a powerful member of the Necromancer Guild")
        self.room:send("</>might know how to cast such a spell.'")
    end
end