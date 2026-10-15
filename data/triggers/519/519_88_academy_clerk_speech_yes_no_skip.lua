-- Trigger: academy_clerk_speech_yes_no_skip
-- Zone: 519, ID: 88
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51988

-- Converted from DG Script #51988: academy_clerk_speech_yes_no_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no", "skip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    local advance
    if speech == "yes" then
        if actor:get_quest_var("school:score") == "complete" and actor:get_quest_var("school:hp") == "complete" then
            advance = "yes"
        else
            advance = "no"
        end
    elseif speech == "skip" then
        advance = "yes"
    elseif speech == "no" then
        actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
        actor:send("<b:yellow>Hit Points</>")
        actor:send("<b:yellow>Score</>_")
        actor:send(tostring(self.name) .. " tells you, <b:green>Say continue</> when you're ready to move on.'")
    end
    if advance == "yes" then
        actor:advance_quest("school")
        self:command("eye " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " considers your capabilities...")
        wait(3)
        actor:send(tostring(self.name) .. " tells you, 'Hmmmm...'")
        wait(2)
        -- switch on actor.class
        do
            local _sw1 = string.lower(tostring(actor.class or ""))
            if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
            elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
            elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
            elseif _sw1 == "warrior" or _sw1 == "paladin" or _sw1 == "anti-paladin" or _sw1 == "ranger" or _sw1 == "monk" or _sw1 == "berserker" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'I have no idea what to do with you.  Find a god and ask for help!'")
            end
        end
    elseif advance == "no" then
        if actor:get_quest_var("school:score") == "complete" then
            actor:send(tostring(self.name) .. " tells you, 'Let's talk about <b:yellow>HIT POINTS</> next.")
            actor:send("<b:green>Say hit points</> to begin.'")
        elseif actor:get_quest_var("school:hp") == "complete" then
            actor:send(tostring(self.name) .. " tells you, 'Let's talk about <b:yellow>SCORE</> next.")
            actor:send("<b:green>Say score</> to begin.'")
        end
    end
end