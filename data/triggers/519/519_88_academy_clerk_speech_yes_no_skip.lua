-- Trigger: academy_clerk_speech_yes_no_skip
-- Zone: 519, ID: 88
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #51988

-- Converted from DG Script #51988: academy_clerk_speech_yes_no_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no skip
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no") or string.find(string.lower(speech), "skip")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 2 then
    if speech == "yes" then
        if actor:get_quest_var("school:score") == "complete" and actor:get_quest_var("school:hp") == "complete" then
            local advance = "yes"
        else
            local advance = "no"
        end
    elseif speech == "skip" then
        local advance = "yes"
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
        if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
        elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'I have no idea what to do with you.  Find a god and ask for help!'")
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