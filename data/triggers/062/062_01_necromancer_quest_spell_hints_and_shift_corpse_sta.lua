-- Trigger: necromancer_quest_spell_hints_and_shift_corpse_start
-- Zone: 62, ID: 1
-- Type: MOB, Flags: SPEECH
--
-- Necromancer guildmaster: hints toward Shift Corpse (level 97+ Necromancers)
-- and Degeneration spells. Starts the shift_corpse quest if the asker is a
-- qualifying Necromancer who hasn't begun it yet.
--
-- Original DG Script: #6201

-- TODO(parity): The original DG script's structure for the "degeneration"
-- branch is ambiguous after conversion (empty inner if + dangling elseif).
-- Current behavior: Necromancer guildmaster handles shift/corpse for
-- Necromancer askers; "degeneration" / fallback hint live below in a
-- separate top-level branch. Verify against DG #6201 source if available.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"shift", "shift?", "corpse", "corpse?", "degeneration", "degeneration?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if string.find(self.class, "necromancer") then
    if speech == "degeneration" or speech == "degeneration?" then
        self.room:send(tostring(self.name) .. " says, 'Controlling negative energy to bolster the dead or")
        self.room:send("</>degenerate the living is theoretically possible.  Someone is working to")
        self.room:send("</>develop a <b:black>Degeneration</> spell for use in the ongoing battle against")
        self.room:send("</>the Eldorian Guard.'")
    elseif string.find(actor.class, "necromancer") and actor:get_quest_stage("shift_corpse") == 0 then
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
                actor:start_quest("shift_corpse")
            end
        else
            self.room:send_except(actor, tostring(self.name) .. " sneers at " .. tostring(actor.name) .. ".")
            actor:send(tostring(self.name) .. " sneers at you.")
            self:say("This magic is not for you!")
        end
    else
        self:say("That spell is far outside the realm of our Guild.")
    end
else
    self.room:send(tostring(self.name) .. " says, 'Only a powerful member of the Necromancer Guild")
    self.room:send("</>might know how to cast such a spell.'")
end